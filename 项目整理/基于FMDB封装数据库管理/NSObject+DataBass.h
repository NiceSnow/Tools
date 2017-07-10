//
//  NSDictionary+DataBass.h
//  项目整理
//
//  Created by shengtian on 2017/7/7.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface modleAttribute : NSObject

/** 模型属性的名称 */
@property (nonatomic, copy) NSString *name;

/** 模型属性的类型值 */
@property(nonatomic,assign) NSInteger type;

/** 模型属性类型名称 */
@property(nonatomic,copy)   NSString  *typeName;

@end

/** ivar_name:属性名，如果符合主键声明条件会自动替换成主键：DB_PrimaryKey */
#define DB_EqualsPrimaryKey(ivar_name)         if ([[[model class] DB_primaryKey] isEqualToString:ivar_name]) ivar_name = DB_PrimaryKey;

/** 模型属性，建表时字段所加的后缀 */
extern NSString *const DB_AppendingID;
/** 所有表的主键默认设置 */
extern NSString *const DB_PrimaryKey;

typedef enum{
    /** 字符串类型 */
    DataBaseJectIvarTypeObject = 64,
    /** 浮点型 */
    DataBaseObjectIvarTypeDoubleAndFloat = 100,
    /** 数组 */
    DataBaseObjectIvarTypeArray = 65,
    /** 流：data */
    DataBaseObjectIvarTypeData = 66,
    /** 图片：image */
    DataBaseObjectIvarTypeImage = 67,
    /** 其他(在数据库中使用long进行取值) */
    DataBaseObjectIvarTypeOther = -1
}DataBaseObjectIvarType;

typedef void(^DataBaseObjectIvarsOption)(modleAttribute *ivar);

@interface NSObject (DataBass)
/**
 * 实现该方法，则必须实现：DB_ReplacedKeyFromPropertyName
 * 设置主键:能够唯一标示该模型的属性
 *s
 */
+ (NSString *)DB_PrimaryKey;

/**
 *  将属性为数组
 *
 */
+ (NSDictionary *)DB_PropertyIsInstanceOfArray;

/**
 *  将属性为NSDATA
 *
 */
+ (NSDictionary *)DB_PropertyIsInstanceOfData;

/**
 *  将属性为UIImage
 *
 */
+ (NSDictionary *)DB_PropertyIsInstanceOfImage;

/**
 *  只有这个数组中的属性名才允许
 */
+ (NSArray *)DB_AllowedPropertyNames;

/**
 *  这个数组中的属性名将会被忽略：不进行
 */
+ (NSArray *)DB_IgnoredPropertyNames;

/**
 *  将属性名换为其他key
 *
 */
+ (NSDictionary *)DB_ReplacedKeyFromPropertyName;

/**
 *  将属性是一个模型对象:字典再根据属性名获取value作为字段名
 *
 */
+ (NSDictionary*)DB_ReplacedKeyFromDictionaryWhenPropertyIsObject;
/**
 *  key : 模型对象的名字
 *  通过key获取类名
 */
+ (NSDictionary *)DB_GetClassForKeyIsObject;


/** 获取对象的属性名和属性类型 */
+ (void)DB_ObjectIvar_NameAndIvar_TypeWithOption:(DataBaseObjectIvarsOption )option;

+ (void)DB_ReplaceKeyWithIvarModel:(modleAttribute *)model Option:(DataBaseObjectIvarsOption )option ;

/** 不保存到数据库的属性集合 */
+ (NSArray *)DB_PropertyDonotSave;


/** 创表*/
//创表一:自定义表名
+ (NSString *)DB_SqlForCreatTable:(NSString *)table PrimaryKey:(NSString *)primaryKey;
//创表二:表名默认为类名
+ (NSString *)DB_SqlForCreateTableWithPrimaryKey:(NSString *)primaryKey ;

/**创表：除模型的属性之外， 有多余的字段 */
//创表三:
+ (NSString *)DB_SqlForCreateTable:(NSString *)table PrimaryKey:(NSString *)primaryKey  ExtraKeyValues:(NSArray <modleAttribute *> *)extraKeyValues;


//条件查询语句
+ (NSString *)DB_SqlForExcuteWithTable:(NSString *)table PrimaryKey:(NSString *)primaryKey UserInfo:(NSDictionary *)userInfo FuzzyUserInfo:(NSDictionary *)fuzzyUserInfo OtherSQL:(NSDictionary *)otherSQL Value:(id )value;
@end
