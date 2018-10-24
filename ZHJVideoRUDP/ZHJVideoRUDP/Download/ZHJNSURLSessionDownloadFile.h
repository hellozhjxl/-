//
//  ZHJNSURLSessionDownloadFile.h
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/14.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZHJNSURLSessionDownloadFileDelegate <NSObject>

//下载进度
- (void)ZHJNSURLSessionDownloadFileProgress:(CGFloat)progress;

@end

@interface ZHJNSURLSessionDownloadFile : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign, readonly) NSURLSessionTaskState taskState;
@property (nonatomic, assign) id<ZHJNSURLSessionDownloadFileDelegate> delegate;
- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithDelegate:(id<ZHJNSURLSessionDownloadFileDelegate>)delegate;
//开始
- (void)start;
//暂停
- (void)suspend;
//取消
- (void)cancel;
//继续下载
- (void)resume;

@end

NS_ASSUME_NONNULL_END
