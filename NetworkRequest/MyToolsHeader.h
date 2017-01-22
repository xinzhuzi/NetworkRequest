
//
//  HeaderZSJPractive.h
//  ZSJPractice
//
//  Created by ZhouLord on 16/1/21.
//  Copyright © 2016年 junL. All rights reserved.
//
#pragma mark ---------------第三方库--------------


#pragma mark ---------------小工具--------------
#import "Tools.h"
#import "Singleton.h"
#import "AFHTTPHeader.h"

#pragma mark ---------------UI宏定义--------------
//主窗口的宽、高
#define Screen_W   [UIScreen mainScreen].bounds.size.width
#define Screen_H   [UIScreen mainScreen].bounds.size.height


#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBA_Color(r,g,b,a)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KeyBoardDisappear [[[UIApplication sharedApplication] keyWindow] endEditing:YES]

#pragma mark ---------------辅助工具宏定义--------------
#define BeginCodeTime   [[NSUserDefaults standardUserDefaults] setDouble:CACurrentMediaTime() forKey:@"代码运行开始时间"];\
[[NSUserDefaults standardUserDefaults] synchronize]
#define EndCodeTime NSLog(@"代码执行耗费了:%8.2f ms",(CACurrentMediaTime() - [[NSUserDefaults standardUserDefaults] doubleForKey:@"代码运行开始时间"]) *1000)
#define weakVariable(variable)  __weak __block typeof(&*variable)weak_##variable = variable


///iOS版本
#define iOS_9_Later  [[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0
#define iOS_8_Later  [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0
#define iOS_7  [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0
#define iOS_6  [[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0

// 设置NSLog可以打印出类名,方法名,行数.
#ifdef DEBUG
#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(fmt,...) {}
#endif





