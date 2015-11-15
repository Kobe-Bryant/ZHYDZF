//
//  ChooseRecordViewController.m
//  GMEPS_HZ
//
//  Created by power humor on 12-7-27.
//  Copyright (c) 2012年 powerdata. All rights reserved.
//

#import "ChooseRecordViewController.h"
#import "UITableViewCell+Custom.h"
#import "ServiceUrlString.h"
#import "WebServiceHelper.h"
#import "PDJsonkit.h"
#import "SharedInformations.h"
#import "GUIDGenerator.h"
#import "RecordsHelper.h"

@implementation ChooseRecordViewController
@synthesize chooseAry;
@synthesize delegate,type;
@synthesize blName,wrymc,templateID;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_isSignature) {
        
        RecordsHelper *helper = [[RecordsHelper alloc] init];
        self.chooseAry = [helper querySignatureByWrymc:wrymc andTableName:blName];
        [self.tableView reloadData];
        return;
    }
    
    if (self.navigationItem.rightBarButtonItem!=nil) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self requestServerHisRecord];
    
    return;
}

-(void)requestServerHisRecord
{
//    NSLog(@"%@", self.blName);
    if ([self.blName isEqualToString:@"T_YDZF_XCKCBL_KYT"])//勘验图
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"QUERY_KYT_HISTORY" forKey:@"service"];
        [params setObject:self.wrybh forKey:@"wrybh"];
        [params setObject:self.wrymc forKey:@"wrymc"];
        NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
        
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self];
    }
    else if ([self.blName isEqualToString:@"T_YDZF_DCXWBL"])
    {
        //询问笔录
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"QUERY_DCXWBL_HISTORY" forKey:@"service"];
        [params setObject:self.wrybh forKey:@"wrybh"];
        NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self];
    }
    else if ([self.blName isEqualToString:@"T_YDZF_XCKCBL"])
    {
        //勘验笔录
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"QUERY_XCKCBL_HISTORY" forKey:@"service"];
        [params setObject:self.wrybh forKey:@"wrybh"];
        NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self];
    }
    else if([self.blName isEqualToString:@"T_YDZF_WRYXCJCJL_NEW"])
    {
        //现场监察记录
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"QUERY_WRYXCJCJL_HISTORY" forKey:@"service"];
        [params setObject:self.wrybh forKey:@"wrybh"];
        NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self];
    }
    else  if ([self.blName isEqualToString:@"T_YDZF_WRYXCJCJL"])
    {
        //点源记录表
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"QUERY_XCJCJL_HISTORY" forKey:@"service"];
        [params setObject:self.wrybh forKey:@"wrybh"];

        NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self];
    }
}

- (void)processError:(NSError *)error
{
    
}

- (void)processWebData:(NSData *)webData
{
    
    if(webData.length <= 0)
    {
        return;
    }
    NSString *resultJson = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", resultJson);
    NSDictionary *tmpParsedDict = [resultJson objectFromJSONString];
    if(tmpParsedDict != nil && resultJson.length > 0)
    {
        self.chooseAry = [tmpParsedDict objectForKey:@"data"];
    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"          检查人员                                                         检查时间";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [chooseAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSUInteger row = indexPath.row;
    NSDictionary *dic = [chooseAry objectAtIndex:row];
    
    if(_isSignature) {
        NSString *jcrStr = [dic objectForKey:@"JCR"];
        NSString *jcsjStr = [dic objectForKey:@"JCSJ"];
        cell.textLabel.text = jcrStr;
        cell.detailTextLabel.text = jcsjStr;
    }
    
    else if ([self.blName isEqualToString:@"T_YDZF_DCXWBL"])
    {
        //询问笔录
        NSString *jcrStr = [dic objectForKey:@"ZFRY"];
        NSString *jcsjStr = [dic objectForKey:@"KSSJ"];
        cell.textLabel.text = jcrStr;
        cell.detailTextLabel.text = jcsjStr;
    }else if ( [self.blName isEqualToString:@"T_YDZF_WRYXCJCJL"])
    {
        //点源记录表
        NSString *jcrStr = [dic objectForKey:@"CJR"];
        NSString *jcsjStr = [dic objectForKey:@"JCSJ"];
        cell.textLabel.text = jcrStr;
        cell.detailTextLabel.text = jcsjStr;
    }
    else if ([self.blName isEqualToString:@"T_YDZF_XCKCBL"])
    {
        //勘验笔录
        NSString *jcrStr = [dic objectForKey:@"JCR"];
        NSString *jcsjStr = [dic objectForKey:@"KCKSSJ"];
        cell.textLabel.text = jcrStr;
        cell.detailTextLabel.text = jcsjStr;
    }
    else if ([self.blName isEqualToString:@"T_YDZF_WRYXCJCJL_NEW"])
    {
        //现场监察记录
        NSString *jcrStr = [dic objectForKey:@"JCRY"];
        NSString *jcsjStr = [dic objectForKey:@"JCKSSJ"];
        cell.textLabel.text = jcrStr;
        cell.detailTextLabel.text = jcsjStr;
    }
    else if ([self.blName isEqualToString:@"T_YDZF_FJB"])
    {
        //现场取证
        NSString *jcrStr = [dic objectForKey:@"PSR"];
        NSString *jcsjStr = [dic objectForKey:@"PSSJ"];
        cell.textLabel.text = jcrStr;
        cell.detailTextLabel.text = jcsjStr;
    }else if ([self.blName isEqualToString:@"T_YDZF_XCKCBL_KYT"])
    {
        //勘验图
        NSString *jcrStr = [dic objectForKey:@"CJR"];
        NSString *jcsjStr = [dic objectForKey:@"CJSJ"];
        cell.textLabel.text = jcrStr;
        cell.detailTextLabel.text = jcsjStr;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSUInteger row = indexPath.row;
    [delegate returnHistoryRecord:[chooseAry objectAtIndex:row]];
}

@end
