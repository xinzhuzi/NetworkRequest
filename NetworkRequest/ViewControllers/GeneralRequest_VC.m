//
//  GeneralRequest_VC.m
//  NetworkRequest
//
//  Created by 郑冰津 on 2016/12/22.
//  Copyright © 2016年 IceGod. All rights reserved.
//

#import "GeneralRequest_VC.h"
#import <objc/message.h>

@interface GeneralRequest_VC ()

@end

@implementation GeneralRequest_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrayVClass = @[@"get普通请求",@"get下载请求",@"HEAD请求",@"POST请求",@"PUT请求",@"PATCH请求",@"DELETE请求"].mutableCopy;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selString = @[@"getRequestTest",@"getDownloadRequestTest",@"HEADRequestTest",@"POSTRequestTest",@"PUTRequestTest",@"PATCHRequestTest",@"DELETERequestTest"][indexPath.row];
    SEL gcdSEL = NSSelectorFromString(selString);
    if ([self respondsToSelector:gcdSEL]) {
        ((void (*)(id self, SEL))objc_msgSend)(self, gcdSEL);
    }
}


//[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"451108668"]
//@"http://blog.csdn.net/u010962810"
- (void)getRequestTest{
    [AFHTTPRequest GET:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"451108668"] parameters:nil response:^(id responesData) {
        if (responesData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responesData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",dict);
        }else{
            NSLog(@"被取消或者根本就没有数据");
        }
    }];
}

- (void)getDownloadRequestTest{
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"路径:%@",filePath);
    // http://www.i1766.com/dushu/22757.html /  http://www.cocoachina.com/bbs/job.php?action=download&aid=33531 下载小说看,文档看,Microsoft软件等等,都可以用,下面的方式.注意一定要向服务器询问请求头是什么格式,下面的请求头格式是Content-Type 数据类型是@"application/force-download" 直接在源码里面添加即可 note:如果在下载中取消,则再次下载会重新下载
    [AFHTTPRequest GETDownload:@"http://dzs.qisuu.com/txt/寻宝美利坚.txt" parameters:nil filePath:filePath response:^(id responesData) {
        NSLog(@"GETDownload:%@",responesData);
    }];
    //[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"451108668"]
}

- (void)HEADRequestTest{
    NSLog(@"请求到的是文件的类型%@",NSHomeDirectory());
    [AFHTTPRequest HEAD:@"http://blog.csdn.net/u010962810" parameters:nil response:^(id responesData) {
        if (responesData) {
            NSLog(@"%@",responesData);
        }else{
            NSLog(@"被取消或者根本就没有数据");
        }
    }];
}

- (void)POSTRequestTest{
    NSDictionary *dict = @{@"username":@"zhengbingjin",@"pwd":@"123456789",@"email":@"1487842110@qq.com",@"tel":@"18336093105"};
    
    [AFHTTPRequest POST:@"http://www.ubabytv.com.cn/ubabytvapp/app_regiester.php" parameters:dict response:^(id responesData) {
        if (responesData) {
            NSString *res = [[NSString alloc]initWithData:responesData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",res);
        }else{
            NSLog(@"没有数据,或者传参不对,请求不对");
        }
    }];
    
    NSDictionary *parameter = @{@"type":@"top",
                                @"key":@"3a7bda4e7369437ce9450026789a29c3"};
    [AFHTTPRequest POST:@"http://v.juhe.cn/toutiao/index" parameters:parameter response:^(id responesData) {
        if (responesData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responesData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",dict);
        }else{
            NSLog(@"没有数据,或者传参不对,请求不对");
        }
    }];
}

#pragma mark ------------以下三种,没有对应的服务器测试,也不愿意去网络上寻找,但是大致都是这个套路,如有其它特殊需求,进源码自行修改

- (void)PUTRequestTest{
    [AFHTTPRequest PUT:@"" parameters:nil response:^(id responesData) {
        
    }];
}

- (void)PATCHRequestTest{
    [AFHTTPRequest PATCH:@"" parameters:nil response:^(id responesData) {
        
    }];
}

- (void)DELETERequestTest{
    [AFHTTPRequest DELETE:@"" parameters:nil response:^(id responesData) {
        
    }];
}



@end





