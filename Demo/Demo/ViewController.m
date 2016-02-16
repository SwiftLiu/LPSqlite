//
//  ViewController.m
//  Demo
//
//  Created by FineexMac on 16/2/16.
//  Copyright © 2016年 LPiOS. All rights reserved.
//

#import "ViewController.h"
#import "LPSqlite.h"

@interface ViewController ()
{
    LPSqlite *sqlite;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)database:(id)sender {
    //注意：在工程导入类似sqlite的资源文件时，需要create folder references 而不是create groups，否则此方法无法找到路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Test.sqlite" ofType:nil];
    NSLog(@"%@", path);
    
    sqlite = [LPSqlite sqlitePath:path];
    
    [self doDatabase];
}

- (IBAction)localDatabase:(id)sender {
    NSString *path = [NSString stringWithFormat:@"%@/Documents/Test2.sqlite", NSHomeDirectory()];
    NSLog(@"%@", path);
    
    sqlite = [LPSqlite sqlitePath:path];
    
    [self doDatabase];
}

- (void)doDatabase
{
    //插入表
    [sqlite updateWithSql:@"CREATE TABLE IF NOT EXISTS TestTable(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, score FLOAT)"];
    //插入行
    for (int i=0; i<3; i++) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO TestTable (name, age, score) VALUES ('刘刘%d', %d, %d)", arc4random()%100, arc4random()%50+20, arc4random()%100];
        [sqlite updateWithSql:sql];
    }
    //查询数据
    NSArray *result = [sqlite queryFrom:@"TestTable" where:nil equal:nil];
    NSLog(@"%@", result);
    
}


@end
