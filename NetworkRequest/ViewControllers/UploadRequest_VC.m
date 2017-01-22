//
//  UploadRequest_VC.m
//  NetworkRequest
//
//  Created by 郑冰津 on 2017/1/16.
//  Copyright © 2017年 IceGod. All rights reserved.
//

#import "UploadRequest_VC.h"
#import <objc/message.h>
#import "AFNetworking/UIKit+AFNetworking/UIProgressView+AFNetworking.h"

@interface UploadRequest_VC ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *urlArrays;
}

@end

@implementation UploadRequest_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [baseTableView removeFromSuperview];
    
    urlArrays = @[@"http://v.juhe.cn/toutiao/avatar",@"http://v.juhe.cn/toutiao/avatar"];
    
    arrayVClass = @[@"POST上传数据",@"上传数据"].mutableCopy;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"断点上传" style:UIBarButtonItemStylePlain target:self action:@selector(goToVC)];
    
    baseTableView = tableView;
}

- (void)goToVC{
    [self.navigationController pushViewController:[NSClassFromString(@"BreakpointUpload_VC") new] animated:YES];
}
- (void)showPath{
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
        [progressView setProgressWithUploadProgressOfTask:(NSURLSessionUploadTask *)task animated:YES];
        downLabel.text = [NSString stringWithFormat:@"%.2f%%",progressView.progress*100];
    }else{
        progressView.progress = 0.0f;
        downLabel.text = @"00.00%%";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selString = @[@"POSTUploadTest:",@"UploadRequestTest:"][indexPath.row];
    NSString *url = urlArrays[indexPath.row];
    SEL gcdSEL = NSSelectorFromString(selString);
    if ([self respondsToSelector:gcdSEL]) {
        ((void (*)(id self, SEL,NSString *))objc_msgSend)(self, gcdSEL,url);
    }
}

- (void)POSTUploadTest:(NSString *)url{
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"iOS_IT技能.png"], 1);
    NSData *imageData1 = UIImageJPEGRepresentation([UIImage imageNamed:@"位数区别.jpg"], 1);
    [AFHTTPRequest POSTUpload:url parameters:nil uploadType:UploadDownloadType_Images dataArray:@[imageData,imageData1] response:^(id requestObjectData) {
        NSLog(@"POSTUpload-->%@",requestObjectData);
    }];
}

- (void)UploadRequestTest:(NSString *)url{
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"iOS_IT技能.png"], 1);
    [AFHTTPRequest upload:url uploadData:imageData response:^(id responesData) {
        NSLog(@"upload-->%@",responesData);
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



