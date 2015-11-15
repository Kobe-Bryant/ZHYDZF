//
//  WryCompanyInfoViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-22.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "WryCompanyInfoViewController.h"
#import "ServiceUrlString.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"
#import "NSStringUtil.h"

@interface WryCompanyInfoViewController ()
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSArray *detailAry;
@property (nonatomic, strong) NSArray *toDisplayHeightAry;
@end

@implementation WryCompanyInfoViewController

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
    
    self.title = [NSString stringWithFormat:@"%@-企业概况", self.wrymc];
    
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network Handler Methods

/**
 * 获取污染源企业概况
 * 参数1:service(这里固定为DETAIL_CATEGORY_CONFIG, 必选)
 * 参数2:LINK(对应前面的LINK字段, 必选)
 * 参数3:PRIMARY_KEY(污染源编号，对应前面的PRIMARY_KEY字段, 必选)
 */
- (void)requestData
{
    self.isLoading = YES;

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:self.link forKey:@"LINK"];
    [params setObject:self.primaryKey forKey:@"PRIMARY_KEY"];
    NSString *UrlStr = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = UrlStr;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self tagID:1];
}

- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    self.isLoading = NO;
    if(webData.length <= 0)
    {
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSDictionary *tmpParsedJSONDict = [jsonStr objectFromJSONString];
    if(tmpParsedJSONDict != nil)
    {
        NSArray *ary = [tmpParsedJSONDict objectForKey:@"data"];
        self.detailAry = ary;
        
        //基本信息Cell高度
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
        NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
        for(int i = 0; i < self.detailAry.count; i++)
        {
            NSDictionary *item = [self.detailAry objectAtIndex:i];
            NSString *key = [[item allKeys] objectAtIndex:0];
            NSString *value = [item objectForKey:key];
            NSString *itemTitle =[NSString stringWithFormat:@"%@", value];
            CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
            if(cellHeight < 60)
            {
                cellHeight = 60;
            }
            [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
        }
        self.toDisplayHeightAry = aryTmp;
    }
    [self.detailTableView reloadData];
}

- (void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self showAlertMessage:@"获取数据出错!"];
}

- (void)viewDidUnload {
    [self setDetailTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailAry.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSDictionary *item = [self.detailAry objectAtIndex:indexPath.row];
    NSString *title = [[item allKeys] objectAtIndex:0];;
    NSString *value = [item objectForKey:title];
    cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:60.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.toDisplayHeightAry != nil && self.toDisplayHeightAry.count > 0)
    {
        return [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
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
    headerView.text = @"  企业基本信息";
    return headerView;
}

@end
