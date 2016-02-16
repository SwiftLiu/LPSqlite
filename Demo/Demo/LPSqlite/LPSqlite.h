//
//  LPDatabase.h
//  FineExAPP
//
//  Created by FineexMac on 16/2/3.
//  Copyright © 2016年 FineEX-LF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface LPSqlite : NSObject



///查询 指定表 指定行 指定字段信息
+ (NSArray *)queryDBName:(NSString *)dbName from:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target;
///查询 指定表 指定行 指定字段信息
+ (NSArray *)queryDBName:(NSString *)dbName select:(NSString *)queryObject from:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target;
///查询 指定表 指定行 指定字段信息 附加
+ (NSArray *)queryDBName:(NSString *)dbName select:(NSString *)queryObject from:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target other:(NSString *)other;

///查询
+ (NSArray *)queryDBName:(NSString *)dbName sql:(NSString *)sql;
///更新
+ (NSInteger)updateDBName:(NSString *)dbName sql:(NSString *)sql;

@end
