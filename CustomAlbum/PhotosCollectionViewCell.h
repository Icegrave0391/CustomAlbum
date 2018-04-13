//
//  PhotosCollectionViewCell.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/13.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Albums ;
@interface PhotosCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)UIImageView * imageView ;
-(void)setWithPhotoImage:(UIImage *)image ;
@end
