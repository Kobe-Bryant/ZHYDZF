//
//  CacheManager.m
//  FoShanYDZF
//
//  Created by 曾静 on 14-1-24.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "CacheManager.h"
#import "PDFileManager.h"

@implementation CacheManager

+ (CacheManager *)shared
{
    static CacheManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CacheManager alloc] init];
    });
    return _instance;
}

- (NSString *)cacheFilePath
{
    NSString *cachePath; //[NSTemporaryDirectory() stringByAppendingPathComponent:kHomeCachePath];
    cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:kBaseCacheName];
    return cachePath;
}

- (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration
{
    NSString *ch = [NSTemporaryDirectory() stringByAppendingPathComponent:kBaseCacheName];
    
    if(duration <= 0)
    {
        duration = 60;
    }
    
    NSMutableDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithFile:ch];
    if(!data)
    {
        data = [[NSMutableDictionary alloc] init];
    }
    
    //构建缓存数据对象
    CacheObject *obj = [[CacheObject alloc] initWithData:value andDuration:duration];
    [data setObject:obj forKey:key];
    //写入到文件中
    BOOL ret = [NSKeyedArchiver archiveRootObject:data toFile:ch];
    if(ret)
    {
        DLog(@"缓存成功");
    }
    else
    {
        DLog(@"缓存失败%@", ch);
    }
}

- (CacheObject *)valueForKey:(NSString *)key
{
    NSString *ch = [NSTemporaryDirectory() stringByAppendingPathComponent:kBaseCacheName];
    
    NSMutableDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithFile:ch];
    if(data)
    {
        CacheObject *obj = [data objectForKey:key];
        if(obj.expired)
        {
            return nil;
        }
        else
        {
            return obj;
        }
    }
    return nil;
}

- (void)clearCache
{
    NSString *ch = [NSTemporaryDirectory() stringByAppendingPathComponent:kBaseCacheName];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"photos"];
    
    PDFileManager *pfm = [[PDFileManager alloc] init];
    [pfm removeDirectoryAtPath:filePath];
    [pfm removeFileAtPath:ch];
    [pfm removeDirectoryAtPath:pfm.printFileFolderPath];
}

@end
