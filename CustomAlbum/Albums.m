//
//  Albums.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/11.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "Albums.h"

@implementation Albums

-(Albums *)initWithTitle:(NSString *)title andCreateTime:(NSString *)createTime{
    self = [super init] ;
    if(self){
        self.title = title ;
        self.createTime = createTime ;
    }
    return self;
}

@end
