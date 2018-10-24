//
//  ZHJNSURLSessionDownloadFile.m
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/14.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import "ZHJNSURLSessionDownloadFile.h"
#import "ZHJDwonloadCache.h"
#import "ZHJDownloadCacheDao.h"

@interface ZHJNSURLSessionDownloadFile () <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) NSInteger curSize;
@property (nonatomic, assign) NSInteger totalSize;
@property (nonatomic, strong) NSFileHandle *hande;
@property (nonatomic, strong) ZHJDwonloadCache *cache;
@end

@implementation ZHJNSURLSessionDownloadFile

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (NSURLSessionDataTask *)task {
    if (!_task) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-",[self getRequestSize]];
        [request setValue:range forHTTPHeaderField:@"Range"];
        _task = [self.session dataTaskWithRequest:request];
    }
    return _task;
}

- (NSString *)filePath {
    if (!_filePath) {
        _filePath = [ZHJTool filePathWithName:[self.url lastPathComponent]];
    }
    return _filePath;
}

- (NSURLSessionTaskState)taskState {
    return self.task.state;
}

/**
 获得需要请求的文件大小,断点下载

 @return 文件大小
 */
- (NSInteger)getRequestSize {
    NSDictionary<NSFileAttributeKey, id> *fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:self.filePath error:nil];
    NSInteger fileSize = [fileAttr[@"NSFileSize"] integerValue];
    self.curSize = fileSize;
    return fileSize;
}

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        self.url = [NSURL URLWithString:url];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<ZHJNSURLSessionDownloadFileDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}


//开始下载

/**
 查询数据库看是否已经下载过,如果下载过就从上次下载完成的位置进行下载(查看文件大小,获得下载位置)
 */
- (void)start{
    ZHJDwonloadCache *scache = [[ZHJDwonloadCache alloc] init];
    scache.url = self.url.absoluteString;
    ZHJDownloadCacheDao *dao = [ZHJDownloadCacheDao cacheDao];
    ZHJDwonloadCache *cache = [dao searchCache:scache];
    if (!cache) {
        self.cache = [[ZHJDwonloadCache alloc] init];
    } else {
        self.totalSize = cache.totalSize;
        self.cache = cache;
    }
    [self.task resume];
}

//暂停
- (void)suspend {
    [self.task suspend];
}

//取消
- (void)cancel {
    [self.task cancel];
}

//继续下载
- (void)resume {
    [self.task resume];
}

#pragma mark dataTask代理

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    //获得文件总大小
    if (self.totalSize == 0) {
        self.totalSize = response.expectedContentLength;
        self.cache.totalSize = self.totalSize;
        self.cache.url = self.url.absoluteString;
        ZHJDownloadCacheDao *dao = [ZHJDownloadCacheDao cacheDao];
        [dao addCache:self.cache];
    }
    //创建一个空的文件
    if (self.curSize == 0) {
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager createFileAtPath:self.filePath contents:nil attributes:nil];
    }
    //创建文件句柄
    if (!self.hande) {
        self.hande = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
        [self.hande seekToEndOfFile];
    }
    completionHandler(NSURLSessionResponseAllow);
}

//写入文件,获得下载进度
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.hande writeData:data];
    self.curSize += data.length;
    CGFloat progress = 1.f*self.curSize/self.totalSize;
//    NSLog(@"%f",progress);
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZHJNSURLSessionDownloadFileProgress:)]) {
        [self.delegate ZHJNSURLSessionDownloadFileProgress:progress];
    }
}

//task完成
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"%s",__func__);
    [self.session invalidateAndCancel];
    self.session = nil;
    [self.hande closeFile];
    self.hande = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DwonloadFinish" object:self];
}

@end
