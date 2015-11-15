//
//  WrySiteOnInspectionController.h
//  BoandaProject
//
//  Created by 熊熙 on 14-1-16.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "BaseRecordViewController.h"
#import "PopupDateViewController.h"
#import "PersonChooseVC.h"
#import "SignNameController.h"
#import "CommenWordsViewController.h"
#import "BuildProjectViewController.h"
#import "DangerWasteViewController.h"
#import "SVSegmentedControl.h"
#import "MultiCommonPicker.h"

@interface WrySiteOnInspectionController : BaseRecordViewController<UITextFieldDelegate,UITextViewDelegate,PopupDateDelegate,PersonChooseResult,SignameDelegate,WordsDelegate,DoneValueDelegate,UITableViewDelegate,UITableViewDataSource,getJCPCDelegate,UITextViewDelegate> {
    
//    zzt实现互斥选择
    NSInteger _btnTag;
    bool _isFirst;
    UIScrollView *_bgScrollView;
    NSMutableArray *_tagArry;
    NSMutableDictionary *_svDic;
    
    BOOL isAnimation;
    
    //基本信息
    IBOutlet UITextField *wrymcTxt;
    IBOutlet UITextField *wrydzTxt;
    IBOutlet UITextField *frdbTxt;
    IBOutlet UITextField *frlxfsTxt;
    IBOutlet UITextField *hbfzrTxt;
    IBOutlet UITextField *hbfzrlxfsTxt;
    IBOutlet UITextField *jckssj;
    IBOutlet UITextField *jcjssj;
    IBOutlet UITextField *sshyTxt;

    IBOutlet UITextField *zfzhTxt;
    IBOutlet UIButton *checkBtn1;
    IBOutlet UIButton *checkBtn2;
    IBOutlet UIButton *checkBtn3;
    IBOutlet UIButton *checkBtn4;
    IBOutlet UIButton *checkOther;
    IBOutlet UITextField *checkQtTxt;
    IBOutlet UITextView  *jcxjTxtView;
    IBOutlet UITextView  *jcyjTxtView;
    IBOutlet UIButton *addBuildProject;
    IBOutlet UIButton *addNoReplyProject;
    IBOutlet UIButton *addDangerWaste;
    IBOutlet UIButton *queryHPSPProject;
    
    IBOutlet UIButton *gllbButton0;
    IBOutlet UIButton *gllbButton1;
    IBOutlet UIButton *gllbButton2;
    IBOutlet UIButton *gllbButton3;
    
    IBOutlet UIButton *sczkButton0;
    IBOutlet UIButton *sczkButton1;
    IBOutlet UIButton *sczkButton2;
    IBOutlet UIButton *sczkButton3;
    IBOutlet UIButton *sczkButton4;
    
    IBOutlet UIButton *jcxjButton0;
    IBOutlet UIButton *jcxjButton1;
    IBOutlet UIButton *jcxjButton2;
    IBOutlet UIButton *jcxjButton3;
    
    //监察记录
    IBOutlet UITextField *jcryTxt;
    IBOutlet UITextField *cjryTxt;
    IBOutlet UITextField *xcfzrTxt;
    IBOutlet UITextField *xcfzrzwTxt;
    IBOutlet UITextField *xcfzrlxdhTxt;

    //帮助文档
    IBOutlet UIButton *bzwdButton;
    IBOutlet UILabel *bzwdLabel;
    
    //检查情况
    IBOutlet UIView *checkItemView;
    SVSegmentedControl *XJXMQK;
    SVSegmentedControl *FSQK;
    SVSegmentedControl *GYFQ;
    SVSegmentedControl *GLFQ;
    SVSegmentedControl *PTGF;
    SVSegmentedControl *WXFW;
    SVSegmentedControl *ZXJC;
    SVSegmentedControl *HJYJ;
    SVSegmentedControl *LDZDHY;
    
    //废水情况
    IBOutlet UISegmentedControl *ywflSegment;
    IBOutlet UITextField *ywflqkTxt;
    IBOutlet UISegmentedControl *psqkSegment;
    IBOutlet UITextField *psqkxqTxt;
    IBOutlet UISegmentedControl *pkszSegment;
    IBOutlet UITextField *pkszxqTxt;
    IBOutlet UISegmentedControl *fsssyxSegment;
    IBOutlet UITextField *fsssyxxqTxt;
    IBOutlet UISegmentedControl *fsyjtjSegment;
    IBOutlet UITextField *fsyjtjxqTxt;
    IBOutlet UISegmentedControl *fsyxtzSegment;
    IBOutlet UITextField *fsyxtzxqTxt;
    IBOutlet UISegmentedControl *zshyqkSegment;
    IBOutlet UITextField *zshyqkxqTxt;
    IBOutlet UISegmentedControl *xccySegment;
    IBOutlet UISegmentedControl *jcjgSegment;
    IBOutlet UITextField *jcjgxqTxt;
    IBOutlet UITextView  *fsqkqtView;
    
    //工艺废气
    IBOutlet UISegmentedControl *ssyxSegment;
    IBOutlet UITextField *ssyxxqTxt;
    IBOutlet UISegmentedControl *yjtjSegment;
    IBOutlet UITextField *yjtjxqTxt;
    IBOutlet UISegmentedControl *yxtzSegment;
    IBOutlet UITextField *yxtzxqTxt;
    IBOutlet UISegmentedControl *fqsjSegment;
    IBOutlet UITextField *fqsjxqTxt;
    IBOutlet UITextView  *gyfqqtView;
    
    //锅炉废气
    IBOutlet UISegmentedControl *rllxSegment;
    IBOutlet UITextField *rllxxqTxt;
    IBOutlet UISegmentedControl *rlpfyqSegment;
    IBOutlet UITextField *rlpfyqxqTxt;
    IBOutlet UISegmentedControl *glssyxSegment;
    IBOutlet UITextField *glssyxxqTxt;
    IBOutlet UISegmentedControl *glyjtjSegment;
    IBOutlet UITextField *glyjtjxqTxt;
    IBOutlet UISegmentedControl *glyxtzSegment;
    IBOutlet UITextField *glyxtzxqTxt;
    IBOutlet UITextView  *glfqqtView;
    
    //普通固废
    IBOutlet UISegmentedControl *zccsSegment;
    IBOutlet UITextField *zccsxqTxt;
    IBOutlet UISegmentedControl *bzbsSegment;
    IBOutlet UITextField *bzbsxqTxt;
    IBOutlet UISegmentedControl *czfsSegment;
    IBOutlet UITextField *czfsxqTxt;
    IBOutlet UISegmentedControl *tzdjSegment;
    IBOutlet UITextField *tzdjxqTxt;
    IBOutlet UITextView  *ptgfqtView;
    
    //在线监测
    IBOutlet UISegmentedControl *sblxSegment;
    IBOutlet UISegmentedControl *jsazSegment;
    IBOutlet UITextField *jsazxqTxt;
    IBOutlet UISegmentedControl *yxqkSegment;
    IBOutlet UISegmentedControl *ywtzSegment;
    IBOutlet UITextField *ywtzxqTxt;
    IBOutlet UISegmentedControl *jcsjSegment;
    IBOutlet UITextField *jcphTxt;
    IBOutlet UITextField *jccodTxt;
    IBOutlet UITextField *jcadTxt;
    IBOutlet UITextField *jcqtTxt;
    IBOutlet UITextView  *zxjcqtView;
    
    //六大重点行业
    IBOutlet UISegmentedControl *zxjcqkSegment;
    IBOutlet UISegmentedControl *zxjcfsSegment;
    IBOutlet UISegmentedControl *sysjcnlSegment;
    IBOutlet UISegmentedControl *wtjcbgSegment;
    IBOutlet UISegmentedControl *jctzSegment;
    IBOutlet UITextField *jctzxqTxt;
    IBOutlet UISegmentedControl *jcsjsbqkSegment;
    IBOutlet UITextField *qykzwryzTxt;
    IBOutlet UITextField *sjjcwryzTxt;
    IBOutlet UITextField *zxjccsTxt;
    IBOutlet UITextField *wtjccsTxt;
    IBOutlet UITextField *wtjcdwTxt;
    IBOutlet UITextView  *ldhyqtView;
    
    //环境应急
    IBOutlet UISegmentedControl *yjssSegment;
    IBOutlet UITextField *yjssxqTxt;
    IBOutlet UISegmentedControl *yjyaSegment;
    IBOutlet UISegmentedControl *yjwzSegment;
    IBOutlet UITextField *yjwzxqTxt;
    IBOutlet UISegmentedControl *yjylSegment;
    IBOutlet UITextView  *hjyjqtView;
    
    NSInteger currentTag;
}

@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *buildProject;
@property (nonatomic, strong) IBOutlet UITableView *buildProjectTable;
@property (nonatomic, strong) IBOutlet UITableView *dangerWasteTable;
@property (nonatomic, strong) IBOutlet UIView *wasteWater;
@property (nonatomic, strong) IBOutlet UIView *techGas;
@property (nonatomic, strong) IBOutlet UIView *boilerGas;
@property (nonatomic, strong) IBOutlet UIView *normalSolidWaste;
@property (nonatomic, strong) IBOutlet UIView *dangerWaste;
@property (nonatomic, strong) IBOutlet UIView *onlineMonitor;
@property (nonatomic, strong) IBOutlet UIView *envEmergency;
@property (nonatomic, strong) IBOutlet UIView *sixKeyIndustry;
@property (nonatomic, strong) IBOutlet UIView *opinion;

@property (nonatomic, strong) UITextField *txtCtrl;
@property (nonatomic, strong) UIButton *gllbButton;
@property (nonatomic, strong) UIButton *sczkButton;
@property (nonatomic, strong) NSMutableArray *buildProjects;
@property (nonatomic, strong) NSMutableArray *dangerWastes;
@property (nonatomic, strong) NSMutableString *jcxjString;
@property (nonatomic, strong) UIButton *jcxjButton;
@property (nonatomic, strong) NSMutableArray *checkItems;
@property (nonatomic, strong) NSMutableArray *checkTags;
@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) NSMutableArray  *checkSubjectAry;
@property (nonatomic, copy)   NSString *checkSubjectStr;

- (IBAction)click:(id)sender;
//温州嘉泰餐饮有限公司
- (IBAction)selectCommenWords:(id)sender;
- (IBAction)radioSelect:(id)sender;

- (IBAction)multipleSelect:(id)sender;
- (IBAction)choosePerson:(id)sender;
- (IBAction)touchFromDate:(id)sender;
- (IBAction)recordRemarks:(id)sender;
- (IBAction)addBuildProjectInfo:(id)sender;
- (IBAction)queryHPSPProject:(id)sender;

@end
