//
//  NSDictionary+DataBass.m
//  项目整理
//
//  Created by shengtian on 2017/7/7.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "NSObject+DataBass.h"
#import <objc/runtime.h>

@implementation modleAttribute

@end

@implementation NSObject (DataBass)

NSString *const DB_AppendingID = @"_id";

NSString *const DB_PrimaryKey = @"id";

NSString *const DB_AutoIncreaseID = @"AutoIncreaseID";


/**
 * 实现该方法，则必须实现：DB_ReplacedKeyFromPropertyName
 * 设置主键:能够唯一标示该模型的属性
 *
 */
+ (NSString *)DB_PrimaryKey{
    return nil;
}

/**
 *  属性为数组
 *
 */

+ (NSDictionary *)DB_PropertyIsInstanceOfArray{
    return nil;
}

/**
 *  属性为NSDATA
 *
 */
+ (NSDictionary *)DB_PropertyIsInstanceOfData{
    return nil;
}

/**
 *  将属性为UIImage
 *
 */
+ (NSDictionary *)DB_PropertyIsInstanceOfImage{
    return nil;
}

/**
 *  只有这个数组中的属性名才允许
 */
+ (NSArray *)DB_AllowedPropertyNames{
    return nil;
}

/**
 *  这个数组中的属性名将会被忽略：不进行
 */
+ (NSArray *)DB_IgnoredPropertyNames{
    return nil;
}

/**
 *  将属性名换为其他key
 *
 */
+ (NSDictionary *)DB_ReplacedKeyFromPropertyName{
    return nil;
}

/**
 *  将属性是一个模型对象:字典再根据属性名获取value作为字段名
 示例：@{@"tea":[NSString stringWithFormat:@"tea%@",YHDB_AppendingID]}；
 *
 */
+ (NSDictionary*)DB_ReplacedKeyFromDictionaryWhenPropertyIsObject{
    return nil;
}

+ (NSDictionary *)DB_GetClassForKeyIsObject{
    return nil;
}

+ (void)DB_ObjectIvar_NameAndIvar_TypeWithOption:(DataBaseObjectIvarsOption )option{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self, &count);
    for (int i =0; i < count; i++) {
        Ivar ivar = ivars[i];
        /** 成员变量名 */
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        const char *type = ivar_getTypeEncoding(ivar);
        NSInteger ivar_type = (NSInteger ) type[0];
        NSString *ivar_name = [key substringFromIndex:1];
        modleAttribute *model = [modleAttribute new];
        model.name = ivar_name;
        model.type = ivar_type;
        model.typeName = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (option) {
            option(model);
        }
    }
    free(ivars);
}

#pragma mark -- SQL
+ (NSString *)DB_SqlForCreatTable:(NSString *)table PrimaryKey:(NSString *)primaryKey{
    return [self DB_SqlForCreateTable:table PrimaryKey:primaryKey ExtraKeyValues:nil];
}

+ (NSString *)DB_SqlForCreateTable:(NSString *)table PrimaryKey:(NSString *)primaryKey  ExtraKeyValues:(NSArray <modleAttribute *> *)extraKeyValues{
    
    __block NSString *initSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",table];
    initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT,",DB_AutoIncreaseID]];
    NSArray *arrProDonotSave = [[self class] DB_PropertyDonotSave];
    
    [self DB_ObjectIvar_NameAndIvar_TypeWithOption:^(modleAttribute *ivar) {
        [self DB_ReplaceKeyWithIvarModel:ivar Option:^(modleAttribute *ivar) {
            
            for (NSString *proNameDonotSave in arrProDonotSave) {
                if([proNameDonotSave isEqualToString:ivar.name]){
                    
                    return;
                }
            }
            
            initSql = [initSql stringByAppendingString:[self DB_SqlWithExtraKeyValue:@[ivar] PrimaryKey:primaryKey]];
        }];
        
    }];
    if (extraKeyValues) {
        initSql = [initSql stringByAppendingString:[self DB_SqlWithExtraKeyValue:extraKeyValues PrimaryKey:primaryKey]];
    }
    initSql = [initSql substringToIndex:initSql.length-1];
    initSql = [initSql stringByAppendingString:@");"];
    return initSql;
    
}


+ (NSString *)DB_SqlForCreateTableWithPrimaryKey:(NSString *)primaryKey {
    return [self DB_SqlForCreateTableWithPrimaryKey:primaryKey ExtraKeyValues:nil];
}

+ (NSString *)DB_SqlForCreateTableWithPrimaryKey:(NSString *)primaryKey  ExtraKeyValues:(NSArray <modleAttribute *> *)extraKeyValues{
    
    __block NSString *initSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",NSStringFromClass([self class])];
    
    [self DB_ObjectIvar_NameAndIvar_TypeWithOption:^(modleAttribute *ivar) {
        [self DB_ReplaceKeyWithIvarModel:ivar Option:^(modleAttribute *ivar) {
            
            initSql = [initSql stringByAppendingString:[self DB_SqlWithExtraKeyValue:@[ivar] PrimaryKey:primaryKey]];
        }];
        
    }];
    if (extraKeyValues) {
        initSql = [initSql stringByAppendingString:[self DB_SqlWithExtraKeyValue:extraKeyValues PrimaryKey:primaryKey]];
    }
    initSql = [initSql substringToIndex:initSql.length-1];
    initSql = [initSql stringByAppendingString:@");"];
    return initSql;
    
}

+ (NSString *)DB_SqlWithExtraKeyValue:(NSArray *)extraKeyValues PrimaryKey:(NSString *)primaryKey{
    NSString *initSql = @"";
    for (modleAttribute *model in extraKeyValues) {
        NSString *ivar_name = model.name;
        NSInteger ivar_type = model.type;
        if (ivar_type == DataBaseObjectIvarTypeDoubleAndFloat) {
            initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@ double DEFAULT NULL,",ivar_name]];
        }else if(ivar_type == DataBaseJectIvarTypeObject){
            initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@ text DEFAULT NULL,",ivar_name]];
        }else if (ivar_type == DataBaseObjectIvarTypeArray){
            initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@ text DEFAULT NULL,",ivar_name]];
        }else if (ivar_type == DataBaseObjectIvarTypeData){
            initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@ text DEFAULT NULL,",ivar_name]];
        }else if (ivar_type == DataBaseObjectIvarTypeImage){
            initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@ text DEFAULT NULL,",ivar_name]];
        }else{
            /** id */
            if ([ivar_name isEqualToString:primaryKey] ) {
                initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@ integer(11) PRIMARY KEY ,",ivar_name]];
            }else
                initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@ long DEFAULT NULL,",ivar_name]];
        }
    }
    return initSql;
}

//查询语句
+ (NSString *)DB_SqlForExcuteWithTable:(NSString *)table PrimaryKey:(NSString *)primaryKey UserInfo:(NSDictionary *)userInfo FuzzyUserInfo:(NSDictionary *)fuzzyUserInfo OtherSQL:(NSDictionary *)otherSQL Value:(id )value{
    
    NSString *tableName = nil;
    if (!table) {
        tableName = NSStringFromClass(self);
    }else{
        tableName = table;
    }
    
    NSString *sql  = @"";
    id priKeyValue = value;
    if (priKeyValue) {
        sql = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@'",tableName,primaryKey,priKeyValue];
    }else{
        sql = [NSString stringWithFormat:@"select * from '%@' where",NSStringFromClass(self)];
    }
    
    //拼接条件查询参数
    for (int i =0 ; i< userInfo.allKeys.count; i++) {
        NSString *key = userInfo.allKeys[i];
        id value =  [userInfo valueForKey:key];
        NSString *sql2 = nil;
        if([value isKindOfClass:[NSString class]]){
            sql2 = [NSString stringWithFormat:@"%@ = '%@'",key,value];
        }else{
            sql2 = [NSString stringWithFormat:@"%@ = %@",key,value];
        }
        
        if (userInfo.allKeys.count == 1) {
            //只有一个key
            if (priKeyValue) {
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and %@ ",sql2]];
            }else{
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@" %@ ",sql2]];
            }
            
        }else{
            if (i == userInfo.allKeys.count-1) {
                sql = [sql stringByAppendingString:sql2];
            }else{
                if(priKeyValue){
                    sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and %@ and ",sql2]];
                }else{
                    sql = [sql stringByAppendingString:[NSString stringWithFormat:@"  %@ and ",sql2]];
                }
            }
        }
        
    }
    
    
    //拼接模糊查询参数
    for (int i =0 ; i< fuzzyUserInfo.allKeys.count; i++) {
        NSString *key = fuzzyUserInfo.allKeys[i];
        id value =  [fuzzyUserInfo valueForKey:key];
        NSString *sql3 = nil;
        if([value isKindOfClass:[NSString class]]){
            sql3 = [NSString stringWithFormat:@"%@ like '%%%@%%'",key,value];
        }else{
            sql3 = [NSString stringWithFormat:@"%@ like %%%@%%",key,value];
        }
        
        if (fuzzyUserInfo.allKeys.count == 1) {
            //只有一个key
            if (priKeyValue || userInfo.allKeys.count) {
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and %@ ",sql3]];
            }else{
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@" %@ ",sql3]];
            }
            
        }else{
            if (i == fuzzyUserInfo.allKeys.count-1) {
                sql = [sql stringByAppendingString:sql3];
            }else{
                if(priKeyValue || userInfo.allKeys.count){
                    sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and %@ and ",sql3]];
                }else{
                    sql = [sql stringByAppendingString:[NSString stringWithFormat:@"  %@ and ",sql3]];
                }
            }
        }
        
    }
    
    
    return sql ;
}



#pragma mark -- replaceKeyValue
/** 通过属性名获取正确的字段名 */
+ (void)DB_ReplaceKeyWithIvarModel:(modleAttribute *)model Option:(DataBaseObjectIvarsOption )option {
    
    NSInteger ivar_type = model.type;
    NSString *ivar_name = model.name;
    NSString *typeName  = model.typeName;
    NSString *newIvarName = [[self DB_ReplacedKeyFromPropertyName] objectForKey:ivar_name];
    ivar_name = (newIvarName ) ? newIvarName : ivar_name;
    
    /** 如果属性名是对象模型名字，取值替换 */
    if ([self DB_ReplacedKeyFromDictionaryWhenPropertyIsObject] && [[self DB_ReplacedKeyFromDictionaryWhenPropertyIsObject] objectForKey:ivar_name]) {
        ivar_name =  [[self DB_ReplacedKeyFromDictionaryWhenPropertyIsObject] objectForKey:ivar_name];
        // 将类型重置为 非对象类型
        ivar_type = DataBaseObjectIvarTypeOther;
    }
    
    if ([self DB_PropertyIsInstanceOfArray]) {
        if ([[self DB_PropertyIsInstanceOfArray] objectForKey:ivar_name]) {
            ivar_type = DataBaseObjectIvarTypeArray;
        }
    }else if ([self DB_PropertyIsInstanceOfImage]) {
        if ([[self DB_PropertyIsInstanceOfImage] objectForKey:ivar_name]) {
            ivar_type = DataBaseObjectIvarTypeImage;
        }
    }else if ([self DB_PropertyIsInstanceOfData] && [[self DB_PropertyIsInstanceOfData] objectForKey:ivar_name]) {
        ivar_type = DataBaseObjectIvarTypeData;
    }
    
    modleAttribute *ivar = [modleAttribute new];
    ivar.name     = ivar_name;
    ivar.type     = ivar_type;
    ivar.typeName = typeName;
    if (option) {
        option(ivar);
    }
}

+ (NSArray *)DB_PropertyDonotSave{
    return nil;
}

@end
