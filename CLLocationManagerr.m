//
//  CLLocationManagerr.m
//  CLLocationManagerTransform
//
//  Created by qiaohui on 16/2/25.
//  Copyright © 2016年 znzx@QH. All rights reserved.
//

#import "CLLocationManagerr.h"
#import "CLLocation+QHLocation.h"

@interface CLLocationManagerr (){
    CLLocationManager *_manager;
}

@property (nonatomic,strong) LocationBlock locationBlock;
@property (nonatomic,strong) NSStringBlock cityBlock;
@property (nonatomic,strong) NSStringBlock addressBlock;
@property (nonatomic,strong) LocationErrorBlock errorBlock;

@end

@implementation CLLocationManagerr

+ (CLLocationManagerr *)shareLocation{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}


- (id)init{
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:CCLastLongitude];
        float latitude = [standard floatForKey:CCLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.lastCity = [standard objectForKey:CCLastCity];
        self.lastAddress = [standard objectForKey:CCLastAddress];
        
        
    }
    return self;
}

- (void)getLocationCoordinate:(LocationBlock)locationBlock{
    self.locationBlock = [locationBlock copy];
    [self startLocation];
}

- (void)getLocationCoordinate:(LocationBlock)locationBlock andAddress:(NSStringBlock)addressBlock{
    self.locationBlock = [locationBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void)getAddress:(NSStringBlock)addressBlock{
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void)getCity:(NSStringBlock)cityBlock{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

- (void)startLocation{
    
    
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
//        [_manager requestAlwaysAuthorization];
        _manager.distanceFilter = 10;
        
        double version = [[UIDevice currentDevice].systemVersion doubleValue];
        //请求权限
        if (version >= 8.0)
        {
            [_manager requestWhenInUseAuthorization];
            if ([_manager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_manager performSelector:@selector(requestAlwaysAuthorization)];//用这个方法，plist里要加字段NSLocationRequestAlwaysAuthorization
            }
            if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [_manager performSelector:@selector(requestWhenInUseAuthorization)];//用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
            }
        }
        //启动定位
        [_manager startUpdatingLocation];
    }else{
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
}

#pragma mark  -------CLLocationManagerDelegate

//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation{
//    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
//    CLLocation * location = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
//    CLLocation * marsLoction =   [location locationMarsFromEarth];
//    
//    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
//    [geocoder reverseGeocodeLocation:marsLoction completionHandler:^(NSArray *placemarks,NSError *error)
//     {
//         if (placemarks.count > 0) {
//             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             _lastCity = placemark.locality;
//             if (!_lastCity) {
//                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                 _lastCity = placemark.administrativeArea;
//             }
//             [standard setObject:_lastCity forKey:CCLastCity];//省市地址
//             NSLog(@"______%@",_lastCity);
//             _lastAddress = placemark.name;
//             NSLog(@"______%@",_lastAddress);
//         }
//         if (_cityBlock) {
//             _cityBlock(_lastCity);
//             _cityBlock = nil;
//         }
//         if (_addressBlock) {
//             _addressBlock(_lastAddress);
//             _addressBlock = nil;
//         }
//         
//         
//     }];
//    
//    _lastCoordinate = CLLocationCoordinate2DMake(marsLoction.coordinate.latitude ,marsLoction.coordinate.longitude);
//    if (_locationBlock) {
//        _locationBlock(_lastCoordinate);
//        _locationBlock = nil;
//    }
//    
//    NSLog(@"%f--%f",marsLoction.coordinate.latitude,marsLoction.coordinate.longitude);
//    [standard setObject:@(marsLoction.coordinate.latitude) forKey:CCLastLatitude];
//    [standard setObject:@(marsLoction.coordinate.longitude) forKey:CCLastLongitude];
//    
//    [manager stopUpdatingLocation];
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = locations[0];
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    CLLocation * location = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    CLLocation * marsLoction =   [location locationMarsFromEarth];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:marsLoction completionHandler:^(NSArray *placemarks,NSError *error)
     {
         if (placemarks.count > 0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             _lastCity = placemark.locality;
             if (!_lastCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 _lastCity = placemark.administrativeArea;
             }
             [standard setObject:_lastCity forKey:CCLastCity];//省市地址
             NSLog(@"______%@",_lastCity);
             _lastAddress = placemark.name;
             NSLog(@"______%@",_lastAddress);
         }
         if (_cityBlock) {
             _cityBlock(_lastCity);
             _cityBlock = nil;
         }
         if (_addressBlock) {
             _addressBlock(_lastAddress);
             _addressBlock = nil;
         }
         
         
     }];
    
    _lastCoordinate = CLLocationCoordinate2DMake(marsLoction.coordinate.latitude ,marsLoction.coordinate.longitude);
    if (_locationBlock) {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }
    
    NSLog(@"%f--%f",marsLoction.coordinate.latitude,marsLoction.coordinate.longitude);
    [standard setObject:@(marsLoction.coordinate.latitude) forKey:CCLastLatitude];
    [standard setObject:@(marsLoction.coordinate.longitude) forKey:CCLastLongitude];
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self stopLocation];
}


- (void)stopLocation{
    UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alvertView show];
    [_manager stopUpdatingLocation];
    _manager = nil;
}

@end
