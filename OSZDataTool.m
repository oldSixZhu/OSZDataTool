//
//  OSZDataTool.m
//  JDYL
//
//  Created by Mac on 2017/8/16.
//  Copyright © 2017年 JDXX. All rights reserved.
//

#import "OSZDataTool.h"

@implementation OSZDataTool

+ (instancetype)sharedTool
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    return instance;
}

/*
 objective-c 下面int 和 NSData数据 互相转换的方法
 int i = 1;
 NSData *data = [NSData dataWithBytes: &i length: sizeof(i)];
 int i;
 [data getBytes: &i length: sizeof(i)];
 */

//int转data
-(NSData *)intToData:(int)i
{
    NSData *data = [NSData dataWithBytes: &i length: sizeof(i)];
    return data;
}


//data转int
-(int)dataToInt:(NSData *)data
{
    int i;
    [data getBytes:&i length:sizeof(i)];
    return i;
}
#pragma mark - 字符串与NSData转换

//16进制字符转(不带0x),转NSData
-(NSData *)hexToBytes:(NSString *)str{
    
    NSMutableData * data = [NSMutableData data];
    
    for (int i = 0; i+2 <= str.length; i+=2) {
        
        NSString * subString = [str substringWithRange:NSMakeRange(i, 2)];
        
        NSScanner * scanner = [NSScanner scannerWithString:subString];
        
        uint number;
        
        [scanner scanHexInt:&number];
        
        [data appendBytes:&number length:1];
        
    }
    return data.copy;
}

//普通字符串,转NSData
- (NSData *)stringToBytes:(NSString *)str
{
    return [str dataUsingEncoding:NSASCIIStringEncoding];
    
}

//NSdata 转16进制字符串
- (NSString *)hexadecimalStringWithData:(NSData *)data
{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.  */
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
    {
        return [NSString string];
    }
    NSUInteger dataLength = [data length];
    
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    return [NSString stringWithString:hexString];
}

//NSdata 转16进制字符串
- (NSString*)hexRepresentationWithSpaces_AS:(BOOL)spaces withData:(NSData *)data
{
    
    const unsigned char* bytes = (const unsigned char*)[data bytes];
    
    NSUInteger nbBytes = [data length];
    
    //If spaces is true, insert a space every this many input bytes (twice this many output characters).
    
    static const NSUInteger spaceEveryThisManyBytes = 4UL;
    
    //If spaces is true, insert a line-break instead of a space every this many spaces.
    
    static const NSUInteger lineBreakEveryThisManySpaces = 4UL;
    
    const NSUInteger lineBreakEveryThisManyBytes = spaceEveryThisManyBytes * lineBreakEveryThisManySpaces;
    
    NSUInteger strLen = 2*nbBytes + (spaces ? nbBytes/spaceEveryThisManyBytes : 0);
    
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    
    for(NSUInteger i=0; i<nbBytes;)
    {
        [hex appendFormat:@"%02X", bytes[i]];
        //We need to increment here so that the every-n-bytes computations are right.
        ++i;
        if (spaces) {
            if (i % lineBreakEveryThisManyBytes == 0) [hex appendString:@":"];
            else if (i % spaceEveryThisManyBytes == 0) [hex appendString:@":"];
        }
    }
    return hex;
}


//NSdata 转16进制字符串
- (NSString*)hexRepresentationWithSymbol:(NSString *)symbol withData:(NSData *)data
{
    const unsigned char* bytes = (const unsigned char*)[data bytes];
    NSUInteger nbBytes = [data length];
    NSUInteger strLen = 2*nbBytes;
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    
    for(NSUInteger i=0; i<nbBytes;)
    {
        [hex appendFormat:@"%02X%@", bytes[i], symbol];
        ++i;
    }
    [hex deleteCharactersInRange:NSMakeRange(hex.length - 1, 1)];
    return hex;
}

//将NSData转化为16进制字符串
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

#pragma mark - 字符串与字符串之间转换

//16进制数字字符串转换为10进制数字字符串的。
- (NSString *)hexNumberStringToNumberString:(NSString *)hexNumberString
{
    unsigned int value = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexNumberString];
    [scanner setScanLocation:0];
    [scanner scanHexInt:&value];
    return [NSString stringWithFormat:@"%d",value];
}

//16进制字符串转10进制
- (int)hexNumberStringToNumber:(NSString *)hexNumberString
{
    NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([hexNumberString UTF8String],0,16)];
    //转成数字
    int cycleNumber = [temp10 intValue];
//    NSLog(@"10进制：%d",cycleNumber);
    return cycleNumber;
}



//10进制数字字符串转换为16进制数字字符串的。
- (NSString *)numberStringToHexNumberString:(NSString *)numberString
{
    return [NSString stringWithFormat:@"%x",[numberString intValue]];
}

// 16进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2)
    {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:NSUTF8StringEncoding];
    return unicodeString;
}

//普通字符串转换为16进制的。
- (NSString *)hexStringFromString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


//16进制转换为2进制
- (NSString *)getBinaryByHex:(NSString *)hex {
    
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    for (int i=0; i<[hex length]; i++) {
        
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            
            binary = [binary stringByAppendingString:value];
        }
    }
    return binary;
}

//将16进制字符串转换成NSData
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    //    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

//10进制转换为2进制
- (NSString *)getBinaryByDecimal:(NSInteger)decimal {
    
    NSString *binary = @"";
    while (decimal) {
        
        binary = [[NSString stringWithFormat:@"%ld", decimal % 2] stringByAppendingString:binary];
        if (decimal / 2 < 1) {
            
            break;
        }
        decimal = decimal / 2 ;
    }
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    return binary;
}

//10进制转16进制
- (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}

// 2进制转换成16进制
- (NSString *)getHexByBinary:(NSString *)binary {
    
    NSMutableDictionary *binaryDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [binaryDic setObject:@"0" forKey:@"0000"];
    [binaryDic setObject:@"1" forKey:@"0001"];
    [binaryDic setObject:@"2" forKey:@"0010"];
    [binaryDic setObject:@"3" forKey:@"0011"];
    [binaryDic setObject:@"4" forKey:@"0100"];
    [binaryDic setObject:@"5" forKey:@"0101"];
    [binaryDic setObject:@"6" forKey:@"0110"];
    [binaryDic setObject:@"7" forKey:@"0111"];
    [binaryDic setObject:@"8" forKey:@"1000"];
    [binaryDic setObject:@"9" forKey:@"1001"];
    [binaryDic setObject:@"A" forKey:@"1010"];
    [binaryDic setObject:@"B" forKey:@"1011"];
    [binaryDic setObject:@"C" forKey:@"1100"];
    [binaryDic setObject:@"D" forKey:@"1101"];
    [binaryDic setObject:@"E" forKey:@"1110"];
    [binaryDic setObject:@"F" forKey:@"1111"];
    
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    NSString *hex = @"";
    for (int i=0; i<binary.length; i+=4) {
        
        NSString *key = [binary substringWithRange:NSMakeRange(i, 4)];
        NSString *value = [binaryDic objectForKey:key];
        if (value) {
            
            hex = [hex stringByAppendingString:value];
        }
    }
    return hex;
}

//2进制转换为10进制
- (NSInteger)getDecimalByBinary:(NSString *)binary {
    
    NSInteger decimal = 0;
    for (int i=0; i<binary.length; i++) {
        
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            
            decimal += pow(2, i);
        }
    }
    return decimal;
}


#pragma mark - Dictionary 转 Json String

-(NSString *)jsonFromDictionary:(id)dic
{
    if (dic==nil) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return jsonString;
}

#pragma mark - 大小端转换
//大小端数据转换（short,int,long型有更简便的方法）
-(NSData *)dataTransfromBigOrSmall:(NSData *)data{
    
    NSString *tmpStr = [self dataChangeToString:data];
    NSMutableArray *tmpArra = [NSMutableArray array];
    for (int i = 0 ;i<data.length*2 ;i+=2) {
        NSString *str = [tmpStr substringWithRange:NSMakeRange(i, 2)];
        [tmpArra addObject:str];
    }
    
    NSArray *lastArray = [[tmpArra reverseObjectEnumerator] allObjects];
    
    NSMutableString *lastStr = [NSMutableString string];
    
    for (NSString *str in lastArray) {
        
        [lastStr appendString:str];
        
    }
    
    NSData *lastData = [self HexStringToData:lastStr];
    
    return lastData;
    
}

-(NSString*)dataChangeToString:(NSData*)data{
    
    NSString * string = [NSString stringWithFormat:@"%@",data];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
    
}

//编写一个NSData类型数据
-(NSMutableData*)HexStringToData:(NSString*)str{
    
    NSString *command = str;
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    return commandToSend;
}

/*
 网络传输一般采用大端序，也被称之为网络字节序，或网络序。IP协议中定义大端序为网络字节序。伯克利socket API定义了一组转换函数，用于16和32bit整数在网络序和本机字节序之间的转换。htonl，htons用于本机序转换到网络序；ntohl，ntohs用于网络序转换到本机序。
 
 在几乎所有的机器上，多字节对象都被存储为连续的字节序列。例如在C语言中，一个类型为int的变量x地址为0x100，那么其对应地址表达式&x的值为0x100。且x的四个字节将被存储在存储器的0x100, 0x101, 0x102, 0x103位置。
 
 而存储地址内的排列则有两个通用规则。一个多位的整数将按照其存储地址的最低或最高字节排列。如果最低有效字节在最高有效字节的前面，则称小端序；反之则称大端序。在网络应用中，字节序是一个必须被考虑的因素，因为不同机器类型可能采用不同标准的字节序，所以均按照网络标准转化。
 
 例如假设上述变量x类型为int，位于地址0x100处，它的十六进制为0x01234567，地址范围为0x100~0x103字节，其内部排列顺序依赖于机器的类型。大端法从首位开始将是：0x100: 01, 0x101: 23,..。而小端法将是：0x100: 67, 0x101: 45,..
 
 不管怎样，使用这些函数决定于你要从主机字节顺序(你的电脑上的)还是网络字节顺序转化。如果是"host"，函数的第一个字母为"h"，否则"network"就为"n"。函数的中间字母总是"to",因为你要从一个转化到另一个，倒数第二个字母说明你要转化成什么。最后一个字母是数据的大小，"s"表示short，"l"表示long。于是：
 
 htons()    host to network short
 
 htonl()     host to network long
 
 ntohs()    network to host short
 
 ntohl()    network to host long
 
 NSSwapHostIntToBig() 也可以
 */

#pragma mark - 提取时间 -
// 转换时间
- (NSString *)getTimeToShowWithTimestamp:(double)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *publishString = [formatter stringFromDate:publishDate];
    return publishString;
}

//提取现在时间转换成nsdata
- (NSData *)getNowTime
{
    NSMutableData *timeData = [NSMutableData data];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *DateTime = [formatter stringFromDate:date];
    NSLog(@"%@",DateTime);
    return timeData;
}

//取出字符串中的数字
//取出字符串中数字
- (void)getNumberFromString:(NSString *)urlString
{
    /** -----------------第一种:字符串: urlString---------------*/
    
    NSScanner *scanner = [NSScanner scannerWithString:urlString];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    NSString *num=[NSString stringWithFormat:@"%d",number];
    NSLog(@" num %@ ",num);
    /** ----------------第二种:字符串: urlString----------------*/
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    int remainSecond =[[urlString stringByTrimmingCharactersInSet:nonDigits] intValue];
    NSLog(@" num %d ",remainSecond);
}



@end
