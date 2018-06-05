//
//  HistoryTaskController.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/5/29.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "HistoryTaskController.h"
#import "historyTaskCell.h"
#import "TaskModel.h"
#import "DataBase.h"
@interface HistoryTaskController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HistoryTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self ;
    self.tableView.delegate = self ;
    
    self.navigationController.navigationBar.hidden = NO ;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated] ;
    self.historyTaskArr = [[DataBase sharedDataBase] getAllHistoryTask] ;
    
    NSLog(@"%@",self.historyTaskArr) ;
    if(!self.historyTaskArr){
        self.historyTaskArr = [[NSMutableArray alloc] init] ;
    }
    //消除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self.tableView reloadData] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.historyTaskArr count] == 0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    }
    return [self.historyTaskArr count] ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //   tableView.estimatedRowHeight = 140 ;
    //   tableView.rowHeight = UITableViewAutomaticDimension ;
    tableView.rowHeight = 140 ;
    return tableView.rowHeight ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"ID" ;
    [tableView registerClass:[historyTaskCell class] forCellReuseIdentifier:cellID] ;
    
    historyTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath] ;
    [cell setWithTaskModel:self.historyTaskArr[indexPath.row]] ;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 惰性实例化
-(NSMutableArray *)historyTaskArr{
    if(!_historyTaskArr){
        _historyTaskArr = [[NSMutableArray alloc] init] ;
    }
    return _historyTaskArr ;
}
@end
