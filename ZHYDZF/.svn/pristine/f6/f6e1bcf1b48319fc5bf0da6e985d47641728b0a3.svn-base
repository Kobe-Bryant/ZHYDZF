//
//  UploadFileManager.m
//  BoandaProject
//
//  Created by 张仁松 on 13-10-16.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "UploadFileManager.h"
#import "ServiceUrlString.h"
#import "ASIFormDataRequest.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"

@interface UploadFileManager()
@property(nonatomic,retain) ASIFormDataRequest * request;
@end

@implementation UploadFileManager
@synthesize fileFields,filePath,serviceType,delegate,request,myProgressView;

-(id)init{
    self = [super init];
    if(self){
        self.serviceType = @"UPLOAD_FILE";
        self.fileFields = @"";
        
    }
    return self;
}

-(void)commitFile{
    
    


    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:serviceType forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"file-----%@",strUrl);
    NSURL *url =[ NSURL URLWithString :strUrl];

    self.request = [ ASIFormDataRequest requestWithURL : url ];

    [request setStringEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"Charset"  value:@"UTF-8"];

    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    
    [ request addPostValue :[loginUsr objectForKey:@"userId"] forKey :@"userid"];
    [ request addPostValue :[loginUsr objectForKey:@"password"]forKey :@"password"];
    [ request addPostValue :[context getDeviceID] forKey :@"imei"];
    [ request addPostValue :[context getAppVersion]  forKey :@"version"];
    [ request addPostValue :serviceType forKey :@"service"];

    //此处注意 utf-8字符串必须经过转换，才不会出现乱码
    NSString *modifiedFileFields = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)fileFields, nil, nil,kCFStringEncodingUTF8));

    [ request addPostValue :modifiedFileFields forKey : @"FILE_FIELDS" ];
   

     [request setFile:self.filePath withFileName:[self.filePath lastPathComponent] andContentType:@"application/octet-stream" forKey: [self.filePath lastPathComponent]];
    [ request setDelegate : self ];
    [request setUploadProgressDelegate:myProgressView];
    [ request setDidFinishSelector : @selector ( responseComplete: )];
    [ request setDidFailSelector : @selector (responseFailed)];
    
    
    
    [request startAsynchronous];

}

-( void )responseComplete:(ASIFormDataRequest*)request{
    // 请求响应结束，返回 responseString
    NSString *responseString = [ self.request responseString ];
    NSLog(@"responseString = %@",responseString);
    NSDictionary *dic = [responseString objectFromJSONString];
    if( dic && [[dic objectForKey:@"result"] boolValue])
    {
        [delegate uploadFileSuccess:YES];
    }
    else
    {
        [delegate uploadFileSuccess:NO];
    }
        

}

-( void )respnoseFailed{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [delegate uploadFileSuccess:NO];
}
@end
