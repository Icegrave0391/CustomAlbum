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
/*    if(self.cellData.photoDetails){
        if([self.cellData.photoDetails.firstObject isMemberOfClass:[UIImageView class]]){
            [self.imageView setImage:[self getImageFromView:self.cellData.photoDetails.firstObject]] ;
            [self.textLabel setText:self.cellData.title] ;
            [self.detailTextLabel setText:self.cellData.createTime] ;
        }
    }
    else{
        [self.textLabel setText:self.cellData.title] ;
        [self.detailTextLabel setText:self.cellData.createTime] ;
    }*/
}
/*
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCellData:) name:@"getCellData" object:nil] ;
        CGRect imageRect = CGRectMake(10, 10, 100, 100);
        //设置cell图片
        if(self.cellData.photoDetails){
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:imageRect] ;
            [imageView setImage:((UIImageView *)self.cellData.photoDetails.firstObject).image] ;
            imageView.contentMode = UIViewContentModeScaleAspectFit ;
            imageView.autoresizesSubviews = YES ;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
            [self addSubview:imageView] ;
        }
        //定制cell标题
        CGRect titleRect = CGRectMake(120, 60, self.frame.size.width - 120, 30) ;
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:titleRect] ;
        titleLabel.text = self.cellData.title ;
        titleLabel.font = [UIFont systemFontOfSize:18] ;
        titleLabel.numberOfLines = 0 ;
        [self addSubview:titleLabel] ;
        //定制cell显示日期
        CGRect dateRect = CGRectMake(10, 120 , self.frame.size.width - 10 , 20) ;
        UILabel * dateLabel = [[UILabel alloc] initWithFrame:dateRect] ;
        dateLabel.text = self.cellData.createTime ;
        dateLabel.font = [UIFont systemFontOfSize:12] ;
        [self addSubview:dateLabel] ;
    }
        [[NSNotificationCenter defaultCenter] removeObserver:self] ;
        return self ;
}
-(void)receiveCellData:(NSNotification *)notification{
    self.cellData = notification.object ;
}*/
-(void)setWithAlbum:(Albums *)album{
    for(UIView * subview in [self.contentView subviews]){
        [subview removeFromSuperview] ;
    }
    CGRect imageRect = CGRectMake(10, 10, 100, 100);
    //设置cell图片
    if(album.photoDetails){
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:imageRect] ;
        [imageView setImage:((UIImageView *)album.photoDetails.firstObject).image] ;
        imageView.contentMode = UIViewContentModeScaleAspectFit ;
        imageView.autoresizesSubviews = YES ;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        self.cellImage = imageView ;
        [self addSubview:self.cellImage] ;
    }
    //定制cell标题
    CGRect titleRect = CGRectMake(120, 60, self.frame.size.width - 120, 30) ;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:titleRect] ;
    titleLabel.font = [UIFont systemFontOfSize:18] ;
    titleLabel.numberOfLines = 0 ;
    titleLabel.text = album.title ;
    self.titleLabel = titleLabel ;
    [self addSubview:self.titleLabel] ;
    //定制cell显示日期
    CGRect dateRect = CGRectMake(10, 120 , self.frame.size.width - 10 , 20) ;
    UILabel * dateLabel = [[UILabel alloc] initWithFrame:dateRect] ;
    dateLabel.font = [UIFont systemFontOfSize:12] ;
    dateLabel.text = album.createTime ;
    self.dateLabel = dateLabel ;
    [self addSubview:self.dateLabel] ;
}
-(void)prepareForReuse{
    [super prepareForReuse] ;
    for(UIView * subview in [self.contentView subviews]) {
        [subview removeFromSuperview] ;
    }
}



@end
