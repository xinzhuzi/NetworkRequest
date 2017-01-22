//
//  DownloadRequest_VC.m
//  NetworkRequest
//
//  Created by 郑冰津 on 2017/1/16.
//  Copyright © 2017年 IceGod. All rights reserved.
//

#import "DownloadRequest_VC.h"
#import <objc/message.h>
#import "AFNetworking/UIKit+AFNetworking/UIProgressView+AFNetworking.h"

#define MovFilePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]


@interface DownloadRequest_VC ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *urlArrays;
}



@end

@implementation DownloadRequest_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [baseTableView removeFromSuperview];
    
    /*
     前台测试,不可后台,不可断点下载,暂停过长,再重连服务器出现问题
     
     可暂停恢复,查询当前下载的进度
     
     下载速度的计算
     http://www.superqq.com/blog/2015/01/29/ioskai-fa-xia-zai-wen-jian-su-du-ji-suan/
     
     模拟器测试可以后台下载
     */
    
    arrayVClass = @[@"QQ最新版->普通下载",@"QQ专版->普通下载",@"欧陆词典->普通下载",@"图片->普通下载"].mutableCopy;
    urlArrays = @[@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg",@"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V1.4.1.dmg",@"http://m2.pc6.com/mac/oulu.dmg",@"http://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg"];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, Screen_W, Screen_H-64) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    [tableView setSeparatorColor:[UIColor purpleColor]];
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(showPath)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"断点下载" style:UIBarButtonItemStylePlain target:self action:@selector(goToVC)];
    
    baseTableView = tableView;
    
}
- (void)goToVC{
    [self.navigationController pushViewController:[NSClassFromString(@"BreakpointDownload_VC") new] animated:YES];
}
- (void)showPath{
    //当前时间和上一秒时间做对比，大于等于一秒就去计算
    //下载速度(多少KB/1秒) = 总量/时间-->1秒的速度 = (总量-原来记录的量)/1s (更新原来记录的量)
    
    for (NSString *url in urlArrays) {
        NSURLSessionTask *task = [AFHTTPRequest requestATaskWith:url];
        if (task.state==NSURLSessionTaskStateCompleted) {
            return;
        }
        int64_t received = task.countOfBytesReceived/1024/1024;
        int64_t receivedExpected = task.countOfBytesExpectedToReceive/1024/1024;
        float percentage = (float)task.countOfBytesReceived/(float)task.countOfBytesExpectedToReceive;
        if (received>0.0f) {
            NSLog(@"%@ 计算正确%lld %lldM %f ID:%lu",NSHomeDirectory(),received,receivedExpected,percentage,(unsigned long)task.taskIdentifier);
        }
    }
    
    [baseTableView reloadData];
}

#pragma mark -----------UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayVClass.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IDCell=@"IDCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:IDCell];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDCell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.frame = CGRectMake(15, 60, Screen_W-160, 5);
        progressView.backgroundColor = [UIColor darkGrayColor];
        progressView.progressTintColor = [UIColor blueColor];
        progressView.tag = 677;
        [cell addSubview:progressView];
        
        UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_W-160, 60, 60, 20)];
        downLabel.textColor = [UIColor blueColor];
        downLabel.tag = 899;
        downLabel.text = @"00:00%%";
        [cell addSubview:downLabel];
        
        UIButton *suspendBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_W-100, 20, 40, 40)];
        [suspendBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [suspendBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [suspendBtn addTarget:self action:@selector(suspendButtonClickAction:event:) forControlEvents:UIControlEventTouchUpInside];
        suspendBtn.tag = 678;
        [cell addSubview:suspendBtn];
        
        UIButton *resumeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_W-50, 20, 40, 40)];
        [resumeBtn setTitle:@"恢复" forState:UIControlStateNormal];
        [resumeBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [resumeBtn addTarget:self action:@selector(resumeButtonClickAction:event:) forControlEvents:UIControlEventTouchUpInside];
        resumeBtn.tag = 678;
        [cell addSubview:resumeBtn];
        
        
    }
    cell.textLabel.text=arrayVClass[indexPath.row];
    
    NSURLSessionTask *task = [AFHTTPRequest requestATaskWith:urlArrays[indexPath.row]];
    
    UIProgressView *progressView = (UIProgressView *)[cell viewWithTag:677];
    UILabel *downLabel = (UILabel *)[cell viewWithTag:899];

    if (task) {
        [progressView setProgressWithDownloadProgressOfTask:(NSURLSessionDownloadTask *)task animated:YES];
        downLabel.text = [NSString stringWithFormat:@"%.2f%%",progressView.progress*100];
    }else{
        progressView.progress = 0.0f;
        downLabel.text = @"00.00%%";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    weakVariable(urlArrays);
    NSString *urlString = weak_urlArrays[indexPath.row];
    
    NSURLSessionTaskState state =  [AFHTTPRequest requestATaskStateWith:urlString];
    if (state==NSURLSessionTaskStateRunning) {
        return;
    }
    if (state==NSURLSessionTaskStateSuspended) {
        return;
    }
    if (state==NSURLSessionTaskStateCanceling) {
        return;
    }
    
    [AFHTTPRequest download:urlString filePath:MovFilePath response:^(id responesData) {
        NSLog(@"%@",responesData);
    }];
    
}
//暂停
- (void)suspendButtonClickAction:(UIButton *)button event:(UIEvent *)event{
    CGPoint location = [[[event allTouches] anyObject] locationInView:baseTableView];
    NSIndexPath *indexPath = [baseTableView indexPathForRowAtPoint:location];
    NSString *urlString = urlArrays[indexPath.row];
    [AFHTTPRequest suspendATaskWith:urlString];
}
//恢复
- (void)resumeButtonClickAction:(UIButton *)button event:(UIEvent *)event{
    CGPoint location = [[[event allTouches] anyObject] locationInView:baseTableView];
    NSIndexPath *indexPath = [baseTableView indexPathForRowAtPoint:location];
    NSString *urlString = urlArrays[indexPath.row];
    [AFHTTPRequest resumeATaskWith:urlString];
}



@end




