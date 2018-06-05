//
//  QNToken.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/5/19.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNToken : NSObject

+ (NSString *)createTokenWithScope:(NSString *)scope accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey liveTime:(NSInteger)deadline ;

+ (NSString *)createTokenWithScope:(NSString *)scope accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;
@end
