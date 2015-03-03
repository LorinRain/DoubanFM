//
//  DoubanFMData.m
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import "DoubanFMData.h"

@implementation DoubanFMData

//-----------------创建表---------------
-(void) createUserTable
{
    sqlite3 *sqlite = nil;
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    
    // 打开数据库
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"创建表里的打开数据库失败");
        return;
    }
    
    // 创建表
    NSString *sql = @"CREATE TABLE IF NOT EXISTS LoginData(id INTEGER primary key, userId TEXT, userToken TEXT, userExpire TEXT, userName TEXT, userEmail TEXT)";
    
    // 执行SQL语句
    char *error;
    result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &error);
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"执行创建表的SQL语句失败");
        return;
    }
    
    // 关闭数据库
    sqlite3_close(sqlite);
    
    NSLog(@"创建表成功");
    
}

//-----------------插入数据(登录)---------------
-(void) insertUser: (NSString *) uId andToken: (NSString *) uToken andExpire: (NSString *) uExpire andName: (NSString *) uName andEmail: (NSString *) uEmail
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    // 打开数据库
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"插入数据里的打开数据库失败");
        return;
    }
    
    // SQL语句
    NSString *sql = @"INSERT INTO LoginData(userId, userToken, userExpire, userName, userEmail) VALUES(?, ?, ?, ?, ?)";
    
    // 编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    // 填充占位符
    sqlite3_bind_text(stmt, 1, [uId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [uToken UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [uExpire UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [uName UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 5, [uEmail UTF8String], -1, NULL);
    
    // 执行SQL语句
    result = sqlite3_step(stmt);
    if(result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        sqlite3_close(sqlite);
        NSLog(@"插入数据里的执行SQL语句失败");
        return;
    }
    
    // 关闭数据库
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    NSLog(@"插入数据成功");
    
}

//-----------------更新数据(更换用户)---------------
-(void) updateUser: (NSString *) uId andToken: (NSString *) uToken andExpire: (NSString *) uExpire andName: (NSString *) uName andEmail: (NSString *) uEmail
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    // 打开数据库
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"更新数据里的打开数据库失败");
        return;
    }
    
    // SQL语句
    NSString *sql = @"UPDATE LoginData set userId = ?, userToken = ?, userExpire = ?, userName = ?, userEmail = ? where id = 1";
    
    // 编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    // 填充占位符
    sqlite3_bind_text(stmt, 1, [uId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [uToken UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [uExpire UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [uName UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 5, [uEmail UTF8String], -1, NULL);
    
    // 执行SQL语句
    result = sqlite3_step(stmt);
    if(result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        sqlite3_close(sqlite);
        NSLog(@"更新数据里的执行SQL语句失败");
        return;
    }
    
    // 关闭数据库
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    NSLog(@"更新数据成功");
    
}

//-----------------查询是否登录---------------
-(BOOL) isLogin
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    // 打开数据库
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"查询里的打开数据库失败");
        return NO;
    }
    
    // SQL语句
    NSString *sql = @"SELECT userId FROM LoginData WHERE id = 1";
    
    // 编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    // 执行SQL语句
    result = sqlite3_step(stmt);
    
    if(result != SQLITE_ROW) {
        sqlite3_close(sqlite);
        NSLog(@"没有登录");
        return NO;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    NSLog(@"查询成功，已经登录");
    return YES;
}

//-----------------------取出登录信息--------------------------
-(NSString *) defaultUserInfo: (NSString *) infoNeeded
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    // 打开数据库
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"取出登录信息里的打开数据库失败");
        return nil;
    }
    
    // SQL语句
    
    NSString *sql = [NSString stringWithFormat: @"SELECT %@ FROM LoginData WHERE id = 1",infoNeeded];
    
    // 编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    // 执行SQL语句
    result = sqlite3_step(stmt);
    if(result != SQLITE_ROW) {
        sqlite3_close(sqlite);
        NSLog(@"取出登录信息里的执行SQL语句失败");
        return nil;
    }
    
    // 查询字段上的数据
    char *user = (char *) sqlite3_column_text(stmt, 0);  // 第二个参数是select字段索引，从0开始
    NSString *userRe = [[NSString alloc] initWithUTF8String: user];
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    return userRe;
    
}

//-----------------------退出登录-----------------
-(void) dropUser
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    // 打开数据库
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"取出登录信息里的打开数据库失败");
        return;
    }
    
    // SQL语句
    NSString *sql = @"DELETE FROM LoginData WHERE id = 1";
    
    // 编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    // 执行SQL语句
    result = sqlite3_step(stmt);
    if(result != SQLITE_DONE) {
        sqlite3_close(sqlite);
        NSLog(@"删除用户失败");
        return;
    }
    
    // 关闭数据库
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    NSLog(@"删除用户成功");
    
}




/*
 *
 *  频道表
 *
 */

//-----------------创建表---------------
-(void) createChannelTable
{
    sqlite3 *sqlite = nil;
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    
    // 打开数据库
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"创建频道表里的打开数据库失败");
        return;
    }
    
    // 创建表
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS ChannelData(id INTEGER primary key, channelId TEXT, channelName TEXT)";
    
    // 执行SQL语句
    char *error;
    result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &error);
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"执行创建频道表的SQL语句失败");
        return;
    }
    
    // 关闭数据库
    sqlite3_close(sqlite);
    
    NSLog(@"创建频道表成功");
    
}

//-----------------------选择默认频道（上一次退出频道，下次启动时继续收听）--------------------------
-(void) addChannel: (NSString *) channel
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    // 打开数据库
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"选择默认频道里的打开数据库失败");
        return;
    }
    
    // SQL语句
    NSString *sql = @"INSERT INTO ChannelData(channelId) VALUES(?)";
    
    // 编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    // 填充占位符
    sqlite3_bind_text(stmt, 1, [channel UTF8String], -1, NULL);
    
    // 执行SQL语句
    result = sqlite3_step(stmt);
    if(result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        sqlite3_close(sqlite);
        NSLog(@"选择默认频道里的执行SQL语句失败");
        return;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    NSLog(@"选择默认频道里的插入数据成功");
    
}

//-----------------------更新数据（切换默认频道）--------------------------
-(void) changeChannel: (NSString *) channel
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    // 打开数据库
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"更新频道里的打开数据库失败");
        return;
    }
    
    // SQL语句
    NSString *sql = @"UPDATE ChannelData set channelId = ? where id = 1";
    
    // 编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    // 填充占位符
    sqlite3_bind_text(stmt, 1, [channel UTF8String], -1, NULL);
    
    // 执行SQL语句
    result = sqlite3_step(stmt);
    if(result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        sqlite3_close(sqlite);
        NSLog(@"更新频道里的执行SQL语句失败");
        return;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    NSLog(@"更新频道里的更新成功");
    
}

//-----------------------查询是否有默认频道--------------------------
-(BOOL) isDefaultChannel
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    // 打开数据库
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    // SQL语句
    NSString *sql = @"SELECT channelId FROM ChannelData WHERE id = 1";
    
    // 编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    // 执行SQL语句
    result = sqlite3_step(stmt);
    
    if(result != SQLITE_ROW) {
        sqlite3_close(sqlite);
        NSLog(@"没有默认频道");
        return NO;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    NSLog(@"查询成功，有默认频道");
    return YES;
    
}

//-----------------------取出默认频道--------------------------
-(NSString *) defaultChannel
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    // 打开数据库
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if(result != SQLITE_OK) {
        sqlite3_close(sqlite);
        NSLog(@"打开数据库失败");
        return nil;
    }
    
    // SQL语句
    NSString *sql = @"SELECT channelId FROM ChannelData WHERE id = 1";
    
    // 编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    // 执行SQL语句
    result = sqlite3_step(stmt);
    if(result != SQLITE_ROW) {
        sqlite3_close(sqlite);
        NSLog(@"执行SQL语句失败");
        return nil;
    }
    
    // 查询字段上的数据
    char *channel = (char *) sqlite3_column_text(stmt, 0);  // 第二个参数是select字段索引，从0开始
    NSString *channelRe = [[NSString alloc] initWithUTF8String: channel];
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    return channelRe;
    
}



@end
