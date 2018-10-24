//
//  ZHJDownloadFile.h
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/14.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 文件下载类,抽取出来的原因是,以后下载方式改变的话只需要修改此类,更换下载方式,减少耦合
 */
@interface ZHJDownloadFile : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) NSURLSessionTaskState taskState;
//开始下载
- (void)downloadWithUrl:(NSString *)url;
//暂停
- (void)suspend;
//取消
- (void)cancel;
//继续下载
- (void)resume;
@end
