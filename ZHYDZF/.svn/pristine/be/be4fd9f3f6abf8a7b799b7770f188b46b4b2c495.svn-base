//
//  TodoTaskListViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-10-12.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//  工作流待办任务查询，分两步加载：先查询出工作流的任务分类，根据任务类型再查待办任务

#import "TodoTaskListViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "QQSectionHeaderView.h"
#import "TaskDetailsViewController.h"

@interface TodoTaskListViewController ()<QQSectionHeaderViewDelegate>
@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)NSArray *aryTodoItem;//各种类型的待办任务总数



@end

#define DATA_COUNT -1


@implementation TodoTaskListViewController{

    

}
@synthesize listTableView,aryTodoItem;

 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//获取指定类型的待办任务个数
-(void)requestTaskList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_TODO_TASK_LIST" forKey:@"service"];
     [params setObject:@"43000000003"forKey:@"TASK_TYPE"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    NSLog(@"daibanrenwu-----%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在请求数据..." tagID:0] ;
}

//获取待办任务的类型以及个数
-(void)requestTaskCount{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_TASK_TYPE_COUNT" forKey:@"service"];

    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在请求数据..." tagID:DATA_COUNT] ;
}

-(void)processWebData:(NSData*)webData andTag:(NSInteger)tag
{
    if([webData length] <=0 )
    {
        NSString *msg = @"没有获取到相关数据。";
        [self showAlertMessage:msg];
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];

   
        self.aryTodoItem = [resultJSON objectFromJSONString];
    NSLog(@"arytodoitem===%@",self.aryTodoItem);
        [self.listTableView reloadData];
    
    
    
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:@"请求数据失败,请检查网络."];
    
    return;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestTaskList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"待办任务";
	// Do any additional setup after loading the view.
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 960) style:UITableViewStylePlain];
    [self.view addSubview:listTableView];
    listTableView.dataSource = self;
    listTableView.delegate = self;
    //[self requestTaskList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

#define HEADER_HEIGHT 59

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//[aryTaskCount count]; // 分组数
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
	return [aryTodoItem count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
     if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
   
   
    if(indexPath.row < [aryTodoItem count]){
        NSDictionary *rowInfo = [aryTodoItem objectAtIndex:indexPath.row];
        
        NSString *lcqxStr = [rowInfo objectForKey:@"LCQX"];
        NSRange range = [lcqxStr rangeOfString:@"00:00"];
        if (range.length > 0) {
            
            lcqxStr = [lcqxStr substringToIndex:range.location - 1];
        }
        
        cell.textLabel.text = [rowInfo objectForKey:@"DWMC"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"交办人：%@    流程期限：%@    步骤名称：%@",[rowInfo objectForKey:@"BZCJR"],lcqxStr,[rowInfo objectForKey:@"BZMC"]];
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    TaskDetailsViewController *details = [[TaskDetailsViewController alloc] initWithNibName:@"TaskDetailsViewController" bundle:nil];
   NSDictionary *rowInfo = [aryTodoItem objectAtIndex:indexPath.row];
    NSLog(@"rowinfo===%@",aryTodoItem);
    details.YWBH = [rowInfo objectForKey:@"YWBH"];
	details.LCSLBH = [rowInfo objectForKey:@"LCSLBH"];
    
    details.LCLXBH = [rowInfo objectForKey:@"LCLXBH"];
    details.WRYBH = [rowInfo objectForKey:@"WRYBH"];
    details.itemParams = rowInfo;
    [self.navigationController pushViewController:details animated:YES];
}



@end
