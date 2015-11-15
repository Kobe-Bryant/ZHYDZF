//
//  PWSFDetailViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "PWSFDetailViewController.h"
#import "ServiceUrlString.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"

@interface PWSFDetailViewController ()
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation PWSFDetailViewController

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
    
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"申报量",@"核定量",@"缴费情况", nil]];
    segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segCtrl addTarget:self action:@selector(segValueChanged:) forControlEvents:UIControlEventValueChanged];
    segCtrl.selectedSegmentIndex = 0;
    self.navigationItem.titleView  = segCtrl;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:self.primaryKey forKey:@"PRIMARY_KEY"];
    [params setObject:@"wry/pwsb/declareDataDetail.jsp" forKey:@"LINK"];
    NSString *url = [ServiceUrlString generateUrlByParameters:params];
    [self requestData:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network Handler Methods

/**
 * 获取污染源企业排污收费详细信息
 * 参数1:service(这里固定为DETAIL_CATEGORY_CONFIG, 必选)
 * 参数2:LINK(对应前面的LINK字段, 必选)
 * 参数3:PRIMARY_KEY(污染源编号，对应前面的PRIMARY_KEY字段, 必选)
 */
- (void)requestData:(NSString *)url
{
    self.isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:url andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
{
    self.isLoading = NO;
    if(webData.length <= 0)
    {
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    
}

- (void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self showAlertMessage:@"获取数据出错!"];
}

-(void)segValueChanged:(id)sender
{
    UISegmentedControl *segCtrl = (UISegmentedControl*)sender;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:self.primaryKey forKey:@"PRIMARY_KEY"];
    if(segCtrl.selectedSegmentIndex == 0)
    {
        [params setObject:@"wry/pwsb/declareDataDetail.jsp" forKey:@"LINK"];
    }
    else if(segCtrl.selectedSegmentIndex == 1)
    {
        [params setObject:@"wry/pwsb/approvalDataDetail.jsp" forKey:@"LINK"];
    }
    else if(segCtrl.selectedSegmentIndex == 2)
    {
        [params setObject:@"wry/pwsb/payDataDetail.jsp" forKey:@"LINK"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    [self requestData:strUrl];
}

@end
