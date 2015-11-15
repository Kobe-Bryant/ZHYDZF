//
//  TaskManagerViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-28.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "TaskManagerViewController.h"
#import "PopupDateViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UITableViewCell+Custom.h"
#import "DoneTaskDetailViewController.h"

#define kTag_KSSJ_Field 1001
#define kTag_JSSJ_Field 1002

@interface TaskManagerViewController ()
@property (nonatomic, assign) int currentTag;
@property (nonatomic, assign) int currentTaskType;
@property (nonatomic, strong) UIPopoverController *popController;

@property (nonatomic, strong) NSMutableArray *listDataArray;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) int totalCount;//总记录条数
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) int currentPage;//当前页
@end

@implementation TaskManagerViewController

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
    
    NSLog(@"hhhhhk");
    self.kssjField.tag = kTag_KSSJ_Field;
    [self.kssjField addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    self.jssjField.tag = kTag_JSSJ_Field;
    [self.jssjField addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    [self.searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.totalCount = 0;
    self.currentPage = 1;
    self.listDataArray = [[NSMutableArray alloc] init];
    
    self.isLoading = NO;
    
    NSArray *titleAry = [[NSArray alloc] initWithObjects:@"未结束任务", @"已结束任务", nil];
    UISegmentedControl *segmentCtrl = [[UISegmentedControl alloc] initWithItems:titleAry];
    segmentCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentCtrl addTarget:self action:@selector(onTitleSegClick:) forControlEvents:UIControlEventValueChanged];
    segmentCtrl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentCtrl;
    self.currentTaskType = kServiceTag_UndoTaskList_Action;
    
    [self requestTaskList:kServiceTag_UndoTaskList_Action];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTitleSegClick:(UISegmentedControl *)sender
{
    [self.listDataArray removeAllObjects];
    self.currentTaskType = sender.selectedSegmentIndex;
    [self requestTaskList:sender.selectedSegmentIndex];
}

- (void)searchButtonClick:(id)sender
{
    if(self.listDataArray)
    {
        [self.listDataArray removeAllObjects];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"ASSIGNED_TASK_LIST" forKey:@"service"];//未结束 TYPE 0 结束 1
    [params setObject:[NSString stringWithFormat:@"%d", self.currentTaskType] forKey:@"TYPE"];
/*    if(self.dwmcField.text != nil && self.dwmcField.text.length > 0)
    {
        [params setObject:self.dwmcField.text forKey:@"dwmc"];
    }
    if(self.kssjField.text != nil && self.kssjField.text.length > 0)
    {
        [params setObject:self.kssjField.text forKey:@"kssj"];
    }
    if(self.jssjField.text != nil && self.jssjField.text.length > 0)
    {
        [params setObject:self.jssjField.text forKey:@"jssj"];
    }*/
    NSString *strURL = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = strURL;
    self.currentPage = 1;
    self.isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strURL andParentView:self.view delegate:self tagID:self.currentTaskType];
}

-(void)touchFromDate:(id)sender
{
	UIControl *btn =(UIControl*)sender;
    self.currentTag = btn.tag;
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	dateController.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
	[self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date
{
    [self.popController dismissPopoverAnimated:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    if(self.currentTag == kTag_KSSJ_Field)
    {
        self.kssjField.text = dateString;
    }
    else if(self.currentTag == kTag_JSSJ_Field)
    {
        self.jssjField.text = dateString;
    }
}

- (void)requestTaskList:(int)type
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"ASSIGNED_TASK_LIST" forKey:@"service"];//未结束 TYPE 0 结束 1
    [params setObject:[NSString stringWithFormat:@"%d", type] forKey:@"TYPE"];
    NSString *strURL = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = strURL;
    self.currentPage = 1;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self tagID:type];
    self.isLoading = YES;
}

-(void)processError:(NSError *)error
{
    NSString *msg = @"查询数据失败";
    [self showAlertMessage:msg];
    return;
}

-(void)processWebData:(NSData*)webData andTag:(NSInteger)tag
{
    if([webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    self.isLoading = NO;
    NSArray *ary = [resultJSON objectFromJSONString];
    if(ary != nil)
    {
        [self.listDataArray  addObjectsFromArray:ary];
    }
    [self.listTableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(self.currentTaskType == kServiceTag_UndoTaskList_Action)
    {
        //未结束的任务
        NSDictionary *dict = [self.listDataArray objectAtIndex:indexPath.row];
        NSString *title = [dict objectForKey:@"DWMC"];
        NSString *BZCLR = [NSString stringWithFormat:@"当前处理人：%@", [dict objectForKey:@"BZCLR"]];
        NSString *LCMC = [NSString stringWithFormat:@"流程名称：%@", [dict objectForKey:@"LCMC"]];
        NSString *LCKSSJ = [NSString stringWithFormat:@"流程开始时间：%@", [dict objectForKey:@"LCKSSJ"]];
        NSString *LCQX = [NSString stringWithFormat:@"办结期限：%@", [dict objectForKey:@"LCQX"]];
        cell = [UITableViewCell makeSubCell:tableView withTitle:title andSubvalue1:BZCLR andSubvalue2:LCKSSJ andSubvalue3:LCQX andSubvalue4:LCMC andNoteCount:indexPath.row];
    }
    else if (self.currentTaskType == kServiceTag_DoneTaskList_Action)
    {
        //已结束的任务
        NSDictionary *dict = [self.listDataArray objectAtIndex:indexPath.row];
        NSString *title = [dict objectForKey:@"DWMC"];
        NSString *BZCLR = [NSString stringWithFormat:@"办结人：%@", [dict objectForKey:@"BJR"]];
        NSString *LCKSSJ = [NSString stringWithFormat:@"流程开始时间：%@", [dict objectForKey:@"LCKSSJ"]];
        NSString *LCJSSJ = [NSString stringWithFormat:@"流程结束时间：%@", [dict objectForKey:@"LCQX"]];
        cell = [UITableViewCell makeSubCell:tableView withTitle:title andSubvalue1:BZCLR andSubvalue2:LCKSSJ andSubvalue3:@"" andSubvalue4:LCJSSJ andNoteCount:indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int pages = self.totalCount%ONE_PAGE_SIZE == 0 ? self.totalCount/ONE_PAGE_SIZE : self.totalCount/ONE_PAGE_SIZE+1;
    if(self.currentPage == pages || pages == 0)
    {
        return;
    }
	if (self.isLoading)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        self.currentPage++;
        NSString *strUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",self.urlString, self.currentPage];
        self.isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tagID:self.currentTaskType];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoneTaskDetailViewController *detail = [[DoneTaskDetailViewController alloc] initWithNibName:@"DoneTaskDetailViewController" bundle:nil];
    NSDictionary *rowInfo = [self.listDataArray objectAtIndex:indexPath.row];
    detail.YWBH = [rowInfo objectForKey:@"YWBH"];
	detail.LCSLBH = [rowInfo objectForKey:@"LCSLBH"];
    detail.LCLXBH = [rowInfo objectForKey:@"LCLXBH"];
    detail.WRYBH = @"";
    detail.itemParams = rowInfo;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)viewDidUnload
{
    [self setKssjField:nil];
    [self setJssjField:nil];
    [self setSearchButton:nil];
    [self setDwmcField:nil];
    [self setListTableView:nil];
    [super viewDidUnload];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return NO;
}

@end
