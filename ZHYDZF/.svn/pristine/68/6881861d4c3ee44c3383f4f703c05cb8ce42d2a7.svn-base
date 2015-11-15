//
//  LocationHelper.m
//  BoandaProject
//
//  Created by 曾静 on 13-7-30.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LocationHelper.h"

@implementation LocationHelper

- (void)addLocation:(LocationItem *)item
{
    if(isDbOpening == NO)
    {
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO T_EMOP_WZXX(UUID,USERID,LCTIME,LCTYPE,LCX,LCY,IMEI) VALUES('%@','%@','%@','%@','%@','%@','%@')", item.uuid, item.userId, item.lctime, item.lctype, item.lon, item.lat, item.imei];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}

- (NSArray *)queryUserLocation:(NSString *)uid
{
    if(isDbOpening == NO)
    {
        [self openDataBase];
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM T_EMOP_WZXX WHERE USERID = '%@'", uid];
    
    __block NSMutableArray *list = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [list addObject:[rs resultDictionary]];
        }
    }];
    return list;
}

- (NSArray *)queryUserLocation:(NSString *)uid
                      fromTime:(NSString *)fromTime
                       endTime:(NSString *)endTime
                         count:(int)count
{
    if(isDbOpening == NO)
    {
        [self openDataBase];
    }
    
    //拼接SQL语句
    NSMutableString *sql = [[NSMutableString alloc] initWithString:@" SELECT * FROM T_EMOP_WZXX WHERE 1=1 "];
    if(uid != nil && uid.length > 0)
    {
        [sql appendFormat:@" AND USERID = '%@' ", uid];
    }
    //开始时间
    if(fromTime != nil && fromTime.length > 0)
    {
        [sql appendFormat:@" AND LCTIME >= '%@' ", fromTime];
    }
    //结束时间
    if(endTime != nil && endTime.length > 0)
    {
        [sql appendFormat:@" AND LCTIME <= '%@' ", endTime];
    }
    //数据条数
    if(count > 0)
    {
        [sql appendFormat:@" LIMIT %d ", count];
    }
    
    NSLog(@"%@", sql);
    //执行SQL语句
    __block NSMutableArray *list = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [list addObject:[rs resultDictionary]];
        }
    }];
    return list;
}

- (NSArray *)queryUserLocation:(NSString *)uid
                      fromTime:(NSString *)fromTime
                       endTime:(NSString *)endTime
{
    if(isDbOpening == NO)
    {
        [self openDataBase];
    }
    //拼接SQL语句
    NSMutableString *sql = [[NSMutableString alloc] initWithString:@" SELECT * FROM T_EMOP_WZXX WHERE 1=1 "];
    //用户ID
    if(uid != nil && uid.length > 0)
    {
        [sql appendFormat:@" AND USERID = '%@' ", uid];
    }
    //开始时间
    if(fromTime != nil && fromTime.length > 0)
    {
        [sql appendFormat:@" AND LCTIME >= '%@' ", fromTime];
    }
    //结束时间
    if(endTime != nil && endTime.length > 0)
    {
        [sql appendFormat:@" AND LCTIME <= '%@' ", endTime];
    }
    
    NSLog(@"%@", sql);
    
    __block NSMutableArray *list = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [list addObject:[rs resultDictionary]];
        }
    }];
    return list;
}

- (BOOL)removeUserLocation:(NSString *)uid
                  fromTime:(NSString *)fromTime
                   endTime:(NSString *)endTime
                     count:(int)count
{
    if(isDbOpening == NO)
    {
        [self openDataBase];
    }
    //拼接查询指定的UUID的语句
    NSMutableString *querySql = [[NSMutableString alloc] initWithString:@"SELECT UUID FROM T_EMOP_WZXX WHERE 1=1"];
    if(uid != nil && uid.length > 0)
    {
        [querySql appendFormat:@" AND USERID = '%@' ", uid];
    }
    if(fromTime != nil && fromTime.length > 0)
    {
        [querySql appendFormat:@" AND LCTIME >= '%@' ", fromTime];
    }
    if(endTime != nil && endTime.length > 0)
    {
        [querySql appendFormat:@" AND LCTIME <= '%@' ", endTime];
    }
    if(count > 0)
    {
        [querySql appendFormat:@" LIMIT %d ", count];
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM T_EMOP_WZXX WHERE UUID IN (%@)", querySql];
    
    NSLog(@"%@", sql);
    
    __block BOOL ret = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    return ret;
}

- (BOOL)removeUserLocation:(NSString *)uid
                  fromTime:(NSString *)fromTime
                   endTime:(NSString *)endTime
{
    if(isDbOpening == NO)
    {
        [self openDataBase];
    }
    //拼接查询指定的UUID的语句
    NSMutableString *querySql = [[NSMutableString alloc] initWithString:@"SELECT UUID FROM T_EMOP_WZXX WHERE 1=1"];
    if(uid != nil && uid.length > 0)
    {
        [querySql appendFormat:@" AND USERID = '%@' ", uid];
    }
    if(fromTime != nil && fromTime.length > 0)
    {
        [querySql appendFormat:@" AND LCTIME >= '%@' ", fromTime];
    }
    if(endTime != nil && endTime.length > 0)
    {
        [querySql appendFormat:@" AND LCTIME <= '%@' ", endTime];
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM T_EMOP_WZXX WHERE UUID IN (%@)", querySql];
    NSLog(@"%@", sql);
    __block BOOL ret = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    return ret;
}

- (void)deleteLocation:(NSString *)uuid
{
    if(isDbOpening == NO)
    {
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM T_EMOP_WZXX WHERE UUID = '%@'", uuid];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}

@end
