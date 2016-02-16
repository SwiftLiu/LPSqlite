//
//  LPDatabase.m
//  FineExAPP
//
//  Created by FineexMac on 16/2/3.
//  Copyright © 2016年 FineEX-LF. All rights reserved.
//

#import "LPSqlite.h"

@interface LPSqlite ()

@end

@implementation LPSqlite



#pragma mark - 查询
+ (NSArray *)queryDBName:(NSString *)dbName from:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target
{
    return [LPSqlite queryDBName:dbName select:@"*" from:tableName where:columnName equal:target];
}

+ (NSArray *)queryDBName:(NSString *)dbName select:(NSString *)queryObject from:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target
{
    return [LPSqlite queryDBName:dbName select:queryObject from:tableName where:columnName equal:target other:nil];
}

+ (NSArray *)queryDBName:(NSString *)dbName select:(NSString *)queryObject from:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target other:(NSString *)other
{
    if (tableName && tableName.length) {
        NSString *sql = @"";
        NSString *key = queryObject;
        if (!key || !key.length) key = @"*";
        
        if (columnName && columnName.length && target && target.length) {
            sql = [NSString stringWithFormat:@"select %@ from %@ where %@='%@' %@", key, tableName, columnName, target, other?:@""];
        }else{
            sql = [NSString stringWithFormat:@"select %@ from %@ %@", key, tableName, other?:@""];
        }
        return [LPSqlite queryDBName:dbName sql:sql];
    }
    return nil;
}

+ (NSArray *)queryDBName:(NSString *)dbName sql:(NSString *)sql
{
    sqlite3_stmt *statement;
    NSMutableArray *array = [NSMutableArray array];
    sqlite3 *db = [LPSqlite openDBWithName:dbName];
    if (db) {
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                for (int i=0,len=sqlite3_column_count(statement); i<len; i++) {
                    NSString *key = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_name(statement, i)];
                    if (sqlite3_column_text(statement, i)) {
                        NSString *object = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                        [dict setObject:object forKey:key];
                    }else{
                        [dict setObject:@"" forKey:key];
                    }
                }
                [array addObject:dict];
            }
        }
        [self closeDB:db withStmt:statement];
    }
    return array;
}


#pragma mark - 创建
+ (BOOL)createDBWithPath:(NSString *)path
{
    //MARK: NEED DO 待完成<<<<<<< 创建数据库 >>>>>>>
    return YES;
}

#pragma mark - 更新
+ (NSInteger)updateDBName:(NSString *)dbName sql:(NSString *)sql
{
    char *err;
    NSInteger count;
    sqlite3 *db = [LPSqlite openDBWithName:dbName];
    if (db) {
        if ((count=sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)) != SQLITE_OK) {
            [self closeDB:db withStmt:nil];
            NSLog(@"数据库操作数据失败!");
        }
    }
    return count;
}

#pragma mark - 打开
+ (sqlite3 *)openDBWithName:(NSString *)dbName
{
    sqlite3 *db;
    NSString *path=[[NSBundle mainBundle] pathForResource:dbName ofType:nil];
    if (sqlite3_open([path UTF8String], &db) == SQLITE_OK) {
        return db;
    }else{
        [self closeDB:db withStmt:nil];
        NSLog(@"数据库打开失败");
    }
    return nil;
}

#pragma mark - 关闭
+ (void)closeDB:(sqlite3 *)db withStmt:(sqlite3_stmt *)stmt
{
    if (stmt) sqlite3_finalize(stmt);
    sqlite3_close(db);
    db=nil;
}

@end
