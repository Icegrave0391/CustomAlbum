//
//  UploadTaskModel.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/6/4.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "UploadTaskModel.h"

@implementation UploadTaskModel

-(NSNumber *)process{
    if(!_process){
        _process = [[NSNumber alloc] initWithFloat:0] ;
    }
    return _process ;
}


@end
