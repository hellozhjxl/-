//
//  ZHJDownloaLlist.h
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/24.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHJDownloaLlist : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign, getter=isDownload) BOOL download;
@property (nonatomic, assign) float progress;
@end

NS_ASSUME_NONNULL_END
