//
//  WrySiteOnInspectionController.m
//  BoandaProject
//
//  Created by 熊熙 on 14-1-16.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "WrySiteOnInspectionController.h"
#import "LoginViewController.h"

#import "UISearchSitesController.h"
#import "QueryHPSPProjectViewController.h"
#import "GUIDGenerator.h"
#import "SharedInformations.h"
#import <QuartzCore/QuartzCore.h>
#import "PDJsonkit.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "UISelectPersonVC.h"
#import "DrawKYTViewController.h"
#import "AHAlertView.h"
#import "UIButton+Bootstrap.h"
#import "PDJsonkit.h"
#import <math.h>
#import "HelpeDocumentPreviceViewController.h"

@interface WrySiteOnInspectionController ()<SignameDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) BOOL hasShowKeyBoard;

@end

@implementation WrySiteOnInspectionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tableName = @"T_YDZF_WRYXCJCJL_NEW";
        self.checkTags =[[NSMutableArray alloc] initWithCapacity:1];
        self.checkItems = [[NSMutableArray alloc] initWithCapacity:1];
        self.checkSubjectAry = [NSMutableArray array];
        self.checkSubjectStr =  [[NSMutableString alloc] init];
        self.jcxjString = [[NSMutableString alloc] initWithCapacity:10];
        self.buildProjects = [NSMutableArray arrayWithCapacity:1];
        self.dangerWastes = [NSMutableArray arrayWithCapacity:1];
        isAnimation = NO;
    }
    return self;
}

- (void)initSubViews
{
    
    XJXMQK = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不检查", @"检查",nil]];
    [XJXMQK addTarget:self action:@selector(setCheckItem:) forControlEvents:UIControlEventValueChanged];
	XJXMQK.crossFadeLabelsOnDrag = YES;
	XJXMQK.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    XJXMQK.selectedIndex = 0;
    XJXMQK.tag = 0;
	[checkItemView addSubview:XJXMQK];
	XJXMQK.center = CGPointMake(214, 55);
    
    FSQK = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不检查", @"检查", nil]];
    [FSQK addTarget:self action:@selector(setCheckItem:) forControlEvents:
     UIControlEventValueChanged];
	FSQK.crossFadeLabelsOnDrag = YES;
	FSQK.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    FSQK.selectedIndex = 0;
	FSQK.tag = 1;
	[checkItemView addSubview:FSQK];
	FSQK.center = CGPointMake(454, 55);
    
    
    GYFQ = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不检查", @"检查", nil]];
    [GYFQ addTarget:self action:@selector(setCheckItem:) forControlEvents:
     UIControlEventValueChanged];
	GYFQ.crossFadeLabelsOnDrag = YES;
	GYFQ.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    GYFQ.selectedIndex = 0;
	GYFQ.tag = 2;
	[checkItemView addSubview:GYFQ];
	GYFQ.center = CGPointMake(684, 55);
    
    GLFQ = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不检查", @"检查", nil]];
    [GLFQ addTarget:self action:@selector(setCheckItem:) forControlEvents:
     UIControlEventValueChanged];
	GLFQ.crossFadeLabelsOnDrag = YES;
	GLFQ.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    GLFQ.selectedIndex = 0;
	GLFQ.tag = 3;
	[checkItemView addSubview:GLFQ];
	GLFQ.center = CGPointMake(214, 105);
    
    PTGF = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不检查", @"检查", nil]];
    [PTGF addTarget:self action:@selector(setCheckItem:) forControlEvents:
     UIControlEventValueChanged];
	PTGF.crossFadeLabelsOnDrag = YES;
	PTGF.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    PTGF.selectedIndex = 0;
	PTGF.tag = 4;
	[checkItemView addSubview:PTGF];
	PTGF.center = CGPointMake(454, 105);
    
    WXFW = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不检查", @"检查", nil]];
    [WXFW addTarget:self action:@selector(setCheckItem:) forControlEvents:
     UIControlEventValueChanged];
	WXFW.crossFadeLabelsOnDrag = YES;
	WXFW.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    WXFW.selectedIndex = 0;
	WXFW.tag = 5;
	[checkItemView addSubview:WXFW];
	WXFW.center = CGPointMake(684, 105);

    ZXJC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不检查", @"检查", nil]];
    [ZXJC addTarget:self action:@selector(setCheckItem:) forControlEvents:
     UIControlEventValueChanged];
    ZXJC.crossFadeLabelsOnDrag = YES;
	ZXJC.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    ZXJC.selectedIndex = 0;
    ZXJC.tag = 6;
	[checkItemView addSubview:ZXJC];
	ZXJC.center = CGPointMake(684, 155);
    
    HJYJ = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不检查", @"检查", nil]];
    [HJYJ addTarget:self action:@selector(setCheckItem:) forControlEvents:
     UIControlEventValueChanged];
	HJYJ.crossFadeLabelsOnDrag = YES;
	HJYJ.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    HJYJ.selectedIndex = 0;
	HJYJ.tag = 7;
	[checkItemView addSubview:HJYJ];
	HJYJ.center = CGPointMake(454, 155);
    
    LDZDHY = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不检查", @"检查", nil]];
    [LDZDHY addTarget:self action:@selector(setCheckItem:) forControlEvents:UIControlEventValueChanged];
	LDZDHY.crossFadeLabelsOnDrag = YES;
	LDZDHY.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    LDZDHY.selectedIndex = 0;
	LDZDHY.tag = 8;
	[checkItemView addSubview:LDZDHY];
	LDZDHY.center = CGPointMake(214, 155);
    

    
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    _tagArry = [[NSMutableArray alloc]initWithCapacity:0];
    //self.checkSubjectStr = [[NSMutableString alloc]initWithCapacity:0];
    _svDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [self initSubViews];
    
    [addNoReplyProject primaryStyle];
    [queryHPSPProject primaryStyle];
    [addBuildProject primaryStyle];
    [addDangerWaste primaryStyle];
    
    self.title = @"现场检查记录表";
    self.views = [[NSArray alloc] initWithObjects:_buildProject, _wasteWater, _techGas, _boilerGas,_normalSolidWaste, _dangerWaste, _onlineMonitor, _envEmergency, _sixKeyIndustry,nil];
    
    CGRect frame = self.opinion.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    frame = CGRectMake(0, 940, width, height);
    self.opinion.frame = frame;
    
    self.scrollView = (UIScrollView *)self.view;
    [self.scrollView setContentSize:CGSizeMake(768, 940+height)];
    self.scrollView.delaysContentTouches =NO;
    [self.view addSubview:self.opinion];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *current = [NSDate date];
    NSString *currentStr = [dateFormatter stringFromDate:current];
    //结束时间比当前时间晚30分钟
    NSString *overStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:30*60]];
    jckssj.text = currentStr;
    jcjssj.text = overStr;
    
    self.gllbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sczkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jcxjButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //帮助文档
    [bzwdButton addTarget:self action:@selector(onBZWDButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    bzwdLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *bzwdTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBZWDLabelClicked:)];
    [bzwdLabel addGestureRecognizer:bzwdTap];
    
    //键盘将要出现时的触发事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    
    //键盘将要消失时的触发事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark action event methods

/**
 *  暂存笔录 
 *
 *  @param sender
 */
-(void)saveBilu:(id)sender
{
    [super saveBilu:sender];
    
    NSString *errMsg = @"";
    if ([wrymcTxt.text length] <=0)
    {
        errMsg = @"企业名称不能为空。";
    }
    else if ([wrydzTxt.text length] <=0)
    {
        errMsg = @"企业地址不能为空。";
    }
    else if ([frdbTxt.text length] <=0)
    {
        errMsg = @"法人代表不能为空。";
    }
    else if ([hbfzrTxt.text length] <=0)
    {
        errMsg = @"环保负责人不能为空";
    }
    else if ([self.gllbButton.titleLabel.text length] <=0)
    {
        errMsg = @"请选择管理类别。";
    }
    else if ([self.sczkButton.titleLabel.text length] <=0)
    {
        errMsg = @"请选择生产状况。";
    }
    else if([sshyTxt.text length] <= 0)
    {
        errMsg = @"请选择所属行业。";
    }
    else if([self.checkSubjectStr length] <=0 )
    {
        errMsg = @"请选择检查事由。";
    }
    else if([jcryTxt.text length] <=0 )
    {
        errMsg = @"监察人员不能为空。";
    }
    else if([zfzhTxt.text length] <=0 )
    {
        errMsg = @"执法证号不能为空。";
    }
    
    if([errMsg length]>0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:errMsg
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithDictionary:[self getValueData]];
    NSString *xjxmStr = [self.buildProjects JSONString];
    NSString *wxfwStr = [self.dangerWastes JSONString];
    [dicData setValue:xjxmStr forKey:@"XJXMSTRING"];
    [dicData setValue:wxfwStr forKey:@"WXFWSTRING"];
    
    NSMutableDictionary *dicValue = [NSMutableDictionary dictionaryWithDictionary:dicData];
    [dicValue setValue:self.xczfbh forKey:@"XCZFBH"];
    [self saveLocalRecord:dicValue];
}

/**
 *  提交笔录
 *
 *  @param sender
 */
-(void)commitBilu:(id)sender
{
    NSString *errMsg = @"";
    if ([wrymcTxt.text length] <=0)
        errMsg = @"企业名称不能为空。";
    else if ([wrydzTxt.text length] <=0)
        errMsg = @"企业地址不能为空。";
    else if ([frdbTxt.text length] <=0)
        errMsg = @"法人代表不能为空。";
    else if ([hbfzrTxt.text length] <=0)
        errMsg = @"环保负责人不能为空";
    else if ([self.gllbButton.titleLabel.text length] <=0)
        errMsg = @"请选择管理类别。";
    else if ([self.sczkButton.titleLabel.text length] <=0)
        errMsg = @"请选择生产状况。";

    else if([sshyTxt.text length] <= 0){
        errMsg = @"请选择所属行业。";
    }
    else if([self.checkSubjectStr length] <=0 ) {
        errMsg = @"请选择检查事由。";
    }
    else if([jcryTxt.text length] <=0 ) {
        errMsg = @"监察人员不能为空。";
    }
    else if([zfzhTxt.text length] <=0 ) {
        errMsg = @"执法证号不能为空。";
    }
    
    if([errMsg length]>0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:errMsg
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
 
    AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"提示" message:@"是否手写签名？"];
    [alert setButtonTitleTextAttributes:[AHAlertView textAttributesWithFont:[UIFont boldSystemFontOfSize:18]
                                                      foregroundColor:[UIColor blackColor]
                                                          shadowColor:[UIColor blackColor]
                                                         shadowOffset:CGSizeMake(0, -1)]];

    [alert setCancelButtonTitle:@"是" block:^{
        [self signName];
    }];
    [alert setDestructiveButtonTitle:@"否" block:^{
          NSDictionary *dicValue = [self getValueData];
        	[self commitRecordDatas:dicValue];
    }];
    
    [alert show];
}

/**
 *  响应单选
 *
 *  @param sender
 */
- (IBAction)radioSelect:(id)sender
{
    
    if ([sender tag] == 101) {
        [self.gllbButton setImage:[UIImage imageNamed:@"RadioButton-Unselected.png"] forState:UIControlStateNormal];
        
        UIButton *titleButton = (UIButton *)sender;
        [titleButton setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
        
        self.gllbButton = titleButton;
    }
    else if([sender tag] == 102){
        [self.sczkButton setImage:[UIImage imageNamed:@"RadioButton-Unselected.png"] forState:UIControlStateNormal];
        
        UIButton *titleButton = (UIButton *)sender;
        [titleButton setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
        
        self.sczkButton = titleButton;
    }
    
    else {
        [self.jcxjButton setImage:[UIImage imageNamed:@"RadioButton-Unselected.png"] forState:UIControlStateNormal];
        UIButton *titleButton = (UIButton *)sender;[titleButton setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
    
    self.jcxjButton = titleButton;
    }
}

- (IBAction)recordRemarks:(id)sender
{
    UISegmentedControl *selectItem = (UISegmentedControl *)sender;
    NSLog(@"123");
    NSString *selectTitle = [selectItem  titleForSegmentAtIndex:[selectItem selectedSegmentIndex]];
    if ([selectTitle hasPrefix:@"不"] && [sender tag] == 901) {
        if ([self.jcxjString length] < 1) {
            [self.jcxjString appendString:@"项目批建:不符"];
        }
        else {
            [self.jcxjString appendString:@"  项目批建:不符"];
        }
    jcxjTxtView.text = self.jcxjString;
    }
}

- (IBAction)multiplePicker:(id)sender
{
    if([sender tag] == 302) {
        self.txtCtrl = zxjccsTxt;
    }
    
    else if([sender tag] == 303) {
        self.txtCtrl = wtjccsTxt;
    }
    
    NSArray *listArray = @[@"年", @"月", @"周", @"日"];
   
    MultiCommonPicker *multiCommonPicker = [[MultiCommonPicker alloc] init];
    multiCommonPicker.contentSizeForViewInPopover = CGSizeMake(360, 44*[listArray count]);
    multiCommonPicker.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:multiCommonPicker];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    self.popController = tmppopover;
    [self.popController presentPopoverFromRect:self.txtCtrl.frame
                                        inView:self.sixKeyIndustry
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}

- (IBAction)selectCommenWords:(id)sender
{
    NSArray *listArray = nil;
    if ([sender tag] == 301) {
        self.txtCtrl = sshyTxt;
        listArray = [NSArray arrayWithObjects:@"造纸", @"纺织印染", @"电镀", @"制革", @"水泥", @"火（热）电", @"铅蓄电池", @"医药化工", @"有机化工", @"生物农药化工", @"染化化工", @"精细化工", @"食品", @"机械加工", @"钢铁", @"玻璃制造", @"冶炼采矿", @"污水处理厂", @"三产", @"其他", nil];
        //listArray = @[@"电镀", @"化工", @"造纸", @"印染", @"污水处理厂", @"热电", @"其他" ];
    }
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController.contentSizeForViewInPopover = CGSizeMake(200, 44*[listArray count]);
	tmpController.delegate = self;
    tmpController.wordsAry = listArray;
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
    self.popController = tmppopover;
    
    [self.popController presentPopoverFromRect:self.txtCtrl.frame
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}

//检查事由-响应多选
- (IBAction)multipleSelect:(id)sender
{
    self.checkSubjectStr = @"";
    
    NSInteger tag = [sender tag];
    UIButton *selectBtn = (UIButton *)sender;
    _bgScrollView = (UIScrollView *)[selectBtn superview];
    
    if (_btnTag != tag - 1000)
    {
        //当前选中的和之前选中的不同
        if (_btnTag > 0)
        {
            UIButton *btn = (UIButton *)[[selectBtn superview] viewWithTag:_btnTag + 1000];
            [btn setImage:[UIImage imageNamed:@"noSelect.png"]
                 forState:UIControlStateNormal];
        }
        
        if (tag - 1000 == 5)
        {
            checkQtTxt.enabled = YES;
            [checkQtTxt becomeFirstResponder];
        }
        else
        {
            checkQtTxt.enabled = NO;
            checkQtTxt.text = @"";
            [checkQtTxt resignFirstResponder];
        }
        [selectBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        _btnTag = tag - 1000;
    }
    else
    {
        if (_btnTag == 5)
        {
            checkQtTxt.enabled = NO;
            checkQtTxt.text = @"";
            [checkQtTxt resignFirstResponder];
        }
        [selectBtn setImage:[UIImage imageNamed:@"noSelect.png"] forState:UIControlStateNormal];
        _btnTag = 0;
    }
    
    switch (tag - 1000)
    {
        case 1:
            self.checkSubjectStr = @"日常监察";
            break;
        case 2:
            self.checkSubjectStr = @"信访";
            break;
        case 3:
            self.checkSubjectStr = @"三同时";
            break;
        case 4:
            self.checkSubjectStr = @"应急专项";
            break;
        default:
            break;
    }
}

/**
 *  动态配置检查项
 *
 *  @param sender 检查项状态
 */

//zzt 点击调用的segment
- (void)setCheckItem:(SVSegmentedControl*)checkItem{
    
    
    if(isAnimation) return;
    isAnimation = YES;
    NSInteger tag = [checkItem tag];
    UIView *checkView = [self.views objectAtIndex:tag];
    CGFloat height = CGRectGetHeight(checkView.frame);
    CGFloat scrollHeight = self.scrollView.contentSize.height;
    if (checkItem.selectedIndex == 1) {
        [self insertCheckViewItem:checkView];
        [self.checkItems addObject:checkView];
        [self.checkTags  addObject:[NSNumber numberWithInteger:tag]];
        [self.scrollView setContentSize:CGSizeMake(768, scrollHeight+height)];
        isAnimation = NO;
        NSLog(@"121111");
    }
    else {
        [checkView removeFromSuperview];
        [self removeCheckViewItem:checkView];
        [self.checkItems removeObject:checkView];
        [self.checkTags  removeObject:[NSNumber numberWithInteger:tag]];
        [self.scrollView setContentSize:CGSizeMake(768, scrollHeight-height)];
        isAnimation = NO;
    }
}

- (IBAction)choosePerson:(id)sender{
    //隐藏键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UITextField *txtField =(UITextField*)sender;
    
    PersonChooseVC *controller = [[PersonChooseVC alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;
    controller.multiUsers = YES;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
    
    CGFloat scrollHeight = self.scrollView.contentSize.height;
    CGRect rect  = txtField.frame;
    rect.origin.y = scrollHeight -100;

    controller.contentSizeForViewInPopover = CGSizeMake(320.0, 640.0);
    //self.popController.popoverContentSize = CGSizeMake(320.0, 640.0);
	[self.popController presentPopoverFromRect:txtField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    currentTag = txtField.tag;
}

- (void)showBuildProjectDetailViewWithInfo:(NSDictionary *)infoDict isApproval:(BOOL)approval Row:(NSInteger)row isModify:(BOOL)enable {
    if (approval) {
        BuildProjectViewController *formViewController = [[BuildProjectViewController alloc] initWithNibName:@"BuildProjectView" bundle:nil];
        formViewController.delegate = self;
        formViewController.projectInfo = infoDict;
        formViewController.modify = enable;
        formViewController.index = row;
        formViewController.xcjcbh = self.basebh;
        formViewController.title = @"已批项目";
        formViewController.isApproval = approval;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:formViewController];
        nav.modalPresentationStyle =  UIModalPresentationFormSheet;
        [self presentModalViewController:nav animated:YES];
        CGRect frame = self.view.frame;
        nav.view.superview.frame = CGRectMake(frame.size.width/2-360, 184, 720, 508);
    }
    
    else {
        BuildProjectViewController *formViewController = [[BuildProjectViewController alloc] initWithNibName:@"NoReplayProjectView" bundle:nil];
        formViewController.delegate = self;
        formViewController.projectInfo = infoDict;
        formViewController.modify = enable;
        formViewController.index = row;
        formViewController.xcjcbh = self.basebh;
        formViewController.title = @"未批项目";
        formViewController.isApproval = approval;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:formViewController];
        
        nav.modalPresentationStyle =  UIModalPresentationFormSheet;
        [self presentModalViewController:nav animated:YES];
        CGRect frame = self.view.frame;
        nav.view.superview.frame = CGRectMake(frame.size.width/2-360, 184, 720, 348);
    }
}

- (void)showDangerWasteDetailViewWithInfo:(NSDictionary *)infoDict Row:(NSInteger)row isModify:(BOOL)enable{
    DangerWasteViewController *formViewController = [[DangerWasteViewController alloc] initWithNibName:@"DangerWasteViewController" bundle:nil];
    formViewController.delegate = self;
    formViewController.dangerWasteInfo = infoDict;
    formViewController.modify = enable;
    formViewController.index = row;
    formViewController.xcjcbh = self.basebh;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:formViewController];
    
	nav.modalPresentationStyle =  UIModalPresentationFormSheet;
	[self presentModalViewController:nav animated:YES];
    CGRect frame = self.view.frame;
    
	nav.view.superview.frame = CGRectMake(frame.size.width/2-360, 166, 720, 540);
}

/**
 *  弹出日期选择器
 *
 *  @param sender 接收器
 */
- (IBAction)touchFromDate:(id)sender
{
    //隐藏键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
	UIControl *btn =(UIControl*)sender;
    
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDateAndTime];
    
	dateController.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	
	UIPopoverController *popover =[[UIPopoverController alloc] initWithContentViewController:
                                   nav];
	self.popController = popover;
    
	[self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	currentTag = btn.tag;
}

- (IBAction)addBuildProjectInfo:(id)sender
{
    [self showBuildProjectDetailViewWithInfo:nil isApproval:YES Row:0 isModify:NO];
}

- (IBAction)queryHPSPProject:(id)sender
{
    QueryHPSPProjectViewController *formViewController = [[QueryHPSPProjectViewController alloc] initWithNibName:@"QueryHPSPProjectViewController" bundle:nil];
    formViewController.title = self.wrymc;
    formViewController.wrybh = self.dwbh;
	//[formViewController setDelegate:self];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:formViewController];
	nav.modalPresentationStyle =  UIModalPresentationFormSheet;
	[self presentModalViewController:nav animated:YES];
    CGRect frame = self.view.frame;
	nav.view.superview.frame = CGRectMake(frame.size.width/2-300, 160, 600,600);
}

- (IBAction)addNoreplayProjectInfo:(id)sender
{
    [self showBuildProjectDetailViewWithInfo:nil isApproval:NO Row:0 isModify:
     NO];
}

- (IBAction)addDangerWasteInfo:(id)sender
{
    [self showDangerWasteDetailViewWithInfo:nil Row:0 isModify:NO];

}

//帮助文档
- (void)onBZWDButtonClicked:(UIButton *)sender
{
    UIActionSheet *helpActionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择要查看的文档" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"工业企业现场检查表(包括台账清单)", @"污水处理厂台账清单", @"污水处理厂检查记录表", nil];
    [helpActionSheet showFromRect:sender.frame inView:self.view animated:YES];
}

//帮助文档
- (void)onBZWDLabelClicked:(UIGestureRecognizer *)sender
{
    UIView *view = [sender view];
    UIActionSheet *helpActionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择要查看的文档" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"工业企业现场检查表(包括台账清单)", @"污水处理厂台账清单", @"污水处理厂检查记录表", nil];
    [helpActionSheet showFromRect:view.frame inView:self.view animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *docTitle = @"";
    NSString *docName = @"";
    switch (buttonIndex) {
        case 0:
        docName = @"doc001";
        docTitle = @"工业企业现场检查表(包括台账清单)";
        break;
        case 1:
        docName = @"doc002";
        docTitle = @"污水处理厂台账清单";
        break;
        case 2:
        docName = @"doc003";
        docTitle = @"污水处理厂检查记录表";
        break;
        default:
        break;
    }
    if(docTitle.length <= 0)
    {
        return;
    }
    
    HelpeDocumentPreviceViewController *hpv = [[HelpeDocumentPreviceViewController alloc] init];
    hpv.docName = docName;
    hpv.docTitle = docTitle;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:hpv];
    [self presentModalViewController:navi animated:YES];
}
    
#pragma mark -
#pragma mark SelectSitesDelegate

/**
 *  获取企业信息
 *
 *  @param values 企业信息
 *  @param bOut   是否选择
 */
-(void)returnSites:(NSDictionary*)values outsideComp:(BOOL)bOut{
    
//    NSLog(@"values=%@",values);
    
    if (values == nil) {
 		[self.navigationController popViewControllerAnimated:YES];
 	}
 	else {
        if (bOut) {
            [btnTitleView setTitle:[values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
            wrymcTxt.text = self.title = self.wrymc = [values objectForKey:@"WRYMC"];
            self.dwbh = @"";
        }
        else
        {
    
            
            for (int i = 0; i < [[values allKeys] count]; i ++) {
                
                NSLog(@"%@:%@",[[values allKeys]objectAtIndex:i],[values valueForKey:[[values allKeys]objectAtIndex:i]]);
            }
            self.dwbh     = [values objectForKey:@"WRYBH"];
            wrymcTxt.text = [values objectForKey:@"WRYMC"];
            wrydzTxt.text = [values objectForKey:@"DWDZ"] ;
            frdbTxt.text  = [values objectForKey:@"FRDB"];
            hbfzrTxt.text = [values objectForKey:@"HBLXR"];
            frlxfsTxt.text = [values objectForKey:@"LXDH"];
            sshyTxt.text = [values objectForKey:@"SSHY"];
            NSLog(@"frlxfsTxt.text=%@",frlxfsTxt.text);
            hbfzrlxfsTxt.text = [values objectForKey:@"HBRLXDH"];
            
            
            NSString *gllbStr = [values objectForKey:@"GLLB"];
            NSArray *gllbs = @[@"国控", @"省控", @"市控", @"县(市、区)控" ];
            NSInteger index = [gllbs indexOfObject:gllbStr];
            switch (index) {
                case 0:
                    [gllbButton0 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
                    self.gllbButton = gllbButton0;
                    break;
                case 1:
                    [gllbButton1 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
                    self.gllbButton = gllbButton1;
                    break;
                case 2:
                    [gllbButton2 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
                    self.gllbButton = gllbButton2;
                    break;
                case 3:
                    [gllbButton3 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
                    self.gllbButton = gllbButton3;
                    break;
                default:
                    break;
            }
            
            
            NSString *sczkStr = [values objectForKey:@"SCQK"];
            NSArray *sczks = @[@"生产", @"停产", @"季节性停产", @"部分停产", @"关停" ];
            index = [sczks indexOfObject:sczkStr];
            switch (index) {
                case 0:
                    [sczkButton0 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
                    self.sczkButton = sczkButton0;
                    break;
                case 1:
                    [sczkButton1 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
                    self.sczkButton = sczkButton1;
                    break;
                case 2:
                    [sczkButton2 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
                    self.sczkButton = sczkButton2;
                    break;
                case 3:
                    [sczkButton3 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
                    self.sczkButton = sczkButton3;
                    break;
                case 4:
                    [sczkButton4 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
                    self.sczkButton = sczkButton4;
                    break;
                default:
                    break;
            }
            
            self.wrymc = self.title = wrymcTxt.text;
            [btnTitleView setTitle:self.title forState:UIControlStateNormal];
            self.dicWryInfo = values;

        }
        bOutSide = bOut;
        [self  queryXCZFBH];
        [super returnSites:values outsideComp:bOut];
	}
}

#pragma mark -
#pragma mark DoneValueDelegate 

- (void)returnValues:(NSDictionary *)values index:(NSInteger)row  modify:(BOOL)enable Tag:(NSInteger)tag
{
    if (tag == 0) {
        if (enable) {
            [self.buildProjects replaceObjectAtIndex:row withObject:values];
        }
        
        else {
            [self.buildProjects addObject:values];
        }
        
        [self.buildProjectTable reloadData];

    }
      
    else {
        if (enable) {
            [self.dangerWastes replaceObjectAtIndex:row withObject:values];
        }
        
        else {
            [self.dangerWastes addObject:values];
        }
        
        [self.dangerWasteTable reloadData];
    }
}

#pragma mark -
#pragma mark PopupDateDelegate

/**
 *  响应时间选取器选择
 *
 *  @param controller 时间选择器
 *  @param bSaved
 *  @param date       日期
 */
- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date {
    [self.popController dismissPopoverAnimated:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    switch (currentTag) {
        case 102:
            jckssj.text = dateString;
            //     //NSLog(@"11%@",XWKSSJ);
            //  self.TZSJDateValue = date;
            break;
        case 103:
            jcjssj.text = dateString;
            //  self.JSCLSJDateValue = date;
            break;
            
        default:
            break;
    }
    
    
    //NSLog(@"start:%@ end:%@",jckssj.text,jcjssj.text);
//    if ([jckssj.text compare:jcjssj.text] == NSOrderedDescending || [jckssj.text compare:jcjssj.text] == NSOrderedSame)
//    {
//        
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"提示"
//                              message:@"结束时间不能早于开始时间"
//                              delegate:self
//                              cancelButtonTitle:@"确定"
//                              otherButtonTitles:nil];
//        [alert show];
//        jcjssj.text= @"";
//    }
}

#pragma mark -
#pragma mark WordsDelegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    if(self.popController.popoverVisible) {
        [self.popController dismissPopoverAnimated:YES];
    }
    self.txtCtrl.text = words;
}

#pragma mark -
#pragma mark getJCPCDelegate
- (void)returnJCPC:(NSString *)jcpcStr {
     self.txtCtrl.text = jcpcStr;
     [self.popController dismissPopoverAnimated:YES];
}

/**
 *  人员选择
 *
 *  @param aryChoosed 
 */
-(void)personChoosed:(NSArray*)aryChoosed{
    
    if([aryChoosed count] < 1 ){
        NSString *msg = @"监察人员不能少于一人！";
        [self showAlertMessage:msg];
        return;
    }
    
    [self.popController dismissPopoverAnimated:YES];
    NSMutableString *strSLRName = [NSMutableString stringWithCapacity:20];
    NSMutableString *strSlrZFZH = [NSMutableString stringWithCapacity:20];
    
    for(NSDictionary *dicPerson in aryChoosed){
        NSString * zfzh = [dicPerson objectForKey:@"ZFZH"];

        if([strSLRName length] == 0){
            
            [strSLRName appendString:[dicPerson objectForKey:@"YHMC"]];
            if([zfzh length] > 0 && ![zfzh isEqualToString:@"null"])
                [strSlrZFZH appendString:zfzh];
        }else{
            [strSLRName appendFormat:@",%@",[dicPerson objectForKey:@"YHMC"]];
            if([zfzh length] > 0 && ![zfzh isEqualToString:@"null"])
                [strSlrZFZH appendFormat:@",%@",zfzh];
        }
    }
    
    NSLog(@"strSLRName=%@,strSlrZFZH=%@",strSLRName,strSlrZFZH);
    jcryTxt.text = strSLRName;
    zfzhTxt.text = strSlrZFZH;

}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
	
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 101) {
        
        if (textField.text.length != 0) {
            self.checkSubjectStr = textField.text;
            //[self.checkSubjectStr setString:textField.text];
        }
    } 
   
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
         return [self.dangerWastes count];
    }
    return [self.buildProjects count];
   
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:(indexPath.row%2 == 0) ? @"lightblue" : @"white" ofType:@"png"];
	UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
	cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage] ;
	cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	cell.backgroundView.frame = cell.bounds;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
//        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 600, 30)];
//        detailLabel.textAlignment = UITextAlignmentLeft;
//        detailLabel.textColor = [UIColor grayColor];
//        detailLabel.font = [UIFont systemFontOfSize:16];
//        detailLabel.backgroundColor = [UIColor clearColor];
//        detailLabel.tag = 101;
//        [cell.contentView addSubview:detailLabel];
    }
    
    NSInteger row = indexPath.row;
    NSInteger tag = tableView.tag;
    
    if (tag == 0 ) {
        NSDictionary *projectInfo = [self.buildProjects objectAtIndex:row];
        NSString *xmmc = [projectInfo objectForKey:@"XJXMXMMC"];
        NSString *jsnr = [projectInfo objectForKey:@"JSNR"];
        NSString *xmsp = [projectInfo objectForKey:@"XMSP"];
        BOOL approval = [xmsp boolValue];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.font  = [UIFont systemFontOfSize:20];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        
        if (approval) {
            cell.textLabel.text = xmmc;  
            cell.detailTextLabel.text = @"已审批";
        }
        else {
            cell.textLabel.text = jsnr;
            cell.detailTextLabel.text = @"未审批";
        }
    }
    
    else {
        NSDictionary *dangerWasteInfo = [self.dangerWastes objectAtIndex:row];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.font  = [UIFont systemFontOfSize:20];
        
        cell.textLabel.text = [dangerWasteInfo objectForKey:@"WXFWFWMC"];
        
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 滑动删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView.tag == 0) {
            [self.buildProjects removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        }
        
        else {
            [self.dangerWastes removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        NSDictionary *projectInfo = [self.buildProjects objectAtIndex:indexPath.row];
        NSString *xmsp = [projectInfo objectForKey:@"XMSP"];
        BOOL approval = [xmsp boolValue];
        
        [self showBuildProjectDetailViewWithInfo:projectInfo isApproval:approval Row:indexPath.row isModify:YES];
    }
   
    else {
        NSDictionary *dangerWasteInfo = [self.dangerWastes objectAtIndex:indexPath.row];
        [self showDangerWasteDetailViewWithInfo:dangerWasteInfo Row:indexPath.row isModify:YES];
    }
}


#pragma mark - 
#pragma mark Parser Network Data

//[{"MBBH":"2013082815162662fd52da9c19402b9f2611775a8d5a27","MBMC":"上海市现场检查记录","SIZE":0}]
-(void)processWebData:(NSData*)webData andTag:(NSInteger)tag
{
    if(tag != COMIT_BL_XCJCBL && tag != QUERY_XCKCBL_HISTORY)
        return [super processWebData:webData andTag:tag];
    if( [webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"result====%@",resultJSON);
    if (tag == COMIT_BL_XCJCBL) {
        
        NSRange result = [resultJSON rangeOfString:@"success"];
        NSLog(@"yaotijiaoshujule=%@",resultJSON);
//        return;
        if ( result.location!= NSNotFound) {
            NSDictionary *dicValue = [self getValueData];
            NSDictionary *baseTableJson = [self createBaseTableFromWryData:dicValue];
            [self commitBaseRecordData:baseTableJson];
            return;
        }
        else{
            
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"错误" message:@"笔录提交失败！"];
            
            [alert setCancelButtonTitle:@"确定" block:^{
                
            }];
            [alert setTitleTextAttributes:[AHAlertView textAttributesWithFont:[UIFont boldSystemFontOfSize:18]
                                                              foregroundColor:[UIColor redColor]
                                                                  shadowColor:[UIColor redColor]
                                                                 shadowOffset:CGSizeMake(0, -1)]];
            
            [alert setMessageTextAttributes:[AHAlertView textAttributesWithFont:[UIFont systemFontOfSize:14]
                                                                foregroundColor:[UIColor redColor]
                                                                    shadowColor:[UIColor redColor]
                                                                   shadowOffset:CGSizeMake(0, -1)]];
            [alert show];
            
        }
    }
    else if (tag == QUERY_XCKCBL_HISTORY) {
        
        NSDictionary *dicInfo = [resultJSON objectFromJSONString];
        if(dicInfo){
            NSArray *ary = [dicInfo objectForKey:@"data"];
            if ([ary count] > 0) {
                NSDictionary *dicRecordData = [ary objectAtIndex:0];
                [self displayRecordDatas:dicRecordData];
            }
        }
    }
}
-(void)processError:(NSError *)error{
    AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"错误" message:@"请求网络数据失败！"];
    
    [alert setCancelButtonTitle:@"确定" block:^{
        
    }];
    [alert setTitleTextAttributes:[AHAlertView textAttributesWithFont:[UIFont boldSystemFontOfSize:18]
                                                      foregroundColor:[UIColor redColor]
                                                          shadowColor:[UIColor redColor]
                                                         shadowOffset:CGSizeMake(0, -1)]];
    
    [alert setMessageTextAttributes:[AHAlertView textAttributesWithFont:[UIFont systemFontOfSize:14]
                                                        foregroundColor:[UIColor redColor]
                                                            shadowColor:[UIColor redColor]
                                                           shadowOffset:CGSizeMake(0, -1)]];
    [alert show];
}

#pragma mark -
#pragma mark private method

/**
 *  显示历史笔录的详情
 *
 *  @param object 详情字典
 */
-(void)displayRecordDatas:(NSDictionary*)object{
    //基本信息
    NSDictionary* valueDatas =[self modifyDicValues:object];
    
    
    for (int i = 0; i < [[valueDatas allKeys] count]; i ++) {
        
        NSLog(@"--%@:%@",[[valueDatas allKeys]objectAtIndex:i],[valueDatas valueForKey:[[valueDatas allKeys]objectAtIndex:i]]);
    }
    wrymcTxt.text = [valueDatas objectForKey:@"WRYMC"];
    wrydzTxt.text = [valueDatas objectForKey:@"WRYDZ"];
    frdbTxt.text = [valueDatas objectForKey:@"FRDB"];
    frlxfsTxt.text = [valueDatas objectForKey:@"FRLXFS"];

    hbfzrlxfsTxt.text = [valueDatas objectForKey:@"HBFZR"];
    hbfzrlxfsTxt.text = [valueDatas objectForKey:@"HBFZRLXFS"];
    jckssj.text = [valueDatas objectForKey:@"JCKSSJ"];
    jcjssj.text = [valueDatas objectForKey:@"JCJSSJ"];
    sshyTxt.text = [valueDatas objectForKey:@"SSHY"];
    jcxjTxtView.text = [valueDatas objectForKey:@"JCXJXXNR"];
    jcryTxt.text = [valueDatas objectForKey:@"JCRY"];
    jcyjTxtView.text = [valueDatas objectForKey:@"JCYJ"];
    zfzhTxt.text = [valueDatas objectForKey:@"ZFZH"];
    cjryTxt.text = [valueDatas objectForKey:@"CJRY"];
    xcfzrTxt.text = [valueDatas objectForKey:@"BJCDWXCFZR"];
    xcfzrzwTxt.text = [valueDatas objectForKey:@"BJCDWXCFZRZW"];
    xcfzrlxdhTxt.text = [valueDatas objectForKey:@"BJCDWXCFZRLXDH"];
    NSLog(@"frlxfsTxt.text=%@",frlxfsTxt.text);
    
    NSString *gllbStr = [valueDatas objectForKey:@"GLLB"];
    NSArray *gllbs = @[@"国控", @"省控", @"市控", @"县(市、区)控" ];
    NSInteger index = [gllbs indexOfObject:gllbStr];
    switch (index) {
        case 0:
            [gllbButton0 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.gllbButton = gllbButton0;
            break;
        case 1:
            [gllbButton1 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.gllbButton = gllbButton1;
            break;
        case 2:
            [gllbButton2 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.gllbButton = gllbButton2;
            break;
        case 3:
            [gllbButton3 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.gllbButton = gllbButton3;
            break;
        default:
            break;
    }
    
    NSString *sczkStr = [valueDatas objectForKey:@"SCQK"];
    NSArray *sczks = @[@"生产", @"停产", @"季节性停产", @"部分停产", @"关停" ];
    index = [sczks indexOfObject:sczkStr];
    switch (index) {
        case 0:
            [sczkButton0 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.sczkButton = sczkButton0;
            break;
        case 1:
            [sczkButton1 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.sczkButton = sczkButton1;
            break;
        case 2:
            [sczkButton2 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.sczkButton = sczkButton2;
            break;
        case 3:
            [sczkButton3 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.sczkButton = sczkButton3;
            break;
        case 4:
            [sczkButton4 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.sczkButton = sczkButton4;
            break;
        default:
            break;
    }
    
    NSString *jcxjStr = [valueDatas objectForKey:@"JCXJWFXW"];
    NSArray *jcxjs = @[@"未发现环境违法行为", @"未发现环境违法行为，但企业管理不到位", @"存在环境违法行为", @"其他" ];
    index = [jcxjs indexOfObject:jcxjStr];
    switch (index) {
        case 0:
            [jcxjButton0 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.jcxjButton = jcxjButton0;
            break;
        case 1:
            [jcxjButton1 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.jcxjButton = jcxjButton1;
            break;
        case 2:
            [jcxjButton2 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.jcxjButton = jcxjButton2;
            break;
        case 3:
            [jcxjButton3 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
            self.jcxjButton = jcxjButton3;
            break;
        default:
            break;
    }

    NSString *jcsyStr = [valueDatas objectForKey:@"JCSY"];
    NSArray *contentAry = [NSArray arrayWithObjects:@"日常监察", @"信访", @"三同时", @"应急专项", nil];
    NSArray *jcsyAry = [jcsyStr componentsSeparatedByString:@","];
    
    for (NSString *checkStr in jcsyAry)
    {
        NSInteger select = [contentAry indexOfObject:checkStr];
        switch (select)
        {
            case 0:
                [checkBtn1 setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                _btnTag = checkBtn1.tag - 1000;
                break;
            case 1:
                [checkBtn2 setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                _btnTag = checkBtn2.tag - 1000;
                break;
            case 2:
                [checkBtn3 setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                _btnTag = checkBtn3.tag - 1000;
                break;
            case 3:
                [checkBtn4 setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                _btnTag = checkBtn4.tag - 1000;
                break;
            default:
                [checkOther setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                checkQtTxt.text = checkStr;
                _btnTag = checkOther.tag - 1000;
                break;
        }
    }
    
    
    self.checkSubjectStr = jcsyStr;
    self.checkSubjectAry = [NSMutableArray arrayWithArray:jcsyAry];
    
    //检查情况
    XJXMQK.selectedIndex = [[valueDatas objectForKey:@"SFXJXMQK"] integerValue];
    FSQK.selectedIndex = [[valueDatas objectForKey:@"SFFSQK"] integerValue];
    GYFQ.selectedIndex = [[valueDatas objectForKey:@"SFGYFQ"] integerValue];
    GLFQ.selectedIndex = [[valueDatas objectForKey:@"SFGLFQ"] integerValue];
    PTGF.selectedIndex = [[valueDatas objectForKey:@"SFPTGF"] integerValue];
    WXFW.selectedIndex = [[valueDatas objectForKey:@"SFWXFW"] integerValue];
    ZXJC.selectedIndex = [[valueDatas objectForKey:@"SFZXJC"] integerValue];
    HJYJ.selectedIndex = [[valueDatas objectForKey:@"SFHJYJ"] integerValue];
    LDZDHY.selectedIndex = [[valueDatas objectForKey:@"SFZDHY"] integerValue];
    
    if (XJXMQK.selectedIndex) {
        [XJXMQK moveThumbToIndex:XJXMQK.selectedIndex animate:NO];
    }
    
    if (FSQK.selectedIndex) {
        [FSQK moveThumbToIndex:FSQK.selectedIndex animate:NO];
        
    }    
    if (GYFQ.selectedIndex) {
        [GYFQ moveThumbToIndex:GYFQ.selectedIndex animate:NO];
    }
    
    if (GLFQ.selectedIndex) {
        [GLFQ moveThumbToIndex:GLFQ.selectedIndex animate:NO];
    }
    
    if (PTGF.selectedIndex) {
        [PTGF moveThumbToIndex:PTGF.selectedIndex animate:NO];
    }
    
    if (WXFW.selectedIndex) {
        [WXFW moveThumbToIndex:WXFW.selectedIndex animate:NO];
    }
    
    if (ZXJC.selectedIndex) {
        [ZXJC moveThumbToIndex:ZXJC.selectedIndex animate:NO];
    }
    
    if (HJYJ.selectedIndex) {
        [HJYJ moveThumbToIndex:HJYJ.selectedIndex animate:NO];
    }
    
    if (LDZDHY.selectedIndex) {
        [LDZDHY moveThumbToIndex:LDZDHY.selectedIndex animate:NO];
    }
    
    
    //废水情况
    
    NSString *selectTitle = [valueDatas objectForKey:@"FSYWFL"];
    for (int n=0; n < ywflSegment.numberOfSegments; n++) {
        NSString *title = [ywflSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            ywflSegment.selectedSegmentIndex = n;
        }
    }
    ywflqkTxt.text = [valueDatas objectForKey:@"FSYWFLXQ"];
    
    selectTitle = [valueDatas objectForKey:@"FSPSQK"];
    for (int n=0; n < psqkSegment.numberOfSegments; n++) {
        NSString *title = [psqkSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            psqkSegment.selectedSegmentIndex = n;
        }
    }
    psqkxqTxt.text = [valueDatas objectForKey:@"FSPSQKXQ"];
    
    selectTitle = [valueDatas objectForKey:@"FSPKQK"];
    for (int n=0; n < pkszSegment.numberOfSegments; n++) {
        NSString *title = [pkszSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            pkszSegment.selectedSegmentIndex = n;
        }
    }
    pkszxqTxt.text = [valueDatas objectForKey:@"FSPKQKXQ"];
    
    selectTitle = [valueDatas objectForKey:@"FSSSYX"];
    for (int n=0; n < fsssyxSegment.numberOfSegments; n++) {
        NSString *title = [fsssyxSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            fsssyxSegment.selectedSegmentIndex = n;
        }
    }
    fsssyxxqTxt.text = [valueDatas objectForKey:@"FSSSYXXQ"];
    
    selectTitle = [valueDatas objectForKey:@"FSYJTJ"];
    for (int n=0; n < fsyjtjSegment.numberOfSegments; n++) {
        NSString *title = [fsyjtjSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            fsyjtjSegment.selectedSegmentIndex = n;
        }
    }
    fsyjtjxqTxt.text = [valueDatas objectForKey:@"FSYJTJXQ"];
    
    selectTitle = [valueDatas objectForKey:@"FSYXTZ"];
    for (int n=0; n < fsyxtzSegment.numberOfSegments; n++) {
        NSString *title = [fsyxtzSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            fsyxtzSegment.selectedSegmentIndex = n;
        }
    }
    fsyxtzxqTxt.text = [valueDatas objectForKey:@"FSYXTZXQ"];
    
    selectTitle = [valueDatas objectForKey:@"FSZSHYQK"];
    for (int n=0; n < zshyqkSegment.numberOfSegments; n++) {
        NSString *title = [zshyqkSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            zshyqkSegment.selectedSegmentIndex = n;
        }
    }
    zshyqkxqTxt.text = [valueDatas objectForKey:@"FSZSHYQKXQ"];
    
    selectTitle = [valueDatas objectForKey:@"FSXCCY"];
    for (int n=0; n < xccySegment.numberOfSegments; n++) {
        NSString *title = [xccySegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            xccySegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueDatas objectForKey:@"FSJCJG"];
    for (int n=0; n < jcjgSegment.numberOfSegments; n++) {
        NSString *title = [jcjgSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            jcjgSegment.selectedSegmentIndex = n;
        }
    }
    jcjgxqTxt.text = [valueDatas objectForKey:@"FSJCJGXQ"];
    fsqkqtView.text = [valueDatas objectForKey:@"FSQKQT"];

    
    //工艺废气
   selectTitle = [valueDatas objectForKey:@"GYFQSSYX"];
    for (int n=0; n < ssyxSegment.numberOfSegments; n++) {
        NSString *title = [ssyxSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            ssyxSegment.selectedSegmentIndex = n;
        }
    }
    ssyxxqTxt.text = [valueDatas objectForKey:@"GYFQSSYXXQ"];

    selectTitle = [valueDatas objectForKey:@"GYFQYJTJ"];
    for (int n=0; n < yjtjSegment.numberOfSegments; n++) {
        NSString *title = [yjtjSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            yjtjSegment.selectedSegmentIndex = n;
        }
    }
    yjtjxqTxt.text = [valueDatas objectForKey:@"GYFQYJTJXQ"];
    

    selectTitle = [valueDatas objectForKey:@"GYFQYXTZ"];
    for (int n=0; n < yxtzSegment.numberOfSegments; n++) {
        NSString *title = [yxtzSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            yxtzSegment.selectedSegmentIndex = n;
        }
    }
    yxtzxqTxt.text = [valueDatas objectForKey:@"GYFQYXTZXQ"];
    
    selectTitle = [valueDatas objectForKey:@"GYFQFQSJQK"];
    for (int n=0; n < fqsjSegment.numberOfSegments; n++) {
        NSString *title = [fqsjSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            fqsjSegment.selectedSegmentIndex = n;
        }
    }
    fqsjxqTxt.text = [valueDatas objectForKey:@"GYFQFQSJQKXQ"];
    gyfqqtView.text = [valueDatas objectForKey:@"GYFQQT"];
    
    //锅炉废气
    selectTitle = [valueDatas objectForKey:@"GLFQRLLX"];
    for (int n=0; n < rllxSegment.numberOfSegments; n++) {
        NSString *title = [rllxSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            rllxSegment.selectedSegmentIndex = n;
        }
    }
    rllxxqTxt.text = [valueDatas objectForKey:@"GLFQRLLXXQ"];

    selectTitle = [valueDatas objectForKey:@"GLFQRLYPFYQ"];
    for (int n=0; n < rlpfyqSegment.numberOfSegments; n++) {
        NSString *title = [rlpfyqSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            rlpfyqSegment.selectedSegmentIndex = n;
        }
    }
    rlpfyqxqTxt.text = [valueDatas objectForKey:@"GLFQRLYPFYQXQ"];

    selectTitle = [valueDatas objectForKey:@"GLFQSSYX"];
    for (int n=0; n < glssyxSegment.numberOfSegments; n++) {
        NSString *title = [glssyxSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            glssyxSegment.selectedSegmentIndex = n;
        }
    }
    glssyxxqTxt.text = [valueDatas objectForKey:@"GLFQSSYXXQ"];

    selectTitle = [valueDatas objectForKey:@"GLFQYJTJ"];
    for (int n=0; n < glyjtjSegment.numberOfSegments; n++) {
        NSString *title = [glyjtjSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            glyjtjSegment.selectedSegmentIndex = n;
        }
    }
    glyjtjxqTxt.text = [valueDatas objectForKey:@"GLFQYJTJXQ"];

    selectTitle = [valueDatas objectForKey:@"GLFQYXTZ"];
    for (int n=0; n < glyxtzSegment.numberOfSegments; n++) {
        NSString *title = [glyxtzSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            glyxtzSegment.selectedSegmentIndex = n;
        }
    }
    glyxtzxqTxt.text = [valueDatas objectForKey:@"GLFQYXTZXQ"];
    glfqqtView.text = [valueDatas objectForKey:@"GLFQQT"];
    
    //普通固废
    selectTitle = [valueDatas objectForKey:@"PTGFZCCS"];
    for (int n=0; n < zccsSegment.numberOfSegments; n++) {
        NSString *title = [zccsSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            zccsSegment.selectedSegmentIndex = n;
        }
    }
    zccsxqTxt.text = [valueDatas objectForKey:@"GLFQYXTZ"];
    
    selectTitle = [valueDatas objectForKey:@"PTGFBZBS"];
    for (int n=0; n < bzbsSegment.numberOfSegments; n++) {
        NSString *title = [bzbsSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            bzbsSegment.selectedSegmentIndex = n;
        }
    }
    bzbsxqTxt.text = [valueDatas objectForKey:@"PTGFBZBSXQ"];
    
    selectTitle = [valueDatas objectForKey:@"PTGFCZFS"];
    for (int n=0; n < czfsSegment.numberOfSegments; n++) {
        NSString *title = [czfsSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            czfsSegment.selectedSegmentIndex = n;
        }
    }
    czfsxqTxt.text = [valueDatas objectForKey:@"PTGFCZFSXQ"];
    
    selectTitle = [valueDatas objectForKey:@"PTGFTZDJ"];
    for (int n=0; n < tzdjSegment.numberOfSegments; n++) {
        NSString *title = [tzdjSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            tzdjSegment.selectedSegmentIndex = n;
        }
    }
    tzdjxqTxt.text = [valueDatas objectForKey:@"PTGFTZDJXQ"];
    ptgfqtView.text = [valueDatas objectForKey:@"PTGFQT"];
    
    //在线监测    
    selectTitle = [valueDatas objectForKey:@"ZXJCSBLX"];
    for (int n=0; n < sblxSegment.numberOfSegments; n++) {
        NSString *title = [sblxSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            sblxSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueDatas objectForKey:@"ZXJCJSAZ"];
    for (int n=0; n < jsazSegment.numberOfSegments; n++) {
        NSString *title = [jsazSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            jsazSegment.selectedSegmentIndex = n;
        }
    }
    jsazxqTxt.text = [valueDatas objectForKey:@"ZXJCJSAZXQ"];
    
    selectTitle = [valueDatas objectForKey:@"ZXJCYXQK"];
    for (int n=0; n < yxqkSegment.numberOfSegments; n++) {
        NSString *title = [yxqkSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            yxqkSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueDatas objectForKey:@"ZXJCYWTZ"];
    for (int n=0; n < ywtzSegment.numberOfSegments; n++) {
        NSString *title = [ywtzSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            ywtzSegment.selectedSegmentIndex = n;
        }
    }
    ywtzxqTxt.text = [valueDatas objectForKey:@"ZXJCYWTZXQ"];
    
    selectTitle = [valueDatas objectForKey:@"ZXJCJCSJCBQK"];
    for (int n=0; n < jcsjSegment.numberOfSegments; n++) {
        NSString *title = [jcsjSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            jcsjSegment.selectedSegmentIndex = n;
        }
    }
    
    jcphTxt.text = [valueDatas objectForKey:@"ZXJCJCSJPH"];
    jccodTxt.text = [valueDatas objectForKey:@"ZXJCJCSJCOD"];
    jcadTxt.text = [valueDatas objectForKey:@"ZXJCJCSJAD"];
    jcqtTxt.text = [valueDatas objectForKey:@"ZXJCJCSJQT"];
    zxjcqtView.text = [valueDatas objectForKey:@"ZXJCQT"];
    
    //六大行业
    selectTitle = [valueDatas objectForKey:@"LDHYQYZXJCQK"];
    for (int n=0; n < zxjcqkSegment.numberOfSegments; n++) {
        NSString *title = [zxjcqkSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            zxjcqkSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueDatas objectForKey:@"LDHYZXJCFS"];
    for (int n=0; n < zxjcfsSegment.numberOfSegments; n++) {
        NSString *title = [zxjcfsSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            zxjcfsSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueDatas objectForKey:@"LDHYSYSJCNL"];
    for (int n=0; n < sysjcnlSegment.numberOfSegments; n++) {
        NSString *title = [sysjcnlSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            sysjcnlSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueDatas objectForKey:@"LDHYWTJCBG"];
    for (int n=0; n < wtjcbgSegment.numberOfSegments; n++) {
        NSString *title = [wtjcbgSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            wtjcbgSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueDatas objectForKey:@"LDHYJCTZ"];
    for (int n=0; n < jctzSegment.numberOfSegments; n++) {
        NSString *title = [jctzSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            jctzSegment.selectedSegmentIndex = n;
        }
    }
    jctzxqTxt.text = [valueDatas objectForKey:@"LDHYJCTZXQ"];
    
    selectTitle = [valueDatas objectForKey:@"LDHYJCSJSBQK"];
    for (int n=0; n < jcsjsbqkSegment.numberOfSegments; n++) {
        NSString *title = [jcsjsbqkSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            jcsjsbqkSegment.selectedSegmentIndex = n;
        }
    }
    
    qykzwryzTxt.text = [valueDatas objectForKey:@"LDHYQYKZWRYZ"];
    sjjcwryzTxt.text = [valueDatas objectForKey:@"LDHYSJJCYZ"];
    zxjccsTxt.text = [valueDatas objectForKey:@"LDHYZXJCPC"];
    wtjccsTxt.text = [valueDatas objectForKey:@"LDHYWTJCPC"];
    wtjcdwTxt.text = [valueDatas objectForKey:@"LDHYWTJCDW"];
    ldhyqtView.text = [valueDatas objectForKey:@"LDHYQT"];
 
    //环境应急
    selectTitle = [valueDatas objectForKey:@"HJYJSS"];
    for (int n=0; n < yjssSegment.numberOfSegments; n++) {
        NSString *title = [yjssSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            yjssSegment.selectedSegmentIndex = n;
        }
    }
    yjssxqTxt.text = [valueDatas objectForKey:@"HJYJSSXQ"];
    
    selectTitle = [valueDatas objectForKey:@"HJYJYA"];
    for (int n=0; n < yjyaSegment.numberOfSegments; n++) {
        NSString *title = [yjyaSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            yjyaSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueDatas objectForKey:@"HJYJWZ"];
    for (int n=0; n < yjwzSegment.numberOfSegments; n++) {
        NSString *title = [yjwzSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            yjwzSegment.selectedSegmentIndex = n;
        }
    }
    yjwzxqTxt.text = [valueDatas objectForKey:@"HJYJWZXQ"];
    
    selectTitle = [valueDatas objectForKey:@"HJYJYL"];
    
    
    for (int n=0; n < yjylSegment.numberOfSegments; n++) {
        NSString *title = [yjylSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            
            yjylSegment.selectedSegmentIndex = n;
        }
    }
    
    hjyjqtView.text = [valueDatas objectForKey:@"HJYJQT"];
    
    NSString *xjxmStr = [valueDatas objectForKey:@"XJXMSTRING"];
    self.buildProjects = [NSMutableArray arrayWithArray:[xjxmStr objectFromJSONString]];
    
    NSString *wxfwStr = [valueDatas objectForKey:@"WXFWSTRING"];
    self.dangerWastes =  [NSMutableArray arrayWithArray:[wxfwStr objectFromJSONString]];
    
    [self.buildProjectTable reloadData];
    [self.dangerWasteTable reloadData];
}

#pragma mark- zzt
- (IBAction)click:(id)sender{

    UISegmentedControl *segC = (UISegmentedControl *)sender;
    NSString * str =[segC titleForSegmentAtIndex:segC.selectedSegmentIndex];

    NSNumber *numbTag = [NSNumber numberWithInt:segC.tag];
    if (segC.tag >= 90 && [str hasPrefix:@"不"]) {
        
        [_tagArry addObject:numbTag];
    }else{
    
        if ([_tagArry containsObject:numbTag]) {
            
            [_tagArry removeObject:numbTag];
        }
    }
}
- (NSDictionary*)getValueData
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:25];
     //if(self.dicWryInfo) [dicParams setDictionary:self.dicWryInfo];
    self.title = self.wrymc  = wrymcTxt.text;
    [btnTitleView setTitle:self.wrymc forState:UIControlStateNormal];
    //基本信息
    [dicParams setValue:self.wrymc forKey:@"WRYMC"];
    [dicParams setValue:wrydzTxt.text forKey:@"WRYDZ"];
    [dicParams setValue:frdbTxt.text forKey:@"FRDB"];
    [dicParams setValue:frlxfsTxt.text forKey:@"FRLXFS"];
    [dicParams setValue:hbfzrTxt.text forKey:@"HBFZR"];
    [dicParams setValue:hbfzrlxfsTxt.text forKey:@"HBFZRLXFS"];
    [dicParams setValue:jckssj.text forKey:@"JCKSSJ"];
    [dicParams setValue:jcjssj.text forKey:@"JCJSSJ"];
    [dicParams setValue:self.checkSubjectStr forKey:@"JCSY"];
    [dicParams setValue:sshyTxt.text forKey:@"SSHY"];
    [dicParams setValue:self.gllbButton.titleLabel.text forKey:@"GLLB"];
    [dicParams setValue:self.sczkButton.titleLabel.text forKey:@"SCQK"];
        
    //检查情况
    [dicParams setValue:[NSString stringWithFormat:@"%d",XJXMQK.selectedIndex] forKey:@"SFXJXMQK"];
    [dicParams setValue:[NSString stringWithFormat:@"%d",FSQK.selectedIndex]  forKey:@"SFFSQK"];
    [dicParams setValue:[NSString stringWithFormat:@"%d",GYFQ.selectedIndex]  forKey:@"SFGYFQ"];
    [dicParams setValue:[NSString stringWithFormat:@"%d",GLFQ.selectedIndex]  forKey:@"SFGLFQ"];
    [dicParams setValue:[NSString stringWithFormat:@"%d",PTGF.selectedIndex]  forKey:@"SFPTGF"];
    [dicParams setValue:[NSString stringWithFormat:@"%d",WXFW.selectedIndex]  forKey:@"SFWXFW"];
    [dicParams setValue:[NSString stringWithFormat:@"%d",ZXJC.selectedIndex]  forKey:@"SFZXJC"];
    [dicParams setValue:[NSString stringWithFormat:@"%d",HJYJ.selectedIndex]  forKey:@"SFHJYJ"];
    [dicParams setValue:[NSString stringWithFormat:@"%d",LDZDHY.selectedIndex]  forKey:@"SFZDHY"];
    
    
    //废水情况
    if (ywflSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[ywflSegment titleForSegmentAtIndex:ywflSegment.selectedSegmentIndex] forKey:@"FSYWFL"];
    }
    [dicParams setValue:ywflqkTxt.text forKey:@"FSYWFLXQ"];
    
    if (psqkSegment.selectedSegmentIndex != -1)
    {
        [dicParams setValue:[psqkSegment titleForSegmentAtIndex:psqkSegment.selectedSegmentIndex] forKey:@"FSPSQK"];
    }
    [dicParams setValue:psqkxqTxt.text forKey:@"FSPSQKXQ"];
    
    if (pkszSegment.selectedSegmentIndex != -1)
    {
        [dicParams setValue:[pkszSegment titleForSegmentAtIndex:pkszSegment.selectedSegmentIndex] forKey:@"FSPKQK"];
    }
    [dicParams setValue:pkszxqTxt.text forKey:@"FSPKQKXQ"];
    
    if (fsssyxSegment.selectedSegmentIndex != -1)
    {
        [dicParams setValue:[fsssyxSegment titleForSegmentAtIndex:fsssyxSegment.selectedSegmentIndex] forKey:@"FSSSYX"];
    }
    [dicParams setValue:fsssyxxqTxt.text forKey:@"FSSSYXXQ"];
    
    if (fsyjtjSegment.selectedSegmentIndex != -1)
    {
        [dicParams setObject:[fsyjtjSegment titleForSegmentAtIndex:fsyjtjSegment.selectedSegmentIndex] forKey:@"FSYJTJ"];
    }
    [dicParams setValue:fsyjtjxqTxt.text forKey:@"FSYJTJXQ"];
    
    if (fsyxtzSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[fsyxtzSegment titleForSegmentAtIndex:fsyxtzSegment.selectedSegmentIndex] forKey:@"FSYXTZ"];
    }
    [dicParams setValue:fsyxtzxqTxt.text forKey:@"FSYXTZXQ"];
    
    if (zshyqkSegment.selectedSegmentIndex != -1) {
        [dicParams setObject:[zshyqkSegment titleForSegmentAtIndex:zshyqkSegment.selectedSegmentIndex] forKey:@"FSZSHYQK"];
    }
    [dicParams setValue:zshyqkxqTxt.text forKey:@"FSZSHYQKXQ"];
    
    if (xccySegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[xccySegment titleForSegmentAtIndex:xccySegment.selectedSegmentIndex] forKey:@"FSXCCY"];
    }
    
    if (jcjgSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[jcjgSegment titleForSegmentAtIndex:jcjgSegment.selectedSegmentIndex] forKey:@"FSJCJG"];
    }
    [dicParams setValue:jcjgxqTxt.text forKey:@"FSJCJGXQ"];
    [dicParams setValue:fsqkqtView.text forKey:@"FSQKQT"];

    
     //工艺废气
    if (ssyxSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[ssyxSegment titleForSegmentAtIndex:ssyxSegment.selectedSegmentIndex] forKey:@"GYFQSSYX"];
    }
    [dicParams setValue:ssyxxqTxt.text forKey:@"GYFQSSYXXQ"];
    
    if (yjtjSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[yjtjSegment titleForSegmentAtIndex:yjtjSegment.selectedSegmentIndex] forKey:@"GYFQYJTJ"];
    }
    [dicParams setValue:yjtjxqTxt.text forKey:@"GYFQYJTJXQ"];
    
    if (yxtzSegment.selectedSegmentIndex != -1) {
         [dicParams setValue:[yxtzSegment titleForSegmentAtIndex:yxtzSegment.selectedSegmentIndex] forKey:@"GYFQYXTZ"];
    }
    [dicParams setValue:yxtzxqTxt.text forKey:@"GYFQYXTZXQ"];
   
    if (fqsjSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[fqsjSegment titleForSegmentAtIndex:fqsjSegment.selectedSegmentIndex] forKey:@"GYFQFQSJQK"];
    }
    [dicParams setValue:fqsjxqTxt.text forKey:@"GYFQFQSJQKXQ"];
    [dicParams setValue:gyfqqtView.text forKey:@"GYFQQT"];
    
    //锅炉废气
    if (rllxSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[rllxSegment titleForSegmentAtIndex:rllxSegment.selectedSegmentIndex] forKey:@"GLFQRLLX"];
    }
    [dicParams setValue:rllxxqTxt.text forKey:@"GLFQRLLXXQ"];
    
    if (rlpfyqSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[rlpfyqSegment titleForSegmentAtIndex:rlpfyqSegment.selectedSegmentIndex] forKey:@"GLFQRLYPFYQ"];
    }
    [dicParams setValue:rlpfyqxqTxt.text forKey:@"GLFQRLYPFYQXQ"];
    
    if (glssyxSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[glssyxSegment titleForSegmentAtIndex:glssyxSegment.selectedSegmentIndex] forKey:@"GLFQSSYX"];
    }
    [dicParams setValue:glssyxxqTxt.text forKey:@"GLFQSSYXXQ"];
    
    if (glyjtjSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[glyjtjSegment titleForSegmentAtIndex:glyjtjSegment.selectedSegmentIndex] forKey:@"GLFQYJTJ"];
    }
    [dicParams setValue:glyjtjxqTxt.text forKey:@"GLFQYJTJXQ"];
    
    if (glyxtzSegment.selectedSegmentIndex != -1) {
         [dicParams setValue:[glyxtzSegment titleForSegmentAtIndex:glyxtzSegment.selectedSegmentIndex] forKey:@"GLFQYXTZ"];
    }
    [dicParams setValue:glyxtzxqTxt.text forKey:@"GLFQYXTZXQ"];
    [dicParams setValue:glfqqtView.text forKey:@"GLFQQT"];
    
    //普通固废
    if (zccsSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[zccsSegment titleForSegmentAtIndex:zccsSegment.selectedSegmentIndex] forKey:@"PTGFZCCS"];
    }
    [dicParams setValue:zccsxqTxt.text forKey:@"PTGFZCCSXQ"];
    
    if (bzbsSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[bzbsSegment titleForSegmentAtIndex:bzbsSegment.selectedSegmentIndex] forKey:@"PTGFBZBS"];
    }
    [dicParams setValue:bzbsxqTxt.text forKey:@"PTGFBZBSXQ"];
    
    if (czfsSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[czfsSegment titleForSegmentAtIndex:czfsSegment.selectedSegmentIndex] forKey:@"PTGFCZfS"];
    }
    [dicParams setValue:czfsxqTxt.text forKey:@"PTGFCZfSXQ"];
    
    if (tzdjSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[tzdjSegment titleForSegmentAtIndex:tzdjSegment.selectedSegmentIndex] forKey:@"PTGFTZDJ"];
    }
    [dicParams setValue:tzdjxqTxt.text forKey:@"PTGFTZDJXQ"];
    [dicParams setValue:ptgfqtView.text forKey:@"PTGFQT"];
    
    //在线监测
    if (sblxSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[sblxSegment titleForSegmentAtIndex:sblxSegment.selectedSegmentIndex] forKey:@"ZXJCSBLX"];
    }
    
    if (jsazSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[jsazSegment titleForSegmentAtIndex:jsazSegment.selectedSegmentIndex] forKey:@"ZXJCJSAZ"];
    }
    [dicParams setValue:jsazxqTxt.text forKey:@"ZXJCJSAZXQ"];

    if (yxqkSegment.selectedSegmentIndex != -1) {
         [dicParams setValue:[yxqkSegment titleForSegmentAtIndex:yxqkSegment.selectedSegmentIndex] forKey:@"ZXJCYXQK"];
    }

    if (ywtzSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[ywtzSegment titleForSegmentAtIndex:ywtzSegment.selectedSegmentIndex] forKey:@"ZXJCYWTZ"];
    }
    [dicParams setValue:ywtzxqTxt.text forKey:@"ZXJCYWTZXQ"];

    if (jcsjSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[jcsjSegment titleForSegmentAtIndex:jcsjSegment.selectedSegmentIndex] forKey:@"ZXJCJCSJCBQK"];
    }

    [dicParams setValue:jcphTxt.text forKey:@"ZXJCJCSJPH"];
    [dicParams setValue:jccodTxt.text forKey:@"ZXJCJCSJCOD"];
    [dicParams setValue:jcadTxt.text forKey:@"ZXJCJCSJAD"];
    [dicParams setValue:jcqtTxt.text forKey:@"ZXJCJCSJQT"];
    [dicParams setValue:zxjcqtView.text forKey:@"ZXJCQT"];
    
    //六大行业
    if (zxjcqkSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[zxjcqkSegment titleForSegmentAtIndex:zxjcqkSegment.selectedSegmentIndex] forKey:@"LDHYQYZXJCQK"];
    }
   
    if (zxjcfsSegment.selectedSegmentIndex != -1) {
            [dicParams setValue:[zxjcfsSegment titleForSegmentAtIndex:zxjcfsSegment.selectedSegmentIndex] forKey:@"LDHYZXJCFS"];
    }

    if (sysjcnlSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[sysjcnlSegment titleForSegmentAtIndex:sysjcnlSegment.selectedSegmentIndex] forKey:@"LDHYSYSJCNL"];
    }

    if (wtjcbgSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[wtjcbgSegment titleForSegmentAtIndex:wtjcbgSegment.selectedSegmentIndex] forKey:@"LDHYWTJCBG"];
    }
      
    if (jctzSegment.selectedSegmentIndex != -1) {
    [dicParams setValue:[jctzSegment titleForSegmentAtIndex:jctzSegment.selectedSegmentIndex] forKey:@"LDHYJCTZ"];
    }
    [dicParams setValue:jctzxqTxt.text forKey:@"LDHYJCTZXQ"];
    

    if (jcsjsbqkSegment.selectedSegmentIndex != -1) {
         [dicParams setValue:[jcsjsbqkSegment titleForSegmentAtIndex:jcsjsbqkSegment.selectedSegmentIndex] forKey:@"LDHYJCSJSBQK"];
    }
    
    [dicParams setValue:qykzwryzTxt.text forKey:@"LDHYQYKZWRYZ"];
    [dicParams setValue:sjjcwryzTxt.text forKey:@"LDHYSJJCYZ"];
    [dicParams setValue:zxjccsTxt.text forKey:@"LDHYZXJCPC"];
    [dicParams setValue:wtjccsTxt.text forKey:@"LDHYWTJCPC"];
    [dicParams setValue:wtjcdwTxt.text forKey:@"LDHYWTJCDW"];
    [dicParams setValue:ldhyqtView.text forKey:@"LDHYQT"];


    //环境应急
    if (yjssSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[yjssSegment titleForSegmentAtIndex:yjssSegment.selectedSegmentIndex] forKey:@"HJYJSS"];
    }
    [dicParams setValue:yjssxqTxt.text forKey:@"HJYJSSXQ"];

    if (yjyaSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[yjyaSegment titleForSegmentAtIndex:yjyaSegment.selectedSegmentIndex] forKey:@"HJYJYA"];
    }
    
    if (yjwzSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[yjwzSegment titleForSegmentAtIndex:yjwzSegment.selectedSegmentIndex] forKey:@"HJYJWZ"];
    }
    [dicParams setValue:yjwzxqTxt.text forKey:@"HJYJWZXQ"];

    if (yjylSegment.selectedSegmentIndex != -1) {
        [dicParams setValue:[yjylSegment titleForSegmentAtIndex:yjylSegment.selectedSegmentIndex] forKey:@"HJYJYL"];
    }
    [dicParams setValue:hjyjqtView.text forKey:@"HJYJQT"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary *userInfo =[[SystemConfigContext sharedInstance] getUserInfo];    
    [dicParams setValue:[userInfo objectForKey:@"uname"] forKey:@"CJR"];
    [dicParams setValue:dateString forKey:@"CJSJ"];
    [dicParams setValue:[userInfo objectForKey:@"uname"]  forKey:@"XGR"];
    [dicParams setValue:dateString forKey:@"XGSJ"];
    [dicParams setValue:[userInfo objectForKey:@"orgid"] forKey:@"ORGID"];
    [dicParams setValue:jcxjTxtView.text forKey:@"JCXJXXNR"];
    [dicParams setValue:self.jcxjButton.titleLabel.text forKey:@"JCXJWFXW"];
    [dicParams setValue:jcyjTxtView.text forKey:@"JCYJ"];
    [dicParams setValue:jcryTxt.text forKey:@"JCRY"];
    [dicParams setValue:zfzhTxt.text forKey:@"ZFZH"];
    [dicParams setValue:cjryTxt.text forKey:@"CJRY"];
    [dicParams setValue:xcfzrTxt.text forKey:@"BJCDWXCFZR"];
    [dicParams setValue:xcfzrzwTxt.text forKey:@"BJCDWXCFZRZW"];
    [dicParams setValue:xcfzrlxdhTxt.text forKey:@"BJCDWXCFZRLXDH"];
    [dicParams setValue:self.xczfbh forKey:@"XCZFBH"];
    [dicParams setValue:self.basebh forKey:@"BH"];
    [dicParams setValue:self.dwbh forKey:@"WRYBH"];
    
    return dicParams;
}

/**
 *  提交笔录
 *
 *  @param value 笔录字典
 */
- (void)commitRecordDatas:(NSDictionary*)value
{
    NSString *jsonStr = [value JSONString];
    NSString *xjxmStr = [self.buildProjects JSONString];
    NSString *wxfwStr = [self.dangerWastes JSONString];
    
    NSMutableDictionary *params =[NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"COMMIT_BL_WRYXCJCJL" forKey:@"service"];
    
    NSMutableDictionary *postParams =[NSMutableDictionary dictionaryWithCapacity:5];
    [postParams setObject:jsonStr forKey:@"jsonString"];
    [postParams setValue:xjxmStr forKey:@"xjxmString"];
    [postParams setValue:wxfwStr forKey:@"wxfwString"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"stru====%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self postParameters:postParams tipInfo:@"正在提交笔录..." tagID:COMIT_BL_XCJCBL];
}

- (NSString *)getNonNullStrWithData:(NSDictionary *)aData andWithKey:(NSString *)aKey
{
    if(aData && aKey)
    {
        if([aData objectForKey:aKey])
        {
            return [aData objectForKey:aKey];
        }
        else
        {
            return @"";
        }
    }
    return @"";
}
    
- (NSMutableDictionary*)createBaseTableFromWryData:(NSDictionary*)value
{
    NSMutableDictionary *dicParams = [super createBaseTableFromWryData:value];
    [dicParams setObject:[self getNonNullStrWithData:value andWithKey:@"JCKSSJ"] forKey:@"KSSJ"];
    [dicParams setObject:[self getNonNullStrWithData:value andWithKey:@"JCJSSJ"] forKey:@"JSSJ"];
    [dicParams setObject:[self getNonNullStrWithData:value andWithKey:@"JCRY"]   forKey:@"JCR"];
    [dicParams setObject:[self getNonNullStrWithData:value andWithKey:@"ZFZH"]   forKey:@"ZFZH"];
    [dicParams setObject:[self getNonNullStrWithData:value andWithKey:@"WRYMC"]  forKey:@"WRYMC"];
    [dicParams setObject:[self getNonNullStrWithData:value andWithKey:@"WRYDZ"]  forKey:@"WRYDZ"];
    [dicParams setObject:[self getNonNullStrWithData:value andWithKey:@"FRDB"]   forKey:@"FDDBR"];
    [dicParams setObject:[self getNonNullStrWithData:value andWithKey:@"FRLXFS"] forKey:@"FDDBRDH"];
    [dicParams setObject:[self getNonNullStrWithData:value andWithKey:@"HBFZR"]  forKey:@"HBFZR"];
    [dicParams setObject:[self getNonNullStrWithData:value andWithKey:@"HBFZRLXFS"] forKey:@"HBFZRDH"];
    return dicParams;
}

-(void)signFinished{
    NSDictionary *dicValue = [self getValueData];
	[self commitRecordDatas:dicValue];
}

-(void)signName{
    SignNameController *controller = [[SignNameController alloc] initWithNibName:@"SignNameController" bundle:nil];
    controller.delegate = self;
    controller.bh = self.basebh;
    controller.xczfbh = self.xczfbh;
    controller.wrymc = self.wrymc;
    controller.tableName = self.tableName;
    controller.modalPresentationStyle =  UIModalPresentationFormSheet;
    [self presentModalViewController:controller animated:YES];
    controller.view.superview.frame = CGRectMake(0, 1024-630, 768, 630);
}

/**
 *  获取历史笔录
 */
-(void)requestHistoryData{
    [super requestHistoryData];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_WRYXCJCJL_HISTORY" forKey:@"service"];
    [params setObject:self.basebh forKey:@"BH"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:QUERY_XCKCBL_HISTORY] ;
}

/**
 *  增加检查项 视图下移
 *
 *  @param height 高度
 */
- (void)insertCheckViewItem:(UIView *)checkView{
    CGRect checkFrame = checkView.frame;
    CGFloat moveHeight = CGRectGetHeight(checkView.frame);
    NSInteger tag = checkView.tag;
    NSTimeInterval animationDuration=0.10f;
    
    if ([self.checkItems count] == 0) {
        checkFrame.origin.y = 940;
        
        [UIView animateWithDuration:animationDuration animations:^{
            CGRect frame = self.opinion.frame;
            CGFloat opinionY = CGRectGetMinY(frame);
            frame.origin.y = opinionY + moveHeight;
            self.opinion.frame = frame;
        }completion:^(BOOL finished){
            
        }];
    }
    
    else {
        NSInteger max = [self getMaxInteger:self.checkTags];
        NSInteger min = [self getMinInteger:self.checkTags];
        if (tag < min){
            
            [UIView animateWithDuration:animationDuration animations:^{
                
                for (NSNumber *number in self.checkTags) {
                    NSInteger sn = [number integerValue];
                    UIView *moveView = [self.views objectAtIndex:sn];
                    CGRect frame = moveView.frame;
                    CGFloat minY = CGRectGetMinY(frame);
                    frame.origin.y = minY + moveHeight;
                    moveView.frame = frame;
                }
                CGRect frame = self.opinion.frame;
                CGFloat opinionY = CGRectGetMinY(frame);
                frame.origin.y = opinionY + moveHeight;
                self.opinion.frame = frame;

            }completion:^(BOOL finished){
                
            }];
            checkFrame.origin.y = 940;
        }
        
        else if(tag > max) {
            CGRect frame = self.opinion.frame;
            CGFloat minY = CGRectGetMinY(frame);
            checkFrame.origin.y = minY;
            
            [UIView animateWithDuration:animationDuration animations:^{
                
                CGRect frame = self.opinion.frame;
                CGFloat opinionY = CGRectGetMinY(frame);
                frame.origin.y = opinionY + moveHeight;
                self.opinion.frame = frame;
            }completion:^(BOOL finished){
            }];
        }
        
        else {
            NSInteger index = [self getMaxInteger:self.checkTags Specify:tag];
            UIView *indexView = [self.views objectAtIndex:index];
            CGFloat minY = CGRectGetMinY(indexView.frame);
            CGFloat height = CGRectGetHeight(indexView.frame);
            checkFrame.origin.y = minY + height;
            
            [UIView animateWithDuration:animationDuration animations:^{
                
                for (NSNumber *number in self.checkTags) {
                    NSInteger sn = [number integerValue];
                    if (sn > index) {
                        UIView *moveView = [self.views objectAtIndex:sn];
                        CGRect frame = moveView.frame;
                        CGFloat minY = CGRectGetMinY(frame);
                        frame.origin.y = minY + moveHeight;
                        moveView.frame = frame;
                    }
                }
                CGRect frame = self.opinion.frame;
                CGFloat opinionY = CGRectGetMinY(frame);
                frame.origin.y = opinionY + moveHeight;
                self.opinion.frame = frame;
            }completion:^(BOOL finished){
                
            }];
        }
    }
    
    checkView.frame = checkFrame;
    [self.view addSubview:checkView];
}

/**
 *  减少检查项 视图上移
 *
 *  @param height 高度
 */
- (void)removeCheckViewItem:(UIView *)checkView{
    if ([self.checkTags count] < 1) {
        return;
    }
    
    CGFloat moveHeight = CGRectGetHeight(checkView.frame);
    NSInteger tag = checkView.tag;

    NSTimeInterval animationDuration=0.10f;
    [UIView animateWithDuration:animationDuration animations:^{
        for (NSNumber *number in self.checkTags) {
            NSInteger sn = [number integerValue];
            if (sn > tag) {
                
                UIView *moveView = [self.views objectAtIndex:sn];
                CGRect frame = moveView.frame;
                float minY = CGRectGetMinY(frame);
                frame.origin.y = minY - moveHeight;
                moveView.frame = frame;
            }
        }
        CGRect frame = self.opinion.frame;
        float minY = CGRectGetMinY(frame);
        frame.origin.y = minY - moveHeight;
        self.opinion.frame = frame;
        
    }completion:^(BOOL finished) {
        
    }];
}

/**
 *  返回在数组中比指定整数小的一个最大数
 *
 *  @param array 对象数组
 *
 *  @return 最大整数
 */
- (NSInteger)getMaxInteger:(NSArray *)array Specify:(NSInteger)specify{
    NSNumber *number =  [array objectAtIndex:0];
    int maxTag = [number integerValue];
    for (NSNumber *tmpNumber in array ) {
        NSInteger tag = [tmpNumber integerValue];
        if (tag > maxTag  && tag< specify) {
            maxTag = tag;
        }
    }
    
    return  maxTag;
}

/**
 *  返回数组中最大的整数
 * 
 *  @param array 对象数组
 *
 *  @return 最大整数
 */
- (NSInteger)getMaxInteger:(NSArray *)array {
    NSNumber *number =  [array objectAtIndex:0];
    int maxTag = [number integerValue];
    for (NSNumber *tmpNumber in array ) {
        NSInteger tag = [tmpNumber integerValue];
        if (tag > maxTag) {
            maxTag = tag;
        }
    }
    return maxTag;
}

/**
 *  返回数组中最小的整数
 *
 *  @param array 对象数组
 *
 *  @return 最小整数
 */
- (NSInteger)getMinInteger:(NSArray *)array {
    NSNumber *number =  [array objectAtIndex:0];
    int minTag = [number integerValue];
    for (NSNumber *tmpNumber in array ) {
        NSInteger tag = [tmpNumber integerValue];
        if (tag < minTag) {
            minTag = tag;
        }
    }
    return minTag;
}

/**
 *  将字典键值为空置为空串
 *
 *  @param val 原字典
 *
 *  @return 重置后字典
 */
-(NSDictionary*)modifyDicValues:(NSDictionary*)val{
    NSMutableDictionary *dicVal = [NSMutableDictionary dictionaryWithDictionary:val];
    //处理为<null> 或者nil的情况
    NSArray *keys = [dicVal allKeys];
    if ([keys count] > 0) {
        for(NSString *aKey in keys){
            id val = [dicVal objectForKey:aKey];
            if( val == nil || [val isKindOfClass:[NSNull class]]){
                [dicVal setObject:@"" forKey:aKey];
            }
        }
    }
    return dicVal;
}

//键盘将要出现前通知处理
- (void)keyboardWillShow:(NSNotification *)notification
{
    if(!self.hasShowKeyBoard)
    {
        self.scrollView.contentSize = CGSizeMake(768, self.scrollView.contentSize.height + 290);
    }
    self.hasShowKeyBoard = YES;
}

//键盘将要隐藏前通知处理
- (void)keyboardWillHidden:(NSNotification *)aNotification
{
    if(self.hasShowKeyBoard)
    {
        self.scrollView.contentSize = CGSizeMake(768, self.scrollView.contentSize.height - 290);
    }
    self.hasShowKeyBoard = NO;
}

@end
