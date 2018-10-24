//
//  ZHJDownloadListiCell.m
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/24.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import "ZHJDownloadListiCell.h"

@interface ZHJDownloadListiCell ()
@property (nonatomic, weak) IBOutlet UILabel *movieName;
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *progressValueLabel;
@end

@implementation ZHJDownloadListiCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setList:(ZHJDownloaLlist *)list {
    if (list) {
        _list = list;
        self.movieName.text = [list.url lastPathComponent];
        if (list.isDownload) {
            [self.downloadButton removeFromSuperview];
            [self showDownloadViews];
        } else {
           
        }
        self.progressView.progress = list.progress;
        self.progressValueLabel.text = [NSString stringWithFormat:@"%d%%",(int)(list.progress*100)];
    }
}

- (void)showDownloadViews {
    for (int i = 100; i < 104; i++) {
        UIView *view = [self viewWithTag:i];
        view.hidden = NO;
    }
}

- (IBAction)downloadMovie:(UIButton *)sender {
    [sender removeFromSuperview];
   
    if (self.downloadMovieBlock) {
        self.downloadMovieBlock([self.list.url lastPathComponent]);
    }
}

- (IBAction)downloadControl:(UIButton *)sender {
    if (self.downloadControlBlock) {
        self.downloadControlBlock(sender);
    }
}
@end
