//
//  NSString+extension.h
//  项目整理
//
//  Created by shengtian on 2017/6/23.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,timeType) {
    Y_M_D_h_m_s = 1,
    
};

typedef NS_ENUM(NSInteger,widthORheight) {
    width,
    height
};

@interface NSString (extension)

/**
 获得当前时间戳

 @return 当前时间戳
 */
+(NSString*)stringWithCurrentTime;


/**
 时间戳转时间格式

 @param type 格式类型
 @return 时间字符串
 */
-(NSString*)timeToStringWithType:(timeType)type;

/**
 json字符串转换成字典或数组

 @return object
 */
-(id)jsonStringToObject;


/**
 获得文字的高度长度

 @param type 高度或长度
 @param fontFloat 字体大小
 @param length 高度或长度
 @return 高度或长度
 */
-(CGFloat)get:(widthORheight)type withFount:(CGFloat)fontFloat andFixed:(CGFloat)length;


//常用判断

/**
 判断是否为电话号

 @return bool
 */
-(BOOL)isPhoneNumber;

/**
 判断是否为密码6~12位

 @return bool
 */
-(BOOL)isPassWorld;

/**
 判断是否为Email

 @return bool
 */
-(BOOL)isEmail;


/**
 获取ip地址

 @return ip地址
 */
+(instancetype)getIPString;

/**
 md5加密

 @return 加密后的string
 */
-(NSString*)md5;

/**
 Base64加密
 
 @return 加密后的string
 */
-(NSString*)encodeBase64;

/**
 Base64解密
 
 @return 加密后的string
 */
-(NSString*)decodeBase64;

- (NSString *) sha1_base64;

- (NSString *) md5_base64;

/**
 AES加密

 @param key 秘钥
 @return 加密后的string
 */
- (NSString *)encryptWithKey:(NSString *)key;

/**
 AES解密
 
 @param key 秘钥
 @return 解密后的string
 */
- (NSString *)decryptWithKey:(NSString *)key;
@end
