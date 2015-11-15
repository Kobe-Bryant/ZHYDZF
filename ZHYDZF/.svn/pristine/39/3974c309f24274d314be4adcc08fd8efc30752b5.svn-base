//
//  ExpertViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-11-15.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "ExpertViewController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "ExpertDetailViewController.h"

@interface ExpertViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *aryExperts;
@property(nonatomic,strong)UITableView *listTableView;
@end

@implementation ExpertViewController
@synthesize listTableView,aryExperts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)requestData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_ZJXX_LIST" forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:0] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"应急专家库";
	// Do any additional setup after loading the view.
    self.listTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768,960 ) style:UITableViewStylePlain];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    [self.view addSubview:listTableView];
    
    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
    {
        NSString *msg = @"登录失败";
        [self showAlertMessage:msg];
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    BOOL bFailed = NO;
    NSDictionary *dicResult = [resultJSON objectFromJSONString];
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        NSArray *ary = [dicResult objectForKey:@"data"];
        if ([ary count] > 0) {
            self.aryExperts = ary;
        }
        [listTableView reloadData];
    }else
        bFailed = YES;
    if(bFailed)
        [self showAlertMessage:@"未能查询到相关数据."];
    
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:@"请求数据失败,请检查网络."];
    
    return;
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryExperts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"共有专家%d人",[aryExperts count]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
      //  cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.imageView.image = [UIImage imageNamed:@"expert.png"];
    }
    
    NSDictionary *dicItem = [self.aryExperts objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@（%@）",[dicItem objectForKey:@"TITLE"],[dicItem objectForKey:@"CONTENT"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",[dicItem objectForKey:@"REMARK"],[dicItem objectForKey:@"TIME"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertDetailViewController *detail = [[ExpertDetailViewController alloc] init];
    NSDictionary *dicItem = [self.aryExperts objectAtIndex:indexPath.row];
    detail.primaryKey = [dicItem objectForKey:@"PRIMARY_KEY"];
    [self.navigationController pushViewController:detail animated:YES];
    
}
@end
