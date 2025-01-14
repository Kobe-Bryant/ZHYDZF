//
//  MenuHelper.m
//  BoandaProject
//
//  Created by 张仁松 on 13-10-9.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "MenuHelper.h"

@implementation MenuHelper

-(BOOL)insertSystemMenu:(NSDictionary*)columns{
     [self openDataBase];
    __block BOOL success = NO;
    //先删除掉已经存在的本条记录
    NSString *sql1 = [NSString stringWithFormat:@"delete from T_MENUS where XH = \'%@\'",[columns objectForKey:@"XH"]];
    NSString *sql2 = [NSString stringWithFormat:@"insert into T_MENUS(XH,SSXT,CDXH,CDMC,FCDXH,SFYX,PXH,TPWZ,LJDZ,BZ ,CJR ,CJSJ ,XGR ,XGSJ ) values(\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',%d,%d,\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\')",[columns objectForKey:@"XH"],[columns objectForKey:@"SSXT"],[columns objectForKey:@"CDXH"],[columns objectForKey:@"CDMC"],[columns objectForKey:@"FCDXH"],[[columns objectForKey:@"SFYX"] integerValue],[[columns objectForKey:@"PXH"] integerValue],[columns objectForKey:@"TPWZ"],[columns objectForKey:@"LJDZ"],[columns objectForKey:@"BZ"],[columns objectForKey:@"CJR"],[columns objectForKey:@"CJSJ"],[columns objectForKey:@"XGR"],[columns objectForKey:@"XGSJ"]];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql1];
         success = [db executeUpdate:sql2];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql2);
    }
    return success;

}

-(BOOL)insertSystemMenuItems:(NSArray*)items{
   BOOL success = NO;
     [self openDataBase];
    FMDatabase *db = [self.dbQueue database];
    if(db == nil)return NO;
    [db beginTransaction];
    
    for(NSDictionary *columns in items){
        //先删除掉已经存在的本条记录
         NSString *sql1 = [NSString stringWithFormat:@"delete from T_MENUS where XH = \'%@\'",[columns objectForKey:@"XH"]];
        NSString *sql2 = [NSString stringWithFormat:@"insert into T_MENUS(XH,SSXT,CDXH,CDMC,FCDXH,SFYX,PXH,TPWZ,LJDZ,BZ ,CJR ,CJSJ ,XGR ,XGSJ ) values(\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',%d,%d,\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\')",[columns objectForKey:@"XH"],[columns objectForKey:@"SSXT"],[columns objectForKey:@"CDXH"],[columns objectForKey:@"CDMC"],[columns objectForKey:@"FCDXH"],[[columns objectForKey:@"SFYX"] integerValue],[[columns objectForKey:@"PXH"] integerValue],[columns objectForKey:@"TPWZ"],[columns objectForKey:@"LJDZ"],[columns objectForKey:@"BZ"],[columns objectForKey:@"CJR"],[columns objectForKey:@"CJSJ"],[columns objectForKey:@"XGR"],[columns objectForKey:@"XGSJ"]];
         [db executeUpdate:sql1];
        [db executeUpdate:sql2];
    }

    success = [db commit];
    return success;

}

//具体用户菜单的插入

-(BOOL)insertClientMenu:(NSDictionary*)columns{
    [self openDataBase];
    __block BOOL success = NO;
    NSString *sql1 = [NSString stringWithFormat:@"delete from T_CLIENT_MENU where XH = \'%@\'",[columns objectForKey:@"XH"]];
    NSString *sql2 = [NSString stringWithFormat:@"insert into T_CLIENT_MENU(YHID,CDBH,XH,SSXT,CJR,CJSJ,XGR,ORGID ) values(\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\')",[columns objectForKey:@"YHID"],[columns objectForKey:@"CDBH"],[columns objectForKey:@"XH"],[columns objectForKey:@"SSXT"],[columns objectForKey:@"CJR"],[columns objectForKey:@"CJSJ"],[columns objectForKey:@"XGR"],[columns objectForKey:@"ORGID"]];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql1];
        success = [db executeUpdate:sql2];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql2);
    }
    return success;
}

-(BOOL)insertClientMenuItems:(NSArray*)items{
    BOOL success = NO;
    [self openDataBase];
    FMDatabase *db = [self.dbQueue database];
    if(db == nil)return NO;
    [db beginTransaction];
    
    for(NSDictionary *columns in items){
        NSString *sql1 = [NSString stringWithFormat:@"delete from T_CLIENT_MENU where XH = \'%@\'",[columns objectForKey:@"XH"]];
         NSString *sql2 = [NSString stringWithFormat:@"insert into T_CLIENT_MENU(YHID,CDBH,XH,SSXT,CJR,CJSJ,XGR,ORGID ) values(\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\')",[columns objectForKey:@"YHID"],[columns objectForKey:@"CDBH"],[columns objectForKey:@"XH"],[columns objectForKey:@"SSXT"],[columns objectForKey:@"CJR"],[columns objectForKey:@"CJSJ"],[columns objectForKey:@"XGR"],[columns objectForKey:@"ORGID"]];
        [db executeUpdate:sql1];
        [db executeUpdate:sql2];
    }
    
    success = [db commit];
    return success;
}

-(BOOL)removeClientMenuItems:(NSArray*)items{
    BOOL success = NO;
    [self openDataBase];
    FMDatabase *db = [self.dbQueue database];
    if(db == nil)return NO;
    [db beginTransaction];
    
    for(NSDictionary *columns in items){
        NSString *sql = [NSString stringWithFormat:@"delete from T_CLIENT_MENU where XH = \'%@\'",[columns objectForKey:@"XH"]];
       
        [db executeUpdate:sql];
    }
    
    success = [db commit];
    return success;
}


//查询所有菜单
-(NSArray*)queryMenusByUser:(NSString*)yhid{
    [self openDataBase];
    
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sql = [NSString stringWithFormat:@"select * from (select * from T_CLIENT_MENU  where YHID=\'%@\') A inner join T_MENUS B   on B.XH=A.CDBH   order by PXH ",yhid];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return ary;
}

//查询所有有效的菜单
-(NSArray*)queryValidMenusByUser:(NSString*)yhid{
    
    [self openDataBase];
        
        
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sql = [NSString stringWithFormat:@"select * from (select * from T_CLIENT_MENU  where YHID=\'%@\') A inner join (select * from T_MENUS where  SFYX=1) B   on B.XH=A.CDBH  order by PXH ",yhid];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                [ary addObject:[rs resultDictionary]];
            }
            [rs close];
    }];
        
    return ary;
}

-(void)removeUserMenus:(NSString*)yhid{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"delete from T_CLIENT_MENU where YHID = \'%@\'",yhid ];

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql];

    }];
}

-(void)processAllMenus:(NSArray*)menus{
   // [self insertSystemMenuItems:menus];
}

-(void)processDelYhcds:(NSArray*)menus{
  //  [self removeClientMenuItems:menus];
}

-(void)processSyncYhcds:(NSArray*)menus{
   // [self insertClientMenuItems:menus];
}

-(NSArray*)getMenuPages:(NSString*)yhid{
    
    [self openDataBase];
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sql = [NSString stringWithFormat:@"select * from (select * from T_CLIENT_MENU  where YHID= \'%@\') A inner join (select * from T_MENUS where FCDXH=(select xh from T_MENUS where cdxh='ROOT') and SFYX=1) B   on B.XH=A.CDBH order by PXH ",yhid];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return ary;
}

-(NSArray*)getPageSubMenus:(NSString*)yhid andFCDXH:(NSString*)fcdxh{
    
    [self openDataBase];
    
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:10];
    NSString *sql = [NSString stringWithFormat:@"select * from (select * from T_CLIENT_MENU  where YHID= \'%@\') A inner join (select * from T_MENUS where FCDXH= \'%@\' and SFYX=1) B   on B.XH=A.CDBH  order by PXH  ",yhid,fcdxh];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return ary;
}


-(NSArray*)getMenuConfig:(NSString*)yhid{
    NSArray *aryItems = [self getMenuPages:yhid];
    NSMutableArray *aryMenuPages = [NSMutableArray arrayWithCapacity:5];
    for(NSDictionary *dicPage in aryItems){
        NSMutableDictionary *dicItem =[NSMutableDictionary dictionaryWithCapacity:2];
        [dicItem setObject:[dicPage objectForKey:@"CDMC"] forKey:@"PageTitle"];
        [dicItem setObject:[self getPageSubMenus:yhid andFCDXH:[dicPage objectForKey:@"XH"]] forKey:@"Menus"];
        [aryMenuPages addObject:dicItem];
        
    }
    return aryMenuPages;
    
}


-(NSDictionary*)getDesktopMenus:(NSString*)yhid{
    [self openDataBase];
    
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:10];
    NSString *sql = [NSString stringWithFormat:@"select * from (select * from T_DESKTOP  where YHID= \'%@\') A inner join (select * from T_MENUS where  SFYX=1) B   on B.XH=A.CDBH  order by PXH ",yhid];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];

    
    NSMutableDictionary *dicItem =[NSMutableDictionary dictionaryWithCapacity:2];
    [dicItem setObject:@"我的桌面" forKey:@"PageTitle"];
    [dicItem setObject:ary forKey:@"Menus"];

    return dicItem;
    
}


-(void)removeAllDesktopMenus:(NSString*)yhid{

    [self openDataBase];

    NSString *sql = [NSString stringWithFormat:@"delete from T_DESKTOP where YHID = \'%@\'",yhid ];
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql];
        
    }];
}

-(BOOL)addMenuItemToDesk:(NSDictionary*)columns{
    [self openDataBase];
    __block BOOL success = NO;
    //columns 对应的是T_MENUS的字段信息
     NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    
    NSString *sql1 = [NSString stringWithFormat:@"delete from T_DESKTOP where CDBH = \'%@\'",[columns objectForKey:@"XH"]];
    NSString *sql2 = [NSString stringWithFormat:@"insert into T_DESKTOP(YHID,CDBH,SSXT,CJR,CJSJ,XGR ) values(\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\')",userID,[columns objectForKey:@"XH"],[columns objectForKey:@"SSXT"],[columns objectForKey:@"CJR"],[columns objectForKey:@"CJSJ"],[columns objectForKey:@"XGR"]];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql1];
        success = [db executeUpdate:sql2];
        
    }];
    
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql2);
    }
    return success;
}

-(void)removeOneDeskMenu:(NSDictionary*)aMenuItem{
    [self openDataBase];
    
    //columns 对应的是T_MENUS的字段信息
    __block BOOL success = NO;
    NSString *sql = [NSString stringWithFormat:@"delete from T_DESKTOP where CDBH = \'%@\'",[aMenuItem objectForKey:@"XH"]];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    return ;
}

- (NSString*)getMenuCodeByName:(NSString *)name
{
    [self openDataBase];
    __block NSString *ret;
    NSString *sql = [NSString stringWithFormat:@"select CDXH from T_MENUS where CDMC=\'%@\'",name];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        if([rs next])
        {
            ret = [rs objectForColumnName:@"CDXH"];
        }
        [rs close];
    }];
    return ret;
}

@end
