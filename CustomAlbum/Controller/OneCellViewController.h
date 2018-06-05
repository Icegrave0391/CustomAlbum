//
//  OneCellViewController.h
//  CustomAlbum
//
//  Created by 张储祺 on 2018/4/17.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <MapKit/MapKit.h>
#import "UploadTaskModel.h"
@class DrawView ;
@interface OneCellViewController : UIViewController

@property(nonatomic, strong) NSString * date ;
@property(nonatomic, strong) UIImageView * imageView ;


@property(nonatomic, strong) DrawView * drawView ;

@property(nonatomic, strong) UILabel * locationLabel1 ;
@property(nonatomic, strong) UILabel *locationLabel2 ;
@property(nonatomic, strong) NSMutableArray * labelArr ;

@property(nonatomic, strong) MKMapView * mapView ;
@property(nonatomic, assign) BOOL isEditing ;
//标注点位置
@property(nonatomic, assign)  CLLocationCoordinate2D  coordinate ;

//起始标注点
@property(nonatomic, strong) CLLocationManager * locationManager ;
//url
@property(nonatomic, strong) UILabel * urlLabel ;
@property(nonatomic, strong) UIProgressView * progressView ;

//上传数组
@property(nonatomic, strong)NSMutableArray * uploadArr ;
@property(nonatomic, assign)NSInteger index ;

@end
