//
//  AlbumViewController.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/11.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UITableViewController

@property(nonatomic, strong) NSMutableArray * albums ;
@property(nonatomic, strong) NSIndexPath * indexPath ;//用于记录选中单元格

@end
