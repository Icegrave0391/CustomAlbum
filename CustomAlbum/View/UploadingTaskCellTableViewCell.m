//
//  UploadingTaskCellTableViewCell.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/6/4.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "UploadingTaskCellTableViewCell.h"

@implementation UploadingTaskCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setWithUploadingModel:(UploadTaskModel *)task{
    for(UIView * subview in [self.contentView subviews]){
        [subview removeFromSuperview] ;
    }

    //定制image
    CGRect imageRect = CGRectMake(10, 10, 100, 100) ;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:imageRect] ;
    [imageView setImage:task.image] ;
    imageView.contentMode = UIViewContentModeScaleAspectFit ;
    imageView.autoresizesSubviews = YES ;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    
    self.uploadingView = imageView ;
    [self.contentView addSubview:self.uploadingView] ;
    
    //定制progressview
    self.progress = task.process ;
    CGRect progressRect = CGRectMake(120, 60, self.frame.size.width - 80, 30) ;
    UIProgressView * progressView = [[UIProgressView alloc] initWithFrame:progressRect] ;
    progressView.transform = CGAffineTransformMakeScale(1.0f, 10.0f) ;
    progressView.progress = [task.process floatValue] ;
    
    self.progressView = progressView ;
    [self.contentView addSubview:self.progressView] ;
}
@end
    
