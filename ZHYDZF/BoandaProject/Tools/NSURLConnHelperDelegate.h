//
//  NSURLConnHelperDelegate.h
//  BoandaProject
//
//  Created by 张 仁松 on 12-2-16.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#ifndef BoandaProject_NSURLConnHelperDelegate_h
#define BoandaProject_NSURLConnHelperDelegate_h

@protocol NSURLConnHelperDelegate<NSObject>

@optional
- (void)processWebData:(NSData*)webData;
- (void)processWebData:(NSData*)webData andTag:(NSInteger)tag;
- (void)processError:(NSError *)error andTag:(NSInteger)tag;
- (void)processError:(NSError *)error;

@end

#endif
