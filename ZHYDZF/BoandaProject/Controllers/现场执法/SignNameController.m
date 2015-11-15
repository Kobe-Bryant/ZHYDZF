//
//  SignNameController.m
//  GMEPS_HZ
//
//  Created by 张 仁松 on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SignNameController.h"
#import "LoginViewController.h"
#import "GUIDGenerator.h"
#import "UIImage+Scale.h"
#import "OMGToast.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"
#import "RecordsHelper.h"

@interface SignNameController ()
@property(nonatomic,strong)NSString *fzrJpgPath;
@property(nonatomic,strong)MBProgressHUD *HUD;
@end

@implementation SignNameController
@synthesize HUD,signView,delegate,wrybh,wrymc,tableName,firstName,secondName,xczfbh,bh,fzrJpgPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        commitStatus = STATUS_NONE;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)clearPressed:(id)sender{
    
    if (isSave) {
        
        isSave = !isSave;
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    signView.needsErase = YES;
    [signView erase];
}
//lx 1表示执法人员签名 2表示被检查人签名
-(void)uploadSignature:(NSString*)filePath andLX:(NSString*)lx{
   
    //提交记录表数据
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    NSString *uname = [userInfo objectForKey:@"uname"];
    NSString *ORGID = [userInfo objectForKey:@"orgid"];
    NSString *sjqx = [userInfo objectForKey:@"sjqx"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *dateStr = [df stringFromDate:now];
    NSMutableDictionary *recordData = [NSMutableDictionary dictionaryWithCapacity:5];
    
    [recordData setObject:[NSString stringWithFormat:@"%@_%@",self.bh,lx] forKey:@"BH"];
    [recordData setObject:self.xczfbh forKey:@"XCZFBH"];
    [recordData setObject:lx forKey:@"FJBZ"];
    [recordData setObject:filePath forKey:@"FJDZ"];
    [recordData setObject:sjqx forKey:@"SJQX"];
    [recordData setObject:uname forKey:@"CJR"];
    [recordData setObject:dateStr forKey:@"CJSJ"];
    [recordData setObject:uname forKey:@"XGR"];
    [recordData setObject:dateStr forKey:@"XGSJ"];
    [recordData setObject:ORGID forKey:@"ORGID"];
    

	uploadManager = [[UploadFileManager alloc] init];
    uploadManager.delegate =self;
 
    
    uploadManager.filePath = filePath;
    uploadManager.fileFields = [recordData JSONString];
    uploadManager.serviceType = @"UPLOAD_SIGNATURE_FILE";
    [uploadManager commitFile];
}

-(IBAction)commitPressed:(id)sender{
    //[self  saveLocalSignImageDB:sender];
    //企业负责人 (0,0,590,190)
    
    //执法人员   (0,210,590,190*2) 需要对图片进行分割
    
    UIImage* origImage =  [signView capturePaintingImage];
    
    CGImageRef imageFuzeren = CGImageCreateWithImageInRect (origImage.CGImage,CGRectMake(0,0,590,190));
    
    CGImageRef imageZhifaren = CGImageCreateWithImageInRect (origImage.CGImage,CGRectMake(0,210,590,380));
    
    UIImage *fuzerenImg = [[UIImage alloc] initWithCGImage:imageFuzeren];
    UIImage *zhifarenImg = [[UIImage alloc] initWithCGImage:imageZhifaren];
    
    UIImage* scaledFuzerenImage = [fuzerenImg scaleToSize:CGSizeMake(590*0.2, 190*0.2)];
    UIImage* scaledZhifarenImage = [zhifarenImg scaleToSize:CGSizeMake(590*0.2,380*0.2)];
    
    
	NSString  *zfrJpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/zfrSignname.jpg"];
	[UIImageJPEGRepresentation(scaledZhifarenImage,0.7) writeToFile:zfrJpgPath atomically:YES];
    
    //负责人图片
    
    self.fzrJpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/fzrSignname.jpg"];
    [UIImageJPEGRepresentation(scaledFuzerenImage,0.7) writeToFile:fzrJpgPath atomically:YES];
    
    CGImageRelease(imageFuzeren);
    CGImageRelease(imageZhifaren);
    //[fuzerenImg release];
    //[zhifarenImg release];
    
    commitStatus = STATUS_ZFR;
  	
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = @"正在提交签名";
    [HUD show:YES];

    [self uploadSignature:zfrJpgPath andLX:[NSString stringWithFormat:@"%d",1]];
}

-(void)uploadFileSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        if (commitStatus == STATUS_FZR) {
            [delegate signFinished];
            if(HUD)  [HUD hide:YES];
            [HUD removeFromSuperview];
            [self dismissModalViewControllerAnimated:YES];
        }else if(commitStatus == STATUS_ZFR){
            commitStatus = STATUS_FZR;
            [self uploadSignature:fzrJpgPath andLX:[NSString stringWithFormat:@"%d",2]];
        }
       
    }else{
        
        [self commitFailed];
    }
}

-(void)cancelSignName:(id)sender{
    if(HUD)  [HUD hide:YES];
    [HUD removeFromSuperview];
    
    if (self.popRecordController != nil) {
        [self.popRecordController dismissPopoverAnimated:YES];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)saveLocalSignImageDB:(id)sender{
    
    if (isSave) {
        
        [OMGToast showWithText:@"签名已暂存在本地！" duration:1.0];
        return;
    }
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    
    NSString *jcr = [loginUsr objectForKey:@"userId"];
    UIImage* signImage =  [signView capturePaintingImage];
    
    RecordsHelper *helper = [[RecordsHelper alloc] init];
    
    NSData *imageData = UIImageJPEGRepresentation(signImage, 0.01);
    
    BOOL res = [helper saveSignName:imageData XCZFBH:xczfbh WRYMC:wrymc TableName:tableName JCR:jcr];
    if(res){
        [OMGToast showWithText:@"签名已暂存在本地！" duration:1.0];
    }
}

- (void)loadLocalSignImageDB:(id)sender {
    if (self.popRecordController == nil) {
        ChooseRecordViewController *tmpController =
        [[ChooseRecordViewController alloc] initWithStyle:UITableViewStylePlain];
        tmpController.blName = tableName;
        tmpController.wrymc = wrymc;
        tmpController.isSignature = YES;
        tmpController.contentSizeForViewInPopover = CGSizeMake(600, 400);
        tmpController.delegate = self;
        
        
        UINavigationController *tmpNav = [[UINavigationController alloc] initWithRootViewController:tmpController];
        UIPopoverController *tmpPopover = [[UIPopoverController alloc] initWithContentViewController:tmpNav];
        self.popRecordController = tmpPopover;
        [tmpController.tableView reloadData];
    }
    
    UINavigationController *navVC = (UINavigationController *)self.popRecordController.contentViewController;
    NSArray *contrArr = navVC.childViewControllers;
    if (contrArr.count>0) {
        ChooseRecordViewController *tmpController = [contrArr objectAtIndex:0];
        tmpController.isSignature = YES;
    }
    
    [self.popRecordController dismissPopoverAnimated:NO];
	[self.popRecordController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"现场执法签名";
    firstNameLabel.text = firstName;
    secondNameLabel.text = secondName;
    
//    UIToolbar *signToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 44.0)];
//    signToolBar.barStyle = UIBarStyleDefault;
//    
//    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelSignName:)];
//    
//    UIBarButtonItem *spaceItem0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    
//    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"现场执法签名" style:UIBarButtonItemStylePlain target:self action:nil];
//    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//  
//    
//   
//    signToolBar.items = [NSArray arrayWithObjects:cancelItem,spaceItem0,titleItem,spaceItem1,nil];
//    
//    [self.view addSubview:signToolBar];
    
    
    
    UIToolbar *signToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 44.0)];
    signToolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelSignName:)];
    
    UIBarButtonItem *spaceItem0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"现场执法签名" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"暂存签名" style:UIBarButtonItemStyleBordered target:self action:@selector(saveLocalSignImageDB:)];
    
    UIBarButtonItem *loadItem = [[UIBarButtonItem alloc] initWithTitle:@"获取暂存签名" style:UIBarButtonItemStyleBordered target:self action:@selector(loadLocalSignImageDB:)];
    
    signToolBar.items = [NSArray arrayWithObjects:cancelItem,spaceItem0,titleItem,spaceItem1,loadItem,saveItem,nil];
        
    [self.view addSubview:signToolBar];
 
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
	return YES;
}
-(void)commitFailed{
    if(HUD)  [HUD hide:YES];
    [HUD removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"提交签名到服务器失败！"  delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [[[alert subviews] objectAtIndex:2] setBackgroundColor:[UIColor colorWithRed:0.5 green:0.0f blue:0.0f alpha:1.0f]];
    [alert show];
    
}

#pragma mark-ChooseRecordDelegate
//zzt
- (void)returnHistoryRecord:(id)values{
    
    NSDictionary *dic = (NSDictionary *)values;
    NSData *data = [dic objectForKey:@"SignName"];
    UIImage *historyImage = [UIImage imageWithData:data];
    /*
     CALayer *imageLayer = [CALayer layer];
     imageLayer.backgroundColor = [[UIColor clearColor] CGColor];//设置背景色
     imageLayer.bounds = CGRectMake(0, 0, signView.frame.size.width, signView.frame.size.height);//层设置为图片大小
     imageLayer.contents = (id)[historyImage CGImage];//层的内容设置为图片
     //imageLayer.position = CGPointMake(1024/2 , 768/2);//层在view的位置
     [signView.layer addSublayer:imageLayer];//将层加到当前View的默认layer下
     */
    signView.layer.contents = (id)historyImage.CGImage;
    [self.popRecordController dismissPopoverAnimated:YES];
    isSave = YES;
}

@end
