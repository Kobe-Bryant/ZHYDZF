//
//  DoneTaskListViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "DoneTaskListViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UITableViewCell+Custom.h"
#import "DoneTaskDetailViewController.h"

#define kTag_StartDate_Field 1001 //开始日期
#define kTag_EndDate_Field 1002 //结束日期
#define kTag_TaskType_Field 1003 //任务类型

@interface DoneTaskListViewController ()

@property (nonatomic,strong) UIPopoverController *wordsPopover;
@property (nonatomic,strong) CommenWordsViewController *wordSelectCtrl;
@property (nonatomic,strong) UIPopoverController *datePopover;
@property (nonatomic,strong) PopupDateViewController *dateSelectCtrl;

@property (nonatomic,strong) NSArray *taskTypeNameAry;
@property (nonatomic,strong) NSArray *taskTypeCodeAry;
@property (nonatomic,strong) NSString *selectedTaskTypeCode;

@property (nonatomic, assign) int currentTag;
@property (nonatomic, assign) int isLoading;
@property (nonatomic, strong) NSMutableArray *listDataArray;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) int totalCount;//总记录条数
@property (nonatomic, assign) int currentPage;//当前页
@end

@implementation DoneTaskListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"已办任务查询";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTaskTypeData];
    
    [self initPopoverController];
    
    [self initQueryView];
    
    [self requestTaskList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setListTableView:nil];
    [self setNameField:nil];
    [self setTaskTypeField:nil];
    [self setStartDateField:nil];
    [self setEndDateField:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if(self.datePopover)
    {
        [self.datePopover dismissPopoverAnimated:YES];
    }
    if(self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.listDataArray objectAtIndex:indexPath.row];
    
    /**/
//    NSLog(@"%@",[dict allKeys]);
    NSString *dwmc = [dict objectForKey:@"DWMC"];
    NSString *bzkssj = [[[dict objectForKey:@"BZKSSJ"] componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString *bzqx = [[[dict objectForKey:@"BZQX"] componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString *detail = [NSString stringWithFormat:@"执法类型：%@ 步骤开始时间：%@ 步骤期限：%@", [dict objectForKey:@"ZFLXXL"],bzkssj,bzqx];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = dwmc;
    cell.detailTextLabel.text = detail;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = [NSString stringWithFormat:@"  查询结果:%d条", self.listDataArray.count];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoneTaskDetailViewController *details = [[DoneTaskDetailViewController alloc] initWithNibName:@"DoneTaskDetailViewController" bundle:nil];
    NSDictionary *rowInfo = [self.listDataArray objectAtIndex:indexPath.row];
    details.YWBH = [rowInfo objectForKey:@"YWBH"];
	details.LCSLBH = [rowInfo objectForKey:@"LCSLBH"];
    details.LCLXBH = [rowInfo objectForKey:@"LCLXBH"];
    details.WRYBH = [rowInfo objectForKey:@"WRYBH"];
    details.itemParams = rowInfo;
    [self.navigationController pushViewController:details animated:YES];
}


#pragma mark - 网络处理

/**
 * 获取已办任务列表
 * 参数1:service(这里固定为PROCESSED_TASK_LIST, 必选)
 * 参数2:TASK_TYPE(污染源任务类型,可选,为空的时候表示全选 43000000003 污染源监察 43000000002 专项执法 43000000000000009 行政处罚
 43000000000000005 环境信访)
 * 参数3:dwmc(污染源名称, 可选)
 * 参数3:kssj(开始时间, 可选)
 * 参数3:jssj(结束时间, 可选)
 */
-(void)requestTaskList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"PROCESSED_TASK_LIST" forKey:@"service"];
    [params setObject:self.selectedTaskTypeCode forKey:@"TASK_TYPE"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = strUrl;
    
    
    self.currentPage = 1;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
    {
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *ary = [resultJSON objectFromJSONString];
    if(ary != nil)
    {
        [self.listDataArray addObjectsFromArray:ary];
    }
    [self.listTableView reloadData];
}

-(void)processError:(NSError *)error
{
    [self showAlertMessage:@"请求数据失败,请检查网络."];
    return;
}

#pragma mark - PopupDateController Delegate Method

// -------------------------------------------------------------------------------
//	实现PopupDateController Delegate委托方法
//  选中日期弹出框的时间后调用此方法
// -------------------------------------------------------------------------------

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate *)date
{
    [self.datePopover dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
		switch (self.currentTag)
        {
			case kTag_StartDate_Field:
				self.startDateField.text = dateString;
				break;
			case kTag_EndDate_Field:
				self.endDateField.text = dateString;
				break;
			default:
				break;
		}
	}
    else
    {
        switch (self.currentTag)
        {
			case kTag_StartDate_Field:
				self.startDateField.text = @"";
				break;
			case kTag_EndDate_Field:
				self.endDateField.text = @"";
				break;
			default:
				break;
		}
    }
}

#pragma mark- UITextField Delegate Method

// -------------------------------------------------------------------------------
//	实现UITextField Delegate委托方法
//  按下UITextField后不让键盘弹出来，实现可以选择时间
// -------------------------------------------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark - Event Handler Method

- (void)touchForDate:(id)sender
{
    if(self.datePopover)
    {
        [self.datePopover dismissPopoverAnimated:YES];
    }
    UIControl *btn =(UIControl*)sender;
	[self.datePopover presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	self.currentTag = btn.tag;
}

- (void)touchForWord:(id)sender
{
     NSLog(@"1590");
    if (self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
    UITextField *field = (UITextField *)sender;
    field.text = @"";
    self.currentTag = field.tag;
    
    switch (self.currentTag)
    {
        case kTag_TaskType_Field:
            self.wordSelectCtrl.wordsAry = self.taskTypeNameAry;
            break;
        default:
            break;
    }
    [self.wordSelectCtrl.tableView reloadData];
    [self.wordsPopover presentPopoverFromRect:[field bounds] inView:field permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)onSearchButtonClick:(id)sender
{

    if(self.listDataArray)
    {
        [self.listDataArray removeAllObjects];
        [self.listTableView reloadData];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"PROCESSED_TASK_LIST" forKey:@"service"];
    [params setObject:self.selectedTaskTypeCode forKey:@"TASK_TYPE"];
    if(self.nameField.text != nil && self.nameField.text.length > 0)
    {
        [params setObject:self.nameField.text forKey:@"dwmc"];
    }
    if(self.startDateField.text != nil && self.startDateField.text.length > 0)
    {
        [params setObject:self.startDateField.text forKey:@"kssj"];
    }
    if(self.endDateField.text != nil && self.endDateField.text.length > 0)
    {
        [params setObject:self.endDateField.text forKey:@"jssj"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"strUrl = %@",strUrl);
    self.urlString = strUrl;
    self.currentPage = 1;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

#pragma mark - Private Methods

- (void)initPopoverController
{
    //类型选择
    CommenWordsViewController *wordCtrl = [[CommenWordsViewController alloc] initWithStyle:UITableViewStylePlain];
    [wordCtrl setContentSizeForViewInPopover:CGSizeMake(320, 400)];
    self.wordSelectCtrl = wordCtrl;
    self.wordSelectCtrl.delegate = self;
    UIPopoverController *popCtrl = [[UIPopoverController alloc] initWithContentViewController:self.wordSelectCtrl];
    self.wordsPopover = popCtrl;
    //日期选择
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateSelectCtrl = tmpdate;
	self.dateSelectCtrl.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.dateSelectCtrl];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.datePopover = popover;
}

- (void)initQueryView
{
    self.taskTypeField.text = [self.taskTypeNameAry objectAtIndex:0];
    self.startDateField.tag = kTag_StartDate_Field;
    [self.startDateField addTarget:self action:@selector(touchForDate:) forControlEvents:UIControlEventTouchDown];
    
    self.endDateField.tag = kTag_EndDate_Field;
    [self.endDateField addTarget:self action:@selector(touchForDate:) forControlEvents:UIControlEventTouchDown];
    
    self.taskTypeField.tag = kTag_TaskType_Field;
    [self.taskTypeField addTarget:self action:@selector(touchForWord:) forControlEvents:UIControlEventTouchDown];
    
    [self.searchButton addTarget:self action:@selector(onSearchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTaskTypeData
{
    self.taskTypeNameAry = [[NSArray alloc] initWithObjects:@"污染源监察", @"环境信访", nil];
    self.taskTypeCodeAry = [[NSArray alloc] initWithObjects:@"43000000003", @"43000000000000005", nil];
    self.listDataArray = [[NSMutableArray alloc] init];
    self.selectedTaskTypeCode = [self.taskTypeCodeAry objectAtIndex:0];
    self.currentPage = 1;
}

#pragma mark - Words Delegate

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    switch (self.currentTag)
    {
        case kTag_TaskType_Field:
            self.taskTypeField.text = words;
            self.selectedTaskTypeCode = [self.taskTypeCodeAry objectAtIndex:row];
            break;
        default:
            break;
    }
    
    if(self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
}

@end
