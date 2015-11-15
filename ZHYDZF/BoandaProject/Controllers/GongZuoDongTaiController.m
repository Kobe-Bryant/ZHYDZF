//
//  GongZuoDongTai1ViewController.m
//  BoandaProject
//
//  Created by 周占通 on 14-5-4.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "GongZuoDongTaiController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "GZDTDetailViewController.h"

@interface GongZuoDongTaiController ()

@property (nonatomic,strong) UIPopoverController *datePopover;
@property (nonatomic,strong) PopupDateViewController *dateSelectCtrl;
@property (nonatomic, assign) int currentTag;

@end

@implementation GongZuoDongTaiController
@synthesize isLoading,pageCount,currentPage,listArray;
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
    self.title = @"工作动态";
    // Do any additional setup after loading the view from its nib.
    self.listArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self addSubViews];
    [self initPopoverController];
    
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 20 - 100) style:UITableViewStylePlain];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.rowHeight = 80;
    [self.view addSubview:listTable];
    [self requestData];
}
- (void)addSubViews{

    UILabel *rwmcLab = [[UILabel alloc]initWithFrame:CGRectMake(33,10, 85, 21)];
    rwmcLab.text = @"工作名称：";
    [self.view addSubview:rwmcLab];
    
    rwmcTxt = [[UITextField alloc]initWithFrame:CGRectMake(115, 7, 400, 30)];
    rwmcTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    rwmcTxt.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:rwmcTxt];
    
//---------------
    UILabel *kssjLab = [[UILabel alloc]initWithFrame:CGRectMake(33, 56, 85, 21)];
    kssjLab.text = @"开始时间：";
    [self.view addSubview:kssjLab];
    
    kssjTxt = [[UITextField alloc]initWithFrame:CGRectMake(115, 51, 200, 30)];
    kssjTxt.delegate = self;
    kssjTxt.borderStyle = UITextBorderStyleRoundedRect;
    kssjTxt.tag = kTag_StartDate_Field;
    [kssjTxt addTarget:self action:@selector(touchForDate:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:kssjTxt];
    
    
    
//---------------
    UILabel *jssjLab = [[UILabel alloc]initWithFrame:CGRectMake(365, 55, 85, 21)];
    jssjLab.text = @"结束时间：";
    [self.view addSubview:jssjLab];
    
    jssjTxt = [[UITextField alloc]initWithFrame:CGRectMake(448, 51, 200, 30)];
    jssjTxt.delegate = self;
    jssjTxt.borderStyle = UITextBorderStyleRoundedRect;
    jssjTxt.tag = kTag_EndDate_Field;
    [jssjTxt addTarget:self action:@selector(touchForDate:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:jssjTxt];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(677, 19, 55, 44);
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
}
- (void)searchClick{

    if(self.listArray)
    {
        [self.listArray removeAllObjects];
    }
    [listTable reloadData];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"GZDT_LIST" forKey:@"service"];

    NSString *rwmcStr = [rwmcTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *kssjStr = [kssjTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *jssjStr = [jssjTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (rwmcStr.length > 0) {
        
        [params setObject:rwmcStr forKey:@"q_BT"];
    }
    if (kssjStr.length > 0) {
        
        [params setObject:kssjStr forKey:@"q_BSJ"];
    }
    if (jssjStr.length > 0) {
        
        [params setObject:jssjStr forKey:@"q_ESJ"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    NSLog(@"strUrl=%@",strUrl);
    //http://61.164.73.82:8090/zhbg/invoke?version=1.16&imei=D8:A2:5E:2B:36:0E&clientType=IPAD&userid=yuying&password=123456&service=GZDT_LIST&q_BT=%E6%B3%A8%E9%87%8D%E8%B4%A8%E9%87%8F&P_PAGESIZE=25
    //http://61.164.73.82:8090/zhbg/invoke?version=1.16&imei=10:DD:B1:BC:2E:AE&clientType=IPAD&userid=yuying&password=123456&service=ZBB_LIST&q_ESJ=2014-07-23&P_PAGESIZE=25
    isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}
- (void)requestData{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"GZDT_LIST" forKey:@"service"];

    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"gongzuostrUrl  = %@",strUrl);
    isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

#pragma mark - Private Methods
- (void)initPopoverController
{
    //日期选择
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateSelectCtrl = tmpdate;
	self.dateSelectCtrl.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.dateSelectCtrl];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.datePopover = popover;
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
				kssjTxt.text = dateString;
				break;
			case kTag_EndDate_Field:
				jssjTxt.text = dateString;
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
				kssjTxt.text = @"";
				break;
			case kTag_EndDate_Field:
				jssjTxt.text = @"";
				break;
			default:
				break;
		}
    }
}

#pragma mark- UITextFiedDelegate
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


#pragma mark- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = [self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"BT"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"作者:%@  时间：%@",[dic objectForKey:@"ZZ"],[dic objectForKey:@"SJ"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dic = [self.listArray objectAtIndex:indexPath.row];
    GZDTDetailViewController *detailViewController = [[GZDTDetailViewController alloc]init];
    detailViewController.wzbh = [dic objectForKey:@"WZBH"];
    detailViewController.title = [dic objectForKey:@"BT"];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    headerView.font = [UIFont systemFontOfSize:20.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = [NSString stringWithFormat:@"  查询结果:%d条", count];
    return headerView;
}
#pragma mark - 网络数据处理
-(void)processWebData:(NSData*)webData{

    isLoading = NO;
    if([webData length] <=0)
    {
        return;
    }
    //解析JSON格式的数据  
    NSString *resultJSON = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0){
        
        NSDictionary *pageInfoDic = [[tmpParsedJsonAry lastObject] objectForKey:@"pageInfo"];
        NSLog(@"pag=%@",pageInfoDic);
        if(pageInfoDic)
        {
            pageCount = [[pageInfoDic objectForKey:@"pages"] intValue];
            currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
            count = [[pageInfoDic objectForKey:@"count"] intValue];
        }
        else
        {
            bParseError = YES;
        }
        
        NSArray *parsedItemAry = [[tmpParsedJsonAry objectAtIndex:0] objectForKey:@"dataInfos"];
        NSLog(@"par====%@",parsedItemAry);
        if (parsedItemAry == nil)
        {
            bParseError = YES;
        }
        else
        {
            
            [self.listArray addObjectsFromArray:parsedItemAry];
        }
    }
    else{
    
        bParseError = YES;
    }
    
    if(bParseError)
    {
        UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"提示"  message:@"获取数据出错。"  delegate:self cancelButtonTitle:@"确定"  otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    else{
    
        [listTable reloadData];
    }
}
-(void)processError:(NSError *)error{

    isLoading = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert show];
    return;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (isLoading) return;
    if (currentPage == pageCount)
        return;
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        currentPage++;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"GZDT_LIST" forKey:@"service"];

        NSString *rwmcStr = [rwmcTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *kssjStr = [kssjTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *jssjStr = [jssjTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (rwmcStr.length > 0) {
            
            [params setObject:rwmcStr forKey:@"q_BT"];
        }
        if (kssjStr.length > 0) {
            
            [params setObject:kssjStr forKey:@"q_BSJ"];
        }
        if (jssjStr.length > 0) {
            
            [params setObject:jssjStr forKey:@"q_ESJ"];
        }
        [params setObject:[NSString stringWithFormat:@"%d", currentPage] forKey:@"P_CURRENT"];
        NSString *newStrUrl = [ServiceUrlString generateUrlByParameters:params];
        isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:newStrUrl andParentView:self.view delegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
