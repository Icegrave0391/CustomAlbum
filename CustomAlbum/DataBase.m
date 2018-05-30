//
//  DataBase.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/5/30.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "DataBase.h"
#import "TaskModel.h"
#import <FMDB.h>
static DataBase * _DBCtl = nil ;

@interface DataBase()<NSCopying, NSMutableCopying>{
    FMDatabase * _db ;
}
@end

@implementation DataBase

+(instancetype)sharedDataBase{
    if(_DBCtl == nil){
        _DBCtl = [[DataBase alloc] init] ;
        
        [_DBCtl initDataBase] ;
    }
    return _DBCtl ;
}

-(void)initDataBase{
    //获取documents目录路径
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    //获取文件路径
    NSString * filePath = [documentsPath stringByAppendingPathComponent:@"historytask.sqlite"] ;
    //实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath] ;
    if([_db open]){
        //初始化数据表
        NSString * historyTaskSql = @"CREATE TABLE IF NOT EXISTS historyTask(imageData blob, urlAddress text, time text);" ;
        [_db executeUpdate:historyTaskSql] ;
        [_db close] ;
    }
}
//增加数据
-(void)addHistoryTask:(TaskModel *)task{
    NSData * imgData = UIImageJPEGRepresentation(task.image, 1) ;
    if([_db open]){
        [_db executeUpdate:@"INSERT INTO historyTask(imageData, urlAddress, time)VALUES(?, ?, ?)",imgData, task.urlAddress, task.time] ;
        
        [_db close] ;
    }
}
//获取数据
-(NSMutableArray *)getAllHistoryTask{
    NSMutableArray * dataArr = [[NSMutableArray alloc] init] ;
    if([_db open]) {
        FMResultSet * res = [_db executeQuery:@"SELECT * FROM historyTask"] ;
        
        while ([res next]) {
            TaskModel * task = [[TaskModel alloc] init] ;
            task.image = [UIImage imageWithData:[res dataForColumn:@"imageData"]] ;
            task.urlAddress = [res stringForColumn:@"urlAddress"] ;
            task.time = [res stringForColumn:@"time"] ;
            
            [dataArr addObject:task] ;
        }
        [_db close] ;
    }
    return dataArr ;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [super allocWithZone:zone];
        
    }
    
    return _DBCtl;
    
}
-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return self;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return self;
    
}
@end
