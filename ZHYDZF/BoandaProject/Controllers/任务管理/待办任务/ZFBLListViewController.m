//
//  ZFBLListViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-31.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "ZFBLListViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "SiteInforcementConroller.h"
#import "InvestigateEvidenceCategoryVC.h"
#import "CaiyangViewController.h"
#import "QueryWriteController.h"
#import "WrySiteOnInspectionController.h"

#import "DisplayAttachFileController.h"

@interface ZFBLListViewController ()
@property (nonatomic, strong) NSArray *listDataArray;
@end

@implementation ZFBLListViewController
@synthesize JBXX;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.MBBH = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.listTableView setBackgroundView:nil];
    [self.listTableView setBackgroundView:[[UIView alloc]init]];
    self.listTableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundColor = [UIColor clearColor];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//service=&=2013103021283003ec2d489cb0487281bdaff30918d40f&=现场勘察笔录
- (void)requestData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"WORKFLOW_RECORD_LIST" forKey:@"service"];
    [params setObject:self.XCZFBH forKey:@"XCZFBH"];
    [params setObject:self.MBBH forKey:@"MBBH"];
    [params setObject:self.RECORDNAME forKey:@"RECORD_NAME"];

    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在请求数据..." tagID:1];
}

#pragma mark - Network Handler Methods

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
        self.title = self.RECORDNAME;
        self.listDataArray = [detailDict objectForKey:@"data"];
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

- (void)processError:(NSError *)error andTag:(NSInteger)tag
{
    [self showAlertMessage:@"获取数据出错!"];
}


- (void)viewDidUnload {
    [self setListTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listDataArray.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [self.listDataArray objectAtIndex:indexPath.section];
    if([self.RECORDNAME isEqualToString:@"勘验笔录"])
    {
        cell.textLabel.text = [dict objectForKey:@"TITLE"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@", [dict objectForKey:@"DESCRIPTION"], [dict objectForKey:@"REMARK"], [dict objectForKey:@"TIME"]];
    }
    else if([self.RECORDNAME isEqualToString:@"现场取证"]  || [self.RECORDNAME isEqualToString:@"询问笔录"])
    {
        cell.textLabel.text = [dict objectForKey:@"TITLE"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"REMARK"], [dict objectForKey:@"TIME"]];
    }
    else if([self.RECORDNAME isEqualToString:@"勘验图"])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"检查人:%@", [dict objectForKey:@"CJR"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"REMARK"]];
    }
    else if ([self.RECORDNAME isEqualToString:@"现场监察记录表"]){
        cell.textLabel.text = [NSString stringWithFormat:@"检查人:%@", [dict objectForKey:@"JCRY"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"REMARK"]];
    
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *item = [self.listDataArray objectAtIndex:indexPath.section];
    NSString *name = self.RECORDNAME;
    if([name isEqualToString:@"勘验笔录"]){
        SiteInforcementConroller *controller = [[SiteInforcementConroller alloc] initWithNibName:@"SiteInforcementConroller" bundle:Nil];
        controller.jbxx = [NSArray arrayWithArray:self.JBXX];
        controller.basebh = [item objectForKey:@"BH"];
        controller.isCKXQ = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
        else if([name isEqualToString:@"现场取证"]){
        InvestigateEvidenceCategoryVC *controller = [[InvestigateEvidenceCategoryVC alloc] init];
        controller.basebh = [item objectForKey:@"BH"];
        controller.xczfbh = self.XCZFBH;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([name isEqualToString:@"现场采样记录"]){
        CaiyangViewController *controller = [[CaiyangViewController alloc] initWithNibName:@"CaiyangViewController" bundle:Nil];
        controller.basebh = [item objectForKey:@"BH"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([name isEqualToString:@"询问笔录"]){
        QueryWriteController *controller = [[QueryWriteController alloc] initWithNibName:@"QueryWriteController" bundle:Nil];
        controller.basebh = [item objectForKey:@"BH"];
        controller.isCKXQ = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else if([name isEqualToString:@"现场监察记录表"]){
        WrySiteOnInspectionController *controller = [[WrySiteOnInspectionController alloc] initWithNibName:@"WrySiteOnInspectionController" bundle:Nil];
        controller.basebh = [item objectForKey:@"BH"];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([name isEqualToString:@"勘验图"]){

        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"DOWN_OA_FILES" forKey:@"service"];
        [params setObject:@"DOWNLOAD_XCQZ_FILE" forKey:@"GLLX"];
        [params setObject:@".jpg" forKey:@"FJLX"];
        [params setObject:[item objectForKey:@"FJDZ"] forKey:@"PATH"];//
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        
        DisplayAttachFileController *detail = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:strUrl andFileName:@"kyt.jpg"];
        [self.navigationController pushViewController:detail animated:YES];
    
        
    }
}
@end
