//
//  StructRefomerStrategy.h
//  EHNetWorking
//
//  Created by howell on 7/13/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "soapStub.h"
#import "EHServiceSOAPGatewayKeys.h"

@interface ReformerStrategy : NSObject
/**
 *  将NSDictionary格式化成网络库需要的请求数据格式
 *
 *  @param dictionary 需要格式化的NSDictionary
 *
 *  @return 网络请求数据格式
 */
- (id)reformerWithRequestDictionary:(NSDictionary *)dictionary;

/**
 *  网络库返回数据格式重新格式化成NSDictionary的键值对输出
 *
 *  @param  value 网络返回的数据格式
 *
 *  @return 格式化的NSDictionary
 */
- (NSDictionary *)reformerWithResponseValue:(id)value;
@end
