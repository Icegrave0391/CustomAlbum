//
//  TaskModel.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/5/30.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TaskModel : NSObject

@property(nonatomic, strong)UIImage * image ;
@property(nonatomic, strong)NSString * urlAddress ;
@property(nonatomic, strong)NSString * time ;

-(TaskModel *)initWithImage:(UIImage *)img AndUrlAddress:(NSString *)url AndTime:(NSString *)time ;
@end
