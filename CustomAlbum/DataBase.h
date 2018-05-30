//
//  DataBase.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/5/30.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TaskModel ;

@interface DataBase : NSObject

@property(nonatomic, strong) TaskModel * historyTask ;
+(instancetype)sharedDataBase ;

#pragma mark historyTask
//添加历史记录
-(void)addHistoryTask:(TaskModel *)task ;
////更新历史记录
//-(void)updateHistoryTask:(TaskModel *)task ;
//获取所有数据
-(NSMutableArray *)getAllHistoryTask ;
@end
