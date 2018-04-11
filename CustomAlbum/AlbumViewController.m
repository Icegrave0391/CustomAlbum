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
    //配置self.albums
    self.albums = [[NSMutableArray alloc] init] ;
    //定制navigation bar
    self.navigationController.navigationBar.hidden = NO ;
    self.title = @"相册列表" ;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newAlbum) ] ;
    self.navigationItem.rightBarButtonItem = rightItem ;
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

    return [self.albums count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"ID" ;
/*    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil){
        cell = [[AlbumCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID] ;
        cell.cellData = [self.albums objectAtIndex:indexPath.row] ;
    }*/
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID] ;
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID] ;
    }
    
    // Configure the cell...
    [cell.textLabel setText:((Albums *)[self.albums objectAtIndex:indexPath.row]).title] ;
    [cell.detailTextLabel setText:((Albums *)[self.albums objectAtIndex:indexPath.row]).createTime] ;
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
                     

@end
