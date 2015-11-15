//
//  DoneTaskDetailViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-29.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "DoneTaskDetailViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UITableViewCell+Custom.h"
#import "NSStringUtil.h"
#import "SiteInforcementConroller.h"
#import "QueryWriteController.h"
#import "CaiyangViewController.h"
#import "ZFBLListViewController.h"

@interface DoneTaskDetailViewController ()
@property (nonatomic, strong) NSArray *jbxxAry;//基本信息
@property (nonatomic, strong) NSArray *zfblAry;//执法笔录
@property (nonatomic, strong) NSArray *blgcAry;//办理过程
@end

@implementation DoneTaskDetailViewController

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
    
    self.title = @"未结束任务详细信息";
    
    [self requestDetailData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.jbxxAry.count;
    }
    else if(section == 1)
    {
        return self.blgcAry.count;
    }
    else if(section == 2)
    {
        return self.zfblAry.count;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        return 100;
    }
    return 80.0f;
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
    if (section == 0)  headerView.text = @"  基本信息";
    else if (section == 1)   headerView.text = @"  办理过程";
    else  headerView.text = @"  执法笔录";
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
    if(indexPath.section == 0)
    {
        NSDictionary *item = [self.jbxxAry objectAtIndex:indexPath.row];
        NSString *title = [item objectForKey:@"TITLE"];
        NSString *value = [item objectForKey:@"CONTENT"];
        cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:60.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(indexPath.section == 1)
    {
        NSDictionary *item = [self.blgcAry objectAtIndex:indexPath.row];

        cell = [UITableViewCell makeSubCell:tableView
                                         withTitle:[item objectForKey:@"TITLE"]
                                         SubValue1:[item objectForKey:@"REMARK"]
                                         SubValue2:[item objectForKey:@"CONTENT"]
                                         SubValue3:[item objectForKey:@"TAG_02"]
                                         andHeight:100];
    }
    else if (indexPath.section == 2)
    {
        NSDictionary *item = [self.zfblAry objectAtIndex:indexPath.row];
        NSString *name = [item objectForKey:@"RECORD_NAME"];
        NSString *count = [item objectForKey:@"RECORD_COUNT"];
        NSString *value = [NSString stringWithFormat:@"%@ : %@条", name, count];
        NSString *CellIdentifier = @"Report_Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = value;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.section < 2)
    {
        return;
    }
    NSDictionary *item = [self.zfblAry objectAtIndex:indexPath.row];
    NSString *name = [item objectForKey:@"RECORD_NAME"];
    int count = [[item objectForKey:@"RECORD_COUNT"] intValue];
    if(count > 0)
    {
        ZFBLListViewController *list = [[ZFBLListViewController alloc] initWithNibName:@"ZFBLListViewController" bundle:nil];
        list.XCZFBH = self.YWBH;
        list.RECORDNAME = name;
        if([item objectForKey:@"MBBH"] != nil)
            list.MBBH = [item objectForKey:@"MBBH"];
        [self.navigationController pushViewController:list animated:YES];
    }
}

#pragma mark - Network Handler Methods

- (void)requestDetailData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"WORKFLOW_DETAIL_MAIN" forKey:@"service"];
    [params setObject:self.YWBH forKey:@"PRIMARY_KEY"];
    [params setObject:self.LCSLBH forKey:@"LCSLBH"];
    [params setObject:self.LCLXBH forKey:@"LCLXBH"];
    [params setObject:self.WRYBH forKey:@"WRYBH"];
    [params setObject:@"DONE" forKey:@"TASK_STATE"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"111strUrl=%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在请求数据..." tagID:1] ;
}

- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    if(webData.length <= 0)
    {
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSDictionary *detailDict = [jsonStr objectFromJSONString];
    BOOL bParsedError = NO;
    if(detailDict != nil)
    {
        self.jbxxAry = [detailDict objectForKey:@"基本信息"];
        self.blgcAry = [detailDict objectForKey:@"办理过程"];
        self.zfblAry = [detailDict objectForKey:@"执法笔录"];
    }
    else
    {
        bParsedError = YES;
    }
    [self.detailTableView reloadData];
    if(bParsedError)
    {
        [self showAlertMessage:@"解析数据出错!"];
    }
}

- (void)processError:(NSError *)error andTag:(NSInteger)tag
{
    [self showAlertMessage:@"获取数据出错!"];
}

- (void)viewDidUnload {
    [self setDetailTableView:nil];
    [super viewDidUnload];
}
@end
