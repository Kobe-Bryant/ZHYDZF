    //
//  InputConditionView.m
//  RetrieveExamine
//
//  Created by hejunhua on 11-9-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "HJXFListViewController.h"
#import "HJXFDetailViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "CustomCell.h"

@implementation HJXFListViewController
@synthesize aryItems,tsdw,startDate,endDate,tsnr;
@synthesize popController,dateController,listTableView,refreshSpinner,currentPage,pageCount;


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

    currentPage = 1;

	NSString *tsdwValue = [[NSString alloc] initWithString:tsdw.text];

	NSString *startDateValue = [[NSString alloc] initWithString:startDate.text];

	NSString *endDateValue = [[NSString alloc] initWithString:endDate.text];

	NSString *tsnrValue = [[NSString alloc] initWithString:tsnr.text];
    

	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_HJXF_LIST" forKey:@"service"];
    //参数PRIMARY_KEY 对应现场执法编号 未使用
    [params setObject:tsdwValue forKey:@"WH"];
    [params setObject:tsnrValue forKey:@"AJLY"];
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
    self.title = @"环境信访查询";
    currentPage = 1;
    NSLog(@"环境信访");
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 119, 768, 841) style:UITableViewStylePlain];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.rowHeight = 100;
    [self.view addSubview:listTableView];
    
    
    
    currentPageIndex = 1;
	PopupDateViewController *date = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = date;
	dateController.delegate = self;

	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_HJXF_LIST" forKey:@"service"];

    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    //NSLog(@"strul===%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:0];
    isLoading = YES;
	
}

-(void)viewDidAppear:(BOOL)animated{
	
    [super viewDidAppear:animated];
    
    [tsdw resignFirstResponder];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
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

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.0;
}*/

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [NSString stringWithFormat:@"查询结果:%@条",totalCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *ExamineListCellIdentifier = @"ExamineListCellIdentifier";
	CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:ExamineListCellIdentifier];
    
	if (cell == nil) {
		cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ExamineListCellIdentifier];
//        UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        /*
        UILabel *lab0 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
        lab0.text = @"111";
        [cell addSubview:lab0];
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, 100, 30)];
        lab1.textColor = [UIColor grayColor];
        lab1.text = @"222";
        [cell addSubview:lab1];
        
        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(200, 35, 100, 30)];
        lab2.textColor = [UIColor grayColor];
        lab2.text = @"333";
        [cell addSubview:lab2];
       
        UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(5, 65, 100, 30)];
        lab3.textColor = [UIColor grayColor];
        lab3.text = @"444";
        [cell addSubview:lab3];
        
        UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(200, 65, 100, 30)];
        lab4.textColor = [UIColor grayColor];
        lab4.text = @"555";
        [cell addSubview:lab4];
        
        UILabel *lab5 = [[UILabel alloc]initWithFrame:CGRectMake(5, 95, 100, 30)];
        lab5.textColor = [UIColor grayColor];
        lab5.text = @"666";
        [cell addSubview:lab5];
        
        UILabel *lab6 = [[UILabel alloc]initWithFrame:CGRectMake(200, 95, 100, 30)];
        lab2.textColor = [UIColor grayColor];
        lab6.text = @"777";
        [cell addSubview:lab6];*/
	}
    
    NSDictionary *dic = [aryItems objectAtIndex:indexPath.row];
    
    cell.lab0.text = [dic objectForKey:@"WH"];
    cell.lab1.text = [dic objectForKey:@"AJLY"];
    cell.lab2.text = [dic objectForKey:@"WRZL"];
    
    cell.lab3.text = [dic objectForKey:@"SLRQ"];
    cell.lab4.text = [dic objectForKey:@"BLQX"];
    /*
    cell.lab5.text = [dic objectForKey:@"SLRQ"];
    cell.lab6.text = [dic objectForKey:@"BLQX"];*/
    cell.lab7.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ROWNUM_"]];
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
    
	if (isLoading){
    
        NSLog(@"isLoading");
        return;
    }
	
    if (currentPage == pageCount){
    
        NSLog(@"currentPage == pageCount");
        return;
    }
    
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        currentPage++;
        NSString *tsdwValue = [[NSString alloc] initWithString:tsdw.text];
        
        NSString *startDateValue = [[NSString alloc] initWithString:startDate.text];
        
        NSString *endDateValue = [[NSString alloc] initWithString:endDate.text];
        
        NSString *tsnrValue = [[NSString alloc] initWithString:tsnr.text];
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
        [params setObject:@"QUERY_HJXF_LIST" forKey:@"service"];
        //参数PRIMARY_KEY 对应现场执法编号 未使用
        [params setObject:tsdwValue forKey:@"WH"];
        [params setObject:tsnrValue forKey:@"AJLY"];
        [params setObject:startDateValue forKey:@"KSSJ"];
        [params setObject:endDateValue forKey:@"JSSJ"];
        [params setObject:[NSString stringWithFormat:@"%d", currentPage] forKey:@"P_CURRENT"];
        
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:0];
        isLoading = YES;
    }
}

#pragma mark -
#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	HJXFDetailViewController *detailsController = [[HJXFDetailViewController alloc] init];
    NSDictionary *dicInfo = [aryItems objectAtIndex:indexPath.row];
    detailsController.primaryKey = [dicInfo objectForKey:@"PRIMARY_KEY"];
    detailsController.link = [dicInfo objectForKey:@"LINK"];
    detailsController.title = @"123";
    [self.navigationController pushViewController:detailsController animated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    isLoading = NO;
    if([webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dicResult = [resultJSON objectFromJSONString];
    pageCount = [[dicResult objectForKey:@"pageCount"] integerValue];
    totalCount = [dicResult objectForKey:@"totalCount"];
    
    /*
    NSArray *arr = [dicResult objectForKey:@"data"];
    for (int i = 0; i < [arr count]; i ++) {
        
        NSDictionary *dic = [arr objectAtIndex:i];
        for (int j = 0; j < [[dic allKeys]count]; j ++) {
            
            NSLog(@"%@:%@",[[dic allKeys]objectAtIndex:j],[dic objectForKey:[[dic allKeys]objectAtIndex:j]]);
        }
        NSLog(@"\n");
    }
    */
    if(dicResult && [dicResult isKindOfClass:[NSDictionary class]]){
        if(aryItems == nil )
            self.aryItems = [NSMutableArray arrayWithCapacity:0];
        NSArray *tmpItems = [dicResult objectForKey:@"data"];
        if ([tmpItems count]) {
            [aryItems addObjectsFromArray:tmpItems];
        }
        
        [listTableView reloadData];
    }
}
@end
