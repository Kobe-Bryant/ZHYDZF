    //
//  ExamineDetailsView.m
//  RetrieveExamine
//
//  Created by hejunhua on 11-9-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMSPDetailsViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "DisplayAttachFileController.h"

/*
 {"totalCount":3,"data":[{"TITLE":"项目审批","LINK":"xmsp/xmspDataDetail.jsp"},{"TITLE":"试运行","LINK":"xmsp/syxDataDetail.jsp"},{"TITLE":"验收","LINK":"xmsp/ysDataDetail.jsp"}]}
 */


@implementation XMSPDetailsViewController
@synthesize webView,primaryKey,aryFiles,tableView,wrybh;

-(void)segValueChanged:(id)sender{
    UISegmentedControl *segCtrl = (UISegmentedControl*)sender;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:primaryKey forKey:@"PRIMARY_KEY"];
    if (segCtrl.selectedSegmentIndex == 0) 
        [params setObject:@"xmsp/xmspDataDetail.jsp" forKey:@"LINK"];
    else if (segCtrl.selectedSegmentIndex == 1)
        [params setObject:@"xmsp/syxDataDetail.jsp" forKey:@"LINK"];
    else if (segCtrl.selectedSegmentIndex == 2)
        [params setObject:@"xmsp/ysDataDetail.jsp" forKey:@"LINK"];
        
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    if (segCtrl.selectedSegmentIndex == 0)
    {
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:0];
        tableView.hidden = NO;
        webView.frame = CGRectMake(0, 0, 768, 700);
        if (aryFiles.count) {
            [aryFiles removeAllObjects];
        }
    }else{
        NSURL *aUrl = [NSURL URLWithString:strUrl];
        [webView loadRequest:[NSURLRequest requestWithURL:aUrl]];
        tableView.hidden = YES;
        webView.frame = CGRectMake(0, 0, 768, 960);
    }
    
    
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 700)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;

    [self.view addSubview:webView];
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 700, 768, 260) style:UITableViewStylePlain];
    tableView.delegate =self;
    tableView.dataSource =self;
    [self.view addSubview:tableView];
    
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"项目审批",@"试运行",@"验收", nil]];
    segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    segCtrl.selectedSegmentIndex = 0;
    [segCtrl addTarget:self action:@selector(segValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView  = segCtrl;
    
    aryFiles = [[NSMutableArray alloc]init];
    
    //默认显示项目审批
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:primaryKey forKey:@"PRIMARY_KEY"];

    [params setObject:@"xmsp/xmspDataDetail.jsp" forKey:@"LINK"];
   
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
//    NSLog(@"项目审批=%@",strUrl);
     self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
     
    return YES;
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
    if (tag == 0) {
        NSArray *ary = [resultJSON componentsSeparatedByString:@"####"];
        if([ary count] == 2){
            
            NSDictionary *dicResult = [[ary objectAtIndex:1] objectFromJSONString];
            if(dicResult && [dicResult isKindOfClass:[NSDictionary class]]){
                
                NSArray *tmpItems = [dicResult objectForKey:@"data"];
                if ([tmpItems count]) {
                    [self.aryFiles addObjectsFromArray:tmpItems];
                }
                [tableView reloadData];
            }
            
            NSString *html = [ary objectAtIndex:0];
            [webView loadHTMLString:html baseURL:nil];
        }
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"WRY_ARCHIVES_LIST" forKey:@"service"];
        [params setObject:wrybh forKey:@"PRIMARY_KEY"];
        [params setObject:@"1" forKey:@"TYPE_CODE"];
        NSString *UrlStr = [ServiceUrlString generateUrlByParameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:UrlStr andParentView:self.view delegate:self tagID:1];
    }
    else if (tag == 1){
        NSDictionary *jsonDic = [resultJSON objectFromJSONString];
        NSArray *jsonArray = [jsonDic objectForKey:@"data"];
        [aryFiles addObjectsFromArray:jsonArray];
        [tableView reloadData];
    }
}

#pragma mark -
#pragma mark TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [aryFiles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"相关附件";
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"XMSPCell";
	UITableViewCell *cell = [atableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

	}
    NSDictionary *dicInfo = [aryFiles objectAtIndex:indexPath.row];
    NSString *title = [dicInfo objectForKey:@"LINK_NAME"];
    if (title == nil) {
        title = [dicInfo objectForKey:@"TITLE"];
    }
    cell.textLabel.text = title;
   
    return cell;
}


#pragma mark -
#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dicInfo = [aryFiles objectAtIndex:indexPath.row];
    NSString *title = nil;
    NSString *fileUrl = [dicInfo objectForKey:@"IMG"];
    NSString *fileName = [dicInfo objectForKey:@"TITLE"];
    if([[fileName pathExtension] isEqualToString:@""])
        fileName = [fileUrl lastPathComponent];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (fileName != nil) {
        title = [dicInfo  objectForKey:@"TITLE"];
        [params setObject:@"DOWN_OA_FILES" forKey:@"service"];
        [params setObject:@"WRY_ARCHIVES" forKey:@"GLLX"];
        [params setObject:fileUrl forKey:@"PATH"];
    }
    else{
        title = [dicInfo  objectForKey:@"LINK_NAME"];
        [params setObject:@"DOWN_OA_FILES" forKey:@"service"];
        [params setObject:@"XMSP_SMWJ" forKey:@"GLLX"];
        [params setObject:[dicInfo objectForKey:@"SRC_PATH"] forKey:@"PATH"];
    }

    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"strUrl=%@",strUrl);
    DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:strUrl andFileName:title];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
