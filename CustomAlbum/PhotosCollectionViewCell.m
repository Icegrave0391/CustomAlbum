//
//  PhotosCollectionViewCell.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/13.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "PhotosCollectionViewCell.h"

@implementation PhotosCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame] ;
    if(self){
        //初始化imageView
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] ;
        [self.imageView setUserInteractionEnabled:YES] ;
        //初始化deleteButton
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width -30, 0, 30, 30)] ;
        [self.deleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal] ;
        [self.deleteButton setHidden:YES] ;
        
        self.layer.borderWidth = 0.5 ;
        
        [self addSubview:self.imageView] ;
        [self addSubview:self.deleteButton] ;
    }
    return self ;
}
//-(void)setWithPhotoImage:(UIImage *)image{
//    for(UIImageView * imageView in [self subviews]){
//        [imageView removeFromSuperview] ;
//    }
//    for(UIButton * button in [self subviews]){
//        [button removeFromSuperview] ;
//    }
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] ;
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit ;
//    self.imageView.autoresizesSubviews = YES ;
//    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
//    [self.imageView setImage:image] ;
//    [self addSubview:self.imageView] ;
//    //配置self.deletebutton
//    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width -30, 0, 30, 20)] ;
//    [self.deleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal] ;
//
//    [self addSubview:self.deleteButton] ;
//}

//-(UIButton *)deleteButton{
//    if(!_deleteButton){
//        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width-30,0, 30, 20)] ;
//        _deleteButton.titleLabel.text = @"删除" ;
//        _deleteButton.titleLabel.tintColor = [UIColor redColor] ;
//        _deleteButton.backgroundColor = [UIColor redColor] ;
//        _deleteButton.hidden = YES ;
////        NSLog(@"buttonLog:frame %f, title%@",_deleteButton.frame.size.height,_deleteButton.titleLabel.text) ;
////        NSLog(@"the subviews in self :%@",self.contentView.subviews) ;
////        NSLog(@"is button hidding :%d",_deleteButton.hidden) ;
//    }
//    return _deleteButton ;
//}
@end
