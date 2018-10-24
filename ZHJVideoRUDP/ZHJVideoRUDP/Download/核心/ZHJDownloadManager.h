//
//  ZHJDownloadManager.h
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/14.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHJDownloadFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHJDownloadManager : NSObject
+ (instancetype)defaultManager;
- (void)downloadWithUrl:(NSString *)url;
- (ZHJDownloadFile *)downloadFileForUrl:(NSString *)url;    //获得下载任务
- (float)getProgressWithUrl:(NSString *)url;    //获得单个下载任务进度
- (NSArray *)urls;
@end

NS_ASSUME_NONNULL_END
