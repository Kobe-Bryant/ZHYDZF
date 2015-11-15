//
//  NewTaskDetailViewController.m
//  BoandaProject
//
//  Created by 曾静 on 14-3-18.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "NewTaskDetailViewController.h"
#import "UITableViewCell+Custom.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "ZFTZMainRecordViewController.h"

@interface NewTaskDetailViewController ()

@property (nonatomic, strong) NSArray *jbxxAry;
@property (nonatomic, strong) NSArray *blgcAry;
@property (nonatomic, strong) NSArray *jcdxAry;

@end

@implementation NewTaskDetailViewController

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
    
    self.title = @"已办任务";
    
    [self addCustomView];
    
    [self requestData];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network Handler Methods

- (void)requestData
{
    NSString *YWBH = [self.itemParams objectForKey:@"YWBH"];
    NSString *LCSLBH = [self.itemParams objectForKey:@"LCSLBH"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"SHOW_RWGL_DETAIL" forKey:@"service"];
    [params setObject:YWBH forKey:@"PRIMARY_KEY"];
    [params setObject:LCSLBH forKey:@"LCSLBH"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
{
    if(webData.length <= 0)
    {
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    if(resultJSON.length > 0)
    {
        
    }
    NSDictionary *resultJSONDict = [resultJSON objectFromJSONString];
    self.jbxxAry = [resultJSONDict objectForKey:@"基本信息"];
    self.blgcAry = [resultJSONDict objectForKey:@"办理过程"];
    self.jcdxAry = [resultJSONDict objectForKey:@"检查对象"];
    
    [self.detailTableView reloadData];
}

- (void)processError:(NSError *)error
{
    [self showAlertMessage:@"获取数据失败,请稍后再试!"];
    return;
}

#pragma mark - Private Methods

- (void)addCustomView
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    bgView.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:bgView];
    
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, 728, 920) style:UITableViewStylePlain];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    [self.view addSubview:self.detailTableView];
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
        return self.jcdxAry.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 60;
    }
    else if(indexPath.section == 1)
    {
        return 90;
    }
    else if(indexPath.section == 2)
    {
        return 200;
    }
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
    else  headerView.text = @"  检查对象";
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
        NSDictionary *dic = [self.jbxxAry objectAtIndex:indexPath.row];
        NSString *TITLE = [dic objectForKey:@"TITLE"];
        NSString *CONTENT = [dic objectForKey:@"CONTENT"];
        NSString *titleStr = [NSString stringWithFormat:@"%@", TITLE];
        cell = [UITableViewCell makeSubCell:tableView withTitle:titleStr value:CONTENT andHeight:60.0f];
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
                                  andHeight:90];
    }
    else if (indexPath.section == 2)
    {
        NSDictionary *item = [self.jcdxAry objectAtIndex:indexPath.row];
        NSString *name = [item objectForKey:@"检查对象名称"];
        NSString *xcjcjlb = [NSString stringWithFormat:@"现场检查记录表：%d条",  [[item objectForKey:@"现场检查记录表"] intValue]];
        NSString *xcjckcbl = [NSString stringWithFormat:@"现场检查勘察笔录：%d条",  [[item objectForKey:@"现场检查勘察笔录"] intValue]];
        NSString *wyyxcjcjl = [NSString stringWithFormat:@"污染源现场监察记录：%d条",  [[item objectForKey:@"污染源现场监察记录"] intValue]];
        NSString *xwbl = [NSString stringWithFormat:@"询问笔录：%d条",  [[item objectForKey:@"询问笔录"] intValue]];
        NSString *xcjcfj = [NSString stringWithFormat:@"现场监察附件：%d条",  [[item objectForKey:@"现场监察附件"] intValue]];
        NSString *xcjckcqyd = [NSString stringWithFormat:@"现场检查勘察取样单：%d条",  [[item objectForKey:@"现场检查勘察取样单"] intValue]];
        NSArray *ary = [NSArray arrayWithObjects:xcjcjlb, xcjckcbl, wyyxcjcjl, xwbl, xcjcfj, xcjckcqyd, nil];
        NSString *CellIdentifier = @"Normal_Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [UITableViewCell makeSubCell:tableView Hight:200 Title:name Array:ary];
        }
        int xcjcjlbCount = [[item objectForKey:@"现场检查记录表"] intValue];
        int xcjckcblCount = [[item objectForKey:@"现场检查勘察笔录"] intValue];
        int wyyxcjcjlCount = [[item objectForKey:@"污染源现场监察记录"] intValue];
        int xwblCount = [[item objectForKey:@"询问笔录"] intValue];
        int xcjcfjCount = [[item objectForKey:@"现场监察附件"] intValue];
        int xcjckcqydCount = [[item objectForKey:@"现场检查勘察取样单"] intValue];
        if(xcjcjlbCount <= 0 && xcjckcblCount <= 0 && wyyxcjcjlCount <= 0 && xwblCount <= 0 && xcjcfjCount<= 0 && xcjckcqydCount <= 0)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        NSDictionary *item = [self.jcdxAry objectAtIndex:indexPath.row];
        
        int xcjcjlbCount = [[item objectForKey:@"现场检查记录表"] intValue];
        int xcjckcblCount = [[item objectForKey:@"现场检查勘察笔录"] intValue];
        int wyyxcjcjlCount = [[item objectForKey:@"污染源现场监察记录"] intValue];
        int xwblCount = [[item objectForKey:@"询问笔录"] intValue];
        int xcjcfjCount = [[item objectForKey:@"现场监察附件"] intValue];
        int xcjckcqydCount = [[item objectForKey:@"现场检查勘察取样单"] intValue];
        if(xcjcjlbCount <= 0 && xcjckcblCount <= 0 && wyyxcjcjlCount <= 0 && xwblCount <= 0 && xcjcfjCount<= 0 && xcjckcqydCount <= 0)
        {
            return;
        }
        
        NSString *bh = [item objectForKey:@"编号"];
        ZFTZMainRecordViewController *detail = [[ZFTZMainRecordViewController alloc] initWithNibName:@"ZFTZMainRecordViewController" bundle:nil];
        detail.primaryKey = bh;
        detail.link = @"wry/inspect/wryJcdxDgbd.jsp";
        [self.navigationController pushViewController:detail animated:YES];
    }
}

@end
