//
//  TaskModel.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/5/30.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel

-(TaskModel *)initWithImage:(UIImage *)img AndUrlAddress:(NSString *)url AndTime:(NSString *)time{
    self = [super init] ;
    if(self){
        self.image = img ;
        self.urlAddress = url ;
        self.time = time ;
    }
    return self ;
}

@end
