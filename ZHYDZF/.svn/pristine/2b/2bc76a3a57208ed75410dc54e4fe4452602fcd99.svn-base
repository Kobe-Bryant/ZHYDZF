//
//  DudelViewController.m
//  Dudel
//
//  Created by JN on 2/23/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "DrawKYTViewController.h"
#import "EraserTool.h"
#import "TextTool.h"
#import "OMGToast.h"
#import "GUIDGenerator.h"
#import <QuartzCore/QuartzCore.h>
#import "ImgDrawingInfo.h"
#import "TextDrawingInfo.h"
#import "BackgroundDrawingInfo.h"
#import "ArrowLine.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "ASIHTTPRequest.h"
#import "MapViewController.h"
#define T_YDZF_XCKCBL_KYT @"T_YDZF_XCKCBL_KYT"
#define Save_KYT_LocalPath @"LocalXckyt"
#import "RecordsHelper.h"
//保存图片的名称，方便获取图片
@implementation UIMyImageView

@synthesize name;

@end

@implementation DrawKYTViewController
@synthesize currentTool, strokeColor, strokeWidth;
@synthesize iconsAry,textInfoAry;
@synthesize popGraphToolsController,popController;
@synthesize textButton,eraserButton,redoButton,pensButton,iconsButton,undoButton,fillColor;
@synthesize clearButton,networkQueue,isCKXQ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableName = T_YDZF_XCKCBL_KYT;
    }
    return self;
}
-(void)changeBtnImageStatus:(NSInteger)tagId{
    static int lastPressedBtn = 0;
    if(lastPressedBtn == tagId)return;
    UIButton *btn = nil;
    NSString *imageName = nil;
    switch (lastPressedBtn) {
        case 0:
            btn = pensButton;
            imageName = @"pens.png";
            break;
        case 1:
            btn = iconsButton;
            imageName = @"customicons.png";
            break;
        case 2:
            btn = textButton;
            imageName = @"inserttext.png";
            break;
        case 3:
            btn = eraserButton;
            imageName = @"eraser.png";
            break;
        case 4:
            btn = undoButton;
            imageName = @"undo.png";
            break;
        case 5:
            btn = redoButton;
            imageName = @"redo.png";
            break;
       
        case 7:
            btn = clearButton;
            imageName = @"clear.png";
            break;

        default:
            break;
    }
    lastPressedBtn = tagId;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
}
- (void)setCurrentTool:(id <Tool>)t {
    [currentTool deactivate];
    if (t != currentTool) {

        currentTool = t ;
        currentTool.delegate = self;
        //[self deselectAllToolButtons];
    }
    [dudelView setNeedsDisplay];
}
- (IBAction)touchTextItem:(id)sender{

        self.strokeColor = [UIColor blackColor];
        TextTool *tool = [TextTool sharedTextTool];
        self.currentTool = tool;
        [textButton setImage:[UIImage imageNamed:@"inserttext_highlighted.png"] forState:UIControlStateNormal];
        [self changeBtnImageStatus:textButton.tag];

}
- (IBAction)touchEraserItem:(id)sender{

	self.strokeColor = [UIColor whiteColor];
	self.currentTool = [EraserTool sharedEraserTool];
    [eraserButton setImage:[UIImage imageNamed:@"eraser_highlighted.png"] forState:UIControlStateNormal];
     [self changeBtnImageStatus:eraserButton.tag];

}
- (IBAction)touchClearAllItem:(id)sender{
    alertType = ALERT_REASEMAP;
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"您要清空画布吗?" 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:@"取消",nil];
    [alert show];
	
    [clearButton setImage:[UIImage imageNamed:@"clear_highlighted.png"] forState:UIControlStateNormal];
    [self changeBtnImageStatus:clearButton.tag];

}
-(IBAction)clipMaps:(id)sender{
    MapViewController *controller = [[MapViewController alloc] init];
    controller.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.modalPresentationStyle =  UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    nav.view.superview.frame = CGRectMake(0, 62, 768, 900);
}

-(void)returnClipedImage:(UIImage*)img{
    dudelView.bDrawBgImage = YES;
    dudelView.bgImage = img;
    [dudelView setNeedsDisplay];
}
//手势缩放
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    
    UIView *big = [gestureRecognizer view];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged)
    {
        if (big.tag == 101)
        {
            [gestureRecognizer view].transform = CGAffineTransformScale([gestureRecognizer view].transform, 1, 1); 
        } else
        {
            [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
            [gestureRecognizer setScale:1];
             
        }
    }
   
}


-(void)Zoom:(UIView*)sender 
{
    UIPinchGestureRecognizer *pinchGesture1 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    //[pinchGesture setDelegate:self];
    [sender addGestureRecognizer:pinchGesture1];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if ([toModifyView isKindOfClass:[UIMyImageView class]])
        {
             toModifyView.transform = CGAffineTransformScale(toModifyView.transform, 1.2, 1.2);
        }
        else
        {
            UITextView * curTextView = (UITextView*)toModifyView;
            CGFloat aFontSize = curTextView.font.pointSize + 3;//变化后字体大 
            
            CGFloat Factor = aFontSize/curTextView.font.pointSize;
            CGRect oldRect = curTextView.frame;
            CGRect newRect = oldRect;
            newRect.size.width *= Factor;
            newRect.size.height *= Factor;
            curTextView.frame = newRect;
            curTextView.font = [UIFont systemFontOfSize:aFontSize];
            
        }
         toModifyView.layer.borderWidth=0;       

    }
    else if(buttonIndex == 1)
    {
        if ([toModifyView isKindOfClass:[UIMyImageView class]])
        {
            toModifyView.transform = CGAffineTransformScale(toModifyView.transform, 0.8, 0.8);
        }
        else
        {
            UITextView * curTextView = (UITextView*)toModifyView;
            
            
            CGFloat oldFontSize = curTextView.font.pointSize;//开始前字体大小
            CGFloat newFontSize = oldFontSize - 3;
            
            CGFloat Factor = newFontSize/oldFontSize;
            CGRect oldRect = curTextView.frame;
            CGRect newRect = oldRect;
            newRect.size.width *= Factor;
            newRect.size.width = newRect.size.width+3;
            newRect.size.height *= Factor;
            //newRect.size.height = InputField.contentSize.height;
            curTextView.frame = newRect;
            curTextView.font = [UIFont systemFontOfSize:newFontSize];
   
        }
        toModifyView.layer.borderWidth=0;
        
    }
    else if(buttonIndex == 2)
    {

        NSString *archiverPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"tmpCopyArchivePath.plist"];
        ////NSLog(@"archiverPath : %@", archiverPath);
        
        BOOL isOK = [NSKeyedArchiver archiveRootObject:toModifyView toFile:archiverPath];
        if (isOK) {
           // //NSLog(@"archiver success");
        }
        UIView *copyView = (UIView*)[NSKeyedUnarchiver unarchiveObjectWithFile:archiverPath];
        if (copyView) {
            copyView.center = CGPointMake(toModifyView.center.x + 30, toModifyView.center.y + 30);
            
            if ([toModifyView isKindOfClass:[UIMyImageView class]]) {
                UIMyImageView *myImage = (UIMyImageView*)toModifyView;
                UIMyImageView *myImage1 = (UIMyImageView*)copyView;
                myImage1.name = myImage.name;
                [iconsAry addObject:myImage1];
            }
            else
                [textInfoAry addObject:copyView];
            [dudelView addSubview:copyView];
        }

        toModifyView.layer.borderWidth=0;
    }
    else if (buttonIndex == 3) {
        if (toModifyType == IMG_COMPONET) {
            [toModifyView removeFromSuperview];
            [iconsAry removeObject:toModifyView];
            toModifyView = nil;
        }
        else if (toModifyType == LABEL_COMPONET){
            [toModifyView removeFromSuperview];
            [textInfoAry removeObject:toModifyView];
            toModifyView = nil;
        }
        
    }
    else if(buttonIndex == 4)
    {
        UITextView * curTextView = (UITextView*)toModifyView;
        curTextView.userInteractionEnabled = YES;
        curTextView.editable = YES;
        [curTextView becomeFirstResponder];
        
    }
        
}

-(void)toModifyViewPressed:(id)sender{
    UIActionSheet *sheet;
    UIView *aView = (UIView *)sender;
    if ([sender isKindOfClass:[UIMyImageView class]])
    {
        sheet = [[ UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"放大",@"缩小",@"复制",@"删除",nil];
    }
    else
    {
        UITextView * curTextView = (UITextView*)toModifyView;
        sheet = [[ UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"放大",@"缩小",@"复制",@"删除",@"编辑",nil];
        curTextView.delegate = self;
        
    }
    [sheet showFromRect:aView.frame inView:dudelView animated:YES];
    toModifyView = aView;
}


-(void)selectedItemImageName:(NSString*)imgName{
    [self setCurrentTool:nil];//去掉正在使用的图形
    
    UIMyImageView *imgView = [[UIMyImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    imgView.name = imgName;
    [dudelView addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    imgView.tag = 1;
    imgView.center = self.view.center;
    [self Zoom:imgView];//图片缩放
    [iconsAry addObject:imgView];
    [popController dismissPopoverAnimated:YES];
}

-(void)returnSelectedTool:(id <Tool>)aTool{
    [self setCurrentTool:aTool];
    self.strokeColor = [UIColor blackColor];
    [popGraphToolsController dismissPopoverAnimated:YES];
}


-(IBAction)touchTools:(id)sender{    

    UIButton *btn = (UIButton*)sender;
    [pensButton setImage:[UIImage imageNamed:@"pens_highlighted.png"] forState:UIControlStateNormal];
    [self changeBtnImageStatus:btn.tag];
    if (popGraphToolsController == nil) {
        UIGraphicToolsController *toolsViewController = [[UIGraphicToolsController alloc] initWithNibName:@"UIGraphicToolsController" bundle:nil]; 
        toolsViewController.delegate = self;
        self.popGraphToolsController = [[UIPopoverController alloc] initWithContentViewController:                                         toolsViewController];
        
    }
    [popController dismissPopoverAnimated:YES];
    [popGraphToolsController presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (IBAction)touchImageItem:(id)sender{
    UIButton *btn = (UIButton*)sender;
    
    [iconsButton setImage:[UIImage imageNamed:@"customicons_highlighted.png"] forState:UIControlStateNormal];
    [self changeBtnImageStatus:btn.tag];
    
    if (popController == nil) {
        CustomIconsViewController *iconsViewController = [[CustomIconsViewController alloc] initWithNibName:@"CustomIconsViewController" bundle:nil]; 
        iconsViewController.delegate = self;
        self.popController = [[UIPopoverController alloc] initWithContentViewController:
                               iconsViewController];
   
    }
    [popGraphToolsController dismissPopoverAnimated:YES];
    [popController presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
  
}

- (IBAction)touchUndoItem:(id)sender{//撤销
    
    UIButton *btn = (UIButton*)sender;
    [undoButton setImage:[UIImage imageNamed:@"undo_highlighted.png"] forState:UIControlStateNormal];
    [self changeBtnImageStatus:btn.tag];
    
    if ([dudelView.drawables count] > 0) {
        if (deletedDrawInfoAry == nil) {
            deletedDrawInfoAry = [[NSMutableArray alloc ] initWithCapacity:10];
        }
        id lastDeletedDrawInfo =[dudelView.drawables lastObject];
        [deletedDrawInfoAry addObject:lastDeletedDrawInfo];
        //[currentTool deleteLastPoint:YES];
        [dudelView.drawables removeLastObject];
        [dudelView setNeedsDisplay];
        
    }
    
}

- (IBAction)touchRedoItem:(id)sender{//重做
    UIButton *btn = (UIButton*)sender;
    [redoButton setImage:[UIImage imageNamed:@"redo_highlighted.png"] forState:UIControlStateNormal];
    [self changeBtnImageStatus:btn.tag];
    
    if (deletedDrawInfoAry && [deletedDrawInfoAry count]>0) {
        id lastDeletedDrawInfo =[deletedDrawInfoAry lastObject];
        [dudelView.drawables addObject:lastDeletedDrawInfo];
        [deletedDrawInfoAry removeLastObject];
        
        [dudelView setNeedsDisplay];
    }
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UIView * curTextView = (UIView*)toModifyView;
    [curTextView resignFirstResponder];
    if (isSwitch == YES) {
        isTwoFinger = YES;
        [dudelView setMultipleTouchEnabled:YES];
    }
    else{
        isTwoFinger = NO;
        //[dudelView setMultipleTouchEnabled:NO];
    }
    isSwitch = YES;
    if ([touches count]==2) {
        if (isTwoFinger == YES) {
            [currentTool touchesEnded:touches withEvent:event];
            [dudelView setNeedsDisplay];
        }
        return;
    }
    if (isTwoFinger == NO) {
         
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:dudelView];
        for (UIMyImageView *icon in iconsAry) {
            if (CGRectContainsPoint(icon.frame ,location)) {
                toModifyView = icon;
                toModifyView.layer.borderColor = [UIColor orangeColor].CGColor;  //textview边框颜色
                toModifyView.layer.borderWidth = 2;
                toModifyType = IMG_COMPONET;
                if ([touch tapCount] >=2 ) {
                    
                    [self toModifyViewPressed:toModifyView];
                    
                }
                break;
            }
        }
        if (toModifyView == nil) {
            for(UITextView * aLabel in textInfoAry ) {
                if (CGRectContainsPoint(aLabel.frame ,location)) {
                    toModifyView = aLabel;
                    toModifyView.layer.borderColor = [UIColor orangeColor].CGColor;  //textview边框颜色
                    toModifyView.layer.borderWidth = 2;
                    toModifyType = LABEL_COMPONET;
                    if ([touch tapCount] >= 2 ) {
                        
                        [self toModifyViewPressed:toModifyView];
                        
                    }
                    break;
                }
            }
        }

        [currentTool touchesBegan:touches withEvent:event];
        [dudelView setNeedsDisplay];
        
    }
          
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count]==2) {
        if (isTwoFinger == YES) {
            [currentTool touchesEnded:touches withEvent:event];
            [dudelView setNeedsDisplay];
        }
        isSwitch = NO;
        isTouchIn = NO;
        return;
    }
    if (isTwoFinger == NO) {
        [dudelView setMultipleTouchEnabled:YES];
        if ([touches count]==1) {
            [currentTool touchesCancelled:touches withEvent:event];
            [currentTool touchesEnded:touches withEvent:event];
            [dudelView setNeedsDisplay];
            isSwitch = NO;
            isTouchIn = NO;
        }
    }
    else
    {
        [currentTool touchesEnded:touches withEvent:event];
        [dudelView setNeedsDisplay];
        isSwitch = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 2) {
        isSwitch = NO;
        isTouchIn = NO;
        return;
    }
    if (isTwoFinger == NO) {
        if (toModifyView != nil ) {
            toModifyView.layer.borderWidth = 0;
            toModifyView = nil;
        }
        else{
            [currentTool touchesEnded:touches withEvent:event];
            [dudelView setNeedsDisplay];
        }
        isTouchIn = NO;
        isSwitch = NO;
    }
    else
        isSwitch = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count]==2) {
        if (isTwoFinger == YES) {
            [currentTool touchesEnded:touches withEvent:event];
            [dudelView setNeedsDisplay];
        }
        return;
    }
    if (isTwoFinger == NO) {
        //isSwitch = YES;
        if (isTouchIn == YES ) {
            UITouch *touch = [touches anyObject];
            CGPoint pt = [touch locationInView:self.view];
            
            dudelView.center = CGPointMake(dudelView.center.x + (pt.x - movePt.x), dudelView.center.y + (pt.y - movePt.y));
            
            movePt = pt;
        }
        
        
        if (toModifyView != nil ) {
            UITouch *touch = [[event allTouches] anyObject];
            //UITouch *touch =  [[event touchesForView:dudelView]anyObject];
            CGPoint location = [touch locationInView:dudelView];
            toModifyView.center = location;
        }
        else{
            [currentTool touchesMoved:touches withEvent:event];
            [dudelView setNeedsDisplay];     
        }
        //isSwitch = NO;
    }
    
        
}


#pragma mark ToolDelegate

- (void)addDrawable:(id <Drawable>)d {
  [dudelView.drawables addObject:d];
  [dudelView setNeedsDisplay];
}

- (void) addTextLabel:(UITextView*)aLabel{
    if (textInfoAry == nil) {
        textInfoAry = [[NSMutableArray alloc] initWithCapacity:10];
    }
    //aLabel.userInteractionEnabled = YES;
    aLabel.tag = 1;
    [self Zoom:aLabel];
    [dudelView addSubview:aLabel];
    [textInfoAry addObject:aLabel];

    //InputField = [aLabel copy];
    self.currentTool = nil;
}

- (UIView *)viewForUseWithTool:(id <Tool>)t {
  return dudelView;
}

- (UIView *)viewForOwner:(id <Tool>)t{
    return self.view;
}

#pragma mark DudelViewDelegate
- (void)drawTemporary {
  [self.currentTool drawTemporary];
}


 
-(void)saveBilu:(id)sender
{
    [super saveBilu:sender];
    NSString *imgPath = [self generatePhoto];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileDir = [docPath stringByAppendingPathComponent:Save_KYT_LocalPath];
    [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",self.wrymc];
    
    NSString *dstPath=[fileDir stringByAppendingPathComponent:fileName];
    if([fileManager fileExistsAtPath:dstPath])
    {
        [fileManager removeItemAtPath:dstPath error:nil];
    }
    [fileManager copyItemAtPath:imgPath toPath:dstPath error:nil];
    NSLog(@"dstPath=%@",dstPath);
    
   // self.recordStatus= Record_SaveLocal;
    
    NSDictionary *dicData = [self getValueData];
    NSMutableDictionary *dicValue = [NSMutableDictionary dictionaryWithDictionary:dicData];
    [dicValue setValue:self.xczfbh forKey:@"XCZFBH"];
    [dicValue setValue:dstPath forKey:@"PATH"];
    [dicValue setValue:self.basebh forKey:@"BH"];
    [self saveLocalRecord:dicValue andPath:dstPath];
    
}

-(void)returnSites:(NSDictionary*)values outsideComp:(BOOL)bOut{
	if (values == nil) {
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
        if (bOut) {
            [btnTitleView setTitle:[values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
            self.wrymc = self.title = [values objectForKey:@"WRYMC"];
            self.dwbh = @"";
        }
        else
        {
            self.dwbh   = [values objectForKey:@"WRYBH"];
            self.wrymc = self.title =  [values objectForKey:@"WRYMC"];
            [btnTitleView setTitle: [values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
            self.dicWryInfo = values;
        }
        bOutSide = bOut;
        [self  queryXCZFBH];
        [super returnSites:values outsideComp:bOut];
        
	}
}

-(NSString*)generatePhoto{
    UIGraphicsBeginImageContext(dudelView.bounds.size);
    for (UIMyImageView *icon in iconsAry) {
        ImgDrawingInfo *info = [[ImgDrawingInfo alloc] initWithLocation:icon.center andSize:icon.frame.size andImage:icon.image];
        [self addDrawable:info];
    }
    //[iconsAry removeAllObjects];
    
    for (UITextView *aLabel in textInfoAry) {
        
        TextDrawingInfo *info = [TextDrawingInfo textDrawingInfoWithPath:[UIBezierPath bezierPathWithRect:aLabel.frame] text:aLabel.text strokeColor:aLabel.textColor font:aLabel.font];
        [self addDrawable:info];
    }
  //  [textInfoAry removeAllObjects];
    
    [dudelView drawRect:dudelView.bounds];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/xckyt.jpg"];
	// Write image to PNG
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:jpgPath])
    {
        [fileManager removeItemAtPath:jpgPath error:nil];
    }
	[UIImageJPEGRepresentation(image,0.7) writeToFile:jpgPath atomically:YES];
    return jpgPath;
}

-(void)commitBilu:(id)sender
{
    
    NSString *filePath = [self generatePhoto];
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
    
    [recordData setObject:[GUIDGenerator generateGUID] forKey:@"BH"];
    [recordData setObject:self.xczfbh forKey:@"XCZFBH"];
    [recordData setObject:filePath forKey:@"FJDZ"];
    [recordData setObject:sjqx forKey:@"SJQX"];
    [recordData setObject:uname forKey:@"CJR"];
    [recordData setObject:dateStr forKey:@"CJSJ"];
    [recordData setObject:uname forKey:@"XGR"];
    [recordData setObject:dateStr forKey:@"XGSJ"];
    [recordData setObject:ORGID forKey:@"ORGID"];
    
    downloadFileProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    downloadFileProgress.frame = CGRectMake(100, 400, 568, 30);
    [dudelView addSubview:downloadFileProgress];
    
	uploadManager = [[UploadFileManager alloc] init];
    uploadManager.delegate =self;
    uploadManager.myProgressView = downloadFileProgress;
    
    uploadManager.filePath = filePath;
    NSLog(@"filePath=%@",filePath);
    uploadManager.fileFields = [recordData JSONString];
    uploadManager.serviceType = @"UPLOAD_KYT_FILE";
    [uploadManager commitFile];
///Users/apple/Library/Application Support/iPhone Simulator/6.1/Applications/A2E977FB-F703-4465-B9C6-2AFBA9320A95/Documents/LocalXckyt/【测试】污染源名称.jpg
}

-(void)uploadFileSuccess:(BOOL)isSuccess{
    [downloadFileProgress removeFromSuperview];
    
    if (isSuccess) {
        NSMutableDictionary *recordData = [[NSMutableDictionary alloc] init];
        if(self.dicWryInfo)
            [recordData setDictionary:self.dicWryInfo];
        [recordData setObject:self.basebh forKey:@"BH"];
        [recordData setObject:self.xczfbh forKey:@"XCZFBH"];

        [self commitBaseRecordData:[self createBaseTableFromWryData:recordData]];
    }else{
        [self showAlertMessage:@"文件上传失败。"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dudelView.userInteractionEnabled = YES;
    [dudelView setMultipleTouchEnabled:YES ];
    isTouchIn = NO;
    isSwitch = NO;
    self.iconsAry = [[NSMutableArray alloc] initWithCapacity:10];
    self.textInfoAry = [[NSMutableArray alloc] initWithCapacity:10];

    dudelView.layer.borderColor = UIColor.grayColor.CGColor;
    dudelView.layer.borderWidth = 2;
    dudelView.tag = 101;
    
    if (self.unCommitedBilu) {
        NSFileManager *file = [NSFileManager defaultManager];
        NSData *data = [file contentsAtPath:self.bgPath];
        dudelView.bDrawBgImage = YES;
        dudelView.bgImage = [UIImage imageWithData:data];
    }
    
    [self Zoom:dudelView];
    self.strokeColor = [UIColor blackColor];
    self.fillColor = [UIColor clearColor];
    self.strokeWidth = 2.0;

}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
//清空画布
-(void)eraseMap{
    [dudelView.drawables removeAllObjects];
    for (UIImageView *icon in iconsAry) {
        [icon removeFromSuperview];
    }
    [iconsAry removeAllObjects];
    for(UITextView *aLabel in textInfoAry) {
        
        [aLabel removeFromSuperview];
    }
    [textInfoAry removeAllObjects];
    [dudelView setNeedsDisplay];
    [currentTool deactivate];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertType == ALERT_REASEMAP){
        if (buttonIndex == 0) {
            [self eraseMap];
        }
        alertType = nil;
    }else{
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    CGSize size = [textView.text sizeWithFont:textView.font constrainedToSize:textView.frame.size];
    CGRect rect = textView.frame;
    rect.size.height = textView.contentSize.height;
    rect.size.width = size.width+20;
    textView.frame = rect;
    //NSLog(@"%f %f",size.width,size.height);
    textView.userInteractionEnabled = NO;
    textView.layer.borderWidth=0; 

}


#pragma mark -
#pragma mark ChooseRecordDelegate delegate
-(void)returnHistoryRecord:(NSDictionary*)valuesData{
    [super returnHistoryRecord:valuesData];
    
    NSString *fjdz = [valuesData objectForKey:@"FJDZ"];
    
    if ([fjdz length] <= 0) {
        return;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"Documents/%@.jpg",self.xczfbh];
    NSString* tmpDirectory  = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"DOWN_OA_FILES" forKey:@"service"];
    [params setObject:@"DOWNLOAD_XCQZ_FILE" forKey:@"GLLX"];
    [params setObject:@".jpg" forKey:@"FJLX"];
    [params setObject:fjdz forKey:@"PATH"];//
    
    NSString *strURL = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"勘验图===%@",strURL);
    if(!self.networkQueue)
    {
        self.networkQueue = [[ASINetworkQueue alloc] init];
    }
                                                                                               
    [networkQueue reset];// 队列清零
    [networkQueue setShowAccurateProgress:YES]; // 进度精确显示
    [networkQueue setDelegate:self ]; // 设置队列的代理对象
    downloadFileProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    downloadFileProgress.frame = CGRectMake(100, 400, 568, 30);
    [dudelView addSubview:downloadFileProgress];
    
    ASIHTTPRequest *request;
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request setDownloadProgressDelegate:downloadFileProgress]; // 文件 1 的下载进度条
    [request setDownloadDestinationPath:tmpDirectory];
    
    [request setCompletionBlock :^( void ){
        NSData *downData = [NSData dataWithContentsOfFile:tmpDirectory];
        if(downData.length < 2)
            dudelView.bDrawBgImage = NO;
            
        else{
            dudelView.bDrawBgImage = YES;
            dudelView.bgImage = [UIImage imageWithContentsOfFile:tmpDirectory];
            [dudelView setNeedsDisplay];
        }
        // 使用 complete 块，在下载完时做一些事;
        [downloadFileProgress removeFromSuperview];

    }];
    [request setFailedBlock :^( void ){
        dudelView.bDrawBgImage = NO;
        [downloadFileProgress removeFromSuperview];
    }];
    [networkQueue addOperation :request];
    [networkQueue go]; // 队列任务开始
}

@end
