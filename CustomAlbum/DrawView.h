//
//  DrawView.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/20.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property(nonatomic, strong) UIColor * pathColor ;
@property(nonatomic, assign) NSInteger pathWidth ;

@property(nonatomic, strong) UIImage * image ;

-(void)clear ;
-(void)undo ;
@end
