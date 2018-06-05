//
//  OneCellViewController.m
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/17.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "OneCellViewController.h"
#import "DrawView.h"
#import <AFNetworking/AFNetworking.h>
#import "QNToken.h"
#import <QiniuSDK.h>
#import "DataBase.h"
#import "TaskModel.h"
#import "HistoryTaskController.h"
#import "UploadingTaskController.h"

@interface OneCellViewController ()<CLLocationManagerDelegate, MKAnnotation>
//new controller
//@property(nonatomic, strong)
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
    [view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.8 alpha:0.5]] ;
    [self.view addSubview:view] ;
//url label set up
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height*0.5)] ;
    [label setText:@"地址:"] ;
    [label setTextColor:[UIColor whiteColor]] ;
    [label setBackgroundColor:[UIColor clearColor]] ;
    self.urlLabel = label ;
    [view addSubview:_urlLabel] ;
//upload button set up
    UIButton * upLoadButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.2, self.view.bounds.size.height*0.6, self.view.bounds.size.width*0.6, self.view.bounds.size.width*0.2)] ;
    upLoadButton.layer.cornerRadius = 10.f ;
    
    [upLoadButton addTarget:self action:@selector(upLoadImage) forControlEvents:UIControlEventTouchUpInside] ;
    upLoadButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.7 alpha:0.3] ;
    
    [upLoadButton setTitle:@"上传" forState:UIControlStateNormal] ;
    [self.view addSubview:upLoadButton] ;
//    [view addSubview:self.locationLabel1] ;
//    [view addSubview:self.locationLabel2] ;
    
//progressView set up
    [self.progressView setFrame:CGRectMake(self.view.bounds.size.width*0.2, self.view.bounds.size.height*0.6, self.view.bounds.size.width*0.6, self.view.bounds.size.width*0.2)] ;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 5.0f);
    [self.view addSubview:_progressView] ;

// task buttons set up
    UIButton * historyTaskButton = [[UIButton alloc] initWithFrame:CGRectMake(0, view.bounds.size.height * 0.5, view.bounds.size.width * 0.5, view.bounds.size.height * 0.5)] ;
    historyTaskButton.backgroundColor = [UIColor darkGrayColor] ;
    historyTaskButton.layer.cornerRadius = 10.f ;
    [historyTaskButton setTitle:@"已完成任务" forState:UIControlStateNormal] ;
    [historyTaskButton addTarget:self action:@selector(pushToHistoryTaskController) forControlEvents:UIControlEventTouchUpInside] ;
    [view addSubview:historyTaskButton] ;
    
    UIButton * uploadingButton = [[UIButton alloc] initWithFrame:CGRectMake(view.bounds.size.width * 0.5, view.bounds.size.height * 0.5, view.bounds.size.width * 0.5, view.bounds.size.height * 0.5)] ;
    uploadingButton.backgroundColor = [UIColor darkGrayColor] ;
    uploadingButton.layer.cornerRadius = 10.f ;
    [uploadingButton setTitle:@"正在上传" forState:UIControlStateNormal] ;
    [uploadingButton addTarget:self action:@selector(pushToUploadTaskController) forControlEvents:UIControlEventTouchUpInside] ;
    [view addSubview:uploadingButton] ;
    
    if(!_labelArr)_labelArr = [[NSMutableArray alloc] init] ;
    //navigation bar item configure
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
#pragma mark 惰性实例化
-(UIProgressView *)progressView{
    if(!_progressView){
        _progressView = [[UIProgressView alloc] init] ;
        self.progressView.layer.cornerRadius = 10.f ;
        self.progressView.backgroundColor = [UIColor clearColor] ;
        self.progressView.alpha = 0.5 ;
        self.progressView.progressTintColor = [UIColor yellowColor] ;
        self.progressView.trackTintColor = [UIColor clearColor] ;
        self.progressView.progress = 0 ;
        [_progressView setProgressViewStyle:UIProgressViewStyleDefault] ;
    }
    return _progressView ;
}

-(UILabel *)urlLabel{
    if(!_urlLabel){
        _urlLabel = [[UILabel alloc] init] ;
    }
    return _urlLabel ;
}
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

-(NSMutableArray *)labelArr{
    if(!_labelArr){
        _labelArr = [NSMutableArray array] ;
    }
    return _labelArr ;
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
-(NSMutableArray *)uploadArr{
    if(!_uploadArr){
        _uploadArr = [[NSMutableArray alloc] init] ;
    }
    return _uploadArr ;
}
-(NSInteger)index{
    if(!_index){
        _index = 0 ;
    }
    return _index ;
}

#pragma mark MKMap
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

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated] ;
    [self.locationManager stopUpdatingLocation] ;
}

#pragma mark AFNetworking


//-(void)upLoadImage{
//    NSLog(@"hh") ;
//    NSString *url = @"http://upload.qiniup.com" ;
//
//
//    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager] ;
//    NSString * accseeKey = @"vN_MxTTJyh1Yo6pZIcx6xo6Dbh0orSrILYbzYTFp" ;
//    NSString * secretKey = @"uqH2Pt1GC5t_6ReiqqUk11pDgW0T8R1GbP_eBpoU" ;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    formatter.dateFormat = @"yyyyMMddHHmmss" ;
//    NSString *str = [formatter stringFromDate:[NSDate date]] ;
//    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//    NSString * scope = [NSString stringWithFormat:@"chuqi:%@",fileName] ;
//
//    NSString * token = [QNToken createTokenWithScope:scope accessKey:accseeKey secretKey:secretKey] ;
//
//    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer] ;
//    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@" UpToken %@",token] forHTTPHeaderField:@"Authorization"] ;
//    [sessionManager.requestSerializer setValue:@" application/json" forHTTPHeaderField:@"Content-Type"] ;
//    [sessionManager.requestSerializer setValue:fileName forHTTPHeaderField:@"fileName"] ;
//
//    UIImage *image = self.imageView.image ;
//    NSData *imageData = UIImageJPEGRepresentation(image, 1) ;
//
//    NSString * fileBinaryData = [NSString stringWithFormat:@"%@",imageData] ;
//  //  NSData * fileBinaryData = [fileBinaryDataString dataUsingEncoding:NSUTF8StringEncoding] ;
//    [sessionManager.requestSerializer setValue:fileBinaryData forHTTPHeaderField:@"fileBinaryData"] ;
//
//
//    [sessionManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        // 上传文件
//        UIImage *image = self.imageView.image ;
//        NSData *imageData = UIImageJPEGRepresentation(image, 1) ;
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//        formatter.dateFormat = @"yyyyMMddHHmmss" ;
//        NSString *str = [formatter stringFromDate:[NSDate date]] ;
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//
//        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpg"];
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@",,,,,,");
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//
//}
-(void)upLoadImage{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.dateFormat = @"yyyyMMddHHmmss" ;
    NSString *str = [formatter stringFromDate:[NSDate date]] ;
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    UIImage * img = self.imageView.image ;
    [self uploadImage:img WithName:fileName] ;
}
-(void)uploadImage:(UIImage *)image WithName:(NSString *)name{
    NSString * accseeKey = @"vN_MxTTJyh1Yo6pZIcx6xo6Dbh0orSrILYbzYTFp" ;
    NSString * secretKey = @"uqH2Pt1GC5t_6ReiqqUk11pDgW0T8R1GbP_eBpoU" ;
    NSString * scope = [NSString stringWithFormat:@"chuqi:%@",name] ;
    
    NSString * uploadToken = [QNToken createTokenWithScope:scope accessKey:accseeKey secretKey:secretKey] ;
    NSData * imgData = UIImageJPEGRepresentation(image, 1) ;
    NSString * url = @"http://upload.qiniup.com" ;
    NSString * key = name ;
    
    NSDictionary * header = @{
                              @"Authorization":[NSString stringWithFormat:@"UpToken %@",uploadToken] ,
                              @"Content-Type": @"application/json" ,
                              @"Host": url ,
                              } ;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager] ;
    [manager POST:url parameters:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //设置上传数组
        UploadTaskModel * task = [[UploadTaskModel alloc] init] ;
        [task setImage:[UIImage imageWithData:imgData]] ;
        [self.uploadArr addObject:task] ;
        
        [formData appendPartWithFormData:[key dataUsingEncoding:NSUTF8StringEncoding] name:@"key"] ;
        [formData appendPartWithFormData:[uploadToken dataUsingEncoding:NSUTF8StringEncoding] name:@"token"] ;
        [formData appendPartWithFormData:imgData name:@"file"] ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_queue_t queue = dispatch_get_main_queue() ;
        dispatch_async(queue, ^{
            self.progressView.progress = 1.0 * uploadProgress.completedUnitCount/ uploadProgress.totalUnitCount ;
            
            CGFloat process = 1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount ;
            [self getProcess:process forIndex:self.index] ;
        }) ;
        
//        NSLog(@"%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount) ;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!!!!!!!\n%@",responseObject) ;
        self.urlLabel.numberOfLines = 0 ;
        [self.urlLabel setText:[NSString stringWithFormat:@"地址: http://p8rhcoup7.bkt.clouddn.com/%@",key]] ;
        self.progressView.progress = 0 ;
        //获取上传时间 数据持久化
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"] ;
        NSString * time =[formatter stringFromDate:[NSDate date]] ;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        UIImage * img = self.imageView.image ;
        NSString * url = self.urlLabel.text ;
        dispatch_async(queue, ^{
            TaskModel * historyTask = [[TaskModel alloc] initWithImage:img AndUrlAddress:url AndTime:time] ;
            //使用数据库持久化
            [[DataBase sharedDataBase] addHistoryTask:historyTask] ;
        });
        //下一个上传任务
        self.index ++ ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed!!!!!!\n%@",error) ;
        self.index ++ ;
    }] ;
}



//-(void)upLoadImageUsingSDK{
//    NSLog(@"sdk") ;
//    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
//        builder.zone = [QNFixedZone zone0];
//    }];
//    //重用uploadManager。一般地，只需要创建一个uploadManager对象
//    NSString * accseeKey = @"vN_MxTTJyh1Yo6pZIcx6xo6Dbh0orSrILYbzYTFp" ;
//    NSString * secretKey = @"uqH2Pt1GC5t_6ReiqqUk11pDgW0T8R1GbP_eBpoU" ;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    formatter.dateFormat = @"yyyyMMddHHmmss" ;
//    NSString *str = [formatter stringFromDate:[NSDate date]] ;
//    NSString *fileName = [NSString stringWithFormat:@"%@", str];
//    NSString * scope = [NSString stringWithFormat:@"chuqi:%@",fileName] ;
//
//    NSString * token = [QNToken createTokenWithScope:scope accessKey:accseeKey secretKey:secretKey] ;
////    NSString * key = @"指定七牛服务上的文件名，或nil";
////    NSString * filePath = @"要上传的文件路径";
////    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
////params:nil
////checkCrc:NO
////cancellationSignal:nil];
//    UIImage *image = self.imageView.image ;
//    NSData *imageData = UIImageJPEGRepresentation(image, 1) ;
////    NSString * string = @"FXXK U!" ;
////    NSData * testData = [string dataUsingEncoding:NSUTF8StringEncoding] ;
////    NSString *testFileName = [NSString stringWithFormat:@"%@", str];
//
//    QNUploadManager * upManager = [[QNUploadManager alloc] initWithConfiguration:config] ;
//    [upManager putData:imageData key:fileName token:token
//              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                  NSLog(@"info = %@\n", info);
//                  NSLog(@"key = %@\n",key);
//                  NSLog(@"resp = %@\n", resp);
//              } option:nil];
//}
#pragma mark Controller跳转

//已完成任务
-(void)pushToHistoryTaskController{
    HistoryTaskController * tvc = [[HistoryTaskController alloc] init] ;
    tvc.navigationItem.title = @"已完成任务" ;
    [self.navigationController pushViewController:tvc animated:YES] ;
}
//上传任务
-(void)pushToUploadTaskController{
    UploadingTaskController * tvc = [[UploadingTaskController alloc] init] ;
    tvc.navigationItem.title = @"正在上传" ;
    [self.navigationController pushViewController:tvc animated:YES] ;
}

#pragma mark 上传数组
-(void)getProcess:(CGFloat)process forIndex:(NSInteger)index{
    UploadTaskModel * task = self.uploadArr[index] ;
    task.process = [NSNumber numberWithFloat:process] ;
    [self pushUploadArr] ;
}
-(void)pushUploadArr{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"progress" object:self.uploadArr] ;
}
@end
