//
//  Albums.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/11.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Albums : NSObject

@property(nonatomic, strong)NSString * title ;
@property(nonatomic, strong)NSString * createTime ;
@property(nonatomic, strong)NSMutableArray * photoDetails ;

-(Albums *)initWithTitle:(NSString *)title andCreateTime:(NSString *)createTime ;

@end
