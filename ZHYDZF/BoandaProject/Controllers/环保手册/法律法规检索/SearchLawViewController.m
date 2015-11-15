//
//  SearchLawViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-11-23.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "SearchLawViewController.h"
#import "LocaFlfgDBHelper.h"
#import "CommenWordsViewController.h"
#import "DetailRightPanelView.h"
@interface SearchLawViewController ()<WordsDelegate>
@property(nonatomic,retain)NSArray *aryResult;
@property (nonatomic, strong) NSString *currentType;//选中的执法类型
@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong)DetailRightPanelView *rightPanel;
@property(nonatomic,strong)NSArray *aryTypeWords;
@end

@implementation SearchLawViewController
@synthesize aryResult,rightPanel,aryTypeWords;
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
    self.title = @"常用违法行为";
    LocaFlfgDBHelper *helper = [[LocaFlfgDBHelper alloc] init];
    self.aryResult = [helper queryByKeyword:@"" andType:@""];
    self.aryTypeWords = [NSArray arrayWithObjects:@"水污染防治",@"大气污染防治", @"噪声污染防治",@"固体废物污染防治",@"辐射污染防治",@"建设项目环保管理",@"排污费征收使用",@"环境保护综合管理",nil];
    DetailRightPanelView *rightView = [[DetailRightPanelView alloc] initWithFrame:CGRectMake(768, 53, 312, 595)];
    self.rightPanel = rightView;
    [self.view addSubview:rightPanel];
    
}

-(IBAction)btnPressed:(id)sender{
    LocaFlfgDBHelper *helper = [[LocaFlfgDBHelper alloc] init];
    self.aryResult = [helper queryByKeyword:mcField.text andType:self.currentType];
    [listTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

-(IBAction)touchTypeField:(id)sender{
    UIControl *btn =(UIControl*)sender;
    self.currentType = @"";
    typeField.text = @"";
    CommenWordsViewController *wordController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
    wordController.delegate = self;
    wordController.wordsAry = aryTypeWords;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:wordController];
    popover.popoverContentSize = CGSizeMake(320, 480);
    self.popController = popover;
	[self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
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
    headerView.text = [NSString stringWithFormat:@"  查询结果:%d条", [aryResult count]];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.detailTextLabel.numberOfLines = 2;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    NSDictionary *item = [self.aryResult objectAtIndex:indexPath.row];
  
    NSInteger lb = [[item objectForKey:@"LB"] integerValue]-1;
    if(lb < [aryTypeWords count])
        cell.textLabel.text = [NSString stringWithFormat:@"违法行为：%@（%@）", [item objectForKey:@"WFXW"],[aryTypeWords objectAtIndex:lb]];
    else
        cell.textLabel.text = [NSString stringWithFormat:@"违法行为：%@", [item objectForKey:@"WFXW"]];
    NSString *wftk = [item objectForKey:@"WFTK"];
    if(wftk == nil || [wftk isKindOfClass:[NSNull class]])
        wftk = @"无";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"违反条款：%@", wftk];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.aryResult objectAtIndex:indexPath.row];

    [rightPanel showDetail:item];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return NO;
}

#pragma mark - CommenWordsViewController Delegate Method

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    if(self.popController)
    {
        [self.popController dismissPopoverAnimated:YES];
    }
    typeField.text = words;
    self.currentType = [NSString stringWithFormat:@"%d", row+1];
}

@end
