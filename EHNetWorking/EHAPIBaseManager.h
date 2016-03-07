//
//  EHAPIBaseManager.h
//  EHNetWorking
//
//  Created by howell on 7/17/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EHAPIBaseManager;

/*************************************************************************************************/
/*                                            Delegate                                           */
/*************************************************************************************************/

/*
 EHAPIBaseManager的派生类必须符合这些protocal
 */
@protocol EHAPIManagerDelegate <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
@end

/*
 外放EHAPIBaseManager的派生类的参数方法，更加灵活
 */
@protocol EHAPIManagerParamSourceDelegate <NSObject>
@required
- (NSDictionary *)paramsForApi:(EHAPIBaseManager *)manager;
@end

/*
 外放EHAPIBaseManager的派生类的回调接口，更加灵活
 */
@protocol EHAPIManagerApiCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(EHAPIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(EHAPIBaseManager *)manager;
@end


/*************************************************************************************************/
/*                                            类定义                                              */
/*************************************************************************************************/
@interface EHAPIBaseManager : NSObject

@property (nonatomic, weak) id<EHAPIManagerApiCallBackDelegate> callBackDelegate;
@property (nonatomic, weak) id<EHAPIManagerParamSourceDelegate> paramSourceDelegate;
@property (nonatomic, weak) NSObject<EHAPIManagerDelegate> *child; //里面会调用到NSObject的方法，所以这里不用id


/*
 根据EHAPIManagerParamSourceDelegate提供的数据加载数据。
 */
- (NSInteger)loadData;

@end
