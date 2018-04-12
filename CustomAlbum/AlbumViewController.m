//
//  AlbumViewController.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/11.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "AlbumViewController.h"
#import "Albums.h"
#import "AlbumCell.h"
@interface AlbumViewController () <UITableViewDataSource , UITableViewDelegate>

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self ;
    self.tableView.delegate = self ;
    //批量操作
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    UILongPressGestureRecognizer * cell = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewCellLongPressed:)] ;
    [self.tableView addGestureRecognizer:cell] ;
    //配置self.albums   ****应该配合数据持久化*******待实现
    self.albums = [[NSMutableArray alloc] init] ;
    //定制navigation bar
    self.navigationController.navigationBar.hidden = NO ;
    self.title = @"相册列表" ;
    UIBarButtonItem * rightItemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newAlbum) ] ;
    UIBarButtonItem * rightItemDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeSelectedCells)];
    self.navigationItem.rightBarButtonItems = @[rightItemAdd,rightItemDelete] ;
    //self.navigationItem.rightBarButtonItem = rightItem ;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if([self.albums count]==0){
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    }
    NSLog(@"删除以前%@",self.albums) ;
    return [self.albums count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"ID" ;
    [tableView registerClass:[AlbumCell class] forCellReuseIdentifier:cellID] ;
    AlbumCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath] ;
    [cell setWithAlbum:[self.albums objectAtIndex:indexPath.row]] ;
    NSLog(@"%@",cell) ;
    return cell ;
}
//设置正确行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 //   tableView.estimatedRowHeight = 140 ;
 //   tableView.rowHeight = UITableViewAutomaticDimension ;
    tableView.rowHeight = 140 ;
    return tableView.rowHeight ;
}

#pragma mark - Table View Delegate
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction * delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.albums removeObjectAtIndex:indexPath.row] ;
        [tableView reloadData] ;
        NSLog(@"删除以后%@",self.albums) ;
    }];
    NSArray *array = [NSArray arrayWithObject:delete] ;
    return array ;
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

//处理 新建相册
-(void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController * alertController = (UIAlertController *)self.presentedViewController ;
    if(alertController){
        UITextField * textField = alertController.textFields.firstObject ;
        UIAlertAction * OK = alertController.actions.lastObject ;
        OK.enabled = textField.text.length?YES:NO ;
    }
}
-(void)newAlbum{
    UIAlertController * newAlbum = [UIAlertController alertControllerWithTitle:@"新建相册"
                                                                       message:@"请输入相册名称"
                                                                preferredStyle:UIAlertControllerStyleAlert] ;
    [newAlbum addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField] ;
        textField.placeholder = @"相册名称" ;
    }] ;
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"好的"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          //移除通知
                                                          [[NSNotificationCenter defaultCenter] removeObserver:self] ;
                                                          //获取当前时间
                                                          NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                                                          [formatter setDateFormat:@"yyyy/MM/dd HH:mm"] ;
                                                          NSString * time =[formatter stringFromDate:[NSDate date]] ;
                                                          Albums * album = [[Albums alloc] initWithTitle:newAlbum.textFields.firstObject.text andCreateTime:time] ;
                                                          [self.albums addObject:album] ;
                                                          [self.tableView reloadData] ;
                                                        
                                                      }] ;
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }];
    [newAlbum addAction:cancelAction] ;
    okAction.enabled = NO ;
    [newAlbum addAction:okAction] ;
    [self presentViewController:newAlbum animated:YES completion:nil] ;
    
}
//处理 批量删除
-(void)tableViewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
//    CGPoint point = [gestureRecognizer locationInView:self.tableView] ;
//    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point] ;
    [self.tableView setEditing:!self.tableView.isEditing animated:YES] ;
}
-(void)removeSelectedCells{
    NSMutableArray * deleteCells = [NSMutableArray array] ;
    for(NSIndexPath * indexPath in self.tableView.indexPathsForSelectedRows){
        [deleteCells addObject:self.albums[indexPath.row]] ;
    }
    [self.albums removeObjectsInArray:deleteCells] ;
    [self.tableView reloadData] ;
}
                     

@end
