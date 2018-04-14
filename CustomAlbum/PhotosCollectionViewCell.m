//
//  PhotosCollectionViewCell.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/13.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "PhotosCollectionViewCell.h"

@implementation PhotosCollectionViewCell

-(void)setWithPhotoImage:(UIImage *)image{
    for(UIImageView * imageView in [self.contentView subviews]){
        [imageView removeFromSuperview] ;
    }
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] ;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit ;
    self.imageView.autoresizesSubviews = YES ;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    [self.imageView setImage:image] ;
    [self.contentView addSubview:self.imageView] ;
}
@end
