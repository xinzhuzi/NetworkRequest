//
//  AFHTTPRequest.m
//  NetworkRequest
//
//  Created by 郑冰津 on 2016/12/18.
//  Copyright © 2016年 IceGod. All rights reserved.
//

#import "AFHTTPRequest.h"
#import "AFNetworking/AFNetworking.h"
#import "UIKit+AFNetworking/UIKit+AFNetworking.h"

@implementation AFHTTPRequest

#pragma mark ----------------网络状态----------------------
//检查网络状态
+ (void)netWorkDuplicates:(BOOL)isDuplicates status:(void (^)(AFHTTPNetworkType type))statusNetWork;
{
    AFNetworkReachabilityManager *__weak reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability startMonitoring];
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status==AFNetworkReachabilityStatusUnknown) {
            statusNetWork(NetworkType_Unknown);
        }else if (status==AFNetworkReachabilityStatusNotReachable){
            statusNetWork(NetworkType_NO);
        }else if (status==AFNetworkReachabilityStatusReachableViaWWAN){
            //这里是本文的核心点:采用遍历查找状态栏的显示网络状态的子视图,通过判断该子视图的类型来更详细的判断网络类型
            NSArray *subviewArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
            int typeViewStaty = 0;
            for (id subview in subviewArray)
            {
                if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
                {///type0:无网,type1:2G,type2:3G,type3:4G,type5:WIFI
                    typeViewStaty = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                    if (typeViewStaty==1) {
                        statusNetWork(NetworkType_2G);
                        break;
                    }else if (typeViewStaty==2){
                        statusNetWork(NetworkType_3G);
                        break;
                    }else if (typeViewStaty==3){
                        statusNetWork(NetworkType_4G);
                        break;
                    }
                }
            }
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            statusNetWork(NetworkType_WiFi);
        }
        if (!isDuplicates) {
            [reachability stopMonitoring];
        }
    }];
}
#pragma mark ----------------HTTP/HTTPS的Session基础设置----------------------
static AFHTTPSessionManager *sessionManager = nil;
+(AFHTTPSessionManager *)getSessionManagerCustom{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ///第一种单例封装
        sessionManager = [AFHTTPSessionManager manager];
        //在iOS7中存在一个bug，在创建后台上传任务时，有时候会返回nil，所以为了解决这个问题，AFNetworking遵照了苹果的建议，在创建失败的时候，会重新尝试创建，次数默认为3次，所以你的应用如果有场景会有在后台上传的情况的话，记得将该值设为YES，避免出现上传失败的问题
        sessionManager.attemptsToRecreateUploadTasksForBackgroundSessions = YES;
        //第二种单例封装
        /*
         baseURL 的目的，就是让后续的网络访问直接使用 相对路径即可，baseURL 的路径一定要有 / 结尾,此时采用的是第二种单例封装,下面的  @"http://c.m.163.com/"  需要替换具体的自己服务器的URL,如果服务器的具体的URL经常变换,最好不要使用第二种单例封装,因为不同服务器不同配置
         NSURL *baseURL = [NSURL URLWithString:@"http://c.m.163.com/"];
         NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
         sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL sessionConfiguration:config];
         */
    });
    /*请求携带的格式
     requestSerializer格式有四种,选择其中一种:
     如果请求体是二进制类型选择AF默认的类型AFHTTPRequestSerializer
     如果请求体是JSON类型选择AFJSONRequestSerializer
     如果请求体是NSString类型使用setQueryStringSerializationWithBlock方法:如:soap形式
     如果请求体是plist类型或者AFPropertyListRequestSerializer (苹果专用,极少使用)
     
     请求头有很多种,根据服务器要求填写请求头:
     使用setValue:forHTTPHeaderField:方法填死数据就可以了,数据从哪来,问服务器
     使用setAuthorizationHeaderFieldWithUsername:password:方法填服务器特别要求的请求头密码与账户
     */
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    //        session.requestSerializer=[AFPropertyListRequestSerializer serializerWithFormat:NSPropertyListXMLFormat_v1_0 writeOptions:512];
    //            [session.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
    //                return  @"Yous string body";
    //            }];
    //        [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //        [session.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];  // 此处设置content-Type生效了，然后就是参数要求是json，怎么设。。
    //            [session.requestSerializer setAuthorizationHeaderFieldWithUsername:<#(nonnull NSString *)#> password:<#(nonnull NSString *)#>];
    /*配合setAuthorizationHeaderFieldWithUsername:password:使用
     设置需要身份验证回调方法：
     - (void)setSessionDidReceiveAuthenticationChallengeBlock:
     (NSURLSessionAuthChallengeDisposition (^)(NSURLSession *session,
     NSURLAuthenticationChallenge *challenge,
     NSURLCredential * __autoreleasing *credential))block;
     block 参数：
     session    ：会话
     challenge  ：身份验证质询
     credential ：指向凭据的指针，该凭据用于解决身份验证
     block 返回值：
     返回身份验证的配置情况
     设置当连接需要身份验证质询时执行的 block。
     */
    //设置超时时间,项目里面根据服务器要求来设置吧!
    //    session.requestSerializer.timeoutInterval = 5;
    //        session.attemptsToRecreateUploadTasksForBackgroundSessions = YES;//如果有后台上传需要设置为YES,避免BUG
    
    
    /*返回的数据格式
     responseSerializer格式有7种,选择其中一种
     AFHTTPResponseSerializer           二进制格式,框架默认
     AFJSONResponseSerializer           JSON,框架默认
     AFXMLParserResponseSerializer      XML,返回XMLParser对象,还需要自己通过代理方法解析
     AFXMLDocumentResponseSerializer    (Mac OS X) XMLDocument     DOM 解析
     AFPropertyListResponseSerializer   PList 苹果专有，极少用
     AFImageResponseSerializer          Image
     AFCompoundResponseSerializer       所有组合
     检测返回的HTTP状态码和数据类型是否合法:
     使用validateResponse:data:error:进行检测
     */
    sessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
//    sessionManager.responseSerializer=[AFJSONResponseSerializer serializer];
    //        session.responseSerializer=[AFXMLParserResponseSerializer serializer];
    //        session.responseSerializer=[AFPropertyListResponseSerializer serializer];
    //        session.responseSerializer=[AFImageResponseSerializer serializer];
    //        session.responseSerializer=[AFCompoundResponseSerializer serializer];
    ///看你服务器使用那种形式,就设置其中一种形式即可,下面的也可默认就行
    sessionManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"application/force-download", @"application/soap+xml; charset=utf-8",@"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/html; charset=iso-8859-1",@"text/plain",@"text/css",@"application/x-plist",@"image/*", nil];
    //        [session.responseSerializer validateResponse:<#(nullable NSHTTPURLResponse *)#> data:<#(nullable NSData *)#> error:<#(NSError *__autoreleasing  _Nullable * _Nullable)#>];
    /*
     HTTPS的设置
     创建securityPolicy
     使用policyWithPinningMode:withPinnedCertificates:方法,第二个参数传入服务器给你的证书
     是否允许无效证书（也就是自建的证书），默认为NO
     使用allowInvalidCertificates属性
     是否需要验证域名(是否验证主机名)，默认为YES;
     假如证书的域名与你请求的域名不一致，需把该项设置为NO,主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
     AFSSLPinningModeNone：
     这个模式表示不做 SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。若证书是信任机构签发的就会通过，若是自己服务器生成的证书，这里是不会通过的。
     AFSSLPinningModeCertificate：
     这个模式表示用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝，这里验证分两步，第一步验证证书的域名/有效期等信息，第二步是对比服务端返回的证书跟客户端返回的是否一致。
     AFSSLPinningModePublicKey：
     这个模式同样是用证书绑定方式验证，客户端要有服务端的证书拷贝，只是验证时只验证证书里的公钥，不验证证书的有效期等信息。只要公钥是正确的，就能保证通信不会被窃听，因为中间人没有私钥，无法解开通过公钥加密的数据。
     使用:validatesDomainName属性
     */
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"adn" ofType:@"cer"];
    //    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    //    if (certData) {
        //securityPolicy.allowInvalidCertificates = YES;正式的CA证书非常昂贵，很多人都知道，AFNetworking2只要通过下面的代码，你就可以使用自签证书来访问HTTPS,设置是否信任无效或过期的 SSL 证书的服务器。默认为否
    //        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[NSSet setWithObject:certData]];
    //        securityPolicy.validatesDomainName = NO;
    //        //            [securityPolicy evaluateServerTrust:<#(nonnull SecTrustRef)#> forDomain:<#(nullable NSString *)#>];//验证服务端是否是受信的
    //        sessionManager.securityPolicy = securityPolicy;
    //    }
    return sessionManager;
}

+ (NSString *)URLEncoding:(NSString *)URL{
    return [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark ----------------GET----------------------
///GET请求获得数据---AFNetWorking,请求普通接口
+ (void)GET:(NSString *)URL
 parameters:(id)parameters
   response:(void (^)(id responesData))responses{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [AFHTTPRequest URLEncoding:URL];
    [session GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responses) {
            responses(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (responses) {
            responses(nil);
        }
    }];
}

///GET下载文件
+ (void)GETDownload:(NSString *)URL
         parameters:(id)parameters
           filePath:(NSString *)filePath
           response:(void (^)(id responesData))responses{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [AFHTTPRequest URLEncoding:URL];
    [session GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *finalFilePath = [NSString stringWithFormat:@"%@/%@",filePath,task.response.suggestedFilename];
        BOOL isOk = [responseObject writeToFile:finalFilePath atomically:YES];
        if (!isOk) {
            NSLog(@"没有传入filePath,写入文件错误,文件无法下载到指定位置");
        }else{
            if (responses) {
                responses(finalFilePath);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (responses) {
            responses(nil);
        }
    }];
}

#pragma mark ----------------HEAD------------------------
+ (void)HEAD:(NSString *)URL
  parameters:(id)parameters
    response:(void (^)(id responesData))responses{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [AFHTTPRequest URLEncoding:URL];
    [session HEAD:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task) {
        if (responses) {
            NSDictionary *dict = @{@"任务描述性标签":task.taskDescription,@"文件类型":task.response.suggestedFilename,@"收到的字节数":[NSString stringWithFormat:@"%lld",task.countOfBytesReceived],@"希望收到的字节数":[NSString stringWithFormat:@"%lld",task.countOfBytesExpectedToReceive]};
            responses(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (responses) {
            responses(nil);
        }
    }];
}
#pragma mark ----------------PUT-------------------------
+ (void)PUT:(NSString *)URL
 parameters:(id)parameters
   response:(void (^)(id responesData))responses{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [AFHTTPRequest URLEncoding:URL];
    //PUT 文件上传
    [session PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responses) {
            responses(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (responses) {
            responses(nil);
        }
    }];
}
#pragma mark ----------------PATCH-----------------------
+ (void)PATCH:(NSString *)URL
   parameters:(id)parameters
     response:(void (^)(id responesData))responses{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [AFHTTPRequest URLEncoding:URL];
    [session PATCH:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responses) {
            responses(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (responses) {
            responses(nil);
        }
    }];
}
#pragma mark ----------------DELETE----------------------
+ (void)DELETE:(NSString *)URL
    parameters:(id)parameters
      response:(void (^)(id responesData))responses{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [AFHTTPRequest URLEncoding:URL];
    [session DELETE:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responses) {
            responses(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (responses) {
            responses(nil);
        }
    }];
}
#pragma mark ----------------POST----------------------
///POST请求获得数据---AFNetWorking,请求普通接口
+ (void)POST:(NSString *)URL
  parameters:(id)parameters
    response:(void (^)(id responesData))responses{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [AFHTTPRequest URLEncoding:URL];
    if (parameters && [parameters isKindOfClass:[NSString class]]) {
        //根据指定的block设置一个自定义查询字符序列化的方法。主要将字符串parameters设置成为请求body
        [session.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            if (error) {
                return nil;
            }
            return [NSString stringWithFormat:@"%@",parameters];
        }];
    }
    [session POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responses) {
            responses(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (responses) {
            NSLog(@"%@",error.userInfo);
            responses(nil);
        }
    }];
}

+ (void)POSTUpload:(NSString *)URL
        parameters:(id)parameters
        uploadType:(AFHTTPNetworkUploadDownloadType)uploadType
         dataArray:(NSArray <NSData *>*)arrayData
          response:(void (^)(id responesData))responses{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [AFHTTPRequest URLEncoding:URL];
    //    NSString *stringBoundary = @"---------";
    //    [session.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary] forHTTPHeaderField:@"Content-Type"];///这个地方需要服务器给出,不然就是AF里面默认的.
    /*
     采用的是uploadTaskWithStreamedRequest:方法上传
     */
    [session POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /*
         name：部分是服务器用来解析的字段
         fileName则是直接上传上去的图片或视频等等
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"yyyyMMddHHmmss";
         NSString *str = [formatter stringFromDate:[NSDate date]];
         */
        if (uploadType==UploadDownloadType_Images) {
            for (NSInteger i = 0; i<arrayData.count; i++) {
                NSTimeInterval time = [NSDate date].timeIntervalSince1970 *1000;
                NSString *name=[NSString stringWithFormat:@"image%.0f",time+i];
                [formData appendPartWithFileData:arrayData[i] name:name fileName:[NSString stringWithFormat:@"%@_%ld.jpg",name,(long)i] mimeType:@"image/jpeg"];
            }
        }else if (uploadType==UploadDownloadType_Videos){
            for (NSInteger i=0; i<arrayData.count; i++) {
                NSTimeInterval time = [NSDate date].timeIntervalSince1970 *1000;
                NSString *name=[NSString stringWithFormat:@"video%.0f",time+i];
                [formData appendPartWithFileData:arrayData[i] name:name fileName:[NSString stringWithFormat:@"%@_%ld.mov",name,(long)i] mimeType:@"video/quicktime"];///@"video/mpeg4"
            }
        }else{
            NSLog(@"没有选择上传类型,不能上传,请求错误");
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responses) {
            responses(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (responses) {
            responses(nil);
        }
    }];
}

#pragma mark ----------------断点上传----------------------
+ (void)upload:(NSString *)URL
    uploadData:(NSData *)uploadData
      response:(void (^)(id responesData))responses{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [AFHTTPRequest URLEncoding:URL];
    /*
     采用的是uploadTaskWithRequest: fromData:方法上传的数据
     */
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]] fromData:uploadData progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            responses(error);
        }else{
            responses(responseObject);
        }
    }];
    [task resume];
}
#pragma mark ----------------断点下载----------------------
+ (void)download:(NSString *)URL
        filePath:(NSString *)filePath
        response:(void (^)(id responesData))responses{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [AFHTTPRequest URLEncoding:URL];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path = [filePath stringByAppendingPathComponent:response.suggestedFilename];
        //将下载文件保存在缓存路径中,指定下载文件保存的路径
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            responses(error);
        }else{
            responses(filePath);
        }
    }];
    [task resume];
}


+ (void)downloadBreakpoint:(NSData *)data
                  filePath:(NSString *)filePath
                  response:(void (^)(id responesData))responses{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    NSURLSessionDownloadTask *task = [session downloadTaskWithResumeData:data progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //将下载文件保存在缓存路径中,指定下载文件保存的路径
        NSString *path = [filePath stringByAppendingPathComponent:response.suggestedFilename];
       return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            responses(error);
        }else{
            responses(filePath);
        }
    }];
    [task resume];
    //此时测试出来是重定向的URL
    //NSLog(@"%@,%@,%lu",task.originalRequest.URL.absoluteString,task.currentRequest.URL.absoluteString,(unsigned long)task.taskIdentifier);
}

#pragma mark ---------请求的状态-------------

+ (NSURLSessionTaskState)requestATaskStateWith:(NSString *)URL{
    NSURLSessionTask *task = [self.class requestATaskWith:URL];
    return task?task.state:/*默认返回*/NSURLSessionTaskStateCompleted;
}

+ (NSURLSessionTask *)requestATaskWith:(NSString *)URL{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    for (NSURLSessionTask *task in session.tasks) {
        BOOL isTask = [task.originalRequest.URL.absoluteString isEqualToString:URL];
        if (isTask) {
            return task;
        }
        //服务器重定向导致的Request变更,这个地方理解不深刻,可能出现错误
        isTask = [task.currentRequest.URL.absoluteString isEqualToString:URL];
        if (isTask) {
            return task;
        }
    }
    return nil;//默认返回
}
#pragma mark ----------------停止请求的方法----------------------
///取消所有的请求,和所有的NSURLSessionTask回调代理
+(void)cancelAllTasksAndOperationQueues{
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    for (NSURLSessionTask *task in session.tasks) {
        [task cancel];
    }
    [session.operationQueue cancelAllOperations];
}
///取消单个的会话任务
+ (void)cancelATaskWith:(NSString *)URL{
    NSURLSessionTask *task = [self.class requestATaskWith:URL];
    [task cancel];
}
///暂停单个的请求任务,
+ (void)suspendATaskWith:(NSString *)URL{
    NSURLSessionTask *task = [self.class requestATaskWith:URL];
    [task suspend];
}
///恢复单个的请求任务,
+ (void)resumeATaskWith:(NSString *)URL{
    NSURLSessionTask *task = [self.class requestATaskWith:URL];
    [task resume];
}


#pragma mark ---------AFNetwork网络请求图片缓存策略-----------
//UIButton和UIImageView的图片缓存,内存缓存和硬盘缓存,URL作为key
+ (void)setCacheForUIButtonAndUIImageView{
    [UIButton setSharedImageDownloader:[UIButton sharedImageDownloader]];
    [UIImageView setSharedImageDownloader:[UIImageView sharedImageDownloader]];
}

@end




/*
 ----------AFURLSessionManager--------------------
 @property(readonly,nonatomic,strong)NSArray *tasks;总的任务集合
 @property(readonly,nonatomic,strong)NSArray *dataTasks;数据任务集合
 @property(readonly,nonatomic,strong)NSArray *uploadTasks;上传任务集合
 @property(readonly,nonatomic,strong)NSArray *downloadTasks;下载任务集合
 @property(nonatomic,assign)BOOL attemptsToRecreateUploadTasksForBackgroundSessions;
 这个属性非常重要，注释里面写到，在iOS7中存在一个bug，在创建后台上传任务时，有时候会返回nil，所以为了解决这个问题，AFNetworking遵照了苹果的建议，在创建失败的时候，会重新尝试创建，次数默认为3次，所以你的应用如果有场景会有在后台上传的情况的话，记得将该值设为YES，避免出现上传失败的问题
 AF包含了GET、POST、PUT、PATCH、DELETE五种请求方式
 DEPRECATED_ATTRIBUTE这个宏是指这个API不建议开发者再使用了，再使用时，会出现编译警告.
 POST请求是向服务端发送数据的，用来更新资源信息，它可以改变数据的种类等资源
 GET请求是向服务端发起请求数据，用来获取或查询资源信息
 PUT请求和POST请求很像，都是发送数据的，但是PUT请求不能改变数据的种类等资源，它只能修改内容(从客户端向服务器传送的数据取代指定的文档的内容。)
 DELETE请求就是用来删除某个资源的
 PATCH请求和PUT请求一样，也是用来进行数据更新的，它是HTTP verb推荐用于更新的
 ----------------------AFSecurityPolicy------------------
 AFSSLPinningModeNone,// 在证书列表中校验服务端返回的证书
 AFSSLPinningModePublicKey,// 客户端要有服务端的证书拷贝，只是验证时只验证证书里的公钥
 AFSSLPinningModeCertificate,// 客户端要有服务端的证书拷贝，第一步先验证证书域名/有效期等信息，第二步对服务端返回的证书和客户端返回的是否一致
 -[evaluateServerTrust:forDomain:]方法是AFSecurityPolicy类最长也是最重要的方法，它用来验证服务端是否是受信的
 　　这么做为什么是安全的？了解HTTPS的人都知道，整个验证体系中，最核心的实际上是服务器的私钥。私钥永远，永远也不会离开服务器，或者以任何形式向外传输。私钥和公钥是配对的，如果事先在客户端预留了公钥，只要服务器端的公钥和预留的公钥一致，实际上就已经可以排除中间人攻击了。
 NS_DESIGNATED_INITIALIZER的作用是什么呢？
 指定的构造器通过发送初始化消息到父类来保证object被完全初始化，指定构造器有以下几个规则：
 1.指定构造器必须调用父类的指定构造器
 2.任何一个便利构造器必须调用最终指向指定构造器的其他构造器
 3.具有指定构造器的类必须实现父类的所有指定构造器
 
 -----------AFURLRequestSerialization-----------
 AFPercentEscapedStringFromString方法将string里面的:#[]@!$&’()*+,;=字符替换成%
 
 */


