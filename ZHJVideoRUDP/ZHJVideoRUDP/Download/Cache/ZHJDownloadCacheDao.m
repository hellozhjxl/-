//
//  ZHJDownloadCacheDao.m
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/14.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import "ZHJDownloadCacheDao.h"

@implementation ZHJDownloadCacheDao
//工厂方法
+ (instancetype)cacheDao {
    return [[self alloc] init];
}

//增
- (BOOL)addCache:(ZHJDwonloadCache *)cache {
    ZHJDwonloadCache *result = [self searchCache:cache];
    if (!result) {  //不存在添加
        return [cache saveToDB];
    } else {    //存在更新
        return [self updateCache:cache];
    }
}
//删
- (BOOL)delCache:(ZHJDwonloadCache *)cache {
    return [ZHJDwonloadCache deleteToDB:cache];
}

//改
- (BOOL)updateCache:(ZHJDwonloadCache *)cache {
    NSDictionary *where = @{@"url":cache.url};
    return  [ZHJDwonloadCache updateToDB:cache where:where];
}

//查
- (ZHJDwonloadCache *)searchCache:(ZHJDwonloadCache *)cache {
    NSDictionary *where = @{@"url":cache.url};
    return [[ZHJDwonloadCache searchWithWhere:where] firstObject];
}

- (NSMutableArray *)searchAll {
    return [ZHJDwonloadCache searchWithWhere:nil];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
