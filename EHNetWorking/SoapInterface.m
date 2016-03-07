//
//  SoapInterface.m
//  GLCameraRipple
//
//  Created by howell howell on 12-9-27.
//  Copyright (c) 2012年 Howell Electronic. All rights reserved.
//

#import "SoapInterface.h"
#import <CommonCrypto/CommonCryptor.h>
#import "base64.h"
#import "CoreTelephony/CTCarrier.h"
#import "CoreTelephony/CTTelephonyNetworkInfo.h"

//#import "NSLogger/NSLogger.h"

#define LPLATFORM [self getAddress]
#define HOSTNAME "www.haoweis.com"


@implementation SoapInterface {
    char _hostAddress[128];
}


@synthesize accountStore = _accountStore;

//用于共享实例，全局共享一个单实例。
static SoapInterface * _sharedInterFace;
+(SoapInterface *)sharedInstance{
    if (!_sharedInterFace) {
        _sharedInterFace = [[SoapInterface alloc]init];
    }
    return  _sharedInterFace;
}


-(id)init
{
    self = [super init];
    if (self) {
        _accountStore = malloc(32);
        _turnServer = malloc(128);
        memset(_turnServer, 0, 128);
        _stunServer = malloc(128);
        memset(_stunServer, 0, 128);
        self.matchingCode = malloc(7);
        memset(self.matchingCode, 0, 7);
        self.lastMatchDeivceID = malloc(21);
        memset(self.lastMatchDeivceID, 0, 21);
        self.matchingCodeFlag = -1;
        deviceNumber = -1;
        
    }
    return self;
}

- (void)dealloc{
    free(_accountStore);
    free(_stunServer);
    free(_turnServer);
    free(self.matchingCode);
    free(self.lastMatchDeivceID);
}


#pragma mark - soap 交互函数
//soap 的返回值如果是指针的方式，那么他指向的内地数据 在soap_end 与  soap_done后被清除，如果要另外做保存。
-(int)soapUserLoginUser:(char*) Account Password:(char*) Password
{
    struct ns1__userLoginReq ns1__userLoginReq;
    struct ns1__userLoginRes ns1__userLoginRes;
    struct soap soap;
    soap_init(&soap);
    soap_set_mode(&soap, SOAP_C_UTFSTRING);
    //NSLog(@"soap rev timeout %d, send timeout %d",soap.recv_timeout,soap.send_timeout);
    soap.send_timeout = 6;
    soap.recv_timeout = 6;
    soap.connect_timeout = 6;
    int ret;
    //soap_init2(&soap, SOAP_IO_KEEPALIVE, SOAP_IO_KEEPALIVE);
    
    memset(&ns1__userLoginReq,0,sizeof(ns1__userLoginReq));
    //user login
    //加密手机密码
    ns1__userLoginReq.Account = Account;
    
    //encrypt password
    char encryptedPassWord[193];
    memset(encryptedPassWord, 0, 193);
    if (Password == NULL || Account == NULL) {
        return -1;
    }
    [self encryptUseDes:Password :encryptedPassWord];
    ns1__userLoginReq.Password = encryptedPassWord;
    
    ns1__userLoginReq.PwdType = 0;
    ns1__userLoginReq.Version = [NSLocalizedString(@"version", nil) UTF8String];
    //要将any置空 否则soap_serialize___ns1__userLogin 里会根据any有数据循环操作。
    ns1__userLoginReq.__any = NULL;
    
    //提交手机网络信息：
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    if([carrier.carrierName isEqualToString:@"中国联通"]){
        ns1__userLoginReq.NetworkOperator = ns1__NetworkOperator__China_x0020Unicom;
    } else if( [carrier.carrierName isEqualToString:@"中国移动"]){
        ns1__userLoginReq.NetworkOperator = ns1__NetworkOperator__China_x0020Mobile;
    } else if( [carrier.carrierName isEqualToString:@"中国电信"]){
        ns1__userLoginReq.NetworkOperator = ns1__NetworkOperator__China_x0020Telecom;
    } else {
        ns1__userLoginReq.NetworkOperator = ns1__NetworkOperator__Other;
    }
    
    //手机设备信息。
    struct ns1__MCUDev dev;
    memset(&dev,0,sizeof(dev));
    ns1__userLoginReq.MCUDev = &dev;
    ns1__userLoginReq.MCUDev->OSType = ns1__MCUOSType__IOS;
    ns1__userLoginReq.MCUDev->OSVersion = [[[UIDevice currentDevice] systemVersion]cStringUsingEncoding:NSASCIIStringEncoding];
    ns1__userLoginReq.MCUDev->Model = [[[UIDevice currentDevice]model]cStringUsingEncoding:NSASCIIStringEncoding];
    ns1__userLoginReq.MCUDev->Manufactory = "Apple";
    if ([[[UIDevice currentDevice]model] isEqualToString:@"iPad"]) {
        ns1__userLoginReq.MCUDev->Type = ns1__MCUDevType__Tablet;
    } else {
        ns1__userLoginReq.MCUDev->Type = ns1__MCUDevType__CellPhone;
    }
    
    char *soap_endpoint = LPLATFORM;
    char *soap_action = NULL;
    int status = soap_call___ns1__userLogin(&soap, soap_endpoint, soap_action, &ns1__userLoginReq, &ns1__userLoginRes);
    
    if ( status == SOAP_OK){
        if(ns1__userLoginRes.result ==0){
            memcpy(mloginSession,ns1__userLoginRes.LoginSession,64);
            if(ns1__userLoginRes.NodeList){
                deviceNumber = ns1__userLoginRes.NodeList->__sizeDev;
                if (deviceNumber > 0) {
                    for(int i=0;i<deviceNumber;i++){
                        memset(&(devinfo[i].desertCallID), 0, 33);
                        memset(&(devinfo[i].Name), 0, 33);
                        memcpy(&(devinfo[i].desertCallID),(ns1__userLoginRes.NodeList->Dev + i)->DevID,32);
                        memcpy(&(devinfo[i].Name),(ns1__userLoginRes.NodeList->Dev + i)->Name,strlen((ns1__userLoginRes.NodeList->Dev + i)->Name));
                        
                        
                        devinfo[i].ChannelNo = (ns1__userLoginRes.NodeList->Dev + i)->ChannelNo;
                        devinfo[i].OnLine = (ns1__userLoginRes.NodeList->Dev + i)->OnLine;
                        devinfo[i].PtzFlag = (ns1__userLoginRes.NodeList->Dev + i)->PtzFlag;
                        devinfo[i].estoreFlag = 1; //默认有sd卡
                        devinfo[i].sharingFlag = 0;
                    }
                }
                
            } else {
                deviceNumber = 0;
            }
            memcpy(self.accountStore,Account,32);
            memset(mPassWord, 0, 32);
            memcpy(mPassWord, Password, strlen(Password));
            NSLog(@"soapUserLoginUser deviceNumber =  %d %d",deviceNumber,&deviceNumber);
        }
        //成功登陆后，将login数据存储在本地
        ret =  ns1__userLoginRes.result;
    }else{
        // Caveat: Better to extract the error message and show it using an alert
        NSLog(@"soapUserLoginUser ERROR!!!");
//        soap_print_fault(&soap,stderr); // Print soap error in console
        ret = NOCONNECT;
    }
    
    soap_end(&soap); // clean up allocated temporaries
    soap_done(&soap); // Free soap context
    return ret;
    
}



#pragma mark - 获取报警与报警图片
/**
 获取设备信息
 */
- (void)soapQueryNoticeshasRead:(BOOL)hasRead
                      PageIndex:(int)pageIndex
                       pageSize:(int)pageSize
                          async:(BOOL)isAsync
                        success:(void (^)(NSArray *resultArray)) success
                        failure:(void (^)(int errorNumber))failure
{
    __block struct soap soap;
    soap_init(&soap);
    soap_set_mode(&soap, SOAP_C_UTFSTRING);
    soap.send_timeout = 10;
    soap.recv_timeout = 10;
    soap.connect_timeout = 10;
    char *soap_endpoint = LPLATFORM;
    char *soap_action = NULL;
    
    struct _ns1__queryNoticesReq  soapReq;
    __block struct _ns1__queryNoticesRes soapRes;
    memset(&soapReq, 0, sizeof(struct _ns1__queryNoticesReq));
    memset(&soapRes, 0, sizeof(struct _ns1__queryNoticesRes));
    soapReq.__any = NULL;
    soapReq.Account = self.accountStore;
    soapReq.LoginSession = mloginSession;
    soapReq.PageNo = &pageIndex;
    soapReq.PageSize = &pageSize;
    soapReq.Status = &hasRead;
    
    dispatch_queue_t queue;
    if (isAsync) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    } else {
        queue = dispatch_get_main_queue();
    }
    
    dispatch_async(queue, ^(){
        int status = soap_call___ns1__queryNotices(&soap, soap_endpoint, soap_action, &soapReq, &soapRes);
        if (status == SOAP_OK) {
            /*请求成功*/
            if (soapRes.result == ns1__MCUResult__OK) {
                //请求返回值成功填充返回array
                NSMutableArray * array = [NSMutableArray array];
                for (int i = 0; i < MIN(soapRes.RecordCount - pageIndex * pageSize, pageSize); i++) {
                    
                    NSMutableArray * pictureArray = [NSMutableArray array];
                    if (soapRes.Notice->Notice[i].PictureID && soapRes.Notice->Notice[i].PictureID->string ) {
                        for (int j = 0; j < soapRes.Notice->Notice[i].PictureID->__sizestring; j++) {
                            [pictureArray addObject:[NSString stringWithUTF8String:*(soapRes.Notice->Notice[i].PictureID->string + j)]];
                        }
                    }
                    
                    [array addObject: @{@"ID":[NSString stringWithUTF8String:soapRes.Notice->Notice[i].ID],
                                        @"Message":[NSString stringWithUTF8String:soapRes.Notice->Notice[i].Message],
                                        @"Time":[NSNumber numberWithLong:soapRes.Notice->Notice[i].Time],
                                        @"DevID":[NSString stringWithUTF8String:soapRes.Notice->Notice[i].DevID],
                                        @"ChannelNo":[NSNumber numberWithInt:soapRes.Notice->Notice[i].ChannelNo],
                                        @"Name":[NSString stringWithUTF8String:soapRes.Notice->Notice[i].Name],
                                        @"PictureArray":pictureArray} ];
                }
                
                
                //主线程执行成功block
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(array);
                });
            } else {
                //请求返回数据error
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(soapRes.result);
                });
            }
        } else {
            /*请求失败*/
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(status);
            });
        }
        soap_end(&soap);
        soap_done(&soap);
    });
    
    return;
}


- (void)soapGetPictureWithID:(char *)pictureID
                       async:(BOOL)isAsync
                     success:(void (^)(NSArray *resultArray)) success
                     failure:(void (^)(int errorNumber))failure
{
    __block struct soap soap;
    soap_init(&soap);
    soap_set_mode(&soap, SOAP_C_UTFSTRING);
    soap.send_timeout = 10;
    soap.recv_timeout = 10;
    soap.connect_timeout = 10;
    char *soap_endpoint = LPLATFORM;
    char *soap_action = NULL;
    
    struct _ns1__getPictureReq  soapReq;
    __block struct _ns1__getPictureRes soapRes;
    memset(&soapReq, 0, sizeof(struct _ns1__getPictureReq));
    memset(&soapRes, 0, sizeof(struct _ns1__getPictureRes));
    soapReq.__any = NULL;
    soapReq.Account = self.accountStore;
    soapReq.LoginSession = mloginSession;
    soapReq.PictureID = pictureID;

    
    dispatch_queue_t queue;
    if (isAsync) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    } else {
        queue = dispatch_get_main_queue();
    }
    
    dispatch_async(queue, ^(){
        int status = soap_call___ns1__getPicture(&soap, soap_endpoint, soap_action, &soapReq, &soapRes);
        if (status == SOAP_OK) {
            /*请求成功*/
            if (soapRes.result == ns1__MCUResult__OK) {
                //请求返回值成功填充返回array
                NSMutableArray * array = [NSMutableArray array];
                NSString * encodedImageStr = [NSString stringWithFormat:@"%s",soapRes.Picture];
                NSData * decodedImageData = [[NSData alloc] initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                [array addObject:decodedImageData];
                //主线程执行成功block
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(array);
                });
            } else {
                //请求返回数据error
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(soapRes.result);
                });
            }
        } else {
            /*请求失败*/
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(status);
            });
        }
        soap_end(&soap);
        soap_done(&soap);
    });
    
    return;
}

#pragma mark DNS
- (char*)getAddress{
    static BOOL hasDNS = NO;
    if (!hasDNS) {
        //获取ip
        struct hostent *phot;
        phot = gethostbyname(HOSTNAME);
        if (!phot) {
            //保护断网情况下程序闪退
            return HOSTNAME;
        }
        struct in_addr ip_addr;
        memcpy(&ip_addr, phot->h_addr_list[0], 4);
        char ip[20] = {0};
        inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
        //合并地址
        memset(_hostAddress, 0, 128);
        sprintf(_hostAddress,"http://%s:8800/HomeService/HomeMCUService.svc", ip);
        
        hasDNS = YES;
    }
    return _hostAddress;
}


#pragma mark 获取数据
-(int)getDeviceNumber:(int*)number{
    //    NSLog(@"getDeviceNumber deivceNumber = %d address %d",deviceNumber ,&deviceNumber);
    //    return deviceNumber;
    *number = deviceNumber;
    return deviceNumber;
}

-(void)getDeviceInfo:(struct deviceInfo**)getDevInfo :(int*)number{
    if (deviceNumber != -1) {
        *getDevInfo = devinfo;
        if (number != NULL){
            *number = deviceNumber;
        }
    }else {
        NSLog(@"deviceNumber = %d",deviceNumber);
    }
}

-(char*)getLoginSession{
    return mloginSession;
}

#pragma mark 加密算法 两次des
-(void)setByte:(unsigned char*)byte toString:(char*)string withLen:(int)len{
    memset(string, 0, 2 * len + 1);
    for (int i = 0; i<len; i++) {
        if ((byte[i] & 0xf0) >= 0xa0 ) {
            string[2 * i] = (byte[i] >> 4) + 96 -9;
        } else {
            string[2 * i] = (byte[i] >> 4) + 48;
        }
        
        if ((byte[i] & 0x0f) >= 0x0a ){
            string[2 * i + 1] = (byte[i] & 0xf) + 96 -9;
        } else {
            string[2 * i + 1] = (byte[i] & 0xf) + 48;
        }
        //        NSLog(@"%d %c",string[2 * i],string[2 * i]);
        //        NSLog(@"%d %c",string[2 * i + 1],string[2 * i + 1]);
    }
}

-(void)encryptUseDes:(char *)password :(char *)result{
    Byte DEVIV []= {0x48,0x4F,0x57,0x45,0x4C,0x4C,0x56,0x49};
    Byte DEVKEY []= {0x48,0x4F,0x57,0x45,0x4C,0x4C,0x4B,0x45};
    //md5加密
    unsigned char MD5result[16];
    memset(MD5result, 0,16);
    int DataLen = strlen(password);
    CC_MD5(password,strlen(password),MD5result);
    //转换字符串
    char byte2String[192 * 2 +1];
    memset(byte2String, 0 , 192 * 2 +1);
    [self setByte:MD5result toString:byte2String withLen:16];
    
    //生成随机des key和向量 一次des加密
    unsigned char randomIV[8],randomKey[8];
    for (int i = 0; i < 7; i++) {
        randomIV[i] = arc4random()%(0xff + 1);
        randomKey[i] = arc4random()%(0xff + 1);
    }
    DataLen = strlen(byte2String);
    unsigned char buffer[192];
    memset(buffer, 0, 192);
    size_t numBytesEncryt = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES, 0/*第二位不设，默认CBC加密*/, randomKey, kCCKeySizeDES, randomIV, byte2String, 32, buffer, 64, &numBytesEncryt);
    
    //合并字符串，第二次用约定key和向量加密
    char firstSting[193];
    memset(firstSting, 0, 193);
    
    [self setByte:randomKey toString:byte2String withLen:8];
    strcat(firstSting, byte2String);
    [self setByte:randomIV toString:byte2String withLen:8];
    strcat(firstSting, byte2String);
    [self setByte:buffer toString:byte2String withLen:32];
    strcat(firstSting, byte2String);
    DataLen = 64 + 16 + 16;
    
    memset(buffer, 0, sizeof(char));
    cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES, 0/*第二位不设，默认CBC加密,第一位用于pading不设默认不补位*/, DEVKEY, kCCKeySizeDES, DEVIV, firstSting, DataLen, buffer, 192, &numBytesEncryt);
    
    [self setByte:buffer toString:byte2String withLen:96];
    memcpy(result, byte2String, 96*2 +1);
    return;
    
}

@end
