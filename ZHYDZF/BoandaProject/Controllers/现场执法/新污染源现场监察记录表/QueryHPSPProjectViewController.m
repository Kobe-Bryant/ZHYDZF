//
//  QueryHPSPProjectViewController.m
//  BoandaProject
//
//  Created by ZHONGWEN on 14-2-27.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "QueryHPSPProjectViewController.h"
#import "XMSPDetailsViewController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
@interface QueryHPSPProjectViewController ()
@property (nonatomic, assign) NSInteger totalCount;//总记录条数
@property (nonatomic, strong) NSArray *dicSubTasks;
@end

@implementation QueryHPSPProjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.totalCount = 0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered
                                                             target:self action:@selector(cancelSelect:)];
	self.navigationItem.rightBarButtonItem = myBtn;
    
    [self requestSubData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 获取污染源企业信息子目录
 * 参数1:service(这里固定为DETAIL_CATEGORY_CONFIG, 必填)
 * 参数2:LINK(对应前面的LINK字段, 必选)
 * 参数3:PRIMARY_KEY(污染源编号，对应前面的PRIMARY_KEY字段, 必填)
 */
- (void)requestSubData
{
    //self.isLoading = YES;
    NSString *link = @"xmsp/wryXmspDataList.jsp";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:link forKey:@"LINK"];
    [params setObject:self.wrybh forKey:@"PRIMARY_KEY"];
    NSString *UrlStr = [ServiceUrlString generateUrlByParameters:params];
    //self.urlString = UrlStr;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:UrlStr andParentView:self.view delegate:self tagID:2];
}

- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    //self.isLoading = NO;
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
        self.dicSubTasks = [detailDict objectForKey:@"data"];
        [self.listTableView reloadData];
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
    //self.isLoading = NO;
    [self showAlertMessage:@"获取数据出错!"];
}

#pragma mark -
#pragma mark event handle
-(void)cancelSelect:(id)sender{
	[self dismissModalViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dicSubTasks count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"环评建设项目(%d)",self.totalCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *rowInfo = [self.dicSubTasks objectAtIndex:indexPath.row];
    cell.textLabel.text = [rowInfo objectForKey:@"TITLE"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"项目编号：%@    %@",[rowInfo objectForKey:@"XMBH"],[rowInfo objectForKey:@"CONTENT"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //项目审批
    //NSString *title = [item objectForKey:@"TITLE"];
    NSDictionary *rowInfo = [self.dicSubTasks objectAtIndex:indexPath.row];
    /*
     WryXMSPDetailViewController *detail = [[WryXMSPDetailViewController alloc] initWithNibName:@"WryXMSPDetailViewController" bundle:nil];
     detail.wrymc = [rowInfo objectForKey:@"TITLE"];;
     detail.primaryKey = [rowInfo objectForKey:@"PRIMARY_KEY"];
     detail.link = [rowInfo objectForKey:@"LINK"];
     [self.navigationController pushViewController:detail animated:YES];*/
    
    XMSPDetailsViewController *detailsController = [[XMSPDetailsViewController alloc] init];
    detailsController.primaryKey = [rowInfo objectForKey:@"PRIMARY_KEY"];
    [self.navigationController pushViewController:detailsController animated:YES];

}

@end
