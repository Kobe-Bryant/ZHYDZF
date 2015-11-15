//
//  PDJsonkit.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "PDJsonkit.h"
#import "JSONKit.h"

@implementation NSString (PDJSONKitSerializing)

//Creating a JSON Object
- (id)objectFromJSONString{
    NSString *sysVersion = [UIDevice currentDevice].systemVersion;
    CGFloat version = [sysVersion floatValue];
    
    if (version >= 5.0) {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    else  {
        return [self objectFromJSONString];
    }
}




@end

@implementation NSData (PDJSONKitSerializing)

//Creating a JSON Object
- (id)objectFromJSONData{
    
    NSString *sysVersion = [UIDevice currentDevice].systemVersion;
    CGFloat version = [sysVersion floatValue];
    
    if (version >= 5.0) {
        NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding] ;
        return str;
    }else{
        return [self objectFromJSONData];
    }
}


@end


@implementation NSDictionary (PDJSONKitSerializing)



- (NSString *)JSONString{ // Invokes
    NSString *sysVersion = [UIDevice currentDevice].systemVersion;
    CGFloat version = [sysVersion floatValue];
    
    if (version >= 5.0) {
        NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding] ;
        return str;
    }else{
        return [self JSONString];
    }
    
}
@end

@implementation NSArray (PDJSONKitSerializing)



- (NSString *)JSONString{ // Invokes
    
    NSString *sysVersion = [UIDevice currentDevice].systemVersion;
    CGFloat version = [sysVersion floatValue];
    
    if (version >= 5.0) {
        NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding] ;
        return str;
    }else{
        return [self JSONString];
    }
    
}
@end

