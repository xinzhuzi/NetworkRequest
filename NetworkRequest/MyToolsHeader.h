
//
//  HeaderZSJPractive.h
//  ZSJPractice
//
//  Created by ZhouLord on 16/1/21.
//  Copyright © 2016年 junL. All rights reserved.
//
#pragma mark ---------------第三方库--------------


#pragma mark ---------------自定义工具--------------
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


#pragma mark ------------------------Unicode反编码------------------
@interface NSArray (HYBUnicodeReadable)

@end

@interface NSDictionary (HYBUnicodeReadable)

@end

@interface NSSet (HYBUnicodeReadable)

@end



#pragma mark ------------------------Unicode反编码------------------
@implementation NSArray (HYBUnicodeReadable)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
    }
    [desc appendString:@"\t(\n"];
    
    for (id obj in self) {
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            [desc appendFormat:@"%@\t%@,\n", tab, str];
        } else if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
        } else {
            [desc appendFormat:@"%@\t%@,\n", tab, obj];
        }
    }
    
    [desc appendFormat:@"%@)", tab];
    
    return desc;
}




@end

@implementation NSDictionary (HYBUnicodeReadable)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
    }
    
    [desc appendString:@"\t{\n"];
    
    // 遍历数组,self就是当前的数组
    for (id key in self.allKeys) {
        id obj = [self objectForKey:key];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, obj];
        } else if ([obj isKindOfClass:[NSArray class]]
                   || [obj isKindOfClass:[NSDictionary class]]
                   || [obj isKindOfClass:[NSSet class]]) {
            [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, [obj descriptionWithLocale:locale indent:level + 1]];
        } else {
            [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
        }
    }
    
    [desc appendFormat:@"%@}", tab];
    
    return desc;
}

@end

@implementation NSSet (HYBUnicodeReadable)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = @"\t";
    if (level > 0) {
        tab = tabString;
    }
    [desc appendString:@"\t{(\n"];
    
    for (id obj in self) {
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            [desc appendFormat:@"%@\t%@,\n", tab, str];
        } else if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
        } else {
            [desc appendFormat:@"%@\t%@,\n", tab, obj];
        }
    }
    
    [desc appendFormat:@"%@)}", tab];
    
    return desc;
}

@end
