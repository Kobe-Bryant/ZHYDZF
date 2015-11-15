//
//  LocaFlfgDBHelper.m
//  BoandaProject
//
//  Created by 张仁松 on 13-11-23.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "LocaFlfgDBHelper.h"
#import "FMDatabaseAdditions.h"

@implementation LocaFlfgDBHelper
@synthesize dbQueue;
//打开数据源

-(BOOL)openDataBase{
    if (isDbOpening)
        return YES;


    NSString *databaseFilePath=[[NSBundle mainBundle] pathForResource:@"flfg" ofType:@"rdb"];
    
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:databaseFilePath];
    if (dbQueue == nil) {
        return NO;
    }
    isDbOpening = YES;
    return YES;
}

//关闭数据源
-(void)closeDataBase{
    if (isDbOpening) {
        [dbQueue close];
        isDbOpening = false;
    }
}


-(NSArray*)queryByKeyword:(NSString*)keyWord andType:(NSString*)type{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:10];
    NSString *sql  =  nil;
    if ([keyWord length] > 0) {
        if([type length] > 0){
            sql  = [NSString stringWithFormat:@"select A.* FROM T_YDZF_ZFZLK_FLFG A where  A.LB='%@'   and A.WFXW like '%%%@%%%%'   ORDER BY A.LB,A.PXH",type,keyWord];
        }else{
            sql  = [NSString stringWithFormat:@"select A.* FROM T_YDZF_ZFZLK_FLFG A where A.WFXW like '%%%@%%%%' ORDER BY A.LB,A.PXH",keyWord];
        }
    }
    else{
        if([type length] > 0){
            sql  = [NSString stringWithFormat:@"select A.* FROM T_YDZF_ZFZLK_FLFG A where   A.LB='%@' ORDER BY A.LB,A.PXH",type];
        }else{
            sql  = [NSString stringWithFormat:@"select A.* FROM T_YDZF_ZFZLK_FLFG A    ORDER BY A.LB,A.PXH"];
        }
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            
            [ary addObject:[rs resultDictionary] ];
            
        }
        [rs close];
    }];
    return ary;
}


@end
