//
//  SoapInterface.h
//  GLCameraRipple
//
//  Created by howell howell on 12-9-27.
//  Copyright (c) 2012年 Howell Electronic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "soapStub.h"
#import "soapH.h"

#define MAXIPCAMNUM 64
#define NOCONNECT 0xFFFF
struct deviceInfo{
    char channel[2];
    char desertCallID[33]; //设备id
    char devId[21]; //用来做push的id
    int deviceType; //ns1__StreamType__Main = 0, ns1__StreamType__Sub = 1
    int ChannelNo;	/* required element of type xsd:int */
    char Name[33];	/* required element of type xsd:string */
    int OnLine;	/* optional element of type xsd:int */
    int PtzFlag;
    int needUpdate;
    int pushFlag; //推送标志位
    int estoreFlag; //存储设备标志位
    int sharingFlag; //分享标志位
    int WLanIntensity; //wifi信号强度
    char upnpAddress[64]; //存储udp地址
    int upnpPort; //存储port
    BOOL isOnlyUseICE;
    char currentVersion[32];
    char newsetVersion[32];
};

@interface SoapInterface : NSObject{
    int deviceNumber; //摄像机设备的数量
    char mPassWord[32]; 
    char mloginSession[64];
    struct deviceInfo devinfo[MAXIPCAMNUM];
}

@property (nonatomic)char * accountStore;
@property (nonatomic)char * turnServer;
@property (nonatomic)char * stunServer;
@property (nonatomic)int turnPort;
@property (nonatomic)int stunPort;
@property (nonatomic)char * matchingCode;
@property (nonatomic)char * lastMatchDeivceID;
@property (nonatomic)int matchingCodeFlag;
- (int)soapUserLoginUser:(char*) Account Password:(char*) Password;
- (int)SoapLogout;
- (int)soapGetPlayUrl:(struct deviceInfo*) ipcamInfo :(int*) deviceNumberRes;
- (int)soapUpdateDevicTakon:(char*)deviceToken :(int)isPush;
- (int)soapInviteId:(char*)DEVID DialogID:(char*) DialogID localsdp:(char*)sdpstr reomtesdp:(char*)remotesdpstr token:(char*)token isSub:(int)reso;
- (int)soapByeDEVID:(char *)DEVID DialogID:(char *)DialogID;
- (int)getDeviceNumber:(int*)number;
- (void)getDeviceInfo:(struct deviceInfo**)getDevInfo :(int*)number;
- (int)soapGetPlayBackInfoWithDevID:(char*)DEVID lastTime:(NSTimeInterval)lastTime BeforeDay:(int)beforeDay Store:(struct VODsearchRecord*)searchRecord pageNO:(int)pageNO recordCount:(int*)recordCount maxPageCount:(int*)maxPageCount; //有起始时间的录像列表获取
- (int)soapGetPlayBackInfoWithDevID:(char*)DEVID BeforeDay:(int)beforeDay Store:(struct VODsearchRecord*)searchRecord pageNO:(int)pageNO recordCount:(int*)recordCount;
- (int)soapGetCodingParamWithDevId:(char*)DEVID isSub:(int)isSub resBitrate:(int*)resBitrate resReslution:(int*)resReslution;
- (int)soapSetCodingParamWithDevId:(char*)DEVID isSub:(int)isSub Bitrate:(int)Bitrate Reslution:(int)reslution;
- (int)soapQueryDeviceWithId:(char*)DEVID ip:(char *)ip port:(int*)port isOnline:(BOOL *) isOnline;
- (int)soapSetVMDParam:(char*)DEVID isActive:(int)isActive row:(char **)row sensitivity:(int)sensitivity;
- (int)soapGetVMDParam:(char*)DEVID isActive:(BOOL*)isActive;
- (int)soapNotifyNatResult:(int)NATType :(char*)DialogID;
- (int)soapgetVideoParam:(char*)DEVID degree:(int*)degree;
- (int)soapsetVideoParam:(char*)DEVID degree:(int)degree;
- (int)soapPTZsetDirection:(int)direction ID:(char*)DEVID;
- (int)soapGetDeviceVersionDevNumber:(int)devNumber;
- (int)soapUpdateDeviceVersionDevNumber:(int)devNumber;
- (int)soapQueryClientVersion:(char*)version;
- (int)soapGetAuxiliary:(int)Auxiliary devNum:(int)devNum State:(int*)state;
- (int)soapSetAuxiliary:(int)Auxiliary devNum:(int)devNum State:(int)state;
- (int)soapSubscribeApplePushDevNum:(int)devNum flag:(int)flag;
- (int)soapUpdatePasswordWithOldPassword:(char*)oldPassword newPassword:(char*)newPassword;
- (int)soapUpdateAccountWithUserName:(char*)userName mobile:(char*)mobile;
- (int)soapUpdateDevNameWithID:(char*)DevID name:(char*)DevName;
- (int)soapAddDeviceWithID:(char*)DevID key:(char*)DevKey forcible:(int)forcible;
- (int)soapcreatAccountWithAccount:(char*)Account username:(char*)username email:(char*)email MobileTel:(char*)mobileTel password:(char*)password SecurityQuestion:(int)securityQuestion SecurityAnswer:(char*)securityAnswer;
- (int)soapGetDeviceMatchingCode;
- (int)soapGetDeviceMatchingResult;
- (int)soapGetAllWirelessNetwork;
- (int)soapNullifyDeviceWithID:(char*)DevID;
- (int)soapAddDeviceSharerWithDevID:(char*)ID account:(char *)sharerAccount priority:(int)sharingPriority;
- (int)soapNullifyDeviceSharerWithDevID:(char*)ID account:(char *)sharerAccount;
- (int)soapQueryDeviceSharerWithDevID:(char*)ID accountList:(char**)accountList accountNumber:(int*)accountNumber;
+ (SoapInterface *)sharedInstance;
- (int)soapReloginUpdateSession;
- (char*)getLoginSession;
- (id)init;

/**
 获取录像列表
 */


/**
 获取系统通知列表
 */
- (void)soapQueryNoticeshasRead:(BOOL)hasRead
                      PageIndex:(int)pageIndex
                       pageSize:(int)pageSize
                          async:(BOOL)isAsync
                        success:(void (^)(NSArray *resultArray)) success
                        failure:(void (^)(int errorNumber))failure;
/**
 获取图片
 */
- (void)soapGetPictureWithID:(char *)pictureID
                       async:(BOOL)isAsync
                     success:(void (^)(NSArray *resultArray)) success
                     failure:(void (^)(int errorNumber))failure;
@end
