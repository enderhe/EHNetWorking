//
//  EHServiceSOAPGatewayPorxy.h
//  EHNetWorking
//
//  Created by howell on 6/30/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHServiceSOAPGatewayKeys.h"


@interface EHServiceSOAPGateway : NSObject

- (void)request:(NSString *)methond
         params:(NSDictionary *)params
        success:(void(^)(NSDictionary *resultDictionary))success
        failure:(void(^)(NSDictionary *resultDictionary))fail;
@end
