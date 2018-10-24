//
//  ViewController.m
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/9.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import "ViewController.h"
#import "ZHJNSURLSessionDemo.h"
#import "ZHJDownloadListViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation ViewController

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"录制",@"上传",@"下载",@"播放",@"ZHJNSURLSessionDemo测试"];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择功能";
    //初始化tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2://下载
        {
            ZHJDownloadListViewController *vc = [[ZHJDownloadListViewController alloc] init];
            vc.title = @"下载列表";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4: //测试ZHJNSURLSessionDemo
        {
            ZHJNSURLSessionDemo *demo = [[ZHJNSURLSessionDemo alloc] init];
            //[demo get];
            //[demo post];
            //[demo downLoadVideo1];
            [demo downloadVideo2];
        }
            break;
        default:
            break;
    }
}



@end
