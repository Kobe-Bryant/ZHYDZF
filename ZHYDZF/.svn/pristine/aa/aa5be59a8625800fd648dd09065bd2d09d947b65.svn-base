//
//  InvestigateEvidenceVC.m
//  BoandaProject
//
//  Created by 张仁松 on 13-10-22.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "InvestigateEvidenceVC.h"
#import <QuartzCore/QuartzCore.h>
#import "UploadFileManager.h"
#import "SystemConfigContext.h"
#import "GUIDGenerator.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "PDLargePhotoView.h"
#import "UIImage+fixOrientation.h"
@interface InvestigateEvidenceVC ()
@property (nonatomic, strong) UIScrollView *photoScrollView;
@property (nonatomic, strong) NSMutableArray *photoList;
@property (nonatomic, strong) NSMutableArray *checkedPhotoList;
@property (nonatomic, strong) UIPopoverController *photoPopoverController;

@property (nonatomic, assign) CGRect currentRect;
@property (nonatomic, assign) UIView *currentView;

@end

@implementation InvestigateEvidenceVC

@synthesize category,xczfbh,nextTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"阿斯顿");
    //初始化数据
    self.photoList = [[NSMutableArray alloc] initWithCapacity:0];
    self.checkedPhotoList = [[NSMutableArray alloc] initWithCapacity:0];
    
    //ScrollView 用于展示图片
    self.photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 50, 760, 850)];
    self.photoScrollView.delegate = self;
    [self.view addSubview:self.photoScrollView];
    
    [self requestServerPicData];
    
    //刷新界面
    [self makeView];
}

- (void)requestServerPicData
{
    if(self.xczfbh != nil && self.xczfbh.length > 0)
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:5];
        [params setObject:@"QUERY_YDZF_PIC_DATA" forKey:@"service"];
        [params setObject:self.xczfbh forKey:@"XCZFBH"];
        [params setObject:self.category forKey:@"QZLB"];
        NSString *strURL = [ServiceUrlString generateUrlByParameters:params];
        NSLog(@"s=====%@",strURL);
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strURL andParentView:self.view delegate:self tagID:QUERY_YDZF_PIC_DATA];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)makeView
{
    for(id sub in self.photoScrollView.subviews)
    {
        [sub removeFromSuperview];
    }
    
    int count = self.photoList.count + 1;
    int row = count%3==0 ? count/3 : count/3+1;//每行显示3张图片,行数
    self.photoScrollView.contentSize = CGSizeMake(760, row*220+(row-1)*40+20);
    
    int x = 0, y = 0;
    for(int i = 0; i < count; i++)
    {
        if(x == 3)
        {
            x = 0;
            y++;
        }
        
        if(i != count-1)
        {
            //预览图显示区域，添加触摸手势
            PDLargePhotoView *image = [[PDLargePhotoView alloc] initWithFrame:CGRectMake(10+x*260, 10+y*260, 220, 220)];
            //UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10+x*260, 10+y*260, 220, 220)];
            NSDictionary *picItem = [self.photoList objectAtIndex:i];
            
            NSString *fileName = [picItem objectForKey:@"FILE_NAME"];//图片名称
            //NSString *fileDesc = [picItem objectForKey:@"FILE_DESC"];//图片描述
            NSString *fileAuthor = [picItem objectForKey:@"FILE_Author"];//拍摄人
            NSString *filePath = [picItem objectForKey:@"FILE_PATH"];//图片路径
            NSString *fileLocalPath = [picItem objectForKey:@"FILE_LOCAL_PATH"];//图片本地路径
            int hasCachePic = [[picItem objectForKey:@"FILE_EXIST"] intValue];
            [image setDoubleTap:self.view andServiceCode:filePath andWithFileName:fileName andWithSatus:hasCachePic];
            //设置占位图片
            UIImage *d = nil;
            if(hasCachePic == 0)
            {
                
                NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:@"default_placehold" ofType:@"png"];
                d = [[UIImage alloc] initWithContentsOfFile:defaultFilePath];
                [image downloadFile];
            }
            else
            {
            
                d = [[UIImage alloc] initWithContentsOfFile:fileLocalPath];
            }
            image.image = d;
            image.tag = 100+i;
            image.userInteractionEnabled = YES;
            [self.photoScrollView addSubview:image];
            //图片名称            
            UILabel *photoDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 220-44, 220, 44)];
            photoDescLabel.textAlignment = UITextAlignmentCenter;
            photoDescLabel.numberOfLines = 0;
            photoDescLabel.backgroundColor = [UIColor whiteColor];
            photoDescLabel.text = [NSString stringWithFormat:@"%@\n上传人:%@",fileName, fileAuthor];
            [image addSubview:photoDescLabel];
            //设置边框
            CALayer *layer=[image layer];
            [layer setMasksToBounds:YES];
            [layer setBorderWidth:2];
            [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        }
        else
        {
            if(!self.isHisRecord)
            {
                //如果是最后一个位置，就是添加照片的选项
                UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(10+x*260, 10+y*260, 220, 220)];
                bg.userInteractionEnabled = YES;
                bg.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
                [self.photoScrollView addSubview:bg];
                //加号图片 92 × 89
                UIImageView *checked = [[UIImageView alloc] initWithFrame:CGRectMake((220-92)/2, (220-89)/2, 92, 89)];
                checked.image = [UIImage imageNamed:@"continue_add.png"];
                [bg addSubview:checked];
                //添加按钮
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, 0, 220, 220);
                [button addTarget:self action:@selector(addPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
                [bg addSubview:button];
                //添加边框
                CALayer *layer=[bg layer];
                [layer setMasksToBounds:YES];
                [layer setBorderWidth:5];
                [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
            }
        }
        x++;
    }
}

//添加照片按钮
- (void)addPhotoClick:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    self.currentRect = sender.frame;
    self.currentView = sender.superview;
    [actionSheet showFromRect:sender.frame inView:sender.superview animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不能拍照" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"图片");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            self.photoPopoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
            self.photoPopoverController.delegate = self;
            self.photoPopoverController.popoverContentSize = CGSizeMake(320, 400);
            //CGRect rect = CGRectMake(110, 220, 320, 400);
            [self.photoPopoverController presentPopoverFromRect:self.currentRect inView:self.currentView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

#pragma mark - Taking Photos

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(self.photoPopoverController)
    {
        [self.photoPopoverController dismissPopoverAnimated:YES];
    }
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
    BOOL ret = [fileManager createFileAtPath:[filePath stringByAppendingPathComponent:fileName] contents:data attributes:nil];
    if(ret)
    {
        //[self.photoList addObject:[filePath stringByAppendingPathComponent:fileName]];
    }
    
    PhotoProfileViewController *profile = [[PhotoProfileViewController alloc] initWithNibName:@"PhotoProfileViewController" bundle:nil];
    profile.filePath = [filePath stringByAppendingPathComponent:fileName];
    profile.xczfbh = self.xczfbh;
    profile.basebh = self.basebh;
    profile.delegate = self;
    profile.category = self.category;
    [self.navigationController pushViewController:profile animated:YES];
    
    //在主线程中刷新界面
    //[self makeView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIPopoverController Delegate Method

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if(self.photoPopoverController)
    {
        [self.photoPopoverController dismissPopoverAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int index = textField.superview.tag-100;
    NSString *from = [self.photoList objectAtIndex:index];
    if([from rangeOfString:[[from pathComponents] lastObject]].location != NSNotFound)
    {
        NSString *t = [from substringToIndex:[from rangeOfString:[[from pathComponents] lastObject]].location];
        if(textField.text.length > 0)
        {
            NSString *to = [t stringByAppendingPathComponent:textField.text];
            //[self.photoManager renamePhotoFromPath:from toPath:to];
            [self.photoList replaceObjectAtIndex:index withObject:to];
        }
    }
}

- (void)uploadWithStatus:(BOOL)isSuccess andWithInfo:(NSDictionary *)info
{
    if(isSuccess)
    {
        [self.photoList addObject:info];
        [self makeView];
    }
    
}

- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    if(tag != QUERY_YDZF_PIC_DATA )
        return [super processWebData:webData andTag:tag];
    if([webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    if(tag == QUERY_YDZF_PIC_DATA)
    {
        NSString *str = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSDictionary *tmpDict = [str objectFromJSONString];
        if(tmpDict != nil)
        {
            NSArray *tmpListAry = [tmpDict objectForKey:@"data"];
            if(tmpListAry != nil && tmpListAry.count > 0)
            {
                for (int i = 0; i < tmpListAry.count; i++)
                {
                    NSMutableDictionary *tmpPicItem = [[NSMutableDictionary alloc] initWithCapacity:0];
                    NSDictionary *picItem = [tmpListAry objectAtIndex:i];
                    
                    NSString *fileCode = [picItem objectForKey:@"BH"];//图片编号
                    NSString *fileName = [picItem objectForKey:@"FJMC"];//图片名称
                    NSString *fileDesc = [picItem objectForKey:@"FJBZ"];//图片描述
                    NSString *fileAuthor = [picItem objectForKey:@"CJR"];//拍摄人
                    NSString *fileDate = [picItem objectForKey:@"CJSJ"];//拍摄时间
                    NSString *fjdz = [picItem objectForKey:@"FJDZ"];
                  /*  NSRange range = [fjdz rangeOfString:@"\\"];
                    if(range.location != NSNotFound)
                    {
                        fjdz = [fjdz substringFromIndex:range.location + range.length];
                    }
                    NSString *filePath = fjdz;*/
                    [tmpPicItem setObject:@"" forKey:@"FILE_LOCAL_PATH"];
                    [tmpPicItem setObject:@"0" forKey:@"FILE_EXIST"];
                    [tmpPicItem setObject:fileCode forKey:@"FILE_CODE"];
                    [tmpPicItem setObject:fileName forKey:@"FILE_NAME"];
                    [tmpPicItem setObject:fileAuthor forKey:@"FILE_Author"];
                    [tmpPicItem setObject:fileDate forKey:@"FILE_Date"];
                    [tmpPicItem setObject:fileDesc forKey:@"FILE_DESC"];
                    [tmpPicItem setObject:fjdz forKey:@"FILE_PATH"];
                    [self.photoList addObject:tmpPicItem];
                }
                
            }
        }
    }
    
    [self makeView];
    
}

@end
