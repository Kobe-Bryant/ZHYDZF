//
//  HBSCHelper.m
//  BoandaProject
//
//  Created by 曾静 on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "HBSCHelper.h"

@implementation HBSCHelper

- (NSArray*) searchByFIDH:(NSString*)strFIDH{
    [self openDataBase];

    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    
  
    NSString *sqlStr = @"";

    sqlStr = [NSString stringWithFormat:@"SELECT * FROM T_YDZF_FLFG WHERE FIDH = '%@'  order by PXH",strFIDH];

     /*
     NSString *sqlStr = @"SELECT * FROM T_YDZF_FLFG";
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM ( SELECT * FROM ( SELECT '1' LX, FGBH,FGMC,FIDH,SFML,HZ,WJDX,CJSJ,CJR,PXH,PXM ,WJLJ FROM T_YDZF_FLFG FLFG)\
                        UNION ALL  SELECT * FROM (\
                        SELECT '0' LX ,XH,FJMC || HZM ,'5bbdd8e8-3795-48f5-9fad-2e355d67df64', '0',HZM,FJ.FJDX,FJ.CJSJ,FJ.CJR,0,DM.PXM,FJ.LJ FROM T_COMN_GGDMZ DM LEFT JOIN T_COMN_FJXX FJ ON DM.DM = FJ.FJLX\
                        WHERE DM.DMJBH = 'WRYFJXXTYPE' AND DM.DM = '4' AND DM.SFYX = '1' ORDER BY DM.PXM,FJ.CJSJ DESC ) ) WHERE FIDH = '%@'  order by PXH",@"5bbdd8e8-3795-48f5-9fad-2e355d67df64"];*/
    
    
    
    NSLog(@"sqlStr=%@",sqlStr);
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    NSLog(@"[ary count]=%d",[ary count]);
    //
    return ary;
}

- (NSArray*) searchByGLBH:(NSString*)strGLBH{
    [self openDataBase];
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    
    NSString *sqlStr = @"";
       sqlStr = [NSString stringWithFormat:@"select *  FROM  T_COMN_FJXX"];
        
    NSLog(@"sqlStr=%@",sqlStr);
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    NSLog(@"[ary count]=%d",[ary count]);
    //
    return ary;
}

- (NSArray*) searchByFGMC:(NSString*)keywords{
    [self openDataBase];
    
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM T_YDZF_FLFG WHERE FGMC like '%%%@%%%%' and SFML ='0' order by PXH ",keywords];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return ary;
}
@end
