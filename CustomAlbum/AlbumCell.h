//
//  AlbumCell.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/11.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Albums ;
@interface AlbumCell : UITableViewCell

@property(nonatomic, strong) UIImageView * cellImage ;
@property(nonatomic, strong) UILabel * titleLabel ;
@property(nonatomic, strong) UILabel * dateLabel ;

-(void)setWithAlbum:(Albums *)album ;

@end
