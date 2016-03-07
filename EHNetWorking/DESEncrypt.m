//
//  DESEncrypt.m
//  EHNetWorking
//
//  Created by howell on 7/8/15.
//  Copyright (c) 2015 howell. All rights reserved.
//

#import "DESEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation DESEncrypt

Byte const DEVIV[]  = {0x48,0x4F,0x57,0x45,0x4C,0x4C,0x56,0x49};
Byte const DEVKEY[] = {0x48,0x4F,0x57,0x45,0x4C,0x4C,0x4B,0x45};

+ (void)setByte:(unsigned char*)byte toString:(char*)string withLen:(int)len{
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
    }
}

+ (void)encryptWithCString:(char *)orgString resultCString:(char *)resultString{
    //md5加密
    unsigned char MD5result[16];
    memset(MD5result, 0,16);
    int DataLen = strlen(orgString);
    CC_MD5(orgString,strlen(orgString),MD5result);
    //转换字符串
    char byte2String[192 * 2 +1];
    memset(byte2String, 0 , 192 * 2 +1);
    [DESEncrypt setByte:MD5result toString:byte2String withLen:16];
    
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
    
    [DESEncrypt setByte:randomKey toString:byte2String withLen:8];
    strcat(firstSting, byte2String);
    [DESEncrypt setByte:randomIV toString:byte2String withLen:8];
    strcat(firstSting, byte2String);
    [DESEncrypt setByte:buffer toString:byte2String withLen:32];
    strcat(firstSting, byte2String);
    DataLen = 64 + 16 + 16;
    
    memset(buffer, 0, sizeof(char));
    cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES, 0/*第二位不设，默认CBC加密,第一位用于pading不设默认不补位*/, DEVKEY, kCCKeySizeDES, DEVIV, firstSting, DataLen, buffer, 192, &numBytesEncryt);
    
    [DESEncrypt setByte:buffer toString:byte2String withLen:96];
    memcpy(resultString, byte2String, 96*2 +1);
    return;
}


@end
