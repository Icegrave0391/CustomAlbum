//
//  UploadingTaskCellTableViewCell.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/6/4.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadTaskModel.h"
@interface UploadingTaskCellTableViewCell : UITableViewCell

@property(nonatomic, strong)UIProgressView * progressView ;
@property(nonatomic, strong)UIImageView * uploadingView ;
@property(nonatomic, strong)NSNumber * progress ;

-(void)setWithUploadingModel:(UploadTaskModel *)task ;

@end
