//
//  ViewController.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/11.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "MainMenu.h"
#import "AlbumViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES ;
    //配置background自适应屏幕
    UIImageView * backGround = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height) ];
    [backGround setImage:[UIImage imageNamed:@"image"]] ;
    backGround.contentMode = UIViewContentModeScaleAspectFill ;
    backGround.autoresizesSubviews = YES ;
    backGround.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    [self.view addSubview:backGround] ;
    //将相册按钮加入视图
    CGRect albumRect = CGRectMake(self.view.center.x - 75,self.view.bounds.size.height - 60 , 150, 40) ;
    UIButton * myAlbum = [UIButton buttonWithType:UIButtonTypeCustom] ;
    myAlbum.frame = albumRect ;
    myAlbum.backgroundColor = [UIColor darkGrayColor] ;
    myAlbum.layer.cornerRadius = 10.f ;
    [myAlbum setTitle:@"我的相册" forState:UIControlStateNormal] ;
    [myAlbum setTintColor:[UIColor whiteColor]] ;
    [myAlbum addTarget:self action:@selector(pushInAlbumViewController) forControlEvents:UIControlEventTouchUpInside] ;
    [self.view addSubview: myAlbum] ;
    
        
}
-(void)pushInAlbumViewController{
    AlbumViewController * tvc = [[AlbumViewController alloc] init] ;
    [self.navigationController pushViewController:tvc animated:YES] ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
