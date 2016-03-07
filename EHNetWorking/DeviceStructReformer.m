//
//  DeviceStructReformer.m
//  EHNetWorking
//
//  Created by howell on 7/13/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import "DeviceStructReformer.h"

NSString * const KDeviceIDKey = @"deviceIDKey";
NSString * const KDeviceChannelNOKey = @"deviceNOKey";
NSString * const kDeviceNameKey = @"deviceNameKey";
NSString * const kDeviceOnLineKey = @"deviceOnLineKey";
NSString * const KDevicePtzFlagKey = @"devicePTZFlagKey";
NSString * const KDeviceShareFlagKey = @"deviceShareKey";
NSString * const KDeviceWirelessKey = @"deviceWirelessKey";


@implementation DeviceStructReformer
- (NSDictionary *)reformerWithResponseValue:(id)value {
    NSMutableDictionary * reformerDic = [NSMutableDictionary dictionary];
    struct ns1__Dev device;
    [(NSData *)value getBytes:&device length:sizeof(struct ns1__Dev)];
    reformerDic[KDeviceIDKey] = [NSString stringWithUTF8String:(const char*)device.DevID];
    reformerDic[kDeviceNameKey] = [NSString stringWithUTF8String:(const char *)device.Name];
    reformerDic[KDeviceChannelNOKey] = [NSNumber numberWithInt:device.ChannelNo];
    reformerDic[KDevicePtzFlagKey] = [NSNumber numberWithBool:device.PtzFlag];
    reformerDic[KDeviceShareFlagKey] = [NSNumber numberWithBool:device.OnLine];
    reformerDic[KDeviceShareFlagKey] = [NSNumber numberWithInt:device.SharingFlag];
    reformerDic[KDeviceWirelessKey] = [NSNumber numberWithInt:device.WirelessFlag];
    return reformerDic;
}

@end
