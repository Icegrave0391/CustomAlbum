//
//  NetworkTool.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/6/7.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "NetworkTool.h"
#import "TaskModel.h"
#import "DataBase.h"
static NetworkTool * tool ;
@implementation NetworkTool
+(instancetype)sharedNetworkTool{
    static dispatch_once_t oncetoken ;
    dispatch_once(&oncetoken, ^{
        tool = [[NetworkTool alloc] init] ;
    });
    return tool ;
}

//-(void)uploadImage:(UIImage *)image WithName:(NSString *)name{
//    NSString * accseeKey = @"vN_MxTTJyh1Yo6pZIcx6xo6Dbh0orSrILYbzYTFp" ;
//    NSString * secretKey = @"uqH2Pt1GC5t_6ReiqqUk11pDgW0T8R1GbP_eBpoU" ;
//    NSString * scope = [NSString stringWithFormat:@"chuqi:%@",name] ;
//
//    NSString * uploadToken = [QNToken createTokenWithScope:scope accessKey:accseeKey secretKey:secretKey] ;
//    NSData * imgData = UIImageJPEGRepresentation(image, 1) ;
//    NSString * url = @"http://upload.qiniup.com" ;
//    NSString * key = name ;
//
//    NSDictionary * header = @{
//                              @"Authorization":[NSString stringWithFormat:@"UpToken %@",uploadToken] ,
//                              @"Content-Type": @"application/json" ,
//                              @"Host": url ,
//                              } ;
//
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager] ;
//    [manager POST:url parameters:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFormData:[key dataUsingEncoding:NSUTF8StringEncoding] name:@"key"] ;
//        [formData appendPartWithFormData:[uploadToken dataUsingEncoding:NSUTF8StringEncoding] name:@"token"] ;
//        [formData appendPartWithFormData:imgData name:@"file"] ;
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        dispatch_queue_t queue = dispatch_get_main_queue() ;
//        dispatch_async(queue, ^{
//            CGFloat process = 1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount ;
//        }) ;
//
//        //        NSLog(@"%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount) ;
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"success!!!!!!!\n%@",responseObject) ;
//        //获取上传时间 数据持久化
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"] ;
//        NSString * time =[formatter stringFromDate:[NSDate date]] ;
//
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(queue, ^{
//            TaskModel * historyTask = [[TaskModel alloc] initWithImage:img AndUrlAddress:url AndTime:time] ;
//            //使用数据库持久化
//            [[DataBase sharedDataBase] addHistoryTask:historyTask] ;
//        });
//        //下一个上传任务
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"failed!!!!!!\n%@",error) ;
//    }] ;
//}
@end
