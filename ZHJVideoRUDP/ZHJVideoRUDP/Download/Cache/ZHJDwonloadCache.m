//
//  ZHJDwonloadCache.m
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/14.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import "ZHJDwonloadCache.h"

@implementation ZHJDwonloadCache

//初始化 DB
+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[LKDBHelper alloc]init];
    });
    return db;
}

//表名
+(NSString *)getTableName
{
    return @"ZHJDwonloadCache";
}


@end
