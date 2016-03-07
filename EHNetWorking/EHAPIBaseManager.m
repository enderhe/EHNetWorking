//
//  EHAPIBaseManager.m
//  EHNetWorking
//
//  Created by howell on 7/17/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import "EHAPIBaseManager.h"

@implementation EHAPIBaseManager

#pragma mark - Life Cycle 
- (instancetype)init {
    self = [super init];
    if (self) {
        _callBackDelegate = nil;
        _paramSourceDelegate = nil;
        if ([self conformsToProtocol:@protocol(EHAPIManagerDelegate)]) {
            self.child = (id <EHAPIManagerDelegate>)self;
        }
    }
    return self;
}

#pragma mark - Public Methods
- (NSInteger)loadData {
    NSDictionary *params = [self.paramSourceDelegate paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params {
    return 0;
}
@end
