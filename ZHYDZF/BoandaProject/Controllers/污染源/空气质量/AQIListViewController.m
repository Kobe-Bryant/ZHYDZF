//
//  AQIListViewController.m
//  BoandaProject
//
//  Created by BOBO on 14-1-16.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "AQIListViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import "AQIInfoViewController.h"


@interface AQIListViewController ()
@property (nonatomic,strong) NSMutableArray *valueAry;
@property (nonatomic,strong) NSMutableArray *IDArray;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* arySectionIsOpen;
@property(nonatomic,assign) NSInteger taskTypeIndex;
@end

@implementation AQIListViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"空气质量监测";
    _valueAry = [[NSMutableArray alloc]initWithObjects:@"移动车",@"LG",@"炼化",@"港埠",@"镇海新城",@"化工区",@"镇海中学",@"围垦",@"龙赛医院", nil];
    _IDArray = [[NSMutableArray alloc]initWithObjects:@"10056",@"10057",@"10069",@"10070",@"10018",@"10052",@"10053",@"10054",@"10000", nil];
    
    [self addViews];
    //[self loadData];
    
    //_searchField.delegate = self;
    
}
-(void)addViews{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (IBAction)searchButton:(UIButton *)sender
{
    
    [self loadData];
    [_searchField resignFirstResponder];
}

-(void)loadData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_YDZF_WRYLIST_ZXJC" forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tagID:0];
}

-(void)processWebData:(NSData *)webData{
    if([webData length] <=0 )
    {
        [self showAlertMessage:@"获取数据失败"];
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    id obj = [resultJSON objectFromJSONString];
    if(![obj isKindOfClass:[NSArray class]])
    {
        
        [self showAlertMessage:@"获取数据失败"];
        return;
    }
    else
    {
        [_valueAry removeAllObjects];
        
        NSArray* dicResult = [resultJSON objectFromJSONString];
        
        NSMutableArray *infoArray = [[dicResult objectAtIndex:0]objectForKey:@"dataInfos"];
        
        if (infoArray && [infoArray count] > 0)
        {
            [_valueAry addObjectsFromArray:infoArray];
            
            for (int i=0; i<_valueAry.count; i++)
            {
                [self.arySectionIsOpen addObject:[NSNumber numberWithBool:NO]];
            }
            
            [_tableView reloadData];
        }
        else{
            [self showAlertMessage:@"没有查询到数据"];
            [_valueAry removeAllObjects];
            [_tableView reloadData];
        }
    }
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:@"请求数据失败,请检查网络."];
    
    return;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _valueAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ListCell" owner:self options:nil]lastObject];
    }
    NSString *str= [_valueAry objectAtIndex:indexPath.row];
    UILabel *label1 = (UILabel *)[cell viewWithTag:1];
    UILabel *label2 = (UILabel *)[cell viewWithTag:2];
    UILabel *label3 = (UILabel *)[cell viewWithTag:3];
    
    label1.text = str;
    label2.text = @"";
    label3.text = @"";
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *IDstr = [_IDArray objectAtIndex:indexPath.row];
    AQIInfoViewController *monitor = [[AQIInfoViewController alloc]initWithNibName:@"MoreInfoViewController" bundle:nil];
    monitor.IDStr = IDstr;
   // NSLog(@"idarray====%@\nvalueary===%@",_IDArray,_valueAry);
    [monitor setIDArray:_IDArray];
    monitor.titleStr = [_valueAry objectAtIndex:indexPath.row];
   // NSLog(@"monitor===%@",monitor.titleStr);
    monitor.pwkNameAry = _valueAry;
    [self.navigationController pushViewController:monitor animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"查询结果";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loadData];
    [_searchField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSearchField:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
}

@end
