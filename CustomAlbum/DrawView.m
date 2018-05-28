//
//  DrawView.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/20.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "DrawView.h"
#import "DrawPath.h"
@interface DrawView()

@property(nonatomic, strong) DrawPath * path ;
@property(nonatomic, strong) NSMutableArray *pathArr ;
@end
@implementation DrawView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame] ;
    if(self){
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)] ;
        [self addGestureRecognizer:pan] ;
    }
    return self ;
}

-(void) pan:(UIPanGestureRecognizer *)pan{
    CGPoint currentPoint = [pan locationInView:self] ;
    //获取开始点
    if(pan.state == UIGestureRecognizerStateBegan){
        //创建贝塞尔路径
        _path = [[DrawPath alloc] init] ;
        //设置线宽
        _path.lineWidth = _pathWidth ;
        //设置路径颜色
        _path.pathColor = _pathColor ;
        //设置起点
        [_path moveToPoint:currentPoint] ;
        [self.pathArr addObject:_path] ;
    }
    [_path addLineToPoint:currentPoint] ;
    [self setNeedsDisplay] ;
}
-(void)clear{
    [self.pathArr removeAllObjects] ;
    [self setNeedsDisplay] ;
}

-(void)undo{
    [self.pathArr removeLastObject] ;
    [self setNeedsDisplay] ;
}

-(NSMutableArray *)pathArr{
    if(_pathArr == nil){
        _pathArr = [NSMutableArray array] ;
    }
    return _pathArr ;
}

-(void) setImage:(UIImage *)image{
    _image = image ;
    [self.pathArr addObject:_image] ;
    [self setNeedsDisplay] ;
}
-(void)drawRect:(CGRect)rect{
    for(DrawPath * path in self.pathArr){
        if([path isKindOfClass:[UIImage class]]){
            UIImage * image = (UIImage *)path ;
            [image drawInRect:rect] ;
        }else{
            
            [path.pathColor set] ;
            [path stroke] ;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
