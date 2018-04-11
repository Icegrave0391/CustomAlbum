//
//  AlbumCell.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/11.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "AlbumCell.h"
#import "Albums.h"
@implementation AlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if(self.cellData.photoDetails){
        if([self.cellData.photoDetails.firstObject isMemberOfClass:[UIImageView class]]){
            [self.imageView setImage:[self getImageFromView:self.cellData.photoDetails.firstObject]] ;
            [self.textLabel setText:self.cellData.title] ;
            [self.detailTextLabel setText:self.cellData.createTime] ;
        }
    }
    else{
        [self.textLabel setText:self.cellData.title] ;
        [self.detailTextLabel setText:self.cellData.createTime] ;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UIImage *)getImageFromView:(UIImageView *)imageView{
    return imageView.image ;
}

@end
