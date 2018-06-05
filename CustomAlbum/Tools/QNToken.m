//
//  QNToken.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/5/19.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "QNToken.h"
#import <QN_GTM_Base64.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation QNToken
+ (NSString *)createTokenWithScope:(NSString *)scope accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey liveTime:(NSInteger)deadline{
//上传策略
    NSMutableDictionary * jsonDict = [[NSMutableDictionary alloc] init] ;
    jsonDict[@"scope"] = scope ;
    jsonDict[@"deadline"] = @(deadline) ;
//将上传策略序列化成json格式
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                        options:0
                                                          error:nil] ;
//编码json
    NSString * encoded = [self URLSafeBase64Encode:jsonData] ;
//使用secretKey加密得到encoded_signed
    NSString * encoded_signed = [self HMACSHA1:secretKey text:encoded] ;
    
//连接
    NSString * uploadToken = [NSString stringWithFormat:@"%@:%@:%@",accessKey , encoded_signed, encoded] ;
    
    return uploadToken ;
}
+ (NSString *)createTokenWithScope:(NSString *)scope accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey {
    NSInteger deadline = [[NSDate date] timeIntervalSince1970] + 3600 ;
    return [self createTokenWithScope:scope accessKey:accessKey secretKey:secretKey liveTime:deadline] ;
}

+ (NSString *)URLSafeBase64Encode:(NSData *)text{
    NSString *base64 = [[NSString alloc] initWithData:[QN_GTM_Base64 encodeData:text] encoding:NSUTF8StringEncoding] ;
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"] ;
    base64 = [base64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"] ;
    return base64 ;
}

+ (NSString *)HMACSHA1:(NSString *)key text:(NSString *)text{
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding] ;
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding] ;
    char cHMAC[CC_SHA1_DIGEST_LENGTH] ;
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC) ;
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH] ;
    NSString *hash = [self URLSafeBase64Encode:HMAC] ;
    return hash ;
}


@end
