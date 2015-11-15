//
//  PhotoProfileViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-31.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "PhotoProfileViewController.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "GUIDGenerator.h"
#import "UIImage+fixOrientation.h"

@interface PhotoProfileViewController ()<ASIProgressDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIPopoverController *photoPopoverController;
@property (nonatomic, strong) ASIFormDataRequest *request;
@property (nonatomic, strong) NSDictionary *profileData;
@property (nonatomic,assign) BOOL isUpload;
@end

@implementation PhotoProfileViewController
@synthesize request,category,isUpload;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"现场取证";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isUpload = NO;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    self.progressView.transform = transform;
    
}

-(void)viewDidAppear:(BOOL)animated{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:self.filePath];
    self.thumbImageView.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setThumbImageView:nil];
    [self setFileNameField:nil];
    [self setFileLocationField:nil];
    [self setFileDescField:nil];
    [self setProgressView:nil];
    [self setProgressLable:nil];
    [super viewDidUnload];
}

- (IBAction)remakeClick:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不能拍照" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}

- (IBAction)uploadPhotoClick:(id)sender
{
  if(!isUpload){
      
      isUpload = YES;
      NSMutableDictionary *recordData = [[NSMutableDictionary alloc] init];
      //图片名称
      if(self.fileNameField.text != nil && self.fileNameField.text.length > 0)
      {
          [recordData setObject:self.fileNameField.text forKey:@"FJMC"];
          
      }
      else
      {
          [recordData setObject:@"" forKey:@"FJMC"];
      }
      //图片拍摄地点
      if(self.fileLocationField.text != nil && self.fileLocationField.text.length > 0)
      {
          [recordData setObject:self.fileLocationField.text forKey:@"PSDD"];
      }
      else
      {
          [recordData setObject:@"" forKey:@"PSDD"];
      }
      //证据描述
      if(self.fileDescField.text != nil && self.fileDescField.text.length > 0)
      {
          [recordData setObject:self.fileDescField.text forKey:@"SMQK"];
      }
      else
      {
        [recordData setObject:@"" forKey:@"SMQK"];
      }

    //提交记录表数据
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    NSString *uname = [userInfo objectForKey:@"uname"];
    NSString *ORGID = [userInfo objectForKey:@"orgid"];
    NSString *sjqx = [userInfo objectForKey:@"sjqx"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *dateStr = [df stringFromDate:now];

    [recordData setObject:[GUIDGenerator generateGUID] forKey:@"BH"];
    [recordData setObject:self.xczfbh forKey:@"XCZFBH"];
    [recordData setObject:[userInfo objectForKey:@"uname"] forKey:@"PSR"];
    [recordData setObject:@"jpg" forKey:@"FJLX"];
    
    NSString *fileDesc = @"";
    if(self.fileDescField.text.length > 0)
    {
        fileDesc = self.fileDescField.text;
    }
    
    NSString *fileName = @"";
    if(self.fileNameField.text != nil && self.fileNameField.text.length > 0)
    {
        fileName = self.fileNameField.text;
    }
    [recordData setObject:self.filePath forKey:@"FJDZ"];
    [recordData setObject:sjqx forKey:@"SJQX"];
    [recordData setObject:uname forKey:@"CJR"];
    [recordData setObject:dateStr forKey:@"CJSJ"];
    [recordData setObject:uname forKey:@"XGR"];
    [recordData setObject:dateStr forKey:@"XGSJ"];
    [recordData setObject:ORGID forKey:@"ORGID"];
    [recordData setObject:category forKey:@"QZLB"];//取证类别
    
    NSMutableDictionary *tmpPicItem = [[NSMutableDictionary alloc] init];
    [tmpPicItem setObject:@"" forKey:@"FILE_CODE"];
    [tmpPicItem setObject:fileName forKey:@"FILE_NAME"];
    [tmpPicItem setObject:[userInfo objectForKey:@"uname"]  forKey:@"FILE_Author"];
    [tmpPicItem setObject:[recordData objectForKey:@"CJSJ"] forKey:@"FILE_Date"];
    [tmpPicItem setObject:fileDesc forKey:@"FILE_DESC"];
    [tmpPicItem setObject:[self.filePath lastPathComponent] forKey:@"FILE_PATH"];
    [tmpPicItem setObject:self.filePath forKey:@"FILE_LOCAL_PATH"];
    [tmpPicItem setObject:@"1" forKey:@"FILE_EXIST"];
    self.profileData = tmpPicItem;
    
    [self commitFile:recordData];
  }else{
      
      return;
  }
    
}


//上传文件
-(void)commitFile:(NSDictionary *)value
{
    NSString *jsonStr = [value JSONString];
    self.progressView.hidden = NO;
    self.progressLable.hidden = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"UPLOAD_FILE" forKey:@"service"];

    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSURL *url =[NSURL URLWithString :strUrl];


    
    self.request = [ASIFormDataRequest requestWithURL:url];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:@"POST"];
    //此处注意 utf-8字符串必须经过转换，才不会出现乱码
    NSString *modifiedFileFields = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)jsonStr, nil, nil,kCFStringEncodingUTF8));
    [self.request setPostValue:modifiedFileFields forKey:@"FILE_FIELDS"];
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    [request setStringEncoding:NSUTF8StringEncoding];
   //  NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //[request setStringEncoding:enc];
    NSDictionary *loginUsr = [context getUserInfo];
    [ request addPostValue :[loginUsr objectForKey:@"userId"] forKey :@"userid"];
    [ request addPostValue :[loginUsr objectForKey:@"password"]forKey :@"password"];
    [ request addPostValue :[context getDeviceID] forKey :@"imei"];
    [ request addPostValue :[context getAppVersion]  forKey :@"version"];
    [ request addPostValue :@"UPLOAD_FILE" forKey :@"service"];
  // [request addRequestHeader:@"Charset"  value:@"UTF-8"];
    [request setFile:self.filePath withFileName:[self.filePath lastPathComponent] andContentType:@"application/octet-stream" forKey: [self.filePath lastPathComponent]];
    //[self.request setFile:self.filePath forKey :@"FJDZ"];
    [self.request setDelegate:self ];
    [self.request setUploadProgressDelegate:self];
    self.request.showAccurateProgress = YES;
    [self.request setDidFinishSelector:@selector(responseComplete)];
    [self.request setDidFailSelector:@selector(responseFailed)];
    [self.request startAsynchronous];
}

-(void)setProgress:(float)newProgress{
    [self.progressView setProgress:newProgress animated:YES];
    self.progressLable.text = [NSString stringWithFormat:@"%0.f%%",newProgress*100];
}

-(void)responseFailed{
    [self.delegate uploadWithStatus:NO andWithInfo:self.profileData];
    isUpload = NO;
    [self showAlertMessage:@"上传失败!"];
}

-( void )responseComplete
{
    NSString *str = self.request.responseString;
//    self.progressView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *dic = [str objectFromJSONString];
    if( dic && [[dic objectForKey:@"result"] boolValue])
    {
        [self.delegate uploadWithStatus:YES andWithInfo:self.profileData];
        [self showAlertMessage:@"文件上传成功!"];
    }
    else
    {
        [self.delegate uploadWithStatus:NO andWithInfo:self.profileData];
        [self showAlertMessage:@"上传失败!"];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.message isEqualToString:@"文件上传成功!"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-( void )respnoseFailed
{
    self.progressView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self showAlertMessage:@"上传失败!"];
}

#pragma mark - Taking Photos

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //先判断是否从设备获取到了图片
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"] == NO)
    {
        [picker dismissModalViewControllerAnimated:YES];
        return;
    }
    //在iPad下面打开照相机和相册的方式不一样,如果是打开的照相机这里需要退出界面
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            [picker dismissModalViewControllerAnimated:YES];
        }
    }
    //将图片转换为二进制数据，耗时较长
    UIImage *tmpOriginImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //旋转一下图片，是倒的
    UIImage *originImage = [tmpOriginImage fixOrientation];
    NSData *data;
    if (UIImagePNGRepresentation(originImage) == nil)
    {
        data = UIImageJPEGRepresentation(originImage, 1);
    }
    else
    {
        data = UIImagePNGRepresentation(originImage);
    }
    //保存图片
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"photos"];
    //NSLog(@"%@", self.xczfbh);
    if(self.xczfbh)
    {
        filePath = [filePath stringByAppendingPathComponent:self.xczfbh];
    }
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[df stringFromDate:[NSDate date]]];
    [fileManager createFileAtPath:[filePath stringByAppendingPathComponent:fileName] contents:data attributes:nil];
    self.filePath = [filePath stringByAppendingPathComponent:fileName];
}

@end
