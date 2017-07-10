//
//  FMDatabase+MyDataBase.h
//  项目整理
//
//  Created by shengtian on 2017/7/10.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "FMDatabase.h"

//补充其他SQL语句
#define DBOrderKey @"order"             //排序key
#define DBLengthLimitKey @"lengthLimit" //长度限制Key
#define DBGreaterKey @"greater"         //大于Key
#define DBLesserKey  @"lesser"          //小于Key
#define DBUpdateItemKey @"updateItem"   //指定更新字段

typedef void(^DBExistExcuteOption)(BOOL exist);
typedef void(^DBInsertOption)(BOOL insert);
typedef void(^DBUpdateOption)(BOOL update);
typedef void(^DBDeleteOption)(BOOL del);
typedef void(^DBSaveOption)(BOOL save);
typedef void(^DBExcuteOption)(id output_model);
typedef void(^DBAllModelsOption)(NSMutableArray *models);

@interface FMDatabase (MyDataBase)

/** 保存一个模型 */
- (void )DB_SaveDataWithTable:(NSString *)table Model:(id )model UserInfo:(NSDictionary *)userInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBSaveOption )option;
/** 删除一个模型 */
- (void)DB_DeleteDataWithTable:(NSString *)table Model:(id )model UserInfo:(NSDictionary *)userInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBDeleteOption )option;
/** 查询某个模型数据 */
- (id )DB_ExcuteDataWithTable:(NSString *)table Model:(id )model  UserInfo:(NSDictionary *)userInfo FuzzyUserInfo:(NSDictionary *)fuzzyUserInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBExcuteOption )option;
/** 查询某种所有的模型数据 */
- (void)DB_ExcuteDatasWithTable:(NSString *)table Model:(id )model UserInfo:(NSDictionary *)userInfo FuzzyUserInfo:(NSDictionary *)fuzzyUserInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBAllModelsOption )option;


#pragma mark -- PrimaryKey
/** 保存一个模型 */
- (void )DB_SaveDataWithTable:(NSString *)table Model:(id )model  PrimaryKey:(NSString *)primaryKey UserInfo:(NSDictionary *)userInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBSaveOption )option;
/** 删除一个模型 */
- (void)DB_DeleteDataWithTable:(NSString *)table Model:(id )model  PrimaryKey:(NSString *)primaryKey UserInfo:(NSDictionary *)userInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBDeleteOption )option;
/** 查询某个模型数据 */
- (id )DB_ExcuteDataWithTable:(NSString *)table Model:(id )model  PrimaryKey:(NSString *)primaryKey UserInfo:(NSDictionary *)userInfo FuzzyUserInfo:(NSDictionary *)fuzzyUserInfo OtherSQL:(NSDictionary *)otherSQL Option:(DBExcuteOption )option;
/** 查询某种所有的模型数据 */
- (void)DB_excuteDatasWithTable:(NSString *)table model:(id )model  primaryKey:(NSString *)primaryKey userInfo:(NSDictionary *)userInfo fuzzyUserInfo:(NSDictionary *)fuzzyUserInfo otherSQL:(NSDictionary *)otherSQL option:(DBAllModelsOption )option;

/** 查询表数据条数 */
- (void)numberOfDatasWithTable:(NSString *)table complete:(void(^)(NSInteger count))complete;
#pragma mark -- Method
/** 根据文件名获取文件全路径 */
- (NSString *)fullPathWithFileName:(NSString *)fileName;

@end
