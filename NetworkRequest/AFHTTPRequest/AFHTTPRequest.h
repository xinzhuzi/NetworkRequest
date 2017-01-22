//
//  AFHTTPRequest.h
//  NetworkRequest
//
//  Created by 郑冰津 on 2016/12/18.
//  Copyright © 2016年 IceGod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFHTTPHeader.h"


@interface AFHTTPRequest : NSObject

#pragma mark ----------------网络状态----------------------
/**
 检查网络连接,是否可用block块回调
 
 @param isDuplicates   YES:重复获取网络状态,当网络改变的时候将会回调block块.NO表示只获取一次
 @param statusNetWork  AFHTTPNetworkType类型
 */
+ (void)netWorkDuplicates:(BOOL)isDuplicates status:(void (^)(AFHTTPNetworkType type))statusNetWork;

#pragma mark ----------------GET----------------------

/**
 GET请求,请求普通接口(客户端请求开始连接,服务器返回数据结束连接)
 
 @param URL         请求的URL
 @param parameters  请求的参数
 @param responses   响应的结果
 */
+ (void)GET:(NSString *)URL
 parameters:(id)parameters
   response:(void (^)(id responesData))responses;

/**
 GET下载文件
 
 @param URL         下载的文件的URL
 @param parameters  请求的参数
 @param filePath    文件夹的路径(不包括具体文件,会覆盖,请分清楚文件夹的路径和具体文件)
 @param responses   响应的结果,返回的下载的文件路径
 */
+ (void)GETDownload:(NSString *)URL
         parameters:(id)parameters
           filePath:(NSString *)filePath
           response:(void (^)(id responesData))responses;
#pragma mark ----------------HEAD------------------------

/**
 HEAD请求,请求普通接口(客户端请求开始连接,服务器返回数据结束连接)

 @param URL         请求的URL
 @param parameters  请求的参数
 @param responses   响应的结果,(数据的描述)
 */
+ (void)HEAD:(NSString *)URL
 parameters:(id)parameters
   response:(void (^)(id responesData))responses;
#pragma mark ----------------PUT-------------------------

/**
 PUT请求,请求普通接口(客户端请求开始连接,服务器返回数据结束连接)
 
 @param URL         请求的URL
 @param parameters  请求的参数
 @param responses   响应的结果
 */
+ (void)PUT:(NSString *)URL
 parameters:(id)parameters
   response:(void (^)(id responesData))responses;
#pragma mark ----------------PATCH-----------------------

/**
 PATCH请求,请求普通接口(客户端请求开始连接,服务器返回数据结束连接)
 
 @param URL         请求的URL
 @param parameters  请求的参数
 @param responses   响应的结果
 */
+ (void)PATCH:(NSString *)URL
 parameters:(id)parameters
   response:(void (^)(id responesData))responses;
#pragma mark ----------------DELETE----------------------

/**
 DELETE请求,请求普通接口(客户端请求开始连接,服务器返回数据结束连接)
 
 @param URL         请求的URL
 @param parameters  请求的参数
 @param responses   响应的结果
 */
+ (void)DELETE:(NSString *)URL
 parameters:(id)parameters
   response:(void (^)(id responesData))responses;

#pragma mark ----------------POST----------------------

/**
 POST请求,请求普通接口(客户端请求开始连接,服务器返回数据结束连接)

 @param URL         请求的URL
 @param parameters  请求的参数,如果是字符串则则实现
 @param responses   响应的结果
 */
+ (void)POST:(NSString *)URL
  parameters:(id)parameters
    response:(void (^)(id responesData))responses;

//+ (void)POSTSOAP:(NSString *)URL parameters:(id )parameters

/**
 POST请求上传图片,MP3,视频,文件等

 @param URL         上传的URL
 @param parameters  上传的参数
 @param uploadType  上传的是图片还是视频
 @param arrayData   装的是NSData对象 @[NSData*]
 @param responses   响应的结果
 */
+ (void)POSTUpload:(NSString *)URL
        parameters:(id)parameters
        uploadType:(AFHTTPNetworkUploadDownloadType)uploadType
         dataArray:(NSArray <NSData *>*)arrayData
          response:(void (^)(id responesData))responses;

#pragma mark ----------------断点上传----------------------

/**
 Upload断点上传

 @param URL         上传的URL
 @param uploadData  文件的二进制流
 @param responses   上传的响应结果
 */
+ (void)upload:(NSString *)URL
    uploadData:(NSData *)uploadData
      response:(void (^)(id responesData))responses;

#pragma mark ----------------断点下载----------------------

/**
 download普通下载,断点下载请看:https://github.com/ShinobiControls/iOS7-day-by-day
 
 @param URL         下载的URL
 @param filePath    下载到沙盒中文件的位置
 @param responses   下载的响应结果
 */
+ (void)download:(NSString *)URL
        filePath:(NSString *)filePath
        response:(void (^)(id responesData))responses;

/**
 断点下载,过程:先进行普通下载,然后不可以调用cancel方法,要用cancelByProducingResumeData方法,接收下载时的详细数据保存:http://blog.csdn.net/majiakun1/article/details/38133789

 @param data        断点下载中需要恢复下载的数据
 @param filePath    下载到沙盒中文件的位置
 @param responses   下载的响应结果
 */
+ (void)downloadBreakpoint:(NSData *)data
                  filePath:(NSString *)filePath
                  response:(void (^)(id responesData))responses;
#pragma mark ---------NSURLSessionTask相关-------------

/**
 每一个Task的State1️⃣,返回4种状态,正在请求,暂停请求,取消请求,完成请求(默认状态)
 1️⃣(Task的State) : NSURLSessionTask的NSURLSessionTaskState
 
 @param URL 传入作为KEY值遍历task,返回状态
 @return    返回状态
 */
+ (NSURLSessionTaskState)requestATaskStateWith:(NSString *)URL;

/**
 根据URL返回一个Task句柄
 
 @param URL 传入作为KEY值遍历tasks
 @return    返回具体的某一个task,使用时需要判断是否为空
 */
+ (NSURLSessionTask *)requestATaskWith:(NSString *)URL;

#pragma mark ----------------停止请求任务的方法----------------------
//下面所有的操作都不是NSURLSession的操作,只是NSURLSessionTask任务的操作.新手搜一下区别
/**
 取消所有的会话任务,和所有的NSURLSessionTask回调代理
 */
+ (void)cancelAllTasksAndOperationQueues;

/**
 停止单个的请求任务,当某一个请求正在请求时不想让其请求了,不包括NSURLSessionStreamTask.

 @param URL 传入URL作为KEY值停止其请求任务
 */
+ (void)cancelATaskWith:(NSString *)URL;

/**
 暂停单个的请求任务,不包括NSURLSessionStreamTask.
 
 @param URL 传入URL作为KEY值恢复其暂停任务
 */
+ (void)suspendATaskWith:(NSString *)URL;

/**
 恢复单个的请求任务,当某一个请求正在请求时不想让其请求了,不包括NSURLSessionStreamTask.
 
 @param URL 传入URL作为KEY值恢复其请求任务
 */
+ (void)resumeATaskWith:(NSString *)URL;

/*
 计算下载进度:[Task countOfBytesReceived] / ([Task countOfBytesExpectedToReceive] * 1.0f)
 计算上传进度:[Task countOfBytesSent] / ([Task countOfBytesExpectedToSend] * 1.0f)
 */

#pragma mark ---------AFNetworking网络请求图片缓存策略-----------
//UIButton和UIImageView的图片缓存,内存缓存和硬盘缓存,URL作为key,如果不用AFNetworking的图片缓存机制,最好不要调用下面的方法避免无用内存加载.
+ (void)setCacheForUIButtonAndUIImageView;

@end




