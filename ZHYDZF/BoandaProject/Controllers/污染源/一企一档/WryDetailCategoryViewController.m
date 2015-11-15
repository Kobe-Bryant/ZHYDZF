//
//  WryDetailCategoryViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-17.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "WryDetailCategoryViewController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "UITableViewCell+Custom.h"
#import "WryDetailCategoryViewController.h"

#import "WryCompanyArchiveViewController.h"
#import "XMSPDetailsViewController.h"
#import "HJXFDetailViewController.h"
#import "XZCFDetailsViewController.h"
#import "DefaultDetailViewController.h"
#import "PWSFDetailViewController.h"
#import "CommenWordsViewController.h"

#import "SiteInforcementConroller.h"
#import "InvestigateEvidenceCategoryVC.h"
#import "DrawKYTViewController.h"
#import "QueryWriteController.h"
#import "WrySiteOnInspectionController.h"
#import "ModifyWryLocViewController.h"

@interface WryDetailCategoryViewController ()<WordsDelegate>
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray *listDataArray;
@property (nonatomic, strong) NSMutableDictionary *dicSubTasks;
@property (nonatomic, strong) NSMutableArray *arySectionIsOpen;
@property (nonatomic, assign) int currentSelectedIndex;
@property(nonatomic,strong) UIPopoverController *popController;
@end

@implementation WryDetailCategoryViewController
@synthesize popController,dataItem,jd,wd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

#pragma mark- WordsDelegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    
         BaseRecordViewController *controller = nil;
        if(row == 1){
            
            controller = [[SiteInforcementConroller alloc] initWithNibName:@"SiteInforcementConroller" bundle:nil];
            
        }else if(row == 2){
            
            controller = [[QueryWriteController alloc] initWithNibName:@"QueryWriteController" bundle:nil];
        }
        else if(row == 3){
            
            controller = [[DrawKYTViewController alloc] initWithNibName:@"DrawKYTViewController" bundle:nil];
        }
        else if(row == 4){
            
            controller = [[InvestigateEvidenceCategoryVC alloc] init];

        }
        else if(row == 0){
            //现场记录
            controller = [[WrySiteOnInspectionController alloc] initWithNibName:@"WrySiteOnInspectionController" bundle:nil];
        }
    
        controller.dwbh = self.primaryKey;
        controller.wrymc = self.wrymc;
        [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)hiddenSelf{

    if (self.popController) {
        
        [self.popController dismissPopoverAnimated:YES];
    }
}

-(void)modifyLoc:(id)sender{
    
    ModifyWryLocViewController *controller = [[ModifyWryLocViewController alloc] initWithNibName:@"ModifyWryLocViewController" bundle:nil];

    controller.oldJD = self.jd;
    controller.oldWD = self.wd;
    
    controller.wrybh = self.primaryKey;
    controller.wrymc = self.wrymc;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)doBilu:(id)sender{
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController.contentSizeForViewInPopover = CGSizeMake(320, 480);
	tmpController.delegate = self;
    tmpController.wordsAry = [NSArray arrayWithObjects:@"现场监察记录表",@"勘验笔录",@"询问笔录",@"绘制勘验图",@"现场取证",nil];
    tmpController.cellImgAry = [NSArray arrayWithObjects:@"icon_xcjcb",@"icon_xckybl.png",@"icon_xwbl.png",@"icon_default.png",@"icon_xcqz.png",nil];
    self.popController = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	[self.popController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"nnnnnnnnnn1");
    UIBarButtonItem *biluBar = [[UIBarButtonItem alloc]initWithTitle:@"做笔录" style:UIBarButtonItemStyleDone target:self action:@selector(doBilu:)];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    NSMutableArray *aryBarItems = [NSMutableArray arrayWithCapacity:5];
    UIBarButtonItem *flexItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
     UIBarButtonItem *modifyLocBar = [[UIBarButtonItem alloc]initWithTitle:@"污染源定位" style:UIBarButtonItemStyleDone target:self action:@selector(modifyLoc:)];
    [aryBarItems addObject:flexItem];
    [aryBarItems addObject:modifyLocBar];
    
    [aryBarItems addObject:biluBar];
    toolBar.items = aryBarItems;
    
    //[self.view addSubview:toolBar];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView DataSource & Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 59;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 59;
	return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.listDataArray count];
}

- (UIView*) tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 59;
    NSDictionary *tmpDic = [self.listDataArray objectAtIndex:section];
    /*
    for (int i = 0; i < [[tmpDic allKeys]count]; i ++) {
        
        NSLog(@"%@:%@",[[tmpDic allKeys]objectAtIndex:i],[tmpDic objectForKey:[[tmpDic allKeys]objectAtIndex:i]]);
    }
    NSLog(@"\n");*/
    NSString *title = [tmpDic objectForKey:@"TITLE"];
    NSRange range = [title rangeOfString:@"[无]"];
    if (range.length > 0) {
        
        title = [title stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"[%@]",[tmpDic objectForKey:@"COUNT"]]];
    }
    
    BOOL opened = YES;
    if(section < [self.arySectionIsOpen count])
    {
        opened = [[self.arySectionIsOpen objectAtIndex:section] boolValue];
    }
	QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc]
                                            initWithFrame:CGRectMake(0.0, 0.0, self.listTableView.bounds.size.width, headerHeight)
                                            title:title
                                            section:section
                                            opened:opened
                                            delegate:self];
	return sectionHeadView ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section < [self.arySectionIsOpen count])
    {
        BOOL opened = [[self.arySectionIsOpen objectAtIndex:section] boolValue];
        if(opened == NO) return 0;
    }
    
    NSDictionary *item = [self.listDataArray objectAtIndex:section];
    NSString *link = [item objectForKey:@"LINK"];
    if([link isEqualToString:@"wry/archives/archiveDetailCategory.jsp"])
    {
        //企业档案
       return 1;
    }
    else if([link isEqualToString:@"wry/pwsb/pwsbDetailCategory.jsp"])
    {
        //排污申报收费
        return 1;
    }
    NSDictionary *dicInfo = [self.listDataArray objectAtIndex:section];
    NSString *title = [dicInfo objectForKey:@"TITLE"];
    NSArray *ary = [self.dicSubTasks objectForKey:title];
	return [ary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.listDataArray objectAtIndex:indexPath.section];
    NSString *link = [item objectForKey:@"LINK"];
    if( [link isEqualToString:@"wry/archives/archiveDetailCategory.jsp"] || [link isEqualToString:@"wry/pwsb/pwsbDetailCategory.jsp"])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Normal_Cell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Normal_Cell"];
        }
        if([link isEqualToString:@"wry/archives/archiveDetailCategory.jsp"])
        {
            //企业档案
            cell.textLabel.text = @"查看污染源企业档案";
        }
        else if([link isEqualToString:@"wry/pwsb/pwsbDetailCategory.jsp"])
        {
            //排污申报收费
            cell.textLabel.text = @"查看排污申报收费信息";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dicInfo = [self.listDataArray objectAtIndex:indexPath.section];
    NSString *title = [dicInfo objectForKey:@"TITLE"];
    NSArray *ary = [self.dicSubTasks objectForKey:title];
    if(indexPath.row < [ary count])
    {
        if([link isEqualToString:@"xmsp/wryXmspDataList.jsp"])
        {
            //项目审批
            NSDictionary *rowInfo = [ary objectAtIndex:indexPath.row];
            cell.textLabel.text = [rowInfo objectForKey:@"TITLE"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"项目编号：%@    %@",[rowInfo objectForKey:@"XMBH"],[rowInfo objectForKey:@"CONTENT"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if([link isEqualToString:@"hjxf/hjxfDataList.jsp"])
        {
            //环境信访
            NSDictionary *rowInfo = [ary objectAtIndex:indexPath.row];
            cell.textLabel.text = [rowInfo objectForKey:@"AJLY"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@    %@",[rowInfo objectForKey:@"WRZL"],[rowInfo objectForKey:@"SLRQ"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if ([link isEqualToString:@"wry/penalty/penaltyDataList.jsp"])
        {
            //行政处罚
            NSDictionary *rowInfo = [ary objectAtIndex:indexPath.row];
            cell.textLabel.text = [rowInfo objectForKey:@"TITLE"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@    %@",[rowInfo objectForKey:@"CONTENT"],[rowInfo objectForKey:@"REMARK"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if([link isEqualToString:@"wry/pwxkz/pwxkzDataList.jsp"])
        {
            //排污许可证
            NSDictionary *rowInfo = [ary objectAtIndex:indexPath.row];
            cell.textLabel.text = [rowInfo objectForKey:@"TITLE"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[rowInfo objectForKey:@"CONTENT"]];
        }
        else if([link isEqualToString:@"wry/wryItemJbxx.jsp"] )
        {
            //基本信息
            NSDictionary *item = [ary objectAtIndex:indexPath.row];
            NSString *title = [[item allKeys] objectAtIndex:0];;
            NSString *value = [item objectForKey:title];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:60.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        else
        {
            NSDictionary *rowInfo = [ary objectAtIndex:indexPath.row];
            cell.textLabel.text = [rowInfo objectForKey:@"TITLE"];
            if([rowInfo objectForKey:@"CONTENT"] != nil)
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[rowInfo objectForKey:@"CONTENT"]];
            else
                cell.detailTextLabel.text = @"";
        }
    }
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.listDataArray objectAtIndex:indexPath.section];
    NSString *link = [item objectForKey:@"LINK"];
    if([link isEqualToString:@"xmsp/wryXmspDataList.jsp"])
    {
        //项目审批
        NSString *title = [item objectForKey:@"TITLE"];
        NSArray *ary = [self.dicSubTasks objectForKey:title];
        NSDictionary *rowInfo = [ary objectAtIndex:indexPath.row];
        /*
        WryXMSPDetailViewController *detail = [[WryXMSPDetailViewController alloc] initWithNibName:@"WryXMSPDetailViewController" bundle:nil];
        detail.wrymc = [rowInfo objectForKey:@"TITLE"];;
        detail.primaryKey = [rowInfo objectForKey:@"PRIMARY_KEY"];
        detail.link = [rowInfo objectForKey:@"LINK"];
        [self.navigationController pushViewController:detail animated:YES];*/
        
        XMSPDetailsViewController *detailsController = [[XMSPDetailsViewController alloc] init];
        detailsController.wrybh = self.primaryKey;
        detailsController.primaryKey = [rowInfo objectForKey:@"PRIMARY_KEY"];
        [self.navigationController pushViewController:detailsController animated:YES];
    }
    else if([link isEqualToString:@"wry/wryItemJbxx.jsp"] ){
        //企业概括
        return;
    }
    else if([link hasPrefix:@"hjxf/hjxfDataList.jsp"])
    {
        //信访投诉
        NSString *title = [item objectForKey:@"TITLE"];
        NSArray *ary = [self.dicSubTasks objectForKey:title];
        NSDictionary *rowInfo = [ary objectAtIndex:indexPath.row];
        HJXFDetailViewController *detail = [[HJXFDetailViewController alloc] init];
        detail.primaryKey = [rowInfo objectForKey:@"PRIMARY_KEY"];
        detail.link = [rowInfo objectForKey:@"LINK"];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if([link isEqualToString:@"wry/archives/archiveDetailCategory.jsp"])
    {
        //企业档案
        WryCompanyArchiveViewController *info = [[WryCompanyArchiveViewController alloc] initWithNibName:@"WryCompanyArchiveViewController" bundle:nil];
        info.link = link;
        info.wrymc = self.wrymc;
        info.primaryKey = self.primaryKey;
        [self.navigationController pushViewController:info animated:YES];
    }
    else if ([link isEqualToString:@"wry/penalty/penaltyDataList.jsp"])
    {
        //行政处罚
        NSString *title = [item objectForKey:@"TITLE"];
        NSArray *ary = [self.dicSubTasks objectForKey:title];
        NSDictionary *rowInfo = [ary objectAtIndex:indexPath.row];
        XZCFDetailsViewController *detail = [[XZCFDetailsViewController alloc] init];
        detail.primaryKey = [rowInfo objectForKey:@"PRIMARY_KEY"];
        detail.link = [rowInfo objectForKey:@"LINK"];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if([link isEqualToString:@"wry/pwsb/pwsbDetailCategory.jsp"])
    {
        //排污申报收费
        PWSFDetailViewController *detail = [[PWSFDetailViewController alloc] init];
        detail.link = link;
        detail.wrymc = self.wrymc;
        detail.primaryKey = self.primaryKey;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else{
        NSString *title = [item objectForKey:@"TITLE"];
        NSArray *ary = [self.dicSubTasks objectForKey:title];
        NSDictionary *rowInfo = [ary objectAtIndex:indexPath.row];
        
        DefaultDetailViewController *detail = [[DefaultDetailViewController alloc] init];
        if([rowInfo objectForKey:@"PRIMARY_KEY"] == nil)
            detail.primaryKey = self.primaryKey;
        else
            detail.primaryKey = [rowInfo objectForKey:@"PRIMARY_KEY"];
        detail.link = [rowInfo objectForKey:@"LINK"];
        if([[item objectForKey:@"COUNT"] integerValue] == -1){
            detail.showDirectly = YES;
        }
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - QQ section header view delegate

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    NSNumber *opened = [self.arySectionIsOpen objectAtIndex:section];
    [self.arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
    [self.listTableView reloadData];
}

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
    NSDictionary *dicInfo = [self.listDataArray objectAtIndex:section];
    NSString * count = [dicInfo objectForKey:@"COUNT"];
    self.currentSelectedIndex = section;
    NSString *link = [dicInfo objectForKey:@"LINK"];
    if([link isEqualToString:@"wry/archives/archiveDetailCategory.jsp"]|| [link isEqualToString:@"wry/pwsb/pwsbDetailCategory.jsp"])
    {
        NSNumber *opened = [self.arySectionIsOpen objectAtIndex:section];
        [self.arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
        [self.listTableView reloadData];
    }
    else 
    {
        
        NSNumber *opened = [self.arySectionIsOpen objectAtIndex:section];
        [self.arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
        NSString *link = [dicInfo objectForKey:@"LINK"];
        if(self.dicSubTasks == nil)
        {
            //没有请求过对应的数据
//            if (count) {
            
                [self requestSubData:link];
//            }
            /*
            if(count == nil || [count integerValue] != 0){
            
                NSLog(@"here");
                [self requestSubData:link];
            }*/
        }
        else
        {
            //之前请求过数据
            NSArray *ary = [self.dicSubTasks objectForKey:[dicInfo objectForKey:@"TITLE"]];
            if(ary == nil)
            {
                [self requestSubData:link];
            }
            else
            {
                [self.listTableView reloadData];
            }
        }
        
    }
}

#pragma mark - Network Handler Methods

/**
 * 获取污染源企业信息目录列表
 * 参数1:service(这里固定为DETAIL_CATEGORY_CONFIG, 必选)
 * 参数2:LINK(对应前面污染源企业列表中的LINK字段, 必选)
 * 参数3:PRIMARY_KEY(污染源编号，对应前面污染源企业列表中的PRIMARY_KEY字段, 必选)
 */
- (void)requestData
{
    self.isLoading = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:self.link forKey:@"LINK"];
    [params setObject:self.primaryKey forKey:@"PRIMARY_KEY"];
    NSString *UrlStr = [ServiceUrlString generateUrlByParameters:params];
//    NSLog(@"1593458=%@",UrlStr);
    self.urlString = UrlStr;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self tagID:1];
}

/**
 * 获取污染源企业信息子目录
 * 参数1:service(这里固定为DETAIL_CATEGORY_CONFIG, 必选)
 * 参数2:LINK(对应前面的LINK字段, 必选)
 * 参数3:PRIMARY_KEY(污染源编号，对应前面的PRIMARY_KEY字段, 必选)
 */
- (void)requestSubData:(NSString *)link
{
    self.isLoading = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:link forKey:@"LINK"];
    [params setObject:self.primaryKey forKey:@"PRIMARY_KEY"];
    NSString *UrlStr = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = UrlStr;
    NSLog(@"UrlStr=%@",UrlStr);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self tagID:2];
}

- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    self.isLoading = NO;
    if(webData.length <= 0)
    {
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSDictionary *detailDict = [jsonStr objectFromJSONString];
    if(tag == 1)
    {
        BOOL bParsedError = NO;
        if(detailDict != nil)
        {
            self.title = [detailDict objectForKey:@"GLOBAL_TITLE"];
            self.listDataArray = [NSMutableArray arrayWithArray:[detailDict objectForKey:@"data"]];
            [self.listDataArray removeLastObject];
            [self.listDataArray removeObjectAtIndex:3];
            [self.listDataArray removeObjectAtIndex:4];
            self.arySectionIsOpen = [NSMutableArray arrayWithCapacity:5];
            for (NSInteger i = 0; i < [self.listDataArray count]; i++)
            {
                [self.arySectionIsOpen addObject:[NSNumber numberWithBool:NO]];
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
    else
    {
        if(self.dicSubTasks == nil)
        {
            self.dicSubTasks = [NSMutableDictionary dictionaryWithCapacity:3];
        }
        NSArray *ary = [detailDict objectForKey:@"data"];
        if(ary == nil)
        {
            ary = [NSArray array];
        }
        NSString *title = [[self.listDataArray objectAtIndex:self.currentSelectedIndex] objectForKey:@"TITLE"];
        [self.dicSubTasks setObject:ary forKey:title];
        [self.listTableView reloadData];
    }
}

- (void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self showAlertMessage:@"获取数据出错!"];
}

- (void)viewDidUnload {
    [self setListTableView:nil];
    [super viewDidUnload];
}
@end
