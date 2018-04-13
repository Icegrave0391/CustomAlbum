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
@interface PhotosCollectionViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

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
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPhoto)];
    self.navigationItem.rightBarButtonItem = rightItem ;
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    
    
    // Register cell classes
    [self.collectionView registerClass:[PhotosCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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
    [cell setWithPhotoImage:image] ;
    // Configure the cell
    NSLog(@"cell is %@",cell) ;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

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
            NSLog(@"Authorized");
        }else{
            NSLog(@"Denied or Restricted");
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
    [self configureAlbum:image] ;
}
-(void)configureAlbum:(UIImage *)image{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image] ;
    [self.album.photoDetails addObject:imageView] ;
    [self.collectionView reloadData] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoDetails" object:imageView] ;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

@end
