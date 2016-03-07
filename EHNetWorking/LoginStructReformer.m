//
//  LoginStructRefomer.m
//  EHNetWorking
//
//  Created by howell on 7/13/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import "LoginStructReformer.h"
#import "DeviceStructReformer.h"
#import "DESEncrypt.h"

NSString * const kLoginAccountKey = @"loginAccont";
NSString * const kLoginPasswordKey = @"loginPassword";
NSString * const kLoginSessionKey = @"loginSession";
NSString * const kLoginUsernameKey = @"loginUsername";
NSString * const kLoginDeviceArrayKey = @"loginDeviceArray";

@implementation LoginStructReformer
- (NSDictionary *)reformerWithResponseValue:(id)value {
    struct ns1__userLoginRes  userLoginRes;
    [(NSData*)value getBytes:&userLoginRes length:sizeof(struct ns1__userLoginRes)];
    
    NSMutableDictionary * reformerDic = [NSMutableDictionary dictionary];
    reformerDic[kLoginSessionKey] = [NSString stringWithUTF8String:(const char*)userLoginRes.LoginSession];
    reformerDic[kLoginAccountKey] = [NSString stringWithUTF8String:(const char *)userLoginRes.Account];
    reformerDic[kLoginUsernameKey] = [NSString stringWithUTF8String:(const char *)userLoginRes.Username];
    reformerDic[kLoginDeviceArrayKey] = [NSMutableArray array];
    
    DeviceStructReformer * deviceStructReformer = [[DeviceStructReformer alloc] init];
    for (int i = 0 ; i < userLoginRes.NodeList->__sizeDev; i++) {
        NSData * deviceData = [NSData dataWithBytes:(userLoginRes.NodeList->Dev+i)  length:sizeof(struct ns1__Dev)];
        NSDictionary * deviceDic = [deviceStructReformer reformerWithResponseValue:deviceData];
        [reformerDic[kLoginDeviceArrayKey] addObject:deviceDic];
    }
    return reformerDic;
}

- (id)reformerWithRequestDictionary:(NSDictionary *)dictionary {
    struct ns1__userLoginReq userLoginReq;
    memset(&userLoginReq, 0, sizeof(struct ns1__userLoginReq));
    userLoginReq.Account = (char *)[dictionary[kLoginAccountKey] UTF8String];
    
    char encrptPassword[194];
    [DESEncrypt encryptWithCString:(char *)[dictionary[kLoginPasswordKey] UTF8String] resultCString:encrptPassword];
    memcpy(userLoginReq.Password,encrptPassword,194);
    
    NSData * data = [NSData dataWithBytes:&userLoginReq length:sizeof(struct ns1__userLoginReq)];
    return data;
}
@end
