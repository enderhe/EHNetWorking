//
//  EHServiceSOAPGatewayPorxy.m
//  EHNetWorking
//
//  Created by howell on 6/30/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import "EHServiceSOAPGateway.h"
#import "SoapInterface.h"
#import "DESEncrypt.h"
#import "ReformerSOAPGetwayFactory.h"
#import "./HomeMCUServiceBinding_USCOREIHomeMCUService.nsmap"


@interface EHServiceSOAPGateway ()
@end

#pragma mark - Motheds Key定义
NSString * const kMethodsLoginKey = @"login";

@implementation EHServiceSOAPGateway
#pragma mark - Public Motheds
- (void)request:(NSString *)methond
         params:(NSDictionary *)params
        success:(void (^)(NSDictionary *))success
        failure:(void (^)(NSDictionary *))failure
{
    struct soap soap;
    soap_init(&soap);
    soap_set_mode(&soap, SOAP_C_UTFSTRING);
    soap.send_timeout = 10;
    soap.recv_timeout = 10;
    soap.connect_timeout = 10;
    
    NSDictionary * resultDic;
    if ([methond isEqualToString:kMethodsLoginKey]) {
        resultDic = [self callSoapLoginWithSoapPtr:(struct soap*)&soap
                                            params:params
                                          reformer:[ReformerSOAPGetwayFactory getReformer:kMethodsLoginKey]];
        success(resultDic);
    }
    
    soap_end(&soap);
    soap_done(&soap);
}


#pragma mark - Private Motheds


- (NSDictionary *)callSoapLoginWithSoapPtr:(struct soap*)soapPtr
                                    params:params
                                  reformer:(ReformerStrategy *)reformer{
    struct ns1__userLoginReq userLoginReq;
    struct ns1__userLoginRes userLoginRes;
    
    NSData * requestData = [reformer reformerWithRequestDictionary:params];
    [requestData getBytes:&userLoginReq length:sizeof(struct ns1__userLoginReq)];
    
    NSDictionary * resultDictionary = [NSDictionary dictionary];
    NSLog(@"%s",userLoginReq.Password);
    int status = soap_call___ns1__userLogin(soapPtr, NULL, NULL, &userLoginReq, &userLoginRes);
    if (status == SOAP_OK) {
        if (userLoginRes.result ==0) {
            NSData * data = [NSData dataWithBytes:&userLoginRes length:sizeof(struct ns1__userLoginRes)];
            resultDictionary = [reformer reformerWithResponseValue:data];
        }
    } else {
        
    }
    return resultDictionary;
}

@end

