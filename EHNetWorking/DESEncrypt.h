//
//  DESEncrypt.h
//  EHNetWorking
//
//  Created by howell on 7/8/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESEncrypt : NSObject
+ (void)encryptWithCString:(char *)orgString resultCString:(char *)resultString;
@end
