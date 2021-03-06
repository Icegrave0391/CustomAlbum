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
        self.photoDetails = [[NSMutableArray alloc] init] ;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"] ;
    [aCoder encodeObject:self.createTime forKey:@"time"] ;
    [aCoder encodeObject:self.photoDetails forKey:@"photo"] ;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init] ;
    if(self){
        self.title = [aDecoder decodeObjectForKey:@"title"] ;
        self.createTime = [aDecoder decodeObjectForKey:@"time"] ;
        self.photoDetails = [aDecoder decodeObjectForKey:@"photo"] ;
    }
    return self ;
}

@end
