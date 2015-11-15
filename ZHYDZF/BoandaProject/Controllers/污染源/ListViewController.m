//
//  ListViewController.m
//  BoandaProject
//
//  Created by 熊熙 on 13-12-10.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "ListViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import "MoreInfoViewController.h"
#import "QQSectionHeaderView.h"
#import "CommenWordsViewController.h"

@interface ListViewController ()<UITextFieldDelegate,WordsDelegate>
@property (nonatomic,strong) UIPopoverController *poverController;
@property (nonatomic,strong) NSMutableArray *valueAry;
@property (strong, nonatomic) NSMutableArray* arySectionIsOpen;
@property(nonatomic,assign) NSInteger taskTypeIndex;
@property (strong, nonatomic) UISearchBar* searchBar;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger savePklx;
@property (assign, nonatomic) NSInteger totalCount;
@end

@implementation ListViewController
@synthesize searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)search{
//
//    [self loadData:searchBar.text];
//}
- (IBAction)searchButtonPress:(UIButton *)sender {
    self.currentPage = 1;
    [self.valueAry removeAllObjects];
    [self.pkmcField resignFirstResponder];
    [self requestData];
}
- (IBAction)textFieldTouchDown:(UITextField *)sender {
    CommenWordsViewController *wordsViewController = [[CommenWordsViewController alloc]initWithStyle:UITableViewStylePlain];
    wordsViewController.contentSizeForViewInPopover = CGSizeMake(200, 300);
    wordsViewController.delegate = self;
    wordsViewController.wordsAry = @[@"全选",@"烟气",@"废水",@"厂界气体"];
    self.poverController = [[UIPopoverController alloc]initWithContentViewController:wordsViewController];
    [self.poverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)requestData{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_ONLINE_SITE" forKey:@"service"];
    [params setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"P_CURRENT"];
    if (self.pkmcField.text && [self.pkmcField.text length] > 0) {
        [params setObject:self.pkmcField.text forKey:@"WRYMC"];
    }
    if (self.savePklx != 0) {
        [params setObject:[NSString stringWithFormat:@"%d",self.savePklx] forKey:@"PORT_TYPE"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tagID:0];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (self.webHelper) {
        [self.webHelper cancel];
    }
    [self.poverController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"污染源在线监测";
    self.currentPage = 1;
    self.pklxField.text = @"全选";
    self.valueAry = [[NSMutableArray alloc]init];
//    self.arySectionIsOpen = [[NSMutableArray alloc]init];
//
//    [self addViews];
//    [self loadData:@""];
//    
//    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
//    searchBar.delegate = self;
//    searchBar.placeholder = @"请输入企业名称查询";
//    self.navigationItem.titleView = searchBar;
//    
//    
//   self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    [self searchButtonPress:nil];
}

//
//-(void)addViews{
//    //_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, 768, 880) style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [self.view addSubview:_tableView];
//}
///**
// *  根据污染源名称筛选污染源名称列表
// *
// *  @param wrymc 污染源名称
// */
//-(void)loadData:(NSString*)wrymc{
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
//    [params setObject:@"QUERY_YDZF_WRYLIST_ZXJC" forKey:@"service"];
//    if ([wrymc length] > 0) {
//        [params setObject:wrymc forKey:@"q_WRYMC"];
//    }
//    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
//   
//    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tagID:0];
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int pages = self.totalCount%ONE_PAGE_SIZE == 0 ? self.totalCount/ONE_PAGE_SIZE : self.totalCount/ONE_PAGE_SIZE+1;
    if(self.currentPage == pages || pages == 0 || self.totalCount <= 25)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        self.currentPage++;
        [self requestData];
    }
}

-(void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    switch (row) {
        case 0:
            self.savePklx = 0;
            break;
        case 1:
            self.savePklx = 3;
            break;
        case 2:
            self.savePklx = 4;
            break;
        default   :
            self.savePklx = 5;
            break;
    }
    self.pklxField.text = words;
    [self.poverController dismissPopoverAnimated:YES];
}

-(void)processWebData:(NSData *)webData{
    if([webData length] <=0 )
    {
        [self showAlertMessage:@"获取数据失败"];
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"resultjson===%@",resultJSON);
    NSDictionary *jsonDic = [resultJSON objectFromJSONString];
    NSArray *jsonArray = [jsonDic objectForKey:@"data"];
    self.totalCount = [[jsonDic objectForKey:@"totalCount"] integerValue];
    if (jsonArray && jsonArray.count) {
        [self.valueAry addObjectsFromArray:jsonArray];
    }
    [self.tableView reloadData];
//    id obj = [resultJSON objectFromJSONString];
//    if(![obj isKindOfClass:[NSArray class]])
//    {
//        
////        [self showAlertMessage:@"获取数据失败"];
//        [self showAlertMessage:@"没有查询到数据"];
//        [_valueAry removeAllObjects];
//        [_tableView reloadData];
//        return;
//    }
//    else
//    {
//        [_valueAry removeAllObjects];
//        
//        NSArray* dicResult = [resultJSON objectFromJSONString];
//
//        NSMutableArray *infoArray = [[dicResult objectAtIndex:0]objectForKey:@"dataInfos"];
//
//        if (infoArray && [infoArray count] > 0)
//        {
//            [_valueAry addObjectsFromArray:infoArray];
//            
//            for (int i=0; i<_valueAry.count; i++)
//            {
//                [self.arySectionIsOpen addObject:[NSNumber numberWithBool:NO]];
//            }
//            
//            [_tableView reloadData];
//        }
//        else{
//            [self showAlertMessage:@"没有查询到数据"];
//            [_valueAry removeAllObjects];
//            [_tableView reloadData];
//        }
//    }
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:@"请求数据失败,请检查网络."];
    
    return;
}
#pragma mark -
#pragma mark UITableViewDataSource Methods
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return 60;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return _valueAry.count;
//}
//-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
//{
//    CGFloat headerHeight = 60;
//
//    NSMutableDictionary *dic = [_valueAry objectAtIndex:section];
//    
//    //NSString *numb = [NSString stringWithFormat:@"   %d",section+1];
//    NSString *title = [NSString stringWithFormat:@"     %@",[dic objectForKey:@"WRYMC"]];
//    
//    BOOL opened = NO;
//    opened = [[self.arySectionIsOpen objectAtIndex:section] boolValue];
//        
//	QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc]
//                                            initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, headerHeight)
//                                            title:title
//                                            section:section
//                                            opened:opened
//                                            delegate:self];
//	return sectionHeadView ;
//}
#pragma mark - QQ section header view delegate
//
//-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
//{
//    NSNumber *opened = [self.arySectionIsOpen objectAtIndex:section];
//    [self.arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
//	
//	// 收缩+动画 (如果不需要动画直接reloaddata)
//	NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:section];
//    if (countOfRowsToDelete > 0)
//    {
//		[self.tableView reloadData];
//        
//    }
//}
//
//-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
//{
//    
//	NSNumber *opened = [self.arySectionIsOpen objectAtIndex:section];
//    [self.arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
//    _taskTypeIndex = section;
//    
//    [self.tableView reloadData];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(section < [self.arySectionIsOpen count]){
//        BOOL opened = [[self.arySectionIsOpen objectAtIndex:section] boolValue];
//        if(opened == NO) return 0;
//    }
//    return [[[_valueAry objectAtIndex:section]objectForKey:@"PWK"] count];
    return self.valueAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *valueDic = [self.valueAry objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"ListCell" owner:self options:nil]lastObject];
//    }
//    NSArray *pwkAry = [[_valueAry objectAtIndex:indexPath.section]objectForKey:@"PWK"];
//    NSMutableDictionary *dic = [pwkAry objectAtIndex:indexPath.row];
//    UILabel *label1 = (UILabel *)[cell viewWithTag:1];
//    UILabel *label2 = (UILabel *)[cell viewWithTag:2];
//    UILabel *label3 = (UILabel *)[cell viewWithTag:3];
//
//    label1.text = @"";
//    label2.text = [dic objectForKey:@"JCDMC"];
//    label3.text = @"";
// 
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [valueDic objectForKey:@"TITLE"];
    cell.detailTextLabel.text = [valueDic objectForKey:@"CONTENT"];
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
    return 72.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self.valueAry objectAtIndex:indexPath.row];
    NSLog(@"dic===%@",dic);
    MoreInfoViewController *monitor = [[MoreInfoViewController alloc]initWithNibName:@"MoreInfoViewController" bundle:nil];
    //monitor.title = [NSString stringWithFormat:@"%@在线监测",[dic objectForKey:@"WRYMC"]];
    monitor.pwkId = [dic objectForKey:@"PRIMARY_KEY"];
    monitor.onejcdwmc = [dic objectForKey:@"TITLE"];
    monitor.infoDic = dic;
    [self.navigationController pushViewController:monitor animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"查询结果";
}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)bar{
//
//    [self loadData:searchBar.text];
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    if ([searchText isEqualToString:@""]) {
//        [self loadData:@""];
//    }
//}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setPkmcField:nil];
    [self setPklxField:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
