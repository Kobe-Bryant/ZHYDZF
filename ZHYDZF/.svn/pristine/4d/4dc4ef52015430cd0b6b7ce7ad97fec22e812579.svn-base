//
//  TaskDetailsViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-10-16.
//  Copyright (c) 2013年 szboanda. All rights reserved.
// WORKFLOW_DETAIL_MAIN   WORKFLOW_RECORD_LIST
// 参数: PRIMARY_KEY->YWBH; LCSLBH->LCSLBH ;LCLXBH->LCLXBH; WRYBH; TASK_STATE->PROCESSED\TO_DO
// WORKFLOW_RECORD_LIST参数: XCZFBH
/*
 http://111.1.15.83:81/ydzf_zj/invoke/?version=1.01&imei=A8:20:66:1E:F0:37&clientType=IPAD&userid=system&password=1&service=WORKFLOW_RECORD_LIST&XCZFBH=2013103021283003ec2d489cb0487281bdaff30918d40f&RECORD_NAME=现场勘察笔录
 */

#import "TaskDetailsViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UITableViewCell+Custom.h"
#import "TaskActionsHandler.h"
#import "SiteInforcementConroller.h"
#import "QueryWriteController.h"
#import "InvestigateEvidenceCategoryVC.h"
#import "CaiyangViewController.h"
#import "ZFBLListViewController.h"
#import "WrySiteOnInspectionController.h"
#import "DrawKYTViewController.h"

@interface TaskDetailsViewController ()
@property (nonatomic, strong) NSArray *jbxxAry;//基本信息
@property (nonatomic, strong) NSArray *blgcAry;//办理过程
@property (nonatomic, strong) NSArray *zfblAry;//执法笔录
@property(nonatomic,strong)TaskActionsHandler *actionsModel;
@property (nonatomic,assign) BOOL bOKFromTransfer;
@end

@implementation TaskDetailsViewController
@synthesize actionsModel,bOKFromTransfer,itemParams;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)requestDetailData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"WORKFLOW_DETAIL_MAIN" forKey:@"service"];
    [params setObject:self.YWBH forKey:@"PRIMARY_KEY"];
    [params setObject:self.LCSLBH forKey:@"LCSLBH"];
    [params setObject:self.LCLXBH forKey:@"LCLXBH"];
    [params setObject:self.WRYBH forKey:@"WRYBH"];
    [params setObject:@"TO_DO" forKey:@"TASK_STATE"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"strUrl---%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在请求数据..." tagID:1] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bOKFromTransfer = NO;
     
    self.actionsModel = [[TaskActionsHandler alloc] initWithTarget:self andParentView:self.view];
    [actionsModel handleActionInfo:itemParams];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    if(self.bOKFromTransfer)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [super viewDidAppear:animated];
    [self requestDetailData];

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
    else
    {
        return self.zfblAry.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
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
        /*
        for (int i = 0; i < [[item allKeys]count]; i ++) {
            
            NSLog(@"haha1%@:%@",[[item allKeys]objectAtIndex:i],[item objectForKey:[[item allKeys]objectAtIndex:i]]);
            NSLog(@"\n");
        }*/
        NSString *title = [item objectForKey:@"TITLE"];
        NSString *value = [item objectForKey:@"CONTENT"];
    
        cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:60.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(indexPath.section == 1)
    {
        NSDictionary *item = [self.blgcAry objectAtIndex:indexPath.row];
        /*
        for (int i = 0; i < [[item allKeys]count]; i ++) {
            
            NSLog(@"haha2%@:%@",[[item allKeys]objectAtIndex:i],[item objectForKey:[[item allKeys]objectAtIndex:i]]);
            NSLog(@"\n");
        }*/
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
        
        if (indexPath.row == 4) {
            
            NSLog(@"item===%@",item);

        }
        /*
        for (int i = 0; i < [[item allKeys]count]; i ++) {
            
            NSLog(@"haha3%@:%@",[[item allKeys]objectAtIndex:i],[item objectForKey:[[item allKeys]objectAtIndex:i]]);
        }*/
        NSString *name = [item objectForKey:@"RECORD_NAME"];
        NSString *count = [item objectForKey:@"RECORD_COUNT"];
        NSString *value = [NSString stringWithFormat:@"%@ : %@条", name, count];
        BOOL canAdd = [[item objectForKey:@"ADD_ENABLE"] boolValue];
        NSString *CellIdentifier = @"Normal_Cell";
        if(canAdd)
        {
            CellIdentifier = @"Edit_Cell";
        }
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = value;
        
        if(canAdd)
        {
            UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            addButton.tag = indexPath.row;
            addButton.frame = CGRectMake(650, 15, 30, 30);
            [cell.contentView addSubview:addButton];
            [addButton addTarget:self action:@selector(addNewZFBL:) forControlEvents:UIControlEventTouchUpInside];
        }
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
    NSLog(@"item===%@",item);
    NSString *name = [item objectForKey:@"RECORD_NAME"];
    int count = [[item objectForKey:@"RECORD_COUNT"] intValue];
    if(count > 0)
    {
               
        ZFBLListViewController *list = [[ZFBLListViewController alloc] initWithNibName:@"ZFBLListViewController" bundle:nil];
        list.JBXX = [NSArray arrayWithArray:self.jbxxAry];
        list.XCZFBH = self.YWBH;
        list.RECORDNAME = name;
        if([item objectForKey:@"MBBH"] != nil)
            list.MBBH = [item objectForKey:@"MBBH"];
        [self.navigationController pushViewController:list animated:YES];
    }
}
/*
 
 item==={
 "ADD_ENABLE" = 1;
 "RECORD_COUNT" = 1;
 "RECORD_NAME" = "\U52d8\U9a8c\U56fe";
 TYPE = RECORD;
 }

 */
#pragma mark - Network Handler Methods

- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    if(webData.length <= 0)
    {
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSMutableString *modifyStr = [NSMutableString stringWithString:jsonStr];
    //去掉tab 和 \r\n键
    [modifyStr replaceOccurrencesOfString:@"\r\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifyStr length])];
    [modifyStr replaceOccurrencesOfString:@"\t" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifyStr length])];
    NSDictionary *detailDict = [modifyStr objectFromJSONString];
    BOOL bParsedError = NO;
    if(detailDict != nil)
    {
        self.jbxxAry = [detailDict objectForKey:@"基本信息"];
        self.zfblAry = [detailDict objectForKey:@"执法笔录"];
         self.blgcAry = [detailDict objectForKey:@"办理过程"];
        NSLog(@"zfbl===%@",self.zfblAry);
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

#pragma mark - Event Handler Methods

- (void)addNewZFBL:(UIButton *)sender
{
    NSDictionary *item = [self.zfblAry objectAtIndex:sender.tag];
    NSString *name = [item objectForKey:@"RECORD_NAME"];
    if([name isEqualToString:@"勘验笔录"]){
        SiteInforcementConroller *controller = [[SiteInforcementConroller alloc] initWithNibName:@"SiteInforcementConroller" bundle:Nil];
        NSLog(@"itemdic===%@",itemParams);
        
        if ([self.WRYBH isEqualToString:@""]) {
            controller.dwbh = self.WRYBH;
            controller.wrymc = [itemParams objectForKey:@"DWMC"];
            controller.xczfbh = self.YWBH;
            controller.jbxx = [NSArray arrayWithArray:self.jbxxAry];

            }else{
                controller.dwbh = self.WRYBH;
                controller.wrymc = [itemParams objectForKey:@"DWMC"];
                controller.xczfbh = self.YWBH;
                
                 }
     
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([name isEqualToString:@"现场取证"]){
        InvestigateEvidenceCategoryVC *controller = [[InvestigateEvidenceCategoryVC alloc] init];
        controller.dwbh = self.WRYBH;
        controller.wrymc = [itemParams objectForKey:@"DWMC"];
        controller.xczfbh = self.YWBH;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([name isEqualToString:@"现场采样记录"]){
        CaiyangViewController *controller = [[CaiyangViewController alloc] initWithNibName:@"CaiyangViewController" bundle:Nil];
        controller.dwbh = self.WRYBH;
        controller.wrymc = [itemParams objectForKey:@"DWMC"];
        controller.xczfbh = self.YWBH;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([name isEqualToString:@"询问笔录"]){
        QueryWriteController *controller = [[QueryWriteController alloc] initWithNibName:@"QueryWriteController" bundle:Nil];
        
        if ([self.WRYBH isEqualToString:@""]) {
            controller.dwbh = self.WRYBH;
            controller.wrymc = [itemParams objectForKey:@"DWMC"];
            controller.xczfbh = self.YWBH;
            controller.jbxx = [NSArray arrayWithArray:self.jbxxAry];
            
        }else{
            controller.dwbh = self.WRYBH;
            controller.wrymc = [itemParams objectForKey:@"DWMC"];
            controller.xczfbh = self.YWBH;
            
        }
        
        [self.navigationController pushViewController:controller animated:YES];
    }else if([name isEqualToString:@"现场监察记录表"]){
    
        WrySiteOnInspectionController *controller = [[WrySiteOnInspectionController alloc] initWithNibName:@"WrySiteOnInspectionController" bundle:Nil];
        controller.dwbh = self.WRYBH;
        controller.wrymc = [itemParams objectForKey:@"DWMC"];
        controller.xczfbh = self.YWBH;
        
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([name isEqualToString:@"勘验图"]){
    
        DrawKYTViewController *controller = [[DrawKYTViewController alloc] initWithNibName:@"DrawKYTViewController" bundle:Nil];
        controller.dwbh = self.WRYBH;
        controller.wrymc = [itemParams objectForKey:@"DWMC"];
        controller.xczfbh = self.YWBH;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)HandleGWResult:(BOOL)ret
{
    self.bOKFromTransfer = ret;
}


@end
