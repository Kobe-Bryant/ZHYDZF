//
//  UploadFileManager.h
//  BoandaProject
//
//  Created by 张仁松 on 13-10-16.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//
//##########################
//UPLOAD_FILE
//FILE_FIELDS json字符串
//
//
#import <Foundation/Foundation.h>

@protocol FileUploadDelegate 

-(void)uploadFileSuccess:(BOOL)isSuccess;


@end


@interface UploadFileManager : NSObject
@property(nonatomic,strong)NSString *serviceType;//默认UPLOAD_FILE
@property(nonatomic,strong)NSString *fileFields;//json字符串
@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,assign)id<FileUploadDelegate> delegate;
@property(nonatomic,strong)UIProgressView *myProgressView;

-(void)commitFile;

@end
