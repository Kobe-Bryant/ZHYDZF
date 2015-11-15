//
//  GUIDGenerator.m
//  GMEPS_HZ
//
//  Created by chen on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GUIDGenerator.h"
#import "NSString+MD5Addition.h"

@implementation GUIDGenerator
+(NSString *)generateGUID {
	
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
	NSString *str = [[NSString alloc] initWithFormat:@"%@",uuidStr];
	////NSLog(str);	
	CFRelease(uuidStr);
    CFRelease(uuid);

	return str;
}

+(NSString*)generateBHByWryName:(NSString*)name{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
  
    return [NSString stringWithFormat:@"%@%@",[name stringFromMD5],dateString];
}


+(NSString*)generateBHByWryName:(NSString*)name andWrybh:(NSString*)bh{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    if([bh length] > 0)
        return [NSString stringWithFormat:@"%@%@",bh,dateString];
    else
        return [NSString stringWithFormat:@"%@%@",name,dateString];
}
@end
