    //
//  InputConditionView.m
//  RetrieveExamine
//
//  Created by hejunhua on 11-9-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "XMSPListViewController.h"
#import "XMSPDetailsViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"

@implementation XMSPListViewController
@synthesize aryItems,xmmc,startDate,endDate,xzqh;
@synthesize popController,dateController,listTableView,refreshSpinner;


-(IBAction)touchFromDate:(id)sender{
	UIControl *btn =(UIControl*)sender;
	[popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	currentTag = btn.tag;
}

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date{ 
	[popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
		switch (currentTag) {
			case 1:				
				startDate.text = dateString;
				break;
			case 2:
				endDate.text = dateString;
				break;
				
			default:
				break;
		}
	}
    else{
        switch (currentTag) {
			case 1:				
				startDate.text = @"";
				break;
			case 2:
				endDate.text = @"";
				break;
				
			default:
				break;
        }
    }
}

- (IBAction)searchBtnPressed:(id)sender {
	if (aryItems)
		[aryItems removeAllObjects];

    currentPageIndex = 1;

	NSString *xmmcValue = [[NSString alloc] initWithString:xmmc.text];

	NSString *startDateValue = [[NSString alloc] initWithString:startDate.text];

	NSString *endDateValue = [[NSString alloc] initWithString:endDate.text];

	NSString *xzqhValue = [[NSString alloc] initWithString:xzqh.text];
    

	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"WRY_XMSP_LINK_LIST" forKey:@"service"];
    //参数PRIMARY_KEY 对应现场执法编号 未使用
    [params setObject:xmmcValue forKey:@"TITLE"];
    [params setObject:xzqhValue forKey:@"SZDS"];
    [params setObject:startDateValue forKey:@"KSSJ"];
    [params setObject:endDateValue forKey:@"JSSJ"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:nil delegate:self tipInfo:@"正在查询数据..." tagID:0];
    isLoading = YES;

	
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
    self.title = @"建设项目审批查询";
	
    currentPageIndex = 1;
	PopupDateViewController *date = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = date;
	dateController.delegate = self;

	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"WRY_XMSP_LINK_LIST" forKey:@"service"];

    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:nil delegate:self tipInfo:@"正在查询数据..." tagID:0];
    isLoading = YES;
	
}

-(void)viewDidAppear:(BOOL)animated{
	
    [super viewDidAppear:animated];
    
    [xmmc resignFirstResponder];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [aryItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *ExamineListCellIdentifier = @"ExamineListCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExamineListCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ExamineListCellIdentifier];
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 600, 30)];
        detailLabel.textAlignment = UITextAlignmentLeft;
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.font = [UIFont systemFontOfSize:16];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.tag = 101;
        
        [cell.contentView addSubview:detailLabel];
	}
    NSDictionary *dicInfo = [aryItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [dicInfo objectForKey:@"TITLE"];
    cell.detailTextLabel.text = [dicInfo objectForKey:@"CONTENT"];
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;	
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        // Released above the header
		
        isLoading = YES;
        currentPageIndex++;
    }
}

#pragma mark -
#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	XMSPDetailsViewController *detailsController = [[XMSPDetailsViewController alloc] init];
    NSDictionary *dicInfo = [aryItems objectAtIndex:indexPath.row];
    detailsController.primaryKey = [dicInfo objectForKey:@"PRIMARY_KEY"];
    [self.navigationController pushViewController:detailsController animated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated
{
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)processError:(NSError *)error{
    
}

-(void)processWebData:(NSData*)webData andTag:(NSInteger)tag
{
    if([webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    

    NSDictionary *dicResult = [resultJSON objectFromJSONString];
    if(dicResult && [dicResult isKindOfClass:[NSDictionary class]]){
        if(aryItems == nil )
            self.aryItems = [NSMutableArray arrayWithCapacity:30];
        NSArray *tmpItems = [dicResult objectForKey:@"data"];
        if ([tmpItems count]) {
            [aryItems addObjectsFromArray:tmpItems];
        }
        
        [listTableView reloadData];
        
    }
}
@end
