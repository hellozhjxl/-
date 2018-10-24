//
//  ZHJDwonloadCache.h
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/14.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
    保存到数据库,获得文件下载进度
 */
@interface ZHJDwonloadCache : NSObject
@property (nonatomic, copy) NSString *url;          //下载的文件请求路径
@property (nonatomic, assign) NSInteger totalSize;  //文件总大小
@end

NS_ASSUME_NONNULL_END
