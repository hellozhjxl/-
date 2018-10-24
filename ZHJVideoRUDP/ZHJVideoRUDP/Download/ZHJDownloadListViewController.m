//
//  ZHJDownloadListViewController.m
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/24.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import "ZHJDownloadListViewController.h"
#import "ZHJDownloadListiCell.h"
#import "ZHJDownloaLlist.h"
#import "ZHJDownloadManager.h"

@interface ZHJDownloadListViewController ()
@property (nonatomic, strong) NSMutableArray *movieList;
@property (nonatomic, strong) ZHJDownloadManager *manager;
@property (nonatomic, assign) BOOL observeFlag;
@end

@implementation ZHJDownloadListViewController

- (NSMutableArray *)movieList {
    if (!_movieList) {
        _movieList = [NSMutableArray arrayWithCapacity:3];
    }
    return _movieList;
}

- (ZHJDownloadManager *)manager {
    if (!_manager) {
        _manager = [ZHJDownloadManager defaultManager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 110;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZHJDownloadListiCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ZHJDownloadListiCell class])];
    [self requestData];
    self.observeFlag = NO;
}

//请求数据
- (void)requestData {
   NetworkManager *manager = [NetworkManager shareNetworkManager];
    [manager GETUrl:API_MOVIERESOURCE parameters:nil success:^(id responseObject) {
        NSArray *list = responseObject;
        for (NSString *url in list) {
            ZHJDownloaLlist *obj = [[ZHJDownloaLlist alloc] init];
            obj.url = url;
            [self.movieList addObject:obj];
        }
        [self initProgress];
        [self.tableView reloadData];
    } failure:^(NSError *error, ParamtersJudgeCode judgeCode) {
        NSLog(@"fail");
    }];
}

- (void)initProgress {
    for (ZHJDownloaLlist *list in self.movieList) {
        NSString *url = [NSString stringWithFormat:@"%@%@",SERVER,list.url];
        float progress = [self.manager getProgressWithUrl:url];
        list.progress = progress;
        if (progress != 0) {
            list.download = YES;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movieList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHJDownloadListiCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZHJDownloadListiCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZHJDownloaLlist *list = self.movieList[indexPath.row];
    cell.list = list;
    //判断任务是否正在下载
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER,list.url];
    ZHJDownloadFile *dwonloadFile = [self.manager downloadFileForUrl:url];
    if (dwonloadFile) {
        if (dwonloadFile.taskState == NSURLSessionTaskStateRunning ||
            dwonloadFile.taskState == NSURLSessionTaskStateSuspended) {
            [self observeProgerssWithUrl:url];
            self.observeFlag = YES;
        }
    }
    //下载电影
    __weak typeof(self) weakself = self;
    cell.downloadMovieBlock = ^(NSString *filename) {
        list.download = YES;
        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakself.manager downloadWithUrl:url];
        [weakself observeProgerssWithUrl:url];
        weakself.observeFlag = YES;
    };
     //暂停,继续
    cell.downloadControlBlock = ^(UIButton *sender) {
        if (sender.tag == 100) {
            [dwonloadFile suspend];
        } else if (sender.tag == 101) {
            if (!dwonloadFile) {
                [weakself.manager downloadWithUrl:url];
                [weakself observeProgerssWithUrl:url];
                weakself.observeFlag = YES;
            }else {
                [dwonloadFile resume];
            }
        }
    };
    return cell;
}

#pragma mark 监听下载进度
- (void)observeProgerssWithUrl:(NSString *)url {
    if (!self.observeFlag) {
        ZHJDownloadFile *dwonloadFile = [self.manager downloadFileForUrl:url];
        if (dwonloadFile) {
            [dwonloadFile addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    ZHJDownloadFile *obj;
    if ([object isKindOfClass:[ZHJDownloadFile class]]) {
        obj = (ZHJDownloadFile *)object;
    }
    if ([keyPath isEqualToString:@"progress"]){
        dispatch_async(dispatch_get_main_queue(), ^{
           [self setProgressWithUrl:obj.url value:obj.progress];
        });
    }
}

- (void)setProgressWithUrl:(NSString *)url value:(float)value {
    int i = 0;
    for (ZHJDownloaLlist *list in self.movieList) {
        if ([[list.url lastPathComponent] isEqualToString:[url lastPathComponent]]) {
            list.progress = value;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        i++;
    }
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    for (NSString *url in [self.manager urls]) {
        ZHJDownloadFile *dwonloadFile = [self.manager downloadFileForUrl:url];
        [dwonloadFile removeObserver:self forKeyPath:@"progress"];
    }
}

@end
