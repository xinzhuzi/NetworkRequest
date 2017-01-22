//
//  Parent_Class_VC.m
//  SOFTDA
//
//  Created by 郑冰津 on 16/7/20.
//  Copyright © 2016年 IceGod. All rights reserved.
//

#import "Parent_Class_VC.h"

@interface Parent_Class_VC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation Parent_Class_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor redColor];
    
    ///下面这个属性设置为NO的时候(不透明的导航栏),没有高斯模糊效果,此时会向下方移动64的距离
    self.navigationController.navigationBar.translucent = NO;
    ///下面这个属性,当设置为不透明的导航栏的时候,需要把属性设置成为YES,充满全屏
    self.extendedLayoutIncludesOpaqueBars = YES;
    ///这个属性默认是UIRectEdgeAll,充满全屏
    self.edgesForExtendedLayout = UIRectEdgeAll;
    ///当前此界面有UIScrollView被加载的时候,把此属性设置为NO,充满全屏
    self.automaticallyAdjustsScrollViewInsets = NO;

    ///下面这个属性设置为NO的时候(不透明的底部标签栏),没有高斯模糊效果.设置为YES或者NO,对self.view都没有任何影响效果,总是占据49的距离
    self.navigationController.tabBarController.tabBar.translucent = NO;
    
    ///这一句不注明,会因为按下home键,再次启动APP信号栏会有黑色的问题!,因为NAV本身是黑色的
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    
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
    baseTableView = tableView;
}

#pragma mark -------------------------UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayVClass.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
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
    }
    cell.textLabel.text=arrayVClass[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *nameVC=arrayVClass[indexPath.row];
    Class VC=NSClassFromString(nameVC);
    //    NSLog(@"push---> %@",arrayVClass[indexPath.row]);
    if (VC) {
        [self.navigationController pushViewController:[VC new] animated:YES];
    }
    //    NSBundle *bundle=[NSBundle mainBundle];
    //    NSString *path=[bundle pathForResource:nameVC ofType:@"class"];
    //    Class newClass=[bundle classNamed:nameVC];
    //    if (newClass) {
    //        NSLog(@"bundle: 可以用这个东西跳转VC");
    //    }
}

///做一下简单的横竖屏的适配!!!!里面的问题很大!!!
//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
//        baseTableView.frame = CGRectMake(0, 64, Screen_W, Screen_H-64);
//    }else{
//        baseTableView.frame = CGRectMake(0, 44, Screen_W, Screen_H-44-49);
//    }
//}

@end
