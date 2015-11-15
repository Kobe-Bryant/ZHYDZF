//
//  ZFTZMainRecordViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-28.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "ZFTZMainRecordViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "ZFTZChildRecordViewController.h"
#import "ZFBLListViewController.h"
@interface ZFTZMainRecordViewController ()
@property (nonatomic, strong) NSArray *listDataArray;
@end

@implementation ZFTZMainRecordViewController

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
    [self.listTableView setBackgroundView:nil];
    [self.listTableView setBackgroundView:[[UIView alloc]init]];
    self.listTableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundColor = [UIColor clearColor];

    NSLog(@"158");
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
    [super viewDidUnload];
}

#pragma mark - Network Handler Methods

/**
 * 获取执法台账执法记录列表
 * 参数1:service(这里固定为RSS_DATA_LIST, 必选)
 * 参数2:MENU_SERIES(菜单编号, 必选)
 */
- (void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:self.link forKey:@"LINK"];
    [params setObject:self.primaryKey forKey:@"PRIMARY_KEY"];
    NSString *UrlStr = [ServiceUrlString generateUrlByParameters:params];
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:UrlStr andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
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
        self.title = [detailDict objectForKey:@"GLOBAL_TITLE"];
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

- (void)processError:(NSError *)error
{
    [self showAlertMessage:@"获取数据出错!"];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [self.listDataArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [dict objectForKey:@"TITLE"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.listDataArray objectAtIndex:indexPath.section];
    if([[dict objectForKey:@"TITLE"] isEqualToString:@"现场取证"]){
        
        NSLog(@"123");
        ZFBLListViewController *list = [[ZFBLListViewController alloc] initWithNibName:@"ZFBLListViewController" bundle:nil];
        list.XCZFBH = self.primaryKey;
        list.RECORDNAME = @"现场取证";
        [self.navigationController pushViewController:list animated:YES];
    }else{
        
        NSLog(@"456");
        ZFTZChildRecordViewController *child = [[ZFTZChildRecordViewController alloc] initWithNibName:@"ZFTZChildRecordViewController" bundle:nil];
        
        child.title = [dict objectForKey:@"TITLE"];
        child.link = [dict objectForKey:@"LINK"];
        child.primaryKey = self.primaryKey;
        child.recordId = [dict objectForKey:@"recordId"];
        child.templateId = [dict objectForKey:@"templateId"];
        [self.navigationController pushViewController:child animated:YES];
    }
    
}

@end
