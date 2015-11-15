//
//  PhotoProfileViewController.h
//  BoandaProject
//
//  Created by PowerData on 13-10-31.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "BaseViewController.h"
#import "UploadFileManager.h"
#import "ASIFormDataRequest.h"



@protocol UploadInvestigatePhotoDelegate <NSObject>

- (void)uploadWithStatus:(BOOL)ret andWithInfo:(NSDictionary *)info;

@end

@interface PhotoProfileViewController : BaseViewController <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *progressLable;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (strong, nonatomic) IBOutlet UITextField *fileNameField;
@property (strong, nonatomic) IBOutlet UITextField *fileLocationField;
@property (strong, nonatomic) IBOutlet UITextView *fileDescField;
@property (assign,   nonatomic) id<UploadInvestigatePhotoDelegate> delegate;

@property (strong, nonatomic) NSString *xczfbh;
@property (strong, nonatomic) NSString *basebh;
@property (strong, nonatomic) NSString *category;//分类
- (IBAction)uploadPhotoClick:(id)sender;

@end
