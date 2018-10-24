//
//  ZHJDownloadListiCell.h
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/24.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHJDownloaLlist.h"
typedef void(^DownloadMovieBlock)(NSString *);
typedef void(^DownloadControlBlock)(UIButton *button);
NS_ASSUME_NONNULL_BEGIN

@interface ZHJDownloadListiCell : UITableViewCell

@property (nonatomic, strong) ZHJDownloaLlist *list;
@property (nonatomic, copy) DownloadMovieBlock downloadMovieBlock;
@property (nonatomic, copy) DownloadControlBlock downloadControlBlock;
- (IBAction)downloadMovie:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
