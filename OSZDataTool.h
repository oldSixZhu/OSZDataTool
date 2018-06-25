//
//  OSZDataTool.h
//  JDYL
//
//  Created by Mac on 2017/8/16.
//  Copyright © 2017年 JDXX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSZDataTool : NSObject

+ (instancetype)sharedTool;

#pragma mark - int 与 NSData 转换

//int转NSData
-(NSData *)intToData:(int)i;

//NSData转int
-(int)dataToInt:(NSData *)data;

#pragma mark - 字符串与NSData转换

//16进制字符串转NSData
- (NSData *)hexToBytes:(NSString *)str;

//16进制字符串转NSData
- (NSData *)convertHexStrToData:(NSString *)str;

//普通字符串,转NSData
- (NSData *)stringToBytes:(NSString *)str;

//NSdata 转16进制普通字符串
- (NSString *)hexadecimalStringWithData:(NSData *)data;

- (NSString *)hexRepresentationWithSpaces_AS:(BOOL)spaces withData:(NSData *)data;

- (NSString *)hexRepresentationWithSymbol:(NSString *)symbol withData:(NSData *)data;

//将NSData转化为16进制字符串
- (NSString *)convertDataToHexStr:(NSData *)data;

#pragma mark - 字符串与字符串之间转换

//16进制数字字符串转换为10进制数字字符串
- (NSString *)hexNumberStringToNumberString:(NSString *)hexNumberString;

//16进制字符串转10进制
- (int)hexNumberStringToNumber:(NSString *)hexNumberString;

//10进制数字字符串转换为16进制数字字符串
- (NSString *)numberStringToHexNumberString:(NSString *)numberString;

// 16进制转换为普通字符串
- (NSString *)stringFromHexString:(NSString *)hexString;

//普通字符串转换为16进制
- (NSString *)hexStringFromString:(NSString *)string;

//16进制转换为2进制
- (NSString *)getBinaryByHex:(NSString *)hex;

//10进制转换为2进制
- (NSString *)getBinaryByDecimal:(NSInteger)decimal;

//10进制转16进制
- (NSString *)getHexByDecimal:(NSInteger)decimal;


// 2进制转换成16进制
- (NSString *)getHexByBinary:(NSString *)binary;

//2进制转换为10进制
- (NSInteger)getDecimalByBinary:(NSString *)binary;

#pragma mark - Dictionary 转 Json String
-(NSString *)jsonFromDictionary:(id)dic;

#pragma mark - 大小端转换
//大小端数据转换（其实还有更简便的方法，不过看起来这个方法是最直观的）
-(NSData *)dataTransfromBigOrSmall:(NSData *)data;

#pragma mark - 提取时间 -
// 转换时间
- (NSString *)getTimeToShowWithTimestamp:(double)time;

//提取现在时间转换成nsdata
- (NSData *)getNowTime;

//取出字符串中数字
- (void)getNumberFromString:(NSString *)urlString;

@end
