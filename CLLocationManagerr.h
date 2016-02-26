//
//  CLLocationManagerr.h
//  CLLocationManagerTransform
//
//  Created by qiaohui on 16/2/25.
//  Copyright © 2016年 znzx@QH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


#define  CCLastLongitude @"CCLastLongitude"
#define  CCLastLatitude  @"CCLastLatitude"
#define  CCLastCity      @"CCLastCity"
#define  CCLastAddress   @"CCLastAddress"

typedef void(^LocationBlock)(CLLocationCoordinate2D locationCorrdinate);
typedef void(^LocationErrorBlock)(NSError *error);
typedef void(^NSStringBlock)(NSString *cityString);
typedef void(^NSStringBlock)(NSString *addressString);

@interface CLLocationManagerr : NSObject<CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D lastCoordinate;
@property (nonatomic,strong)NSString *lastCity;
@property (nonatomic,strong)NSString *lastAddress;

@property (nonatomic,assign)float latitude;
@property (nonatomic,assign)float longitude;

+ (CLLocationManagerr *)shareLocation;
/**
 *  获取坐标
 *
 *  @param locationBlock 经纬度
 */
- (void)getLocationCoordinate:(LocationBlock)locationBlock;
/**
 *  获取坐标和地址
 *
 *  @param locationBlock 经纬度
 *  @param addressBlock  地址
 */
- (void)getLocationCoordinate:(LocationBlock)locationBlock andAddress:(NSStringBlock)addressBlock;
/**
 *  获取详细地址
 *
 *  @param addressBlock 地址
 */
- (void)getAddress:(NSStringBlock)addressBlock;
/**
 *  获取城市
 *
 *  @param cityBlock 城市
 */
- (void)getCity:(NSStringBlock)cityBlock;








@end
