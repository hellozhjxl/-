//
//  ZHJNSURLSessionDemo.m
//  ZHJVideoRUDP
//
//  Created by zhj on 2018/10/13.
//  Copyright © 2018年 zhj. All rights reserved.
//

#import "ZHJNSURLSessionDemo.h"

@interface ZHJNSURLSessionDemo() <NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>

@end

@implementation ZHJNSURLSessionDemo

-(instancetype)init {
    if (self = [super init]) {
//        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//        NSLog(@"%@",path);
    }
    return self;
}

#pragma mark----------------------
#pragma mark get请求
- (void)get {
    //1.创建url
    NSString *urlStr = [[SERVER stringByAppendingString:API_LOGIN] stringByAppendingString:@"?username=zhj&&password=123"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //2.初始化NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    //3.创建dataTask
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                NSString *respStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                NSLog(@"%@",respStr);
                                            }];
    //启动task
    [task resume];
}

#pragma mark----------------------
#pragma mark post请求
- (void)post {
    //1.创建url
    NSString *urlStr = [SERVER stringByAppendingString:API_LOGIN];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //1.1设置request
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"username=zhj&&password=123" dataUsingEncoding:NSUTF8StringEncoding];
    //2.初始化NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    //3.创建dataTask
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                NSString *respStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                NSLog(@"%@",respStr);
                                            }];
    //启动task
    [task resume];
}

#pragma mark----------------------
#pragma mark 下载1
/**
 方法1:无法监听进度
 */
- (void)downLoadVideo1 {
    NSString *urlStr = [SERVER stringByAppendingString:API_MOVIERESOURCE];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    /**
     这个方法实现了边接收数据边写入沙盒的tmp文件夹下,会马上被删除,所以要把文件剪切到Document文件夹
     */
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@---%@",location,error);
        //获取沙盒路径
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //拼接文件名,用拼接路径的这个方法stringByAppendingPathComponent
        NSString *filename = [response suggestedFilename];
        NSString *fullPath = [path stringByAppendingPathComponent:filename];
        //剪切文件
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
        NSLog(@"%@",fullPath);
    }];
    [task resume];
}

#pragma mark----------------------
#pragma mark 下载2
/**
 方式2:使用代理方式可以监听下载进度,这种方式在断点下载时候不合适
 */
- (void)downloadVideo2 {
    NSString *urlStr = [SERVER stringByAppendingString:API_MOVIERESOURCE];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置代理
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    [task resume];
}

#pragma mark NSURLSessionDownloadDelegate
//下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    //获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //拼接文件名,用拼接路径的这个方法stringByAppendingPathComponent
    NSString *filename = [downloadTask.response suggestedFilename];
    NSString *fullPath = [path stringByAppendingPathComponent:filename];
    //剪切文件
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
    NSLog(@"%@",fullPath);
}

//监听进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"%f",1.f*totalBytesWritten/totalBytesExpectedToWrite);
}

//下载失败,恢复下载
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"%s",__func__);
}

//这个代理方式是NSURLSessionTaskDelegate的,请求完成时候调用,NSURLSessionDownloadDelegate继承自NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"%s",__func__);
}


@end
