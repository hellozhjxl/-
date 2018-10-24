//
//  ZHJDownloadCacheDao.h
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/14.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHJDwonloadCache.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHJDownloadCacheDao : NSObject
//增
- (BOOL)addCache:(ZHJDwonloadCache *)cache;
//删
- (BOOL)delCache:(ZHJDwonloadCache *)cache;
//改
- (BOOL)updateCache:(ZHJDwonloadCache *)cache;
//查
- (ZHJDwonloadCache *)searchCache:(ZHJDwonloadCache *)cache;

- (NSMutableArray *)searchAll;

//工厂方法
+ (instancetype)cacheDao;
@end

NS_ASSUME_NONNULL_END
