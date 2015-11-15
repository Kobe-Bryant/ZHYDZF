//
//  DudelViewController.h
//  Dudel
//
//  Created by JN on 2/23/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tool.h"
#import "DudelView.h"
#import "CustomIconsViewController.h"
#import "UIGraphicToolsController.h"
#import "BaseRecordViewController.h"
#import "UploadFileManager.h"
#import "ASINetworkQueue.h"
#import "MapViewController.h"

#define ALERT_RequestHisMap 1
#define ALERT_CommitMap     2
#define ALERT_REASEMAP      3
#define ALERT_CHOOSENEWWRY  4//重新选择污染源


#define IMG_COMPONET   1
#define LABEL_COMPONET 2
@interface UIMyImageView:UIImageView

@property(nonatomic,strong)NSString *name;
@end

@interface DrawKYTViewController : BaseRecordViewController <ToolDelegate, DudelViewDelegate,FileUploadDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITextViewDelegate,CustomIconDelegate,SelectGraphToolDelegate,MapClipDelegate> {

   
    IBOutlet DudelView *dudelView;
    UIColor *strokeColor;
    CGFloat strokeWidth;
    UIBarButtonItem *commitBar;
    MBProgressHUD *HUD;
    
    NSInteger alertType;

    BOOL bHaveShowIcons;

    NSMutableArray *iconsAry;//存放界面上所画的图标
    NSMutableArray *deletedDrawInfoAry;
    
    NSMutableArray *textInfoAry;//存放输入的信息 UILabel 可拖动
    UITextView *curLabel;
    
    UIView *toModifyView;
    int toModifyType;

    BOOL             isTouchIn;
    BOOL             isSwitch;
    BOOL             isTwoFinger;
    CGPoint			 movePt;
    UploadFileManager *uploadManager;
    UIProgressView *downloadFileProgress;
}

@property (strong, nonatomic) id <Tool> currentTool;
@property (retain, nonatomic) UIColor *strokeColor;
@property (assign, nonatomic) CGFloat strokeWidth;
@property (retain, nonatomic) UIColor *fillColor;
@property (nonatomic, copy) NSString *bgPath;
@property (nonatomic, retain) NSMutableArray *iconsAry;
@property (nonatomic, retain) NSMutableArray *textInfoAry;
@property (nonatomic, strong) ASINetworkQueue * networkQueue ;
@property(nonatomic,retain)UIPopoverController *popController;
@property(nonatomic,retain)UIPopoverController *popGraphToolsController;
@property (nonatomic, assign)BOOL isCKXQ;


@property (nonatomic, retain)IBOutlet UIButton *textButton;
@property (nonatomic, retain)IBOutlet UIButton *eraserButton;
@property (nonatomic, retain)IBOutlet UIButton *redoButton;
@property (nonatomic, retain)IBOutlet UIButton *pensButton;
@property (nonatomic, retain)IBOutlet UIButton *iconsButton;
@property (nonatomic, retain)IBOutlet UIButton *undoButton;
@property (nonatomic, retain)IBOutlet UIButton *clearButton;

- (IBAction)touchTextItem:(id)sender;
- (IBAction)touchEraserItem:(id)sender;
- (IBAction)touchClearAllItem:(id)sender;
- (IBAction)touchImageItem:(id)sender;
- (IBAction)touchUndoItem:(id)sender;//撤销
- (IBAction)touchRedoItem:(id)sender;//重做
-(IBAction)touchTools:(id)sender; //选择画笔工具
-(IBAction)clipMaps:(id)sender; //地图截图
@end

