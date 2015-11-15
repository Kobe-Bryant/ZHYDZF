//
//  RecordsHelper.h
//  BoandaProject
//
//  Created by 王哲义 on 13-10-8.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteHelper.h"

@interface RecordsHelper : SqliteHelper

-(NSDictionary *)queryRecordByWrymc:(NSString*)mc andWryBH:(NSString*)wrybh andTableName:(NSString*)tableName andBH:(NSString*)bh;


-(BOOL)saveRecord:(NSDictionary*)values  andTableName:(NSString*)tableName;

//存储签名到本地
-(BOOL)saveSignName:(NSData *)imageData XCZFBH:(NSString*)bh WRYMC:(NSString*)mc TableName:(NSString*)tableName JCR:(NSString*)jcr;

//获取本地签名
-(NSArray *)querySignatureByWrymc:(NSString*)mc andTableName:(NSString*)tableName;

-(NSArray *)queryWDRecordByBH:(NSString*)blbh;

//存储问答表数据
-(BOOL)saveWDRecordWT:(NSArray*)wtAry andDA:(NSArray*)daAry BLBH:(NSString*)bh;

//删除未提交笔录中的某条记录
-(BOOL)deleteRecordByBH:(NSString*)bh andTableName:(NSString*)tableName;

//插入一条未提交笔录 lrr:录入人 bh：笔录编号
-(BOOL)insertRecordByBH:(NSString*)bh andTableName:(NSString*)tableName andJBXXJson:(NSString*)jsonStr andWryMC:(NSString*)mc andLRR:(NSString*)lrr;
-(BOOL)insertRecordByBH:(NSString*)bh andTableName:(NSString*)tableName andJBXXJson:(NSString*)jsonStr andWryMC:(NSString*)mc andLRR:(NSString*)lrr andPath:(NSString *)path;

//通过录入人来查询未提交笔录
-(NSArray*)queryUncommitedRecords:(NSString*)lrr;

@end
