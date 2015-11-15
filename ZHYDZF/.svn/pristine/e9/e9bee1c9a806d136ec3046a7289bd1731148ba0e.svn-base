//
//  BuildProjectDetailViewController.m
//  BoandaProject
//
//  Created by 熊熙 on 14-2-8.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "BuildProjectDetailViewController.h"
#import "GUIDGenerator.h"
@interface BuildProjectDetailViewController ()
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) UIPopoverController *popController;
@end

@implementation BuildProjectDetailViewController

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
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    switch (self.currentTag) {
        case 101:
            spsjTxt.text = dateString;
            break;
            
        case 102:
            sscsjTxt.text = dateString;
            break;
            
        case 103:
            jssjTxt.text = dateString;
            break;
            
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark Event Handle
- (void)cancelAdd:(id)sender{
	[self dismissModalViewControllerAnimated:NO];
}

- (void)doneAdd:(id)sender{
    [self dismissModalViewControllerAnimated:NO];
    NSDictionary *valueDict = [self getValue];
    [self.delegate returnValues:valueDict index:self.index modify:self.modify Tag:0];
}

/**
 *  弹出日期选择器
 *
 *  @param sender 接收器
 */
-(IBAction)touchFromDate:(id)sender{
    
    //隐藏键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
	UIControl *btn =(UIControl*)sender;
    
    self.currentTag = [btn tag];
    
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
    
	dateController.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
    
	[self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


#pragma mark -
#pragma mark private method

- (NSDictionary *)getValue{
    
    NSMutableDictionary *valueDict = [NSMutableDictionary dictionaryWithCapacity:4];
    //新建项目
    
    NSString *bh =  [GUIDGenerator generateGUID];
    [valueDict setValue:bh forKey:@"BH"];
    [valueDict setValue:self.xcjcbh forKey:@"XCJCBH"];
    [valueDict setValue:hpspdwTxt.text forKey:@"XJXMHPSPDW"];
    [valueDict setValue:xmmcTxt.text forKey:@"XJXMXMMC"];
        
    if (jsjdSegment.selectedSegmentIndex != -1) {
        [valueDict setValue:[jsjdSegment titleForSegmentAtIndex:jsjdSegment.selectedSegmentIndex] forKey:@"XJXMJSJD"];
    }
    
    if (spsjTxt && ![spsjTxt.text isEqualToString:@""]) {
        [valueDict setValue:spsjTxt.text forKey:@"XJXMSPSJ"];
    }
    
    if (sscsjTxt && ![sscsjTxt.text isEqualToString:@""]) {
        [valueDict setValue:sscsjTxt.text forKey:@"XJXMSSCSJ"];
    }
    
    if (sscSegment.selectedSegmentIndex != -1) {
        [valueDict setValue:[sscSegment titleForSegmentAtIndex:sscSegment.selectedSegmentIndex] forKey:@"XJXMSSCSFCB"];
    }
    
    if (xmpjSegment.selectedSegmentIndex != -1) {
        [valueDict setValue:[xmpjSegment titleForSegmentAtIndex:xmpjSegment.selectedSegmentIndex] forKey:@"XJXMXMPJ"];
    }
    
    if (xmysSegment.selectedSegmentIndex != -1) {
        [valueDict setValue:[xmysSegment titleForSegmentAtIndex:xmysSegment.selectedSegmentIndex] forKey:@"XJXMXMYS"];
    }
    
    [valueDict setValue:xmpjRemark.text forKey:@"XJXMPJXQ"];
    [valueDict setValue:xmysRemark.text forKey:@"XJXMYSXQ"];
    [valueDict setValue:jssjTxt.text forKey:@"JSSJ"];
    [valueDict setValue:jsnrTxt.text forKey:@"JSNR"];
    [valueDict setValue:[NSString stringWithFormat:@"%d",self.isApproval] forKey:@"XJXMXMSP"];
    [valueDict setValue:qtView.text forKey:@"QT"];
    return valueDict;
}

- (void)loadValue:(NSDictionary *)valueData{
    //新建项目
    hpspdwTxt.text = [valueData objectForKey:@"XJXMHPSPDW"];
    xmmcTxt.text = [valueData objectForKey:@"XJXMXMMC"];
    spsjTxt.text = [valueData objectForKey:@"XJXMSPSJ"];
    sscsjTxt.text = [valueData objectForKey:@"XJXMSSCSJ"];
    xmpjRemark.text = [valueData objectForKey:@"XJXMPJXQ"];
    xmysRemark.text = [valueData objectForKey:@"XJXMYSXQ"];
    jsnrTxt.text    = [valueData objectForKey:@"JSNR"];
    jssjTxt.text    = [valueData objectForKey:@"JSSJ"];
    qtView.text = [valueData objectForKey:@"QT"];
    
    NSString *selectTitle = [valueData objectForKey:@"XJXMJSJD"];
    for (int n=0; n < jsjdSegment.numberOfSegments; n++) {
        NSString *title = [jsjdSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            jsjdSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueData objectForKey:@"XJXMSSCSFCB"];
    for (int n=0; n < sscSegment.numberOfSegments; n++) {
        NSString *title = [sscSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            sscSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueData objectForKey:@"XJXMXMPJ"];
    for (int n=0; n < xmpjSegment.numberOfSegments; n++) {
        NSString *title = [xmpjSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            xmpjSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueData objectForKey:@"XJXMXMYS"];
    for (int n=0; n < xmysSegment.numberOfSegments; n++) {
        NSString *title = [xmysSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            xmysSegment.selectedSegmentIndex = n;
        }
    }
}


#pragma mark -
#pragma mark viewlife cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadValue:self.projectInfo];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAdd:)];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAdd:)];
    
    self.navigationItem.leftBarButtonItem = cancel;
	self.navigationItem.rightBarButtonItem = done;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
