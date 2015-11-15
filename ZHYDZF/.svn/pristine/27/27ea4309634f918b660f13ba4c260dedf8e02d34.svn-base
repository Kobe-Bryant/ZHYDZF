//
//  RecordsHelper.m
//  BoandaProject
//
//  Created by 王哲义 on 13-10-8.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "RecordsHelper.h"
#import "GUIDGenerator.h"
#import "FMDatabaseAdditions.h"

@implementation RecordsHelper

-(NSDictionary *)queryRecordByWrymc:(NSString*)mc andWryBH:(NSString*)wrybh andTableName:(NSString*)tableName andBH:(NSString*)bh
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    
    NSLog(@"%@-%@-%@",tableName,bh,wrybh);
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:10];
    NSString *sql  =  nil;
    
    if([bh length] > 0){
        NSLog(@"111");
        sql  = [NSString stringWithFormat:@"SELECT * from %@  where BH  ='%@'  order by CJSJ desc ",tableName,bh];
    }
    else{
        if ([wrybh length] > 0) {
            NSLog(@"222");
            sql  = [NSString stringWithFormat:@"SELECT * from %@  where WRYBH  ='%@'  order by CJSJ desc ",tableName,wrybh];
        }
        else{
            NSLog(@"333");
            sql  = [NSString stringWithFormat:@"SELECT * from %@  where WRYMC ='%@'  order by CJSJ desc ",tableName,mc];
        }
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            
            
            [ary addObject:[rs resultDictionary] ];
            
        }
        [rs close];
    }];
    
    if([ary count] > 0)
        return [ary objectAtIndex:0];
    return nil;
}

-(BOOL)saveRecord:(NSDictionary*)values  andTableName:(NSString*)tableName{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    
    NSMutableString *sqlstr = [NSMutableString stringWithCapacity:100];
    NSMutableString *fieldStr = [NSMutableString stringWithCapacity:50];
    NSMutableString *valueStr = [NSMutableString stringWithCapacity:50];
    NSArray *aryKeys = [values allKeys];
    FMDatabase *db = [self.dbQueue database];
    if(db == nil)return NO;
    
    for(NSString *field in aryKeys){
        //查看是否有该列
        if([db columnExists:field inTableWithName:tableName]){
            [fieldStr appendFormat:@"%@,",field];
            [valueStr appendFormat:@"'%@',",[values objectForKey:field]];
        }
        
        
    }
    if([fieldStr length] >0 && [valueStr length] >0){
        [sqlstr appendFormat:@"insert into %@(%@) values(%@)",tableName,[fieldStr substringToIndex:([fieldStr length]-1)],[valueStr substringToIndex:([valueStr length]-1)]];
        
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            BOOL rs = [db executeUpdate:sqlstr];
            if (rs == NO) {
                NSLog(@"sql err data:%@",sqlstr);
            }
        }];
        return YES;
        
        
    }
    
    return NO;
}

-(BOOL)saveSignName:(NSData *)imageData XCZFBH:(NSString*)bh WRYMC:(NSString*)mc TableName:(NSString*)tableName JCR:(NSString*)jcr {
    if( (imageData == nil) || [bh length] <=0 || [mc length] <=0 || [tableName length] <=0  )
        return NO;
    if (isDbOpening == NO) {
        [self openDataBase];
    }
    
    NSMutableString *sqlstr = [NSMutableString stringWithFormat:@"INSERT INTO T_YDZF_SIGNATURE"];
    NSMutableString *keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString *values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:5];
    
    [keys appendString:@"XCZFBH,"];
    [values appendString:@"?,"];
    [arguments addObject:bh];
    
    [keys appendString:@"WRYMC,"];
    [values appendString:@"?,"];
    [arguments addObject:mc];
    
    [keys appendString:@"TABLENAME,"];
    [values appendString:@"?,"];
    [arguments addObject:tableName];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [keys appendString:@"JCSJ,"];
    [values appendString:@"?,"];
    [arguments addObject:dateString];
    
    
    [keys appendString:@"SignName,"];
    [values appendString:@"?,"];
    [arguments addObject:imageData];
    
    [keys appendString:@"JCR,"];
    [values appendString:@"?,"];
    [arguments addObject:jcr];
    
    [keys appendString:@")"];
    [values appendString:@")"];
    [sqlstr appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL rs = [db executeUpdate:sqlstr withArgumentsInArray:arguments];
        if (rs == NO) {
            NSLog(@"sql err data:%@",sqlstr);
        }
    }];
    
    return YES;
}

-(NSArray *)queryWDRecordByBH:(NSString*)blbh
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:10];
    
    if ([blbh length] == 0) {
        return nil;
    }
    
    NSString *sql   = [NSString stringWithFormat:@"SELECT * from T_YDZF_WDB  where BLBH  ='%@'  order by PXH ",blbh];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            
            [ary addObject:[rs resultDictionary] ];
            
        }
        [rs close];
    }];
    
    return ary;
}

-(NSArray *)querySignatureByWrymc:(NSString*)mc andTableName:(NSString*)tableName {
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:10] ;
    NSString *sql = [NSString stringWithFormat:@"SELECT * from T_YDZF_SIGNATURE  where WRYMC ='%@' and  TABLENAME ='%@' order by JCSJ desc ",mc,tableName];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *dicItem = [NSMutableDictionary dictionaryWithCapacity:10];
            [dicItem setObject: [rs stringForColumn:@"XCZFBH"] forKey:@"XCZFBH"];
            [dicItem setObject: [rs stringForColumn:@"WRYMC"] forKey:@"WRYMC"];
            [dicItem setObject: [rs stringForColumn:@"TABLENAME"] forKey:@"TABLENAME"];
            [dicItem setObject: [rs stringForColumn:@"JCSJ"] forKey:@"JCSJ"];
            [dicItem setObject: [rs stringForColumn:@"JCR"] forKey:@"JCR"];
            if ([rs dataForColumn:@"SignName"]) {
                [dicItem setObject:[rs dataForColumn:@"SignName"] forKey:@"SignName"];
            }
            [ary addObject:dicItem];
        }
    }];
    
    return ary;
}

//存储问答表数据
-(BOOL)saveWDRecordWT:(NSArray*)wtAry andDA:(NSArray*)daAry BLBH:(NSString*)bh{
    
    if(isDbOpening == NO){
        [self openDataBase];
    }
    if(wtAry == nil || [wtAry count] == 0 )
        return NO;
    
    if([wtAry count] != [daAry count] )
        return NO;
    
    
    
    FMDatabase *db = [self.dbQueue database];
    if(db == nil)return NO;
    [db beginTransaction];
    int i = 0;
    for(NSString *strWT in wtAry){
        
        NSString *sqlstr = [NSString stringWithFormat:@"insert into T_YDZF_WDB(BH,BLBH,WT,DA,PXH) values(%d,'%@','%@','%@',%d)",i,bh,strWT,[daAry objectAtIndex:i],i];
        i++;
        [db executeUpdate:sqlstr];
        
    }
    [db commit];
    return YES;
    
}

//删除未提交笔录中的某条记录
-(BOOL)deleteRecordByBH:(NSString*)bh andTableName:(NSString*)tableName{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block BOOL success = NO;
    
    NSString *sql = [NSString stringWithFormat:@"delete from T_YDZF_UNCOMMITED_RECORD  where BH = '%@' and TABLENAME = '%@'",bh,tableName];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        success = [db executeUpdate:sql];
        
    }];
    
    
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    
    return success;
}

//插入一条未提交笔录
-(BOOL)insertRecordByBH:(NSString*)bh andTableName:(NSString*)tableName andJBXXJson:(NSString*)jsonStr andWryMC:(NSString*)mc andLRR:(NSString*)lrr{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block BOOL success = NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *delsql = [NSString stringWithFormat:@"delete from  T_YDZF_UNCOMMITED_RECORD where BH='%@' and TABLENAME='%@'",bh,tableName];
    
    NSString *sql = [NSString stringWithFormat:@"insert into T_YDZF_UNCOMMITED_RECORD(BH,TABLENAME,WRYMC,JBXXJSON,LRR,CJSJ) values('%@','%@','%@','%@','%@','%@') ",bh,tableName,mc,jsonStr,lrr,dateString];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:delsql];
        success = [db executeUpdate:sql];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    return success;
}

-(BOOL)insertRecordByBH:(NSString*)bh andTableName:(NSString*)tableName andJBXXJson:(NSString*)jsonStr andWryMC:(NSString*)mc andLRR:(NSString*)lrr andPath:(NSString *)path{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block BOOL success = NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *delsql = [NSString stringWithFormat:@"delete from  T_YDZF_UNCOMMITED_RECORD where BH='%@' and TABLENAME='%@'",bh,tableName];
    
    NSString *sql = [NSString stringWithFormat:@"insert into T_YDZF_UNCOMMITED_RECORD(BH,TABLENAME,WRYMC,JBXXJSON,LRR,CJSJ,PATH) values('%@','%@','%@','%@','%@','%@','%@') ",bh,tableName,mc,jsonStr,lrr,dateString,path];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:delsql];
        success = [db executeUpdate:sql];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    return success;
}

//通过录入人来查询未提交笔录
-(NSArray*)queryUncommitedRecords:(NSString*)lrr{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:10];
    
    if ([lrr length] == 0) {
        return nil;
    }
    
    NSString *sql   = [NSString stringWithFormat:@"SELECT * from T_YDZF_UNCOMMITED_RECORD  where LRR ='%@' order by CJSJ ",lrr];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            
            [ary addObject:[rs resultDictionary]];
            
        }
        [rs close];
    }];
    
    return ary;
}
@end
