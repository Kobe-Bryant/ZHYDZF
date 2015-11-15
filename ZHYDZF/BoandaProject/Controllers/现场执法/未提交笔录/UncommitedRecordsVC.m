//
//  UncommitedRecordsVC.m
//  BoandaProject
//
//  Created by 张仁松 on 13-12-13.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "UncommitedRecordsVC.h"
#import "RecordsHelper.h"
#import "SystemConfigContext.h"
#import "SiteInforcementConroller.h"
#import "QueryWriteController.h"  //询问笔录

#import "DrawKYTViewController.h"
#import "WrySiteOnInspectionController.h"
@interface UncommitedRecordsVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *aryRecords;
@end

@implementation UncommitedRecordsVC
@synthesize listTableView,aryRecords;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString*)getBiluNameByTable:(NSString*)tableName{
    if([tableName isEqualToString:@"T_YDZF_XCKCBL"])
        return @"勘验笔录";
    else  if([tableName isEqualToString:@"T_YDZF_XCKCBL_KYT"])
        return @"绘制勘验图";
    else  if([tableName isEqualToString:@"T_YDZF_DCXWBL"])
        return @"询问笔录";
    else  if([tableName isEqualToString:@"T_YDZF_WRYXCJCJL_NEW"])
        return @"现场监察记录表";
    else
        return @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"未提交笔录";
    self.aryRecords = [[NSMutableArray alloc]initWithCapacity:0];
	// Do any additional setup after loading the view.
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RecordsHelper *helper = [[RecordsHelper alloc] init];
    NSDictionary *usrInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    NSLog(@"usrinfo===%@",usrInfo);
    [self.aryRecords removeAllObjects];
    [self.aryRecords addObjectsFromArray:[helper queryUncommitedRecords:[usrInfo objectForKey:@"uname"]]];
    [self.listTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource & Delegate Methods
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    RecordsHelper *helper = [[RecordsHelper alloc] init];
//    NSDictionary *dic = [self.aryRecords objectAtIndex:indexPath.row];
//    NSString *path = [dic objectForKey:@"PATH"];
//    if (!(path == nil || [path isEqual:[NSNull null]])) {
//        NSFileManager *file = [NSFileManager defaultManager];
//        [file removeItemAtPath:path error:nil];
//    }
//    [helper deleteRecordByBH:[dic objectForKey:@"BH"] andTableName:[dic objectForKey:@"TABLENAME"]];
//    
//    [self.aryRecords removeObjectAtIndex:indexPath.row];
//    [self.listTableView reloadData];
//}
-(void)deleteLoaded:(NSIndexPath *)indexpath{

    RecordsHelper *helper = [[RecordsHelper alloc] init];
        NSDictionary *dic = [self.aryRecords objectAtIndex:indexpath.row];
        NSString *path = [dic objectForKey:@"PATH"];
        if (!(path == nil || [path isEqual:[NSNull null]])) {
            NSFileManager *file = [NSFileManager defaultManager];
            [file removeItemAtPath:path error:nil];
        }
        [helper deleteRecordByBH:[dic objectForKey:@"BH"] andTableName:[dic objectForKey:@"TABLENAME"]];
    
    [self.aryRecords removeObjectAtIndex:indexpath.row];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.aryRecords objectAtIndex:[self.aryRecords count] - 1 - indexPath.row];
    NSString *dwmc = [dict objectForKey:@"WRYMC"];
    NSString *detail = [NSString stringWithFormat:@"笔录类型：%@  日期：%@", [self getBiluNameByTable:[dict objectForKey:@"TABLENAME"]],[dict objectForKey:@"CJSJ"]];
    
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
    headerView.text = [NSString stringWithFormat:@"  未提交笔录:%d条", self.aryRecords.count];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"self.aryrecodes====%@\n",self.aryRecords);
    NSDictionary *dict = [self.aryRecords objectAtIndex:[self.aryRecords count] - 1 - indexPath.row];
    NSLog(@"index===%d",[self.aryRecords count] - 1 - indexPath.row);
    NSString * tableName = [dict objectForKey:@"TABLENAME"];
    NSString *bh = [dict objectForKey:@"BH"];
    NSLog(@"bh===%@",bh);
    NSString *wrymc = [dict objectForKey:@"WRYMC"];
    
    RecordsHelper *helper = [[RecordsHelper alloc] init];
    // 读取数据库
    NSDictionary *result = [helper queryRecordByWrymc:wrymc andWryBH:@"" andTableName:tableName andBH:bh];
    NSLog(@"result====%@",result);
    if (result == nil) {
        return;
    }
    
    NSString *xczfbh = [result objectForKey:@"XCZFBH"];
    NSString *wrybh = [result objectForKey:@"WRYBH"];
    if([tableName isEqualToString:@"T_YDZF_XCKCBL_KYT"]){
        DrawKYTViewController *controller = [[DrawKYTViewController alloc] initWithNibName:@"DrawKYTViewController" bundle:nil];
        controller.bgPath = [result objectForKey:@"PATH"];
        controller.wrymc = wrymc;
        controller.dwbh = wrybh;
        controller.xczfbh = xczfbh;
        controller.basebh = bh;
        controller.unCommitedBilu = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else if([tableName isEqualToString:@"T_YDZF_XCKCBL"]){
        SiteInforcementConroller *controller = [[SiteInforcementConroller alloc] initWithNibName:@"SiteInforcementConroller" bundle:nil];
        controller.wrymc = wrymc;
        controller.dwbh = wrybh;
        controller.xczfbh = xczfbh;
        controller.basebh = bh;
        controller.unCommitedBilu = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else  if([tableName isEqualToString:@"T_YDZF_DCXWBL"]){
        
        QueryWriteController *controller = [[QueryWriteController alloc] initWithNibName:@"QueryWriteController" bundle:nil];
        controller.wrymc = wrymc;
        controller.dwbh = wrybh;
        controller.xczfbh = xczfbh;
        controller.basebh = bh;
        controller.unCommitedBilu = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    else  if([tableName isEqualToString:@"T_YDZF_WRYXCJCJL_NEW"]){
        WrySiteOnInspectionController *controller = [[WrySiteOnInspectionController alloc] initWithNibName:@"WrySiteOnInspectionController" bundle:nil];
        controller.wrymc = wrymc;
        controller.dwbh = wrybh;
        controller.xczfbh = xczfbh;
        controller.basebh = bh;
        controller.unCommitedBilu = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    //[self deleteLoaded:indexPath];
}

@end
