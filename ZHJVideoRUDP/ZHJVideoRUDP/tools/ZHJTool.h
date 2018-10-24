//
//  ZHJTool.h
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/24.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHJTool : NSObject
/**
 获得文件路径
 
 @param filename 文件名称
 @return 保存沙盒路径
 */
+ (NSString *)filePathWithName:(NSString *)filename;

@end

NS_ASSUME_NONNULL_END
