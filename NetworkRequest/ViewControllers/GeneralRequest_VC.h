//
//  GeneralRequest_VC.h
//  NetworkRequest
//
//  Created by 郑冰津 on 2016/12/22.
//  Copyright © 2016年 IceGod. All rights reserved.
//

#import "Parent_Class_VC.h"

@interface GeneralRequest_VC : Parent_Class_VC

@end

/*
 
 [AFHTTPRequest GET:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"1071519523"] parameters:nil respones:^(id responesData) {
 if (responesData) {
 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responesData options:NSJSONReadingAllowFragments error:nil];
 NSLog(@"%@",dict);
 }else{
 NSLog(@"被取消或者根本就没有数据");
 }
 }];
 
 ///测试下面的代码看看,
 //取消
 [AFHTTPRequest cancelATaskWith:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"1071519523"]];
 
// 暂停和恢复请求的任务场景相对复杂,并且一定要测试超时时间,不过已经写好,请自行测试复杂场景,[NSString stringWithFormat:@"http:itunes.apple.com/lookup?id=%@",@"1071519523"]并不适用暂停恢复场景.
//暂停
[AFHTTPRequest suspendATaskWith:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"1071519523"]];
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    [NSThread sleepForTimeInterval:3];
    //恢复
    [AFHTTPRequest resumeATaskWith:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"1071519523"]];
});

 */
