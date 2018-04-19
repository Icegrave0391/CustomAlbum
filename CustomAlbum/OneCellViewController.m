//
//  OneCellViewController.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/17.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "OneCellViewController.h"

@interface OneCellViewController ()

@end

@implementation OneCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]] ;
    // Do any additional setup after loading the view.

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 20)] ;
    [label setText:self.date] ;
    [label setTextColor:[UIColor blackColor]] ;
    [label setFont:[UIFont systemFontOfSize:18]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    [self.view addSubview:label] ;
    //question：为什么视图大小会根据设置的尺寸的变化而变化？
    [self.imageView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.width)] ;
//    self.imageView.contentMode = UIViewContentModeCenter ;
    
    [self.view addSubview:self.imageView] ;
    
    UIBarButtonItem * infoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showInfo)] ;
    self.navigationItem.rightBarButtonItem = infoItem ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showInfo{
    UIAlertController * info = [UIAlertController alertControllerWithTitle:@"拍摄时间" message:self.date preferredStyle:UIAlertControllerStyleAlert] ;
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [info addAction:ok] ;
    [self presentViewController:info animated:YES completion:nil] ;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
