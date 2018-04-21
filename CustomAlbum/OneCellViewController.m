//
//  OneCellViewController.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/17.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "OneCellViewController.h"
#import "DrawView.h"

@interface OneCellViewController ()<CLLocationManagerDelegate, MKAnnotation>

@end

@implementation OneCellViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]] ;
    self.isEditing = NO ;
    NSString * file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"label.data"] ;
    self.labelArr = [NSKeyedUnarchiver unarchiveObjectWithFile:file] ;
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
    UIButton *blackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width,10)] ;
    [blackButton setBackgroundColor:[UIColor blackColor]] ;
    blackButton.layer.cornerRadius = 30.f ;
    [blackButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside] ;
    [view addSubview:blackButton] ;

    [view addSubview:self.locationLabel1] ;
    [view addSubview:self.locationLabel2] ;
//    UIButton * blackButton = [[UIButton alloc] initWithFrame:CGRectMake(1/3*view.bounds.size.width, self.view.bounds.size.height*0.9, 1/3*self.view.bounds.size.width, self.view.bounds.size.height*0.1)] ;
//    [blackButton setBackgroundColor:[UIColor blackColor]] ;
//    [view addSubview:blackButton] ;
//
//    UIButton * greenButton = [[UIButton alloc] initWithFrame:CGRectMake(2/3*view.bounds.size.width, self.view.bounds.size.height*0.9, 1/3*self.view.bounds.size.width,self.view.bounds.size.height*0.1)] ;
//    [greenButton setBackgroundColor:[UIColor greenColor]] ;
//    [view addSubview:greenButton] ;

    if(!_labelArr)_labelArr = [[NSMutableArray alloc] init] ;
    
    UIBarButtonItem * infoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showInfo)] ;
    UIBarButtonItem * undoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undo)] ;
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] ;
    UIBarButtonItem *locationItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(changeLocation)] ;
    self.navigationItem.rightBarButtonItems = @[infoItem,undoItem,locationItem,saveItem] ;
    
    //location
    [self.locationManager startUpdatingLocation];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GraffitiSaveNotification" object:image] ;
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
-(UILabel *)locationLabel1{
    if(!_locationLabel1){
        _locationLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width-60, 30)] ;
    }
    _locationLabel1.backgroundColor = [UIColor whiteColor] ;
    if(_labelArr){
        _locationLabel1.text = self.labelArr.firstObject ;
    }else{
        _locationLabel1.text = @"经度:" ;
    }
    return _locationLabel1 ;
}

-(UILabel *)locationLabel2{
    if(!_locationLabel2){
        _locationLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width-60, 30)] ;
        _locationLabel2.backgroundColor = [UIColor whiteColor] ;
        if(_labelArr){
            _locationLabel2.text = self.labelArr.lastObject ;
        }else{
            _locationLabel2.text = @"纬度:" ;
        }
    }
    return _locationLabel2 ;
}

-(void)changeLocation{
    if(!self.isEditing){
        [self.view addSubview:self.mapView] ;
        self.isEditing = !self.isEditing ;
    }else{
        [self.mapView removeFromSuperview] ;
        self.isEditing = !self.isEditing ;
    }
}
-(MKMapView *)mapView{
    if(!_mapView){
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds] ;
        _mapView.mapType = MKMapTypeStandard ;
//        _mapView.delegate = self ;
        _mapView.zoomEnabled = YES ;
        _mapView.userTrackingMode = YES ;
        _mapView.centerCoordinate = self.locationManager.location.coordinate ;
        
        MKPointAnnotation * anno = [[MKPointAnnotation alloc] init] ;
        anno.coordinate = _mapView.centerCoordinate ;
        anno.title = @"初始" ;
        [_mapView addAnnotation:anno] ;
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)] ;
        [_mapView addGestureRecognizer:longPress] ;
    }
    return _mapView ;
}
-(CLLocationManager *)locationManager{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init] ;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest ;
        _locationManager.distanceFilter = 1000.0f ;
        _locationManager.delegate = self ;
    }
    return _locationManager ;
}
-(void)longPress:(UILongPressGestureRecognizer*)longPress{
    CGPoint location = [longPress locationInView:self.view] ;
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:location toCoordinateFromView:self.mapView] ;
    
    //创建标注
    MKPointAnnotation * anno = [[MKPointAnnotation alloc] init] ;
    anno.coordinate = coordinate ;
    anno.title = @"选择的位置" ;
    [self.mapView addAnnotation:anno] ;
    self.labelArr = [[NSMutableArray alloc] init] ;
    
    NSString * label1 = [NSString stringWithFormat:@"经度:%3.5f",anno.coordinate.longitude] ;
    self.locationLabel1.text = label1 ;
    [_labelArr addObject:label1] ;
    NSString * label2 = [NSString stringWithFormat:@"纬度:%3.5f",anno.coordinate.latitude] ;
    self.locationLabel2.text = label2 ;
    [_labelArr addObject:label2] ;
    [self writeToFile] ;
}

-(void)writeToFile{
    NSString * file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"label.data"] ;
    [NSKeyedArchiver archiveRootObject:self.labelArr toFile:file];
}
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    self.locationLabel1.text = [NSString stringWithFormat:@"经度 :%3.5f",self.locationManager.location.coordinate.longitude] ;
//}
-(NSMutableArray *)labelArr{
    if(!_labelArr){
        _labelArr = [NSMutableArray array] ;
    }
    return _labelArr ;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated] ;
    [self.locationManager stopUpdatingLocation] ;
}
@end
