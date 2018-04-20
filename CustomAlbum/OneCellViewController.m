//
//  OneCellViewController.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/17.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "OneCellViewController.h"
#import "DrawView.h"

@interface OneCellViewController ()

@end

@implementation OneCellViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]] ;
    // Do any additional setup after loading the view.

//    //question：为什么视图大小会根据设置的尺寸的变化而变化？
//    [self.imageView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.width)] ;
////    self.imageView.contentMode = UIViewContentModeCenter ;

//    [self.view addSubview:self.imageView] ;
    [self.view addSubview:self.drawView] ;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0.8*self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.2)] ;
    [view setBackgroundColor:[UIColor darkGrayColor]] ;
    [self.view addSubview:view] ;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height*0.5)] ;
    [label setText:@"请选择颜色:(算了就一种颜色)"] ;
    [view addSubview:label] ;
//    UIButton * redButton = [[UIButton alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height*0.9,1/3*self.view.bounds.size.width, self.view.bounds.size.height*0.1)] ;
//    [redButton setBackgroundColor:[UIColor redColor]] ;
    UIButton *blackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width,100)] ;
    [blackButton setBackgroundColor:[UIColor blackColor]] ;
    blackButton.layer.cornerRadius = 30.f ;
    [blackButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside] ;
    [view addSubview:blackButton] ;
    
//    UIButton * blackButton = [[UIButton alloc] initWithFrame:CGRectMake(1/3*view.bounds.size.width, self.view.bounds.size.height*0.9, 1/3*self.view.bounds.size.width, self.view.bounds.size.height*0.1)] ;
//    [blackButton setBackgroundColor:[UIColor blackColor]] ;
//    [view addSubview:blackButton] ;
//
//    UIButton * greenButton = [[UIButton alloc] initWithFrame:CGRectMake(2/3*view.bounds.size.width, self.view.bounds.size.height*0.9, 1/3*self.view.bounds.size.width,self.view.bounds.size.height*0.1)] ;
//    [greenButton setBackgroundColor:[UIColor greenColor]] ;
//    [view addSubview:greenButton] ;
    
    UIBarButtonItem * infoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showInfo)] ;
    UIBarButtonItem * undoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undo)] ;
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] ;
    self.navigationItem.rightBarButtonItems = @[undoItem,infoItem,saveItem] ;
}

-(void)showInfo{
    UIAlertController * info = [UIAlertController alertControllerWithTitle:@"拍摄时间" message:self.date preferredStyle:UIAlertControllerStyleAlert] ;
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [info addAction:ok] ;
    [self presentViewController:info animated:YES completion:nil] ;
}
-(void)clickButton:(UIButton *)sender{
    _drawView.pathColor =sender.backgroundColor ;
}
-(void)undo{
    [_drawView undo] ;
}
-(void)save{
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(_drawView.bounds.size, NO, 0) ;
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    //渲染涂层
    [_drawView.layer renderInContext:context] ;
    //获取上下文图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext() ;
    //关闭上下文
    UIGraphicsEndImageContext() ;
    //更新imageView
    self.imageView.image = image ;
    //保存
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError:contextInfo:), nil);
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"保存成功") ;
}
-(DrawView *)drawView{
    if(!_drawView){
        _drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)] ;
        _drawView.image = self.imageView.image ;
//        _drawView.pathColor = [UIColor blackColor] ;
        _drawView.pathWidth = 2 ;
    }
    return _drawView ;
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
