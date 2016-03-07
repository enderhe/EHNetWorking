//
//  ViewController.m
//  EHNetWorking
//
//  Created by howell on 6/29/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import "ViewController.h"
#import "EHServiceSOAPGateway.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    EHServiceSOAPGateway * gateway = [[EHServiceSOAPGateway alloc] init];
    NSDictionary * idc = @{kLoginAccountKey:@"10086012",
                           kLoginPasswordKey:@"10086012"};
    [gateway request:kMethodsLoginKey
              params:idc
             success:^(NSDictionary *resultDictionary) {
                 for (NSDictionary * deviceDic in resultDictionary[kLoginDeviceArrayKey]) {
                     NSLog(@"device name %@",deviceDic[kDeviceNameKey]);
                 }
             } failure:^(NSDictionary *resultDictionary) {
                 
             }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
