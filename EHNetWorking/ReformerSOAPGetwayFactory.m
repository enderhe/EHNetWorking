//
//  ReformerSOAPGetwayFactory.m
//  EHNetWorking
//
//  Created by howell on 7/14/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import "ReformerSOAPGetwayFactory.h"
#import "EHServiceSOAPGatewayKeys.h"
#import "LoginStructReformer.h"

@implementation ReformerSOAPGetwayFactory

+ (ReformerStrategy *)getReformer:(NSString *)reformerName {
    ReformerStrategy * reformer;
    if ([reformerName isEqualToString:kMethodsLoginKey]) {
        reformer = [[LoginStructReformer alloc] init];
    }
    return reformer;
}

@end
