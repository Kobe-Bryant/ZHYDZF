//
//  SharedInformations.m
//  GMEPS_HZ
//
//  Created by chen on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SharedInformations.h"



@implementation SharedInformations

+(NSString*)getJJCDFromInt:(NSInteger) num{
    if (num == 1) return @"一般";
    else if (num == 2) return @"紧急";
    else if (num == 3) return @"特急";
    else return @" ";
}

+(NSString*)getLWLXFromStr:(NSString*) type{//来文类型
    
    NSArray *itemAry = [NSArray arrayWithObjects:@"厅来文",@"厅发文",@"厅通知公告",@"其他单位来文",@"会议",@"电话记录",@"其他",nil];
    NSArray *typeAry = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    int index = 0;
    for(NSString *str in typeAry){
        if ([str isEqualToString:type]) {
            return [itemAry objectAtIndex:index];
        }
        index++;
    }
    return @"";
}

+(NSString*)getFWLXFromStr:(NSString*) type{//发文类型 
    
    NSArray * itemAry = [NSArray arrayWithObjects:@"阳环函",@"办公室下行文",@"办公室上行文",@"环保局下行文",@"环保局上行文", nil];
    
    NSArray *typeAry = [NSArray arrayWithObjects:@"10",@"15",@"20",@"25",@"30",nil];
    int index = 0;
    for(NSString *str in typeAry){
        if ([str isEqualToString:type]) {
            return [itemAry objectAtIndex:index];
        }
        index++;
    }
    return @"";
}

+(NSString*)getGKLXFromInt:(NSInteger) num{
    if (num == 1) return @"主动公开";
    else if (num == 2) return @"依申请公开";
    else  if (num == 3) return @"不予公开";
    else return @"内部公开";
    
}
@end
