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

- (IBAction)creatDB:(id)sender {
    NSString *path = [NSString stringWithFormat:@"%@/Documents/Test.sqlite", NSHomeDirectory()];
    sqlite = [LPSqlite sqlitePath:path];
}

- (IBAction)openDB:(id)sender {
    [sqlite updateWithSql:nil];
}


@end
