//
//  EHAPIPorxy.m
//  
//
//  Created by howell on 7/3/15.
//
//

#import "EHAPIPorxy.h"
#import "EHServiceSOAPGateway.h"
@interface EHAPIPorxy ()
@property (nonatomic,strong)EHServiceSOAPGateway * soap;
@end

@implementation EHAPIPorxy
#pragma mark - Life Cycle
- (instancetype)sharedInstance {
    static dispatch_once_t oneToken;
    static EHAPIPorxy * sharedInstance = nil;
    dispatch_once(&oneToken,^{
        sharedInstance = [[EHAPIPorxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public Methonds
- (NSInteger)callSOAPWithParams:(NSDictionary *)params
             serviceIndentifier:(NSString *)serviceIndentifer
                     mothedName:(NSString *)methodName
                        success:(AXCallBack)success
                           fail:(AXCallBack)fail
{
    
    return 0;
}
@end
