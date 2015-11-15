//
//  ZFTZListViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-28.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "ZFTZListViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UITableViewCell+Custom.h"
#import "ZFTZMainRecordViewController.h"
#import "MenuHelper.h"

#define kTag_KSSJ_Field 1001 //开始时间
#define kTag_JSSJ_Field 1002 //结束时间
#define kTag_ZFLX_Field 1003 //执法类型

@interface ZFTZListViewController ()

@property (nonatomic, strong) NSMutableArray *listDataArray;
@property (nonatomic, strong) NSArray *listTaskTypeAry;//任务类型列表
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) int totalCount;//总记录条数
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) int currentPage;//当前页
@property (nonatomic, assign) int currentTag;
@property (nonatomic, strong) NSString *currentZFLX;//选中的执法类型
@property (nonatomic, strong) UIPopoverController *popController;

@end

@implementation ZFTZListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//初始化查询区域视图控件
- (void)initQueryView
{
    self.kssjField.tag = kTag_KSSJ_Field;
    [self.kssjField addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    self.jssjField.tag = kTag_JSSJ_Field;
    [self.jssjField addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    self.zflxField.tag = kTag_ZFLX_Field;
    self.zflxField.delegate = self;
    [self.zflxField addTarget:self action:@selector(touchFromType:) forControlEvents:UIControlEventTouchDown];
    [self.searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

//初始化默认数据
- (void)initDefaultData
{
    self.totalCount = 0;
    self.currentPage = 1;
    self.isLoading = NO;
    self.listDataArray = [[NSMutableArray alloc] init];
    
    self.listTaskTypeAry = [[NSArray alloc] initWithObjects:@"应急检查", @"现场执法", @"“三同时”监察", @"信访调查", @"监察稽查", @"专项行动", @"其他",nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"执法台账";
    
    [self initDefaultData];
    
    [self initQueryView];
    
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setListTableView:nil];
    [self setKssjField:nil];
    [self setJssjField:nil];
    [self setZflxField:nil];
    [self setWyrmcField:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(self.popController)
    {
        [self.popController dismissPopoverAnimated:YES];
    }
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    headerView.text = [NSString stringWithFormat:@"  查询结果:%d条", self.totalCount];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   

    static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    NSDictionary *item = [self.listDataArray objectAtIndex:indexPath.row];
    NSString *wrymc_value = [item objectForKey:@"TITLE"];
    NSString *jcry_value = [NSString stringWithFormat:@"%@", [item objectForKey:@"CONTENT"]];
    
    NSString *sj_value = [NSString stringWithFormat:@"%@", [item objectForKey:@"TIME"]];
    
    cell.textLabel.text = wrymc_value;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",jcry_value,sj_value];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int pages = self.totalCount%ONE_PAGE_SIZE == 0 ? self.totalCount/ONE_PAGE_SIZE : self.totalCount/ONE_PAGE_SIZE+1;
    if(self.currentPage == pages || pages == 0 || self.totalCount <= ONE_PAGE_SIZE)
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
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.listDataArray objectAtIndex:indexPath.row];
    ZFTZMainRecordViewController *mainRecord = [[ZFTZMainRecordViewController alloc] initWithNibName:@"ZFTZMainRecordViewController" bundle:nil];
    mainRecord.wrymc = [dict objectForKey:@"TITLE"];
    mainRecord.link = [dict objectForKey:@"LINK"];
    mainRecord.primaryKey = [dict objectForKey:@"PRIMARY_KEY"];
    [self.navigationController pushViewController:mainRecord animated:YES];
}

#pragma mark - Network Handler Methods

/**
 * 获取执法台账数据
 * 参数1:service(这里固定为RSS_DATA_LIST, 必选)
 * 参数2:MENU_SERIES(菜单编号,从同步回来的菜单数据中获取, 必选)
 */
- (void)requestData
{
    self.isLoading = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"RSS_DATA_LIST" forKey:@"service"];
  //  MenuHelper *mh = [[MenuHelper alloc] init];
    //NSString *cdxh = [mh getMenuCodeByName:@"执法台账"];
    NSString *cdxh = @"0x600304";
    [params setObject:cdxh forKey:@"MENU_SERIES"];
    NSString *UrlStr = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = UrlStr;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
{
    self.isLoading = NO;
    if(webData.length <= 0)
    {
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSDictionary *detailDict = [jsonStr objectFromJSONString];
    BOOL bParsedError = NO;
    if(detailDict != nil)
    {
        self.totalCount = [[detailDict objectForKey:@"totalCount"] intValue];
        NSArray *tmpAry = [detailDict objectForKey:@"data"];
        if(tmpAry.count > 0)
        {
            [self.listDataArray addObjectsFromArray:tmpAry];
        }
    }
    else
    {
        bParsedError = YES;
    }
    [self.listTableView reloadData];
    if(bParsedError)
    {
        [self showAlertMessage:@"解析数据出错!"];
    }
}

- (void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self showAlertMessage:@"获取数据出错!"];
}

#pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return NO;
}

#pragma mark - Event Handler Methods

- (void)searchButtonClick:(id)sender
{
    if(self.listDataArray)
    {
        [self.listDataArray removeAllObjects];
    }
    [self.listTableView reloadData];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"RSS_DATA_LIST" forKey:@"service"];
   // MenuHelper *mh = [[MenuHelper alloc] init];
  //  NSString *cdxh = [mh getMenuCodeByName:@"执法台账"];
    [params setObject:@"0x600304" forKey:@"MENU_SERIES"];
    if(self.wyrmcField.text != nil && self.wyrmcField.text.length > 0)
    {
        [params setObject:self.wyrmcField.text forKey:@"TITLE"];
    }
    if(self.zflxField.text != nil && self.zflxField.text.length > 0)
    {
        //self.zflxField.text
//        [params setObject:self.currentZFLX forKey:@"TASK_TYPE"];
        NSString *zflxStr = [self.zflxField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [params setObject:zflxStr forKey:@"TASK_TYPE"];
    }
    if(self.kssjField.text != nil && self.kssjField.text.length > 0)
    {
        [params setObject:self.kssjField.text forKey:@"KSSJ"];
    }
    if(self.jssjField.text != nil && self.jssjField.text.length > 0)
    {
        [params setObject:self.jssjField.text forKey:@"JSSJ"];
    }
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
    
    self.urlString = urlStr;
    self.isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self];
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

-(void)touchFromType:(id)sender
{
    UIControl *btn =(UIControl*)sender;
    self.currentTag = btn.tag;
    CommenWordsViewController *wordController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
    wordController.delegate = self;
    wordController.wordsAry = self.listTaskTypeAry;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:wordController];
    popover.popoverContentSize = CGSizeMake(200, 300);
    self.popController = popover;
	[self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - PopupDateViewController Delegate Method

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

#pragma mark - CommenWordsViewController Delegate Method

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    if(self.popController)
    {
        [self.popController dismissPopoverAnimated:YES];
    }
    if(self.currentTag == kTag_ZFLX_Field)
    {
        self.zflxField.text = words;
        NSLog(@"self.zflxField.text-----%@",self.zflxField.text);
        self.currentZFLX = [NSString stringWithFormat:@"%d", row+1];
    }
}

@end
