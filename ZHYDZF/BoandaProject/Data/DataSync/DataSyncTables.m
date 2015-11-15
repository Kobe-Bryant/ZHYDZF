//
//  DataSyncTables.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataSyncTables.h"
//@"T_YDZF_FLFG",@"T_COMN_GGDMZ",
//@"T_JCGL_XCZF_JBXX",

//@"T_COMN_FJXX",@"T_COMN_GGDMZ"
@implementation DataSyncTables
+(NSArray*)tableNamesAry{

    NSArray *ary = [[NSArray alloc] initWithObjects:@"T_ADMIN_RMS_ZZJG",@"T_ADMIN_RMS_YH",@"T_YDZF_HBJMC_JCDDCW",@"T_YDZF_FLFG",@"T_COMN_FJXX",nil];

       
    return ary;
}

+(NSString*)primaryKeyForTable:(NSString*)tableName{
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"zzbh", @"yhid",@"FGBH",@"SJQX",nil] forKeys:[NSArray arrayWithObjects:@"T_ADMIN_RMS_ZZJG",@"T_ADMIN_RMS_YH",@"T_YDZF_FLFG",@"T_YDZF_HBJMC_JCDDCW", nil]];
 
    return [dic objectForKey:tableName];
}
@end
