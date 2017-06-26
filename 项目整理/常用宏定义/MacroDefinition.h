//
//  MacroDefinition.h
//  项目整理
//
//  Created by shengtian on 2017/6/22.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

/**
 debug版本输出查看信息
 */
#ifdef DEBUG
#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define HKLog( s, ... )
#endif

/**
 版本号
 */
#define TheVersionNumber [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 NavBar高度
 */
#define NavigationBar_HEIGHT 64

/**
 tabbar高度
 */
#define Tabbar_HEIGHT 49

/**
 这个View的宽高
 */
#define This_View_Height   self.frame.size.height
#define This_View_Width    self.frame.size.width
/**
 屏幕的宽高和大小
 */
#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenBounds [UIScreen mainScreen].bounds
/**
 沙河路径
 */
#define DocumentsPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
/**
 UserDefault
 */
#define UserDefault [NSUserDefaults standardUserDefaults]
/**
 弱引用
 */
#define WS(weakSelf)     __weak typeof(self) weakSelf = self;
/**
 16进制颜色以及透明度
 */
#define UICOLOR_RGB_Alpha(_color,_alpha) [UIColor colorWithRed:((_color>>16)&0xff)/255.0f green:((_color>>8)&0xff)/255.0f blue:(_color&0xff)/255.0f alpha:_alpha]

/**
 RGB颜色以及透明度
 */
#define RGBCOLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

/**
 定义UIImage对象
 */
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer］

/**
 字符串是否为空
 */
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

/**
 数组是否为空
 */
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

/**
 字典是否为空
 */
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

/**
 是否是空对象
 */
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

/**
 系统版本号
 */
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
#endif /* MacroDefinition_h */
