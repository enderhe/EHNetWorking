//
//  EHAPIPorxy.h
//  
//
//  Created by howell on 7/3/15.
//
//

#import <Foundation/Foundation.h>
#import "AIFURLResponse.h"
typedef void (^AXCallBack) (AIFURLResponse* response);

@interface EHAPIPorxy : NSObject
+ (instancetype)sharedInstance;
/**
 *  调用soap的代理方法
 *
 *  @param params            调用参数
 *  @param serviceIndentifer 服务器ID
 *  @param methodName        要调用的参数名
 *  @param success           成功后回调
 *  @param fail              失败后回调
 *  @return
 */
- (NSInteger)callSOAPWithParams:(NSDictionary *)params
             serviceIndentifier:(NSString *)serviceIndentifer
                     mothedName:(NSString *)methodName
                        success:(AXCallBack)success
                           fail:(AXCallBack)fail;
@end
