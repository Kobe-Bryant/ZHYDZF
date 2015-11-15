//
//  LocaFlfgDBHelper.h
//  BoandaProject
//
//  Created by 张仁松 on 13-11-23.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface LocaFlfgDBHelper : NSObject{
    
    BOOL isDbOpening;
}
@property(nonatomic,strong) FMDatabaseQueue *dbQueue;

-(BOOL)openDataBase;

-(void)closeDataBase;


-(NSArray*)queryByKeyword:(NSString*)keyWord andType:(NSString*)type;

@end

