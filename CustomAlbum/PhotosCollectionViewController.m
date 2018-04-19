//
//  PhotosCollectionViewController.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/13.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "Albums.h"
#import "PhotosCollectionViewCell.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "OneCellViewController.h"

NS_ENUM(NSInteger,CellState){
    NormalState ,
    DeleteState
} ;
@interface PhotosCollectionViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic, assign)enum CellState ;

@end

@implementation PhotosCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self ;
    self.collectionView.backgroundColor = [UIColor whiteColor] ;
    [self.view addSubview: self.collectionView] ;
    //定制navigationBar
    self.navigationController.navigationBar.hidden = NO ;
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPhoto)];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editActionPressed)] ;
    self.navigationItem.rightBarButtonItems = @[addItem,deleteItem] ;
    //多选操作
    self.collectionView.allowsMultipleSelection = YES ;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    
    
    // Register cell classes
    [self.collectionView registerClass:[PhotosCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    CellState = NormalState ;
    //加载时间数据
    NSString * file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"time.data"] ;
    self.dateArr = [NSKeyedUnarchiver unarchiveObjectWithFile:file] ;
    if(!self.dateArr){
        self.dateArr = [[NSMutableArray alloc] init] ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.album.photoDetails.count;
}

- (PhotosCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImageView * imageView = self.album.photoDetails[indexPath.row] ;
    UIImage * image = imageView.image ;
    cell.imageView.image = image ;
    //设置deleteButton
    if (CellState == NormalState) {
        cell.deleteButton.hidden = YES ;
    }else{
        cell.deleteButton.hidden = NO ;
    }
    [cell.deleteButton addTarget:self action:@selector(deleteCellButtonPressed:) forControlEvents:UIControlEventTouchUpInside] ;
    // Configure the cell
//    NSLog(@"cell is %@",cell) ;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OneCellViewController * tvc = [[OneCellViewController alloc] init] ;
    UIImageView * imageView = [self.album.photoDetails objectAtIndex:indexPath.row] ;
    tvc.imageView = imageView ;
    tvc.date = self.dateArr[indexPath.row] ;
    NSLog(@"cell date : %@",tvc.date) ;
    [self.navigationController pushViewController:tvc animated:YES] ;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
//添加照片
-(void)addPhoto{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
        if (granted) {
//            NSLog(@"Authorized");
        }else{
//            NSLog(@"Denied or Restricted");
        }
    }];
    UIImagePickerController * photoController = [[UIImagePickerController alloc] init] ;
    photoController.delegate = self ;
    photoController.allowsEditing = YES ;
    photoController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
    [self presentViewController:photoController animated:YES completion:nil] ;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil] ;
    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage] ;
    //获取exif
    NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"] ;
    PHAsset *asset = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil].firstObject ;
    [self addDateInfoForCell:asset] ;
    NSLog(@"all date: %@",self.dateArr) ;
    [self writeToFile] ;
    NSLog(@"asset :%@",asset) ;
    
    [self configureAlbum:image] ;
}
-(void)configureAlbum:(UIImage *)image{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image] ;
    [self.album.photoDetails addObject:imageView] ;
    [self.collectionView reloadData] ;
    self.receivePhotoDetails();
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoDetails" object:imageView] ;
}

//批量删除照片
-(void)editActionPressed{
    if(CellState == NormalState){
        CellState = DeleteState ;
        //这个时候如何修改barbuttonItem 的 systemstyle？
        for(PhotosCollectionViewCell * cell in self.collectionView.visibleCells){
            cell.deleteButton.hidden = NO ;
        }
    }else if(CellState == DeleteState){
        CellState = NormalState ;
    }
    [self.collectionView reloadData] ;
}
-(void)deleteCellButtonPressed:(id)sender{
    PhotosCollectionViewCell * cell =(PhotosCollectionViewCell *)[sender superview] ;//获取cell
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell] ;
    
    [self.album.photoDetails removeObjectAtIndex:indexpath.row] ;
    [self.dateArr removeObjectAtIndex:indexpath.row] ;
    [self writeToFile] ;
    
    self.receivePhotoDetails();
    [self.collectionView reloadData] ;
}
//获取照片时间信息并储存在自身时间数组
-(void)addDateInfoForCell:(PHAsset *)asset{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"] ;
    NSString * time = [formatter stringFromDate:asset.creationDate] ;
    
    [self.dateArr addObject:time] ;
}
//归档时间数组
-(void)writeToFile{
    NSString * file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"time.data"] ;
    [NSKeyedArchiver archiveRootObject:self.dateArr toFile:file] ;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

@end
