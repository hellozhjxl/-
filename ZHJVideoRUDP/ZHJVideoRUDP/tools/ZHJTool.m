//
//  ZHJTool.m
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/24.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import "ZHJTool.h"

@implementation ZHJTool

+ (NSString *)filePathWithName:(NSString *)filename {
   return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:filename];
}


@end
