//
//  PhotosCollectionViewController.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/13.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class Albums ;

@interface PhotosCollectionViewController : UICollectionViewController
@property(nonatomic, strong) Albums * album ;    //数据由上一个controller传入加载
@property(nonatomic, strong) NSIndexPath * indexPath ; //用于记录涂鸦的相片
@property(nonatomic, strong) NSMutableArray * dateArr ;    //使用归档加载
@property void(^receivePhotoDetails)() ;
@end
