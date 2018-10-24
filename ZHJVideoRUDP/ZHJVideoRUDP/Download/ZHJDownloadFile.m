//
//  ZHJDownloadFile.m
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/14.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import "ZHJDownloadFile.h"
#import "ZHJNSURLSessionDownloadFile.h"

@interface ZHJDownloadFile () <ZHJNSURLSessionDownloadFileDelegate>
@property (nonatomic, strong) ZHJNSURLSessionDownloadFile *urlSessionDownload;
@end

@implementation ZHJDownloadFile

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (ZHJNSURLSessionDownloadFile *)urlSessionDownload {
    if (!_urlSessionDownload) {
        _urlSessionDownload = [[ZHJNSURLSessionDownloadFile alloc] initWithDelegate:self];
    }
    return _urlSessionDownload;
}

//开始下载
- (void)downloadWithUrl:(NSString *)url{
    self.url = url;
    self.urlSessionDownload.url = [NSURL URLWithString:url];
    [self.urlSessionDownload start];
}

//暂停
- (void)suspend {
    [self.urlSessionDownload suspend];
}

//取消
- (void)cancel {
    [self.urlSessionDownload cancel];
}

//继续下载
- (void)resume {
    [self.urlSessionDownload resume];
}

- (NSURLSessionTaskState)taskState {
    return self.urlSessionDownload.taskState;
}

- (void)ZHJNSURLSessionDownloadFileProgress:(CGFloat)progress {
    NSLog(@"%f",progress);
    self.progress = progress;
}


@end
