//
//  ReformerSOAPGetwayFactory.h
//  EHNetWorking
//
//  Created by howell on 7/14/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReformerStrategy.h"

@interface ReformerSOAPGetwayFactory : NSObject
+ (ReformerStrategy *)getReformer:(NSString *)reformerName;
@end
