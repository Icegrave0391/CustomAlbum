//
//  UploadingTaskController.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/6/5.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "UploadingTaskController.h"

@interface UploadingTaskController ()

@end

@implementation UploadingTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadProcessing:) name:@"progress" object:nil] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.uploadingTaskArr.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"cellID" ;
    [tableView registerClass:[UploadingTaskCellTableViewCell class] forCellReuseIdentifier:cellID] ;
    UploadingTaskCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath] ;
    [cell setWithUploadingModel:self.uploadingTaskArr[indexPath.row]] ;
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
#pragma mark table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.rowHeight = 140 ;
    return tableView.rowHeight ;
}

#pragma mark 惰性实例化
-(NSMutableArray *)uploadingTaskArr{
    if(!_uploadingTaskArr){
        _uploadingTaskArr = [[NSMutableArray alloc] init] ;
    }
    return _uploadingTaskArr ;
}

-(void)uploadProcessing:(NSNotification *)notification{
    self.uploadingTaskArr = (NSMutableArray *)notification.object ;
    int i = 0 ;
    for(UploadTaskModel * task in self.uploadingTaskArr){
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0] ;
        [self configureCellWithTask:task forIndexPath:indexPath] ;
        i++ ;
    }
    [self.tableView reloadData] ;
}

-(void)configureCellWithTask:(UploadTaskModel *)task forIndexPath:(NSIndexPath *)indexpath{
//    NSLog(@"%@",indexpath) ;
    UploadingTaskCellTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexpath] ;
    cell.progress = task.process ;
//    NSLog(@"cell %@",cell) ;
//    NSLog(@"%@",cell.progressView) ;
//    NSLog(@"task:%f",[task.process floatValue]) ;
    cell.progressView.progress = [cell.progress floatValue] ;
//    NSLog(@" pro : %f",cell.progressView.progress) ;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}
@end
