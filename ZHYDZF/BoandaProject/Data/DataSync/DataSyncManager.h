//
//  DataSyncManager.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  描述：同步远程服务器与本地的数据库

#import <Foundation/Foundation.h>

@class ASINetworkQueue;

@interface DataSyncManager : NSObject{
    NSInteger count;
}

@property(nonatomic,strong)NSMutableArray *aryHandlers;//保存处理完数据的线程个数
@property(nonatomic,retain) ASINetworkQueue * networkQueue ;
-(BOOL)syncAllTables:(BOOL)now;//now yes不计算时间，马上更新
-(BOOL)syncDataByTable:(NSString*)tableName;
@property(nonatomic,retain)UIProgressView *pregress;
-(void)cancel;

//重新同步所有数据
-(void)reSyncAllTables;


@end
