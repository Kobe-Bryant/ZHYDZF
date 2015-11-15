//
//  InputConditionView.h
//  RetrieveExamine
//
//  Created by hejunhua on 11-9-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"
#import "MBProgressHUD.h"

@interface HJXFListViewController : BaseViewController
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PopupDateDelegate,UITextFieldDelegate>{

    NSInteger currentTag;
    NSInteger currentPageIndex;
    NSString *totalCount;
    BOOL isLoading;
}



@property (nonatomic, retain) NSMutableArray *aryItems;//存储查询到的所有审批项目

@property (nonatomic, retain) IBOutlet UITextField *tsdw;       //投诉单位输入栏
@property (nonatomic, retain) IBOutlet UITextField *startDate;  //开始时间输入栏
@property (nonatomic, retain) IBOutlet UITextField *endDate;    //结束时间输入栏
@property (nonatomic, retain) IBOutlet UITextField *tsnr;       //投诉内容输入栏


//时间选择浮动窗口及其内视图
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) PopupDateViewController *dateController;

@property (nonatomic, retain) UITableView *listTableView;//查询结果输出列表
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;//系统正忙的动画标识

@property (nonatomic,unsafe_unretained) NSInteger pageCount;
@property (nonatomic,unsafe_unretained) NSInteger currentPage;
- (IBAction)searchBtnPressed:(id)sender; //确定按钮按下后调用的方法

-(IBAction)touchFromDate:(id)sender;    //选择日期按钮按下
@end
