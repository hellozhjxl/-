//
//  ZHJDownloadManager.m
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/14.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import "ZHJDownloadManager.h"
#import "ZHJNSURLSessionDownloadFile.h"
#import "ZHJDownloadCacheDao.h"

@interface ZHJDownloadManager ()
@property (nonatomic, strong) NSMutableDictionary<NSString *,ZHJDownloadFile *> *tasks;
@end

@implementation ZHJDownloadManager

- (NSMutableDictionary<NSString *,ZHJDownloadFile *> *)tasks {
    if (!_tasks) {
        _tasks = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    return _tasks;
}

static ZHJDownloadManager *_downloadManager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _downloadManager = [super allocWithZone:zone];
    });
    
    return _downloadManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _downloadManager;
}

- (instancetype)init {
    if (self == [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinish:) name:@"DwonloadFinish" object:nil];
    }
    return self;
}

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManager = [[self alloc] init];
    });
    
    return _downloadManager;
}

- (NSArray *)urls {
    return  [self.tasks allKeys];
}

//释放内存
- (void)downloadFinish:(NSNotification *)noti {
    if ([noti.object isKindOfClass:[ZHJNSURLSessionDownloadFile class]]) {
        ZHJNSURLSessionDownloadFile *obj = (ZHJNSURLSessionDownloadFile *)noti.object;
        [self.tasks removeObjectForKey:obj.url.absoluteString];
    }
}

//开始下载
- (void)downloadWithUrl:(NSString *)url {
    ZHJDownloadFile *downloadFile = [[ZHJDownloadFile alloc] init];
    [downloadFile downloadWithUrl:url];
    [self.tasks setValue:downloadFile forKey:url];
}

//获得下载任务
- (ZHJDownloadFile *)downloadFileForUrl:(NSString *)url {
    return [self.tasks objectForKey:url];
}

//单个下载任务进度
- (float)getProgressWithUrl:(NSString *)url {
    ZHJDwonloadCache *scache = [[ZHJDwonloadCache alloc] init];
    scache.url = url;
    ZHJDownloadCacheDao *dao = [ZHJDownloadCacheDao cacheDao];
    ZHJDwonloadCache *cache = [dao searchCache:scache];
    if (cache) {
        NSString *filePath = [ZHJTool filePathWithName:[url lastPathComponent]];
        NSDictionary<NSFileAttributeKey, id> *fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        NSInteger fileSize = [fileAttr[@"NSFileSize"] integerValue];
        NSInteger totalSize = cache.totalSize;
        return 1.f*fileSize/totalSize;
    }
    return 0.f;
}


@end
