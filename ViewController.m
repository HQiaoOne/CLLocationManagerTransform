//
//  ViewController.m
//  CLLocationManagerTransform
//
//  Created by qiaohui on 16/2/25.
//  Copyright © 2016年 znzx@QH. All rights reserved.
//

#import "ViewController.h"
#import "CLLocationManagerr.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/2.0 - 10, self.view.frame.size.width - 2 * 10, 200)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    
    
    [[CLLocationManagerr shareLocation] getAddress:^(NSString *addressString) {
        label.text = addressString;
        NSLog(@"%@",addressString);
    }];
    
//    [[CLLocationManagerr shareLocation] getCity:^(NSString *addressString) {
//        NSLog(@"%@",addressString);
//    }];
//    
//    [[CLLocationManagerr shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrdinate) {
//        NSLog(@"%f    %f",locationCorrdinate.latitude,locationCorrdinate.longitude);
//        
//        
//    } andAddress:^(NSString *addressString) {
//        label.text = addressString;
//        NSLog(@"%@",addressString);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
