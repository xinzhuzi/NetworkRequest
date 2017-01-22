//
//  DownloadRequest_VC.h
//  NetworkRequest
//
//  Created by 郑冰津 on 2017/1/16.
//  Copyright © 2017年 IceGod. All rights reserved.
//

#import "Parent_Class_VC.h"

@interface DownloadRequest_VC : Parent_Class_VC

@end

/*
 [AFHTTPRequest download:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.3.1.dmg" filePath:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] progress:^(double progress) {
 NSLog(@"---%f",progress);
 } respones:^(NSError *error) {
 NSLog(@"%@",error);
 }];
 
 [AFHTTPRequest suspendATaskWith:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.3.1.dmg"];
 
 
 */

