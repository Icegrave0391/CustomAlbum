//
//  historyTaskCell.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/5/30.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "historyTaskCell.h"
#import "TaskModel.h"

@implementation historyTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setWithTaskModel:(TaskModel *)task{
    for(UIView * subview in [self.contentView subviews]){
        [subview removeFromSuperview] ;
    }
    //定制cell图片
    CGRect imageRect = CGRectMake(10, 10, 100, 100) ;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:imageRect] ;
    [imageView setImage:task.image] ;
    imageView.contentMode = UIViewContentModeScaleAspectFit ;
    imageView.autoresizesSubviews = YES ;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    
    self.historyTaskImageView = imageView ;
    [self.contentView addSubview:self.historyTaskImageView] ;
    //定制cell时间
    CGRect dateRect = CGRectMake(10, 120 , self.frame.size.width - 10 , 20) ;
    UILabel * dateLabel = [[UILabel alloc] initWithFrame:dateRect] ;
    dateLabel.font = [UIFont systemFontOfSize:12] ;
    dateLabel.text = task.time ;
    self.timeLabel = dateLabel ;
    [self.contentView addSubview:self.timeLabel] ;
    //定制cell url
    CGRect urlRect = CGRectMake(120, 0, self.frame.size.width - 80, 100) ;
    UILabel * urlLabel = [[UILabel alloc] initWithFrame:urlRect] ;
    urlLabel.font = [UIFont systemFontOfSize:18] ;
    urlLabel.numberOfLines = 0 ;
    urlLabel.text = task.urlAddress ;
    self.urlAddressLabel = urlLabel ;
    [self.contentView addSubview:self.urlAddressLabel] ;
}

-(void)prepareForReuse{
    [super prepareForReuse] ;
    for(UIView * subview in [self.contentView subviews]) {
        [subview removeFromSuperview] ;
    }
}

@end
