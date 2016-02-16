//
//  LPDatabase.m
//  FineExAPP
//
//  Created by FineexMac on 16/2/3.
//  Copyright © 2016年 FineEX-LF. All rights reserved.
//

#import "LPSqlite.h"

@interface LPSqlite ()

@property (strong, nonatomic) NSString *dbPath;

@end

@implementation LPSqlite

#pragma mark - 便利初始化
+ (LPSqlite *)sqlitePath:(NSString *)path
{
    LPSqlite *sqlite = [LPSqlite new];
    if (path && path.length) {
        sqlite.dbPath = path;
        [sqlite openDB];
    }
    return sqlite;
}

#pragma mark 查询
- (NSArray *)queryFrom:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target
{
    return [self querySelect:@"*" from:tableName where:columnName equal:target];
}

- (NSArray *)querySelect:(NSString *)queryObject from:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target
{
    return [self querySelect:queryObject from:tableName where:columnName equal:target other:nil];
}

- (NSArray *)querySelect:(NSString *)queryObject from:(NSString *)tableName where:(NSString *)columnName equal:(NSString *)target other:(NSString *)other
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
        return [self queryWithSql:sql];
    }
    return nil;
}

- (NSArray *)queryWithSql:(NSString *)sql
{
    NSMutableArray *array = [NSMutableArray array];
    if (sql && sql.length) {
        sqlite3 *db = [self openDB];
        if (db) {
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    [array addObject:Column(statement)];
                }
            }
            [self closeDB:db withStmt:statement];
        }
    }
    return array;
}

//解析单行数据
NSDictionary *Column(sqlite3_stmt *stmt) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int i=0,len=sqlite3_column_count(stmt); i<len; i++) {
        //字段名
        NSString *key = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_name(stmt, i)];
        //值
        NSString *object = @"";
        if (sqlite3_column_text(stmt, i)) {
            object = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, i)];
        }
        [dict setObject:object forKey:key];
    }
    return dict;
}


#pragma mark 更新
- (NSInteger)updateWithSql:(NSString *)sql
{
    NSInteger count;
    if (sql && sql.length) {
        sqlite3 *db = [self openDB];
        if (db) {
            if ((sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL)) == SQLITE_OK) {
                NSLog(@"数据库操作成功");
            }else {
                NSLog(@"数据库操作数据失败，请检查sql语句!");
            }
            [self closeDB:db withStmt:nil];
        }
    }
    return count;
}


#pragma mark - 打开或创建
- (sqlite3 *)openDB
{
    sqlite3 *db;
    if (_dbPath && _dbPath.length) {
        if (sqlite3_open([_dbPath UTF8String], &db) == SQLITE_OK) {
            return db;
        }else{
            NSLog(@"打开数据库失败，路径：%@", _dbPath);
            [self closeDB:db withStmt:nil];
        }
    }else{
        NSLog(@"没有数据库路径，无法打开或创建!");
    }
    return nil;
}

#pragma mark 关闭
- (void)closeDB:(sqlite3 *)db withStmt:(sqlite3_stmt *)stmt
{
    if (stmt) sqlite3_finalize(stmt);
    sqlite3_close(db);
    db=nil;
}

@end
