//
//  MenuHelper.h
//  BoandaProject
//
//  Created by 张仁松 on 13-10-9.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "SqliteHelper.h"

@interface MenuHelper : SqliteHelper
//系统所有菜单的插入
-(BOOL)insertSystemMenu:(NSDictionary*)columns ;

-(BOOL)insertSystemMenuItems:(NSArray*)items;
//具体用户菜单的插入

-(BOOL)insertClientMenu:(NSDictionary*)columns ;

-(BOOL)insertClientMenuItems:(NSArray*)items;

//查询所有菜单
-(NSArray*)queryMenusByUser:(NSString*)yhid;

//查询所有有效的菜单
-(NSArray*)queryValidMenusByUser:(NSString*)yhid;

-(NSArray*)getMenuConfig:(NSString*)yhid;

-(NSArray*)getMenuPages:(NSString*)yhid;

-(void)removeUserMenus:(NSString*)yhid;

-(void)processAllMenus:(NSArray*)menus;

-(void)processDelYhcds:(NSArray*)menus;

-(void)processSyncYhcds:(NSArray*)menus;

//获取我的桌面菜单
-(NSDictionary*)getDesktopMenus:(NSString*)yhid;

-(void)removeAllDesktopMenus:(NSString*)yhid;

-(BOOL)addMenuItemToDesk:(NSDictionary*)aMenuItem;

-(void)removeOneDeskMenu:(NSDictionary*)aMenuItem;

//根据菜单的名称获取菜单的序号
- (NSString *)getMenuCodeByName:(NSString *)name;

@end
