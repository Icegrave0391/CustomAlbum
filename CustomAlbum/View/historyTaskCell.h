//
//  historyTaskCell.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/5/30.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaskModel ;
@interface historyTaskCell : UITableViewCell

@property(nonatomic, strong)UIImageView * historyTaskImageView ;
@property(nonatomic, strong)UILabel * urlAddressLabel ;
@property(nonatomic, strong)UILabel * timeLabel ;

-(void)setWithTaskModel:(TaskModel *)task ;
@end
