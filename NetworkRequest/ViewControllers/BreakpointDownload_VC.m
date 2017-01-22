//
//  BreakpointDownload_VC.m
//  NetworkRequest
//
//  Created by 郑冰津 on 2017/1/19.
//  Copyright © 2017年 IceGod. All rights reserved.
//

#import "BreakpointDownload_VC.h"
#import "MyToolsHeader.h"
#import "AFNetworking/UIKit+AFNetworking/UIProgressView+AFNetworking.h"

#define MovFilePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
//@"http://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg"
//@"http://lensbuyersguide.com/gallery/219/2/23_iso100_14mm.jpg" 效果最好
#define URLString @"http://lensbuyersguide.com/gallery/219/2/23_iso100_14mm.jpg"


@interface BreakpointDownload_VC ()
{
    UIProgressView *progressView;
}
@property(nonatomic,strong)UIImageView *imageV;
///断点下载的data
@property(nonatomic,strong)NSData *dResumeData;

@end

@implementation BreakpointDownload_VC

- (void)dealloc{
    NSLog(@"对象被销毁了:%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"断点下载";
    /*
     1.下载过后,点击取消
     2.杀掉进程
     3.再次进入,仍然可以恢复下载.接上次下载的数据进行下载
     */
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc]initWithItems:@[@"开始",@"取消",@"恢复"]];
    segmented.frame = CGRectMake(0, 100, Screen_W, 60);
    [segmented addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmented];
    
    progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(0, 180, Screen_W, 5);
    progressView.backgroundColor = [UIColor darkGrayColor];
    progressView.progressTintColor = [UIColor blueColor];
    progressView.tag = 677;
    [self.view addSubview:progressView];
    
    _imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, Screen_W, 200)];
    [self.view addSubview:_imageV];
    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/resumeData",MovFilePath]];
    if (data) {
        self.dResumeData = data;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    weakVariable(self);
    NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask *)[AFHTTPRequest requestATaskWith:URLString];
    [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        weak_self.dResumeData = resumeData;
        BOOL isOk = [resumeData writeToFile:[NSString stringWithFormat:@"%@/resumeData",MovFilePath] atomically:YES];
        if (isOk) {
            NSLog(@"resumeData已经存储,杀掉进程,然后在恢复下载");
        }
    }];
}

- (void)segmentedAction:(UISegmentedControl *)segmented{
    NSLog(@"\n%@\n",NSHomeDirectory());
    weakVariable(self);
    if (segmented.selectedSegmentIndex==0) {
        [AFHTTPRequest download:URLString filePath:MovFilePath response:^(id responesData) {
            NSLog(@"%@",responesData);
        }];
        NSURLSessionDownloadTask *dTask = (NSURLSessionDownloadTask *)[AFHTTPRequest requestATaskWith:URLString];
        [progressView setProgressWithDownloadProgressOfTask:dTask animated:YES];
    }else if (segmented.selectedSegmentIndex==1){
        NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask *)[AFHTTPRequest requestATaskWith:URLString];
        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            weak_self.dResumeData = resumeData;
            BOOL isOk = [resumeData writeToFile:[NSString stringWithFormat:@"%@/resumeData",MovFilePath] atomically:YES];
            if (isOk) {
                NSLog(@"resumeData已经存储,杀掉进程,然后在恢复下载");
            }
        }];
    }else if (segmented.selectedSegmentIndex==2){
        [AFHTTPRequest downloadBreakpoint:_dResumeData filePath:MovFilePath response:^(id responesData) {
            NSLog(@"%@",responesData);
            if ([responesData isKindOfClass:[NSURL class]]) {
                weak_self.imageV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:responesData]];
                weak_self.dResumeData = nil;
                ///得到数据之后需要把缓存的resumeData移除,具体怎么来,按照自己的逻辑,我这个地方是为了沙盒不存在垃圾文件
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/resumeData",MovFilePath] error:nil];
            }
        }];
        NSURLSessionDownloadTask *dTask = (NSURLSessionDownloadTask *)[AFHTTPRequest requestATaskWith:URLString];
        [progressView setProgressWithDownloadProgressOfTask:dTask animated:YES];
    }
}

@end
