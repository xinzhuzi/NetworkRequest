//
//  SpecialRequest_VC.m
//  NetworkRequest
//
//  Created by 郑冰津 on 2017/1/16.
//  Copyright © 2017年 IceGod. All rights reserved.
//

#import "SpecialRequest_VC.h"
#import <objc/message.h>
#import "AFNetworking/AFNetworking.h"

@interface SpecialRequest_VC ()

@end

@implementation SpecialRequest_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrayVClass = @[@"Cookie手动设置",@"WebView的Cookie设置",@"soap(POST)请求"].mutableCopy;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selString = @[@"CookieSetStorage",@"WebCookieSet",@"soapPostRequestXml"][indexPath.row];
    SEL gcdSEL = NSSelectorFromString(selString);
    if ([self respondsToSelector:gcdSEL]) {
        ((void (*)(id self, SEL))objc_msgSend)(self, gcdSEL);
    }
}

- (void)CookieSetStorage{

    //第二步:在程序重启时，NSHTTPCookieStorage 并不会保存上一次使用应用时的 cookie，所以我们需要在程序启动时读取自己保存的 cookie，同时更新 NSHTTPCookieStorage 的 cookie。关于 cookie 的有效期处理，在使用 cookie 时需要自己判断 cookie 是否过期.
    NSDictionary *cookieProperties = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDefaultUserCookieKey"];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    //第一步:玩过请求过后,cookie都被系统所处理,我只需要取出即可
    NSArray <NSHTTPCookie *> *cookies =[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;  // 只要服务器在请求返回时带了 cookie，NSHTTPCookieStorage 就会自动帮我们管理 cookie
    for (NSHTTPCookie *aCookie in cookies) {
        if ([aCookie.name isEqualToString:@"BUA"]) {  // 获取并保存用户cookie
            [[NSUserDefaults standardUserDefaults] setObject:aCookie.properties forKey:@"UserDefaultUserCookieKey"]; // 自己做持久化存储
            break;
        }
    }
    
    
    //第三步:如果过期了，就要废弃掉失效的 cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserDefaultUserCookieKey"];
    
}

- (void)WebCookieSet{
    /*
     UIWebView 是属于 URL Loading System 的一部分，所以系统会自动帮我们将 NSHTTPCookieStorage 中的 cookie 同步到 UIWebView 中去。
     由于 WKWebView 是独立于 URL Loading System 之外的，所以 WKWebView 所有的 cookie 管理都需要开发者自己操作，具体方法可以参考 stackoverflow 上的解决方案：Can I set the cookies to be used by a WKWebView?，也有国内开发者根据这个答案造了一个轮子 haifengkao/YWebView。
     https://segmentfault.com/a/1190000004556040
     
     可以使用YWebView库  cocoapods安装
     将单条Cookie字符串转成NSHTTPCookie对象,Cookie的规范可以见相应的RFC文档 http://tools.ietf.org/html/rfc6265 ,从以下代理方法中获取Cookie字符串
     - (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
     从NSArray<NSString*>* cookies = [message.body componentsSeparatedByString:@"; "];里面获取
     遍历得到字符串
     */
    NSMutableArray<NSString*>* cookies = [[@"VERSION=1; PATH=P; NAME=Servers; VALUE=V" componentsSeparatedByString:@"; "] mutableCopy];
    [cookies addObject:@"ORIGINURL=https://www.baidu.com"];
    
    NSMutableDictionary *cookieMap = @{}.mutableCopy;
    for (NSString *cookieKeyValueString in cookies) {
        NSRange separatorRange = [cookieKeyValueString rangeOfString:@"="];
        if (separatorRange.location != NSNotFound &&
            separatorRange.location > 0 &&
            separatorRange.location < ([cookieKeyValueString length] - 1)) {
            //以上条件确保"="前后都有内容，不至于key或者value为空
            NSRange keyRange = NSMakeRange(0, separatorRange.location);
            NSString *key = [cookieKeyValueString substringWithRange:keyRange];
            NSString *value = [cookieKeyValueString substringFromIndex:separatorRange.location + separatorRange.length];
            key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [cookieMap setObject:value forKey:key];
            NSLog(@"value:%@  key:%@",value,key);
        }
    }
    NSDictionary * cookieDict= [self.class cookieProperties:cookieMap];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDict];
    if (cookie) {//设置保存cookie
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

+ (NSDictionary *)cookieProperties:(NSDictionary *)cookieMap{
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    for (NSString *key in [cookieMap allKeys]) {
        
        NSString *value = [cookieMap objectForKey:key];
        NSString *uppercaseKey = [key uppercaseString];//主要是排除命名不规范的问题
        
        if ([uppercaseKey isEqualToString:@"DOMAIN"]) {
            if (![value hasPrefix:@"."] && ![value hasPrefix:@"www"]) {
                value = [NSString stringWithFormat:@".%@",value];
            }
            [cookieProperties setObject:value forKey:NSHTTPCookieDomain];
        }else if ([uppercaseKey isEqualToString:@"VERSION"]) {
            [cookieProperties setObject:value forKey:NSHTTPCookieVersion];
        }else if ([uppercaseKey isEqualToString:@"MAX-AGE"]||[uppercaseKey isEqualToString:@"MAXAGE"]) {
            [cookieProperties setObject:value forKey:NSHTTPCookieMaximumAge];
        }else if ([uppercaseKey isEqualToString:@"PATH"]) {
            [cookieProperties setObject:value forKey:NSHTTPCookiePath];
        }else if([uppercaseKey isEqualToString:@"ORIGINURL"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieOriginURL];
        }else if([uppercaseKey isEqualToString:@"PORT"]){
            [cookieProperties setObject:value forKey:NSHTTPCookiePort];
        }else if([uppercaseKey isEqualToString:@"SECURE"]||[uppercaseKey isEqualToString:@"ISSECURE"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieSecure];
        }else if([uppercaseKey isEqualToString:@"COMMENT"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieComment];
        }else if([uppercaseKey isEqualToString:@"COMMENTURL"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieCommentURL];
        }else if([uppercaseKey isEqualToString:@"EXPIRES"]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            dateFormatter.dateFormat = @"EEE, dd-MMM-yyyy HH:mm:ss zzz";
            [cookieProperties setObject:[dateFormatter dateFromString:value] forKey:NSHTTPCookieExpires];
        }else if([uppercaseKey isEqualToString:@"DISCART"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieDiscard];
        }else if([uppercaseKey isEqualToString:@"NAME"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieName];
        }else if([uppercaseKey isEqualToString:@"VALUE"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieValue];
        }else{
            [cookieProperties setObject:key forKey:NSHTTPCookieName];
            [cookieProperties setObject:value forKey:NSHTTPCookieValue];
        }
        NSLog(@"cookie-->key:%@ uppercaseKey:%@,value:%@",key,uppercaseKey,value);
    }
    
    //由于cookieWithProperties:方法properties中不能没有NSHTTPCookiePath，所以这边需要确认下，如果没有则默认为@"/"
    if (![cookieProperties objectForKey:NSHTTPCookiePath]) {
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    }
    
    return cookieProperties;
}

#pragma mark ---------------请求xml数据-------------------
//这个地方我使用的是中兴的内网,外网无法链接,且我在测试时,链接已作废.大致套路如下:主要是方法setQueryStringSerializationWithBlock的使用,设置返回的字符串为body
#define SERVERURL @"http://210.51.195.25:8080/colorring/services/"
#define SOAP_NAMESPACE @"http://impl.pcrbt.zte.com/"

- (void)soapPostRequestXml{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval=10.0f;
    session.requestSerializer=[AFHTTPRequestSerializer serializer];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [session.requestSerializer setValue:[NSString stringWithFormat:@"%@%@", SOAP_NAMESPACE,@"QryUserTone"] forHTTPHeaderField:@"SOAPAction"];
    [session.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString * stringHTTP = [[NSString stringWithFormat:@"%@UserToneMan",SERVERURL]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDict = @{@"callNumber":@"7000001",@"showNum":@"1000",@"pageNo":@"0",@"inaccessInfo":@{@"DID":@"0010001",@"SEQ":@"10280002014011703153700433146",@"DIDPWD":@"EE01488C002FEE4BBDFA4A62F73D4F91",@"role":@"001",@"roleCode":@"CRBT001",@"version":@"1.0",}};
    NSString *soapMessage = [self.class generateSoapMessageStr:paramDict methodName:@"QryUserToneEvt" withAction:@"QryUserTone"];
    [session.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        return soapMessage;
    }];
    
    [session POST:stringHTTP parameters:soapMessage progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"soap:%f",uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"soap:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"soap:%@",error);
    }];
}

///添加scop参数
+(NSString*)generateSoapMessageStr:(NSDictionary*)parameterDic methodName:(NSString *)methodName withAction:(NSString*)action
{
    NSMutableString *temp_SoapMessage = [[NSMutableString alloc] init];
    NSString *prefixBaseStr;
    NSString *suffixBaseStr ;
    if(methodName == nil){
        prefixBaseStr = [NSString stringWithFormat: @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"><v:Header /><v:Body><n0:%@ xmlns:n0=\"http://impl.pcrbt.zte.com\">",action];
        suffixBaseStr = [NSString stringWithFormat:@"</n0:%@></v:Body></v:Envelope>", action];
    }else{
        prefixBaseStr = [NSString stringWithFormat: @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"><v:Header /><v:Body><n0:%@ xmlns:n0=\"http://impl.pcrbt.zte.com\"><%@ i:type=\"n0:\">",action,methodName];
        suffixBaseStr = [NSString stringWithFormat:@"</%@></n0:%@></v:Body></v:Envelope>",methodName, action];
    }
    [temp_SoapMessage appendString:prefixBaseStr];
    [parameterDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString* keyName = (NSString*)key;
        NSString *item;
        if ([obj isKindOfClass:[NSDictionary class]]) {//info:{{@"key":"value"},{@"key":"value"}}
            NSString *info = @"";
            NSMutableString *temp_info = [[NSMutableString alloc] init];
            NSString *header = [NSString stringWithFormat:@"<%@ i:type=\"n0:%@\">",keyName,keyName ];
            [temp_info appendString:header];
            for (int i = 0; i < [obj count]; i++) {
                
                info = [NSString stringWithFormat:@"<%@ i:type=\"d:string\">%@</%@>",[[obj allKeys] objectAtIndex:i], [[obj allValues] objectAtIndex:i], [[obj allKeys] objectAtIndex:i]];
                
                [temp_info appendString:info];
            }
            [temp_info appendString:info];
            [temp_info appendString:[NSString stringWithFormat:@"</%@>",keyName]];
            item = temp_info;
        }else{
            NSString *valueName = (NSString*)obj;
            if ([keyName isEqualToString:@"pageNo"] || [keyName isEqualToString:@"showNum"] ||[keyName isEqualToString:@"toneTypeID"]){
                item = [NSString stringWithFormat:@"<%@ i:type=\"d:int\">%@</%@>", keyName, valueName, keyName];
            }else{
                item = [NSString stringWithFormat:@"<%@ i:type=\"d:string\">%@</%@>", keyName, valueName, keyName];
            }
        }
        [temp_SoapMessage appendString:item];
    }];
    [temp_SoapMessage appendString:suffixBaseStr];
    //    NSLog(@"req:%@",temp_SoapMessage);
    return temp_SoapMessage;
}


@end



