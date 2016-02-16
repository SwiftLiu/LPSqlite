//
//  LPSqlite.h
//
//  Created by iOS_Liu on 16/2/3.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//
//  下载链接 https://github.com/SwiftLiu/LPSqlite.git
//  作者GitHub主页 https://github.com/SwiftLiu
//  作者邮箱 1062014109@qq.com
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface LPSqlite : NSObject

///便利初始化（该路径没有数据库则创建）
+ (LPSqlite *)sqlitePath:(NSString *)path;

///查询
- (NSArray *)queryWithSql:(NSString *)sql;
///更新（创建表，删除、插入、更改数据等）
- (NSInteger)updateWithSql:(NSString *)sql;


///查询 指定表 指定行 指定字段信息
- (NSArray *)queryFrom:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target;
///查询 指定表 指定行 指定字段信息
- (NSArray *)querySelect:(NSString *)queryObject from:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target;
///查询 指定表 指定行 指定字段信息 附加
- (NSArray *)querySelect:(NSString *)queryObject from:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target other:(NSString *)other;



@end
