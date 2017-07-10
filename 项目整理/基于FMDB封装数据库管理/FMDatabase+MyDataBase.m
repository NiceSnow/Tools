//
//  FMDatabase+MyDataBase.m
//  项目整理
//
//  Created by shengtian on 2017/7/10.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "FMDatabase+MyDataBase.h"
#import "NSObject+DataBass.h"
#import <UIKit/UIKit.h>

@implementation FMDatabase (MyDataBase)

#pragma mark -- 无PrimaryKey
- (void )DB_SaveDataWithTable:(NSString *)table Model:(id )model UserInfo:(NSDictionary *)userInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBSaveOption )option{
    [self DB_SaveDataWithTable:table Model:model  PrimaryKey:DB_PrimaryKey UserInfo:userInfo OtherSQL:otherSQL Option:option];
}

- (void)DB_DeleteDataWithTable:(NSString *)table Model:(id )model UserInfo:(NSDictionary *)userInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBDeleteOption )option{
    [self DB_DeleteDataWithTable:table Model:model PrimaryKey:DB_PrimaryKey UserInfo:userInfo OtherSQL:otherSQL Option:option];
}

- (id )DB_ExcuteDataWithTable:(NSString *)table Model:(id )model UserInfo:(NSDictionary *)userInfo  FuzzyUserInfo:(NSDictionary *)fuzzyUserInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBExcuteOption )option{
    return [self DB_ExcuteDataWithTable:table Model:model PrimaryKey:DB_PrimaryKey UserInfo:userInfo FuzzyUserInfo:fuzzyUserInfo OtherSQL:otherSQL Option:option];
}

//查询某种所有的模型数据
- (void)DB_ExcuteDatasWithTable:(NSString *)table Model:(id )model  UserInfo:(NSDictionary *)userInfo FuzzyUserInfo:(NSDictionary *)fuzzyUserInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBAllModelsOption )option{
    [self DB_ExcuteDatasWithTable:table Model:model PrimaryKey:DB_PrimaryKey UserInfo:userInfo FuzzyUserInfo:fuzzyUserInfo OtherSQL:otherSQL Option:option];
}

#pragma mark -- 有PrimaryKey
- (void)DB_ExsitInDatabaseWithTable:(NSString *)table Model:(id )model PrimaryKey:(NSString *)primaryKey UserInfo:(NSDictionary *)userInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBExistExcuteOption )option{
    if (!primaryKey) primaryKey = DB_PrimaryKey;
    
    id primary_keyValue = nil;
    if ([[model class] DB_PrimaryKey]) {
        primary_keyValue = [model valueForKey:[[model class] DB_PrimaryKey]];
        primaryKey = DB_PrimaryKey;
    }else{
        primary_keyValue = [model valueForKey:primaryKey];
    }
    
    NSString *tableName = nil;
    if (!table) {
        tableName = NSStringFromClass([model class]);
    }else{
        tableName = table;
    }
    
    FMResultSet *set = [self executeQuery:[NSString stringWithFormat:@"select * from '%@' where %@ = '%@' ;",tableName,primaryKey,primary_keyValue]];
    if (option) {
        if ([set next]) {
            option(YES);
        } else {
            option(NO);
        }
        [set close];
    }
}

- (void)DB_InsertDataWithTable:(NSString *)table Model:(id )model  PrimaryKey:(NSString *)primaryKey  OtherSQL:(NSDictionary *)otherSQL Option:(DBInsertOption )option {
    NSString *tableName = nil;
    if (!table) {
        tableName = NSStringFromClass([model class]);
    }else{
        tableName = table;
    }
    __block NSString *sql1 = [NSString stringWithFormat:@"insert into %@ (",tableName];
    __block NSString *sql2 = [NSString stringWithFormat:@")  values  ("];
    
    //非保存字段数组
    NSArray *arrProDonotSave = [[model class] DB_PropertyDonotSave];
    
    //获取模型的属性名和属性类型
    [[model class] DB_ObjectIvar_NameAndIvar_TypeWithOption:^(modleAttribute *ivar) {
        
        //跳过非保存字段数组
        for (NSString *proNameDonotSave in arrProDonotSave) {
            if([proNameDonotSave isEqualToString:ivar.name]){
                
                return;
            }
        }
        
        NSString *ivar_name = ivar.name;
        NSInteger ivar_type = ivar.type;
        if (ivar_type == DataBaseJectIvarTypeObject) {
            //先取值出来
            id value = [model valueForKey:ivar_name];
            
            if ([[model class] DB_ReplacedKeyFromDictionaryWhenPropertyIsObject]) {
                NSDictionary *dict = [[model class] DB_ReplacedKeyFromDictionaryWhenPropertyIsObject];
                if ([dict objectForKey:ivar_name]) {
                    // 递归调用
                    if (value) {
                        
                        [self DB_SaveDataWithTable:NSStringFromClass([value class]) Model:value PrimaryKey:DB_PrimaryKey UserInfo:nil OtherSQL:otherSQL Option:nil];
                    }
                    //拼接外键
                    
                    id subValue = [value valueForKey:[[value class] DB_PrimaryKey]];
                    value = subValue;
                    ivar_name = [dict objectForKey:ivar_name];
                    ivar_type = DataBaseObjectIvarTypeOther;
                    
                    if ([value isKindOfClass:[NSString class]]) {
                        sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"'%@',",value]];
                    }else{
                        sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"%ld,",[value longValue]]];
                    }
                    
                }
            }
            if ([[model class] DB_PropertyIsInstanceOfArray] && [[[model class] DB_PropertyIsInstanceOfArray] objectForKey:ivar_name]) {
                NSArray *arr = value;
                NSMutableArray *arrm = [NSMutableArray arrayWithCapacity:arr.count];
                for (id model in arr) {
                    
                    if ([model isKindOfClass:[NSURL class]]) {
                        NSURL *url = model;
                        [arrm addObject:url.absoluteString];
                    }else{
                        [arrm addObject:[model mj_keyValues]];
                    }
                    
                    
                }
                ivar_type = DataBaseObjectIvarTypeArray;
                sql2 = [sql2 stringByAppendingString:@"'"];
                
                
                sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"%@",arrm.mj_JSONString]];
                sql2 = [sql2 stringByAppendingString:@"',"];
            }else if ([[model class] DB_PropertyIsInstanceOfData] && [[[model class] DB_PropertyIsInstanceOfData] objectForKey:ivar_name]) {
                NSData *data = value;
                ivar_type = DataBaseObjectIvarTypeData;
                sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"%@,",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
            }else if ([[model class] DB_PropertyIsInstanceOfImage] && [[[model class] DB_PropertyIsInstanceOfImage] objectForKey:ivar_name]){
                //保存UIImage
                ivar_type = DataBaseObjectIvarTypeImage;
                //                NSString *timeSince1970 = [self stringForTimeSince1970];
                //                UIImage *image = [model valueForKey:ivar_name];
                //                [UIImagePNGRepresentation(image) writeToFile:[self fullPathWithFileName:timeSince1970] atomically:YES];
                //                //这里只需要存储时间戳的字符串，取值时需要拼接
                //                sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"%@,",timeSince1970]];
                //SDWebImage 已经缓存图片,暂时不用存在数据库
                sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@""]];
            }
            if (ivar_type == DataBaseJectIvarTypeObject) {
                sql2 = [sql2 stringByAppendingString:@"'"];
                sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
                sql2 = [sql2 stringByAppendingString:@"',"];
            }
        }
        else if (ivar_type == DataBaseObjectIvarTypeDoubleAndFloat){
            
            NSNumber *doubleNumber = [model valueForKey:ivar_name];
            sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"%@,",doubleNumber]];
            
            
        }else if (ivar_type == DataBaseObjectIvarTypeArray){
            NSArray *arr = [model valueForKey:ivar_name];
            NSMutableArray *arrm = [NSMutableArray arrayWithCapacity:arr.count];
            for (id model in arr) {
                [arrm addObject:[model mj_keyValues]];
            }
            ivar_type = DataBaseObjectIvarTypeArray;
            sql2 = [sql2 stringByAppendingString:@"'"];
            sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"%@",arrm.mj_JSONString]];
            sql2 = [sql2 stringByAppendingString:@"',"];
        }else if (ivar_type == DataBaseObjectIvarTypeData){
            
            NSString *dataStr = @"";
            id data = [model valueForKey:ivar_name];
            
            if ([NSStringFromClass([data class]) isEqualToString:@"NSData"]) {
                dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                
            }
            else if([NSStringFromClass([data class]) isEqualToString:@"__NSCFBoolean"]){
                NSNumber *bdata = (NSNumber *)data;
                float num =  [bdata floatValue];
                dataStr = [NSString stringWithFormat:@"%f",num];
                
            }else{
                float num =  [data floatValue];
                dataStr = [NSString stringWithFormat:@"%f",num];
                
            }
            sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"%@,",dataStr]];
            
        }else{
            
            id value = [model valueForKey:ivar_name];
            NSString *clsName = NSStringFromClass([value class]);
            if ([clsName isEqualToString:@"NSConcreteValue"]) {
                //CGSize 转成 数组   格式[宽,高]
                NSValue *vObj = value;
                CGSize sizeV = [vObj CGSizeValue];
                NSArray *arr = @[@0,@0];
                if (sizeV.width && sizeV.height) {
                    arr = @[@(sizeV.width),@(sizeV.height)];
                }
                sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"'%@' ",arr.mj_JSONString]];
                
            }else{
                sql2 = [sql2 stringByAppendingString:[NSString stringWithFormat:@"%ld,",[value longValue]]];
            }
        }
        
        /** 检测是否是表主键 */
        DB_EqualsPrimaryKey(ivar_name);
        /** 所有情况sql1的拼接都一样 */
        sql1 = [sql1 stringByAppendingString:[NSString stringWithFormat:@"%@,",ivar_name]];
    }];
    sql1 = [sql1 substringToIndex:sql1.length - 1];
    sql2 = [sql2 substringToIndex:sql2.length - 1];
    sql2 = [sql2 stringByAppendingString:@");"];
    sql1 = [sql1 stringByAppendingString:sql2];
    
    if ([self executeUpdate:sql1]) {
        NSLog(@"---insertDataWithModel:YES----");
        if (option) option(YES);
    }else{
        NSLog(@"---insertDataWithModel:NO----");
        if (option) option(NO);
    }
}

- (void)DB_UpdateDataWithTable:(NSString *)table Model:(id) model  PrimaryKey:(NSString *)primaryKey OtherSQL:(NSDictionary *)otherSQL Option:(DBUpdateOption )option{
    
    NSString *tableName = nil;
    if (!table) {
        tableName = NSStringFromClass([model class]);
    }else{
        tableName = table;
    }
    
    NSString *model_primaryKey = [primaryKey copy];
    __block NSString *initSql = [NSString stringWithFormat:@"update '%@' set ",tableName];;
    if ([[model class] DB_PrimaryKey]) {
        model_primaryKey = [[model class] DB_PrimaryKey];
    }else{
        model_primaryKey = DB_PrimaryKey;
    }
    NSString *sql2 = [NSString stringWithFormat:@" where %@ = '%@' ;",primaryKey,[model valueForKey:model_primaryKey]];
    //非保存字段数组
    NSArray *arrProDonotSave = [[model class] DB_PropertyDonotSave];
    //指定更新字段
    NSArray *arrDesignateUpdateItems = otherSQL[DBUpdateItemKey];
    
    [[model class] DB_ObjectIvar_NameAndIvar_TypeWithOption:^(modleAttribute *ivar) {
        [[model class] DB_ReplaceKeyWithIvarModel:ivar Option:^(modleAttribute *ivar) {
            
            //跳过非保存字段
            for (NSString *proNameDonotSave in arrProDonotSave) {
                if([proNameDonotSave isEqualToString:ivar.name]){
                    
                    return;
                }
            }
            
            //更新部分字段
            if (arrDesignateUpdateItems) {
                BOOL canFindUpdateItem = NO;
                for (NSString *needUpdateItem in arrDesignateUpdateItems) {
                    if([needUpdateItem isEqualToString:ivar.name]){
                        canFindUpdateItem = YES;
                        break;
                    }
                }
                
                if (!canFindUpdateItem) {
                    return;
                }
            }
            
            NSString *ivar_name = ivar.name;
            NSInteger ivar_type = ivar.type;
            id value = nil;
            if (ivar_type == DataBaseJectIvarTypeObject) {
                
                if ([ivar_name isEqualToString:DB_PrimaryKey]) {
                    value = [model valueForKey:[[model class] DB_PrimaryKey]];
                }else{
                    value = [model valueForKey:ivar_name];
                }
                
                if (value) {
                    initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@ = ",ivar_name]];
                    initSql = [initSql stringByAppendingString:@"'"];
                    initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
                    initSql = [initSql stringByAppendingString:@"',"];
                    value = nil;
                }
            }else if (ivar_type == DataBaseObjectIvarTypeDoubleAndFloat){
                value = [model valueForKey:ivar_name];
            }else if (ivar_type == DataBaseObjectIvarTypeArray){
                
                NSArray *arrValue = [model valueForKey:ivar_name];
                NSMutableArray *arrm = [NSMutableArray arrayWithCapacity:arrValue.count];
                for (id model in arrValue) {
                    if ([model isKindOfClass:[NSURL class]]) {
                        NSURL *url = model;
                        [arrm addObject:url.absoluteString];
                    }else{
                        
                        [arrm addObject:[model mj_keyValues]];
                        
                    }
                }
                value = arrm.mj_JSONString;
                if (value) {
                    initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@ = ",ivar_name]];
                    initSql = [initSql stringByAppendingString:@"'"];
                    initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
                    initSql = [initSql stringByAppendingString:@"',"];
                    value = nil;
                }
                
            }else if (ivar_type == DataBaseObjectIvarTypeData){
                
                NSString *dataStr = nil;
                id data = [model valueForKey:ivar_name];
                if ([NSStringFromClass([data class]) isEqualToString:@"NSData"]) {
                    dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                }else if([NSStringFromClass([data class]) isEqualToString:@"__NSCFBoolean"]){
                    NSNumber *bdata = (NSNumber *)data;
                    float num =  [bdata floatValue];
                    dataStr = [NSString stringWithFormat:@"%f",num];
                    
                }else{
                    NSNumber *num = [NSNumber numberWithBool:data];
                    dataStr = [num stringValue];
                }
                
                value = dataStr;
            }else if (ivar_type == DataBaseObjectIvarTypeImage){
                UIImage *image = [model valueForKey:ivar_name];
                NSString *timeSince1970 = [self stringForTimeSince1970];
                [UIImagePNGRepresentation(image) writeToFile:[self fullPathWithFileName:timeSince1970] atomically:YES];
                value = timeSince1970;
            }else{
                //判断字符串以---YHDB_AppendingID---结尾
                if ([ivar_name hasSuffix:DB_AppendingID]) {
                    //获取属性的值（是一个模型）
                    NSString *nameForPropertyModel = [ivar_name substringToIndex:ivar_name.length - DB_AppendingID.length];
                    value = [model valueForKey:nameForPropertyModel];
                    if (value) {
                        //递归调用
                        
                        [self DB_SaveDataWithTable:NSStringFromClass([value class]) Model:value PrimaryKey:DB_PrimaryKey UserInfo:nil OtherSQL:otherSQL Option:nil];
                    }
                    
                    if ([primaryKey isEqualToString:DB_PrimaryKey] ) {
                        value = [value valueForKey:[[value class] DB_PrimaryKey]];
                    }else
                        value = [value valueForKey:primaryKey];
                }else {
                    if ([ivar_name isEqualToString:DB_PrimaryKey] ) ivar_name = model_primaryKey;
                    value = [model valueForKey:ivar_name];
                }
            }
            if (value && ![ivar_name isEqualToString:model_primaryKey]) initSql = [initSql stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@' ,",ivar_name,value]];
        }];
    }];
    initSql = [initSql substringToIndex:initSql.length -1];
    initSql = [initSql stringByAppendingString:sql2];
    BOOL  ok = [self executeUpdate:initSql];
    if (option) option(ok);
    
}

- (void )DB_SaveDataWithTable:(NSString *)table Model:(id )model  PrimaryKey:(NSString *)primaryKey UserInfo:(NSDictionary *)userInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBSaveOption )option{
    [self DB_ExsitInDatabaseWithTable:table Model:model PrimaryKey:primaryKey UserInfo:userInfo OtherSQL:otherSQL Option:^(BOOL exist) {
        if (exist) {//update
            [self DB_UpdateDataWithTable:table Model:model PrimaryKey:primaryKey OtherSQL:otherSQL Option:^(BOOL update) {
                if (option) option(update);
            }];
        }else {//插入
            [self DB_InsertDataWithTable:table Model:model PrimaryKey:primaryKey OtherSQL:otherSQL Option:^(BOOL insert) {
                if (option) option(insert);
            }];
        }
    }];
}
- (void)DB_DeleteDataWithTable:(NSString *)table Model:(id )model  PrimaryKey:(NSString *)primaryKey UserInfo:(NSDictionary *)userInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBDeleteOption )option{
    
    model = [self DB_ExcuteDataWithTable:table Model:model UserInfo:userInfo FuzzyUserInfo:nil OtherSQL:nil Option:nil];
    if (model == nil) return;
    
    id value  = nil;//model的主键值
    if ([[model class] DB_PrimaryKey].length > 0) {
        value = [model valueForKey:[[model class] DB_PrimaryKey]];
    }else{
        value = [model valueForKey:primaryKey];
    }
    if (value <= 0) return;
    
    
    /** 获取所有模型属性名和属性类型 */
    [[model class] DB_ObjectIvar_NameAndIvar_TypeWithOption:^(modleAttribute *ivar) {
        
        [[model class] DB_ReplaceKeyWithIvarModel:ivar Option:^(modleAttribute *ivar) {
            
            id valueOfIvarName = nil;
            if ([ivar.name hasSuffix:DB_AppendingID]) {
                NSString *foreignKey = [ivar.name substringToIndex:ivar.name.length - DB_AppendingID.length];
                valueOfIvarName = [model valueForKey:foreignKey];
                id classOfForeignKey = [[model class] DB_GetClassForKeyIsObject][foreignKey];
                if (classOfForeignKey != nil && valueOfIvarName) {
                    //创建实例对象
                    //                    id instanceOfForeignKey = [[classOfForeignKey alloc]init];
                    id instanceOfForeignKey = valueOfIvarName;
                    // instanceOfForeignKey的主键
                    id primaryKeyOf_instanceOfForeignKey = nil;
                    if ([[instanceOfForeignKey class] DB_PrimaryKey]) {
                        primaryKeyOf_instanceOfForeignKey = [[instanceOfForeignKey class] DB_PrimaryKey];
                    }else{
                        primaryKeyOf_instanceOfForeignKey = DB_PrimaryKey;
                    }
                    //设置模型的主键值
                    // [instanceOfForeignKey setValue:valueOfIvarName forKey:primaryKeyOf_instanceOfForeignKey];
                    /** 在数据库查询该模型 */
                    id instanceInDatabase = [self DB_ExcuteDataWithTable:table Model:instanceOfForeignKey PrimaryKey:DB_PrimaryKey UserInfo:userInfo FuzzyUserInfo:nil OtherSQL:otherSQL Option:nil];
                    if (instanceInDatabase) {
                        [self DB_DeleteDataWithTable:table Model:instanceInDatabase PrimaryKey:DB_PrimaryKey UserInfo:userInfo OtherSQL:otherSQL Option:nil];
                    }
                }
            }else{
                
            }
            
        }];
        
    }];
    NSString *sql = [NSString stringWithFormat:@"delete from '%@' where %@ = '%@' ",table,primaryKey,value];
    if (sql) {
        FMResultSet *set = [self executeQuery:sql];
        if ([set next]) {
            if (option) {
                option([set next]);
                [set close];
            }
        }
        if (option) option(model);
        [set close];
    }
    
    
}
#pragma mark -- excuteDataWithModel
- (id )DB_ExcuteDataWithTable:(NSString *)table Model:(id )fmodel  PrimaryKey:(NSString *)primaryKey UserInfo:(NSDictionary *)userInfo FuzzyUserInfo:(NSDictionary *)fuzzyUserInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBExcuteOption )option{
    NSString *modelPrimaryKey = nil;
    
    if ([[fmodel class] DB_PrimaryKey]) {
        modelPrimaryKey = [[fmodel class] DB_PrimaryKey];
    }else{
        modelPrimaryKey = primaryKey;
    }
    
    
    id fvalue = [fmodel valueForKey:modelPrimaryKey];
    id model = [[[fmodel class]alloc ]init];
    [model setValue:fvalue forKey:modelPrimaryKey];
    
    NSString * sql = [[model class ] DB_SqlForExcuteWithTable:table PrimaryKey:primaryKey UserInfo:userInfo FuzzyUserInfo:fuzzyUserInfo OtherSQL:otherSQL Value:[fmodel valueForKey:modelPrimaryKey]];
    
    
    FMResultSet *set= [self executeQuery:sql];
    
    NSArray *arrProDonotSave = [[model class] DB_PropertyDonotSave];
    if (![set next]) {
        model = nil;
    }
    else{
        
        [[model class ] DB_ObjectIvar_NameAndIvar_TypeWithOption:^(modleAttribute *ivar) {
            
            [[model class] DB_ReplaceKeyWithIvarModel:ivar Option:^(modleAttribute *ivar) {
                
                
                for (NSString *proNameDonotSave in arrProDonotSave) {
                    if([proNameDonotSave isEqualToString:ivar.name]){
                        
                        return;
                    }
                }
                
                
                if (ivar.type == DataBaseObjectIvarTypeArray) {
                    NSString *jsonStr = [set stringForColumn:ivar.name];
                    NSArray *jsonArr = [jsonStr mj_JSONObject];
                    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:jsonArr.count];
                    
                    Class destclass = [[[model class] DB_PropertyIsInstanceOfArray] objectForKey:ivar.name];
                    for (NSDictionary *dict in jsonArr) {
                        NSObject *obj = nil;
                        if([dict isKindOfClass:[NSDictionary class]]){
                            obj = [destclass mj_objectWithKeyValues:dict];
                            if(obj){
                                [arrM addObject:obj];
                            }
                        }else{
                            if(dict){
                                [arrM addObject:dict];
                            }
                            
                        }
                        
                        
                        
                    }
                    [model setValue:arrM forKey:ivar.name];
                }else if(ivar.type == DataBaseObjectIvarTypeData){
                    
                    if ([ivar.typeName isEqualToString:@"B"]) {
                        BOOL value = [set boolForColumn:ivar.name];
                        [model setValue:@(value) forKey:ivar.name];
                    }else{
                        NSString *dataStr = [set stringForColumn:ivar.name];
                        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
                        [model setValue:data forKey:ivar.name];
                    }
                    
                    
                    
                }else if(ivar.type == DataBaseObjectIvarTypeImage){
                    NSString *imageName = [set stringForColumn:ivar.name];
                    UIImage *image = [UIImage imageWithContentsOfFile:[self fullPathWithFileName:imageName]];
                    [model setValue:image forKey:ivar.name];
                }else if (ivar.type == DataBaseObjectIvarTypeDoubleAndFloat){
                    [model setValue:@([set doubleForColumn:ivar.name]) forKey:ivar.name];
                }else if (ivar.type == DataBaseJectIvarTypeObject){
                    
                    if ([ivar.name isEqualToString:DB_PrimaryKey]) {
                        NSString *key = [[model class] DB_PrimaryKey];
                        [model setValue:[set stringForColumn:ivar.name] forKey:key];
                    }else if([ivar.typeName isEqualToString:@"@\"UIImage\""]){
                        
                        //跳过图片操作
                        [model setValue:nil forKey:ivar.name];
                    }else if([ivar.typeName isEqualToString:@"@\"NSURL\""]){
                        NSString *urlStr = [set stringForColumn:ivar.name];
                        NSURL *url = [NSURL URLWithString:urlStr];
                        [model setValue:url forKey:ivar.name];
                    }else if ([ivar.typeName isEqualToString:@"@\"NSArray\""]){
                        NSString *strArr = [set stringForColumn:ivar.name];
                        NSUInteger count = [[strArr substringToIndex:1] integerValue];
                        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
                        
                        if (count) {
                            
                            strArr = [strArr stringByReplacingOccurrencesOfString:@"\n\t" withString:@""];
                            strArr = [strArr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                            strArr = [strArr stringByReplacingOccurrencesOfString:@" " withString:@""];
                            NSUInteger start = [strArr rangeOfString:@"("].location + 1;
                            strArr = [strArr substringFromIndex:start];
                            strArr = [strArr stringByReplacingOccurrencesOfString:@",)" withString:@""];
                            NSArray *arrayTemp = [strArr componentsSeparatedByString:@","];
                            for (NSString *aStr in arrayTemp) {
                                if ([aStr hasPrefix:@"http"]) {
                                    
                                    NSURL *url = [NSURL URLWithString:aStr];
                                    [array addObject:url];
                                }else{
                                    [array addObject:aStr];
                                }
                            }
                            
                        }
                        [model setValue:array forKey:ivar.name];
                    }else{
                        
                        NSString *strValue = [set stringForColumn:ivar.name];
                        if ([strValue isEqualToString:@"(null)"]) {
                            strValue = nil;
                        }
                        [model setValue:strValue forKey:ivar.name];
                    }
                    
                    
                }else{
                    if ([ivar.name hasSuffix:DB_AppendingID]) {//模型里面嵌套模型
                        
                        id setValue = [set stringForColumn:ivar.name];
                        NSString *realName = [ivar.name substringToIndex:ivar.name.length - DB_AppendingID.length];
                        if (![setValue isEqualToString:@"0"]) {
                            
                            Class destClass = [[[model class] DB_GetClassForKeyIsObject] objectForKey:realName];
                            id subModel = [[destClass alloc]init];
                            
                            //如果主键有替换
                            [subModel setValue:setValue forKey:[[subModel class] DB_PrimaryKey]];
                            
                            
                            id retModel = [self DB_ExcuteDataWithTable:NSStringFromClass([subModel class]) Model:subModel PrimaryKey:primaryKey UserInfo:nil FuzzyUserInfo:nil OtherSQL:otherSQL Option:nil];
                            [model setValue:retModel forKey:realName];
                            
                        }else{
                            [model setValue:nil forKey:realName];
                        }
                        
                        
                    }else{//基本数据类型：long
                        if ([ivar.name isEqualToString:DB_PrimaryKey] && modelPrimaryKey) {
                            [model setValue:@([set longForColumn:ivar.name]) forKey:modelPrimaryKey];
                        }else{
                            [model setValue:@([set longForColumn:ivar.name]) forKey:ivar.name];
                        }
                    }
                }
            }];
        }];
        
    }
    if (option) option(model);
    [set close];
    return model;
}




#pragma mark -- 查询所有
- (void)DB_ExcuteDatasWithTable:(NSString *)table Model:(id )model  PrimaryKey:(NSString *)primaryKey UserInfo:(NSDictionary *)userInfo FuzzyUserInfo:(NSDictionary *)fuzzyUserInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBAllModelsOption )option{
    NSString *modelPrimaryKey = [[model class] DB_PrimaryKey];
    NSString *tableName = nil;
    if (!table) {
        tableName = NSStringFromClass([model class]);
    }else{
        tableName = table;
    }
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from '%@' ",tableName];
    
    
    if (otherSQL) {
        
        //大于
        NSString *greaterSQL = otherSQL[DBGreaterKey];
        if (greaterSQL) {
            [sql appendString:[NSString stringWithFormat:@"where %@",greaterSQL]];
        }
        //小于
        NSString *lesserSQL = otherSQL[DBLesserKey];
        if (lesserSQL) {
            [sql appendString:[NSString stringWithFormat:@"where %@",lesserSQL]];
        }
        //排序方式
        NSString *orderSQL = otherSQL[DBOrderKey];
        if (orderSQL) {
            [sql appendString:orderSQL];
        }
        //长度限制
        int lengthLimit = [otherSQL[DBLengthLimitKey] intValue];
        if (lengthLimit) {
            [sql appendFormat:@"%@", [NSString stringWithFormat:@" limit %d ",lengthLimit]];
        }
        
        
    }
    
    
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *set = [self executeQuery:sql];
    while ([set next]) {
        id submodel = [[[model class] alloc]init];
        id value = [set stringForColumn:primaryKey];
        if (modelPrimaryKey) {
            [submodel setValue:value forKey:modelPrimaryKey];
        }else{
            [submodel setValue:value forKey:primaryKey];
        }
        submodel = [self DB_ExcuteDataWithTable:table Model:submodel PrimaryKey:primaryKey UserInfo:userInfo FuzzyUserInfo:fuzzyUserInfo OtherSQL:otherSQL Option:nil];
        if(submodel){
            [arr addObject:submodel];
        }
    }
    if (option) option(arr);
    
}

- (void)numberOfDatasWithTable:(NSString *)table complete:(void(^)(NSInteger count))complete{
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select count (*) from '%@' ",table];
    
    FMResultSet *set = [self executeQuery:sql];
    
    // 遍历结果集
    NSInteger totalCount = 0;
    if ([set next]) {
        totalCount = [set intForColumnIndex:0];
    }
    complete(totalCount);
}

#pragma mark - PrivateMethod
/** 根据文件名获取文件全路径 */
- (NSString *)fullPathWithFileName:(NSString *)fileName{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"YHDatabase%@",fileName]];
}

- (NSString *)stringForTimeSince1970{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.5f", a];//转为字符型
    return timeString;
}

@end
