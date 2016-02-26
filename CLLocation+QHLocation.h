//
//  CLLocation+QHLocation.h
//  CLLocationManagerTransform
//
//  Created by qiaohui on 16/2/25.
//  Copyright © 2016年 znzx@QH. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (QHLocation)

//从地图坐标转化到火星坐标
- (CLLocation*)locationMarsFromEarth;

//从火星坐标转化到百度坐标
- (CLLocation*)locationBaiduFromMars;

//从百度坐标到火星坐标
- (CLLocation*)locationMarsFromBaidu;

@end
