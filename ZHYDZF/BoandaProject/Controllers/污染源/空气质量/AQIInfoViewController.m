//
//  AQIInfoViewController.m
//  BoandaProject
//
//  Created by BOBO on 14-1-16.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "AQIInfoViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>


@interface AQIInfoViewController ()
@property (nonatomic,retain) UIPopoverController *popController;
@property (nonatomic,retain) UITableView *dataTableView;
@property (nonatomic,retain) UIWebView *resultWebView;
@property (nonatomic,strong) S7GraphView *graphView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) NSMutableString *html;
@property (nonatomic,strong) ChooseTimeRangeVC *dateController;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIButton *pwkButton;

@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic,strong)NSMutableArray *typeAry;
@property (nonatomic,strong)NSMutableArray *resultDataAry;
@property (nonatomic,strong)NSMutableArray *valueAry;
@property (nonatomic,strong)NSMutableArray *timeAry;
@property (nonatomic,strong)NSMutableString *curParsedData;
@property (nonatomic,assign)BOOL isGotJsonString;
@property (nonatomic,copy)NSString *itemName;
@property (nonatomic,strong)NSString *unit;
@property (nonatomic,strong)NSString *jclx;
@property (nonatomic,strong)NSString *qsrq;
@property (nonatomic,strong)NSString *jzrq;
@property (nonatomic,strong)NSString *orgStr;
@property (nonatomic,strong)NSString *typeStr;

@property (nonatomic,strong)NSMutableArray *jcdwmcAry;

@end

@implementation AQIInfoViewController
@synthesize IDStr,pwkNameAry,titleStr;

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
    //self.typeAry = [[NSArray alloc]initWithObjects:@"Nox折算浓度",@"氧气百分比",@"烟气压力",@"Nox浓度",@"烟尘实测浓度",@"烟尘折算浓度",@"SO2实测浓度",@"SO2折算浓度",@"标况流量",@"烟气一次流速",@"烟气温度",nil];
    self.typeAry = [[NSMutableArray alloc]init];
    self.resultDataAry = [[NSMutableArray alloc]initWithCapacity:0];
    self.jcdwmcAry = [[NSMutableArray alloc]init];
    self.unit = @"";
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, 40)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UIImageView * topImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 400, 40)];
    topImg.image = [UIImage imageNamed:@"选择框1.png"];
    topImg.backgroundColor = [UIColor clearColor];
    
    self.pwkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pwkButton.frame = CGRectMake(0, 0, 400, 40);
    self.pwkButton.backgroundColor = [UIColor clearColor];
    self.pwkButton.titleLabel.textColor = [UIColor blackColor];
    [self.pwkButton addTarget:self action:@selector(selectPwkName:) forControlEvents:UIControlEventTouchUpInside ];
    [self.pwkButton setTitle:@"排污口选择" forState:UIControlStateNormal];
    
    [titleView addSubview:topImg];
    [titleView addSubview:self.pwkButton];
    
    self.navigationItem.titleView = titleView;
    
    
    self.html = [NSMutableString string];
    self.curParsedData = [NSMutableString stringWithCapacity:1000];
    self.valueAry = [NSMutableArray array];
    self.timeAry = [NSMutableArray array];
    
    [self initView];
    [self requestData];
}


-(void)selectPwkName:(id)sender
{
    if (self.popController.isPopoverVisible) {
        [self.popController  dismissPopoverAnimated:YES];
    }
    
    UIControl *btn =(UIControl*)sender;
    CommenWordsViewController *wordController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
    wordController.delegate = self;
    wordController.wordsAry = self.pwkNameAry;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:wordController];
    popover.popoverContentSize = CGSizeMake(400, 300);
    self.popController = popover;
	[self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
#pragma mark - CommenWordsViewController Delegate Method

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    //[self.titleLab setText:[self.pwkNameAry objectAtIndex:row]];
    //[self.pwkButton setTitle:words forState:UIControlStateNormal];
    self.pwkButton.titleLabel.text = words;
    self.pwkButton.titleLabel.textColor = [UIColor blackColor];
    [self setIDStr:[_IDArray objectAtIndex:row]];
    [self setTitleStr:words];
    if (self.typeAry.count>0)
    {
        [self.typeAry removeAllObjects];
        
    }
    
    [self requestData];
    [self.popController dismissPopoverAnimated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
	[super viewDidAppear:animated];
}


-(void)initView
{
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"选择时间段" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDateRange:)] ;
    ChooseTimeRangeVC *date = [[ChooseTimeRangeVC alloc] init];
    self.dateController = date;
    self.dateController.delegate = self;
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.jzrq = [dateFormatter stringFromDate:nowDate];
    self.qsrq = [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:nowDate]];
    self.typeStr = @"1";
    
    
    self.imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.imgView];
    
    self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(11, 503, 289, 400) style:UITableViewStyleGrouped] ;
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    [self.view addSubview:self.dataTableView];
    
    self.resultWebView = [[UIWebView alloc] initWithFrame:CGRectMake(305, 504, 452, 421)];
    [self.view addSubview:self.resultWebView];
    
    self.graphView = [[S7GraphView alloc] initWithFrame:CGRectMake(30, 5, 740, 480)];
	self.graphView.dataSource = self;
    self.graphView.info = self.unit;
	NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMinimumFractionDigits:1];
	[numberFormatter setMaximumFractionDigits:1];
	
	self.graphView.yValuesFormatter = numberFormatter;
	
	self.graphView.backgroundColor = [UIColor whiteColor];
	
	self.graphView.drawAxisX = YES;
	self.graphView.drawAxisY = YES;
	self.graphView.drawGridX = YES;
	self.graphView.drawGridY = YES;
	
	self.graphView.xValuesColor = [UIColor blackColor];
	self.graphView.yValuesColor = [UIColor blackColor];
	
	self.graphView.gridXColor = [UIColor blackColor];
	self.graphView.gridYColor = [UIColor blackColor];
	self.graphView.info = @"";
	self.graphView.drawInfo = YES;
	self.graphView.infoColor = [UIColor blackColor];
    
    [self.view addSubview:self.graphView];
    
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.frame = CGRectMake(0, 10, 768, 25);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.titleLab.text = [NSString stringWithFormat:@"(%@ ~ %@)",self.qsrq,self.jzrq ];
    //NSLog(@"titlelable.text=====%@",self.titleLab.text);
    [self.view addSubview:self.titleLab];
    
    self.graphView.frame = CGRectMake(11, 40, 746, 440);
    self.dataTableView.frame = CGRectMake(11, 503, 289, 421);
    self.resultWebView.frame = CGRectMake(305, 504, 452, 421);
    self.imgView.image = [UIImage imageNamed:@"zxjc_BG.jpg"];
    
}
-(void)requestData
{
    self.titleLab.text = [NSString stringWithFormat:@"%@(%@ ~ %@)",self.titleStr,self.qsrq,self.jzrq ];
    //NSLog(@"self.titlelab.text====%@",self.titleLab.text);
    if ([self.valueAry count] > 0)
        [self.valueAry removeAllObjects];
    if ([self.timeAry count] > 0)
        [self.timeAry removeAllObjects];
    if ([self.resultDataAry count] > 0)
    {
        [self.resultDataAry removeAllObjects];
    }
    if ([self.jcdwmcAry count]>0)
    {
        [self.jcdwmcAry removeAllObjects];
    }
    self.isLoading = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"QUERY_YDZF_DQYZ_ZXJC" forKey:@"service"];
    [params setObject:self.IDStr forKey:@"q_DWBH"];
    [params setObject:self.qsrq forKey:@"q_ST"];
    [params setObject:self.jzrq forKey:@"q_ET"];
    [params setObject:self.typeStr forKey:@"q_CXLX"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
   // NSLog(@"url=%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}
//http://61.164.73.82:8090/ydzf/invoke?version=1.16&imei=D8:A2:5E:2B:36:0E&clientType=IPAD&userid=leying&password=123456&service=QUERY_YDZF_DQYZ_ZXJC&q_CXLX=1&q_DWBH=10000&q_ST=2014-07-21&q_ET=2014-07-22&P_PAGESIZE=25
//http://61.164.73.82:8090/ydzf/invoke?version=1.16&imei=D8:A2:5E:2B:36:0E&clientType=IPAD&userid=leying&password=123456&service=QUERY_YDZF_DQYZ_ZXJC&q_CXLX=1&q_DWBH=10056&q_ST=2014-07-21&q_ET=2014-07-22&P_PAGESIZE=25
//http://61.164.73.82:8090/ydzf/invoke?version=1.16&imei=D8:A2:5E:2B:36:0E&clientType=IPAD&userid=leying&password=123456&service=QUERY_YDZF_DQYZ_ZXJC&q_CXLX=1&q_DWBH=10057&q_ST=2014-07-21&q_ET=2014-07-22&P_PAGESIZE=25
#pragma 控件点击方法
-(void)chooseDateRange:(id)sender
{

    if (self.popController.isPopoverVisible) {
        [self.popController  dismissPopoverAnimated:YES];
    }
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    if (self.popController.isPopoverVisible) {
        [self.popController dismissPopoverAnimated:YES];
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.dateController];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    [self setPopController:popover];
    [self.popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
#pragma mark - ChooseDateRange delegate

-(void)choosedFromTime:(NSString *)fromTime andEndTime:(NSString *)endTime andType:(NSString *)type
{
    if (self.popController)
    {
        [self.popController dismissPopoverAnimated:YES];
    }
    self.qsrq = fromTime;
    self.jzrq = endTime;
    //self.typeStr = type;
    [self requestData];
}
-(void)cancelSelectTimeRange
{
    [self.popController dismissPopoverAnimated:YES];
    self.popController = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    if (self.webHelper) {
        [self.webHelper cancel];
    }
    if (self.popController)
        [self.popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}
#pragma mark - protocol S7GraphViewDataSource

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
    
   // NSLog(@"------1");
	/* Return the number of plots you are going to have in the view. 1+ */
	if (self.valueAry == nil || 0 == [self.valueAry count]) {
		return 0;//还未取到数据
	}
	return 1;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
    
	int xCount = [self.timeAry count];
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:xCount];
	for ( int i = 0 ; i < xCount ; i ++ ) {
		NSString *str =[self.timeAry objectAtIndex:i];
        if (str != nil && str.length > 0) {
            
            [array insertObject:[str substringFromIndex:5] atIndex:0];
        }
	}
	return array;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
    
   // NSLog(@"------3");
	NSMutableArray* ary = [[NSMutableArray alloc] initWithCapacity:10];
	for (NSString *value in self.valueAry) {
        if (nil != value) {
            
            [ary insertObject:[NSNumber numberWithFloat:[value floatValue]] atIndex:0];
        }
	}
	return ary ;
}

#pragma mark - Network Handler Methods

- (void)processWebData:(NSData *)webData
{
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonStr===%@",jsonStr);
    NSArray *itemArry = [jsonStr objectFromJSONString];
    //NSLog(@"返回的字典为：%@",detailDict);
    BOOL bParsedError = NO;
   // NSLog(@"itemArry.count===%d",itemArry.count);
    if(itemArry.count > 0)
    {
        NSArray *tmpAry = [[itemArry objectAtIndex:0]objectForKey:@"dataInfos"];
        if(tmpAry.count > 0)
        {
            [self.resultDataAry addObjectsFromArray:tmpAry];
        }else{
            [self.resultDataAry removeAllObjects];
            [self.dataTableView reloadData];
            [self.resultWebView loadHTMLString:Nil baseURL:Nil];
            [self.graphView reloadData];
            
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示：" message:@"该项暂无数据" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
            [alt show];
        }
    }
    //NSLog(@"self.resultDataAry===%@",self.resultDataAry);
    //NSLog(@"resultDataary===%d",self.resultDataAry.count);
    if (self.resultDataAry.count>0)
    {
        
        NSDictionary *onejcdwDic = [self.resultDataAry objectAtIndex:0];
        NSArray *ary = [onejcdwDic allKeys];
        NSMutableArray *keyAry = [[NSMutableArray alloc]initWithArray:ary];
        [keyAry removeObject:@"JCDWMC"];
        [keyAry removeObject:@"JCSJ"];
        [self.typeAry removeAllObjects];
        [self.typeAry addObjectsFromArray:keyAry];
        self.itemName = [self.typeAry objectAtIndex:0];
        self.jclx = [self.typeAry objectAtIndex:0];
        
        [self.dataTableView reloadData];
        if(bParsedError)
        {
            [self showAlertMessage:@"解析数据出错!"];
        }
        
        [self parserData];
        
    }
    
}
-(void)processError:(NSError *)error{
    NSString *msg = @"请求数据失败，请检查网络。";
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    return;
}
-(void)parserData
{
    //NSLog(@"详细界面====%@",self.resultDataAry);
    
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    NSString *width = nil;
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
        width = @"672px";
    else
        width = @"452px";
    if(self.html)
    {
        self.html = nil;
        self.html = [[NSMutableString alloc] init];
    }
    
    [self.html appendFormat:@"<html><body topmargin=0 leftmargin=0><table width=\"%@\" bgcolor=\"#FFCC32\" border=1 bordercolor=\"#893f7e\" frame=below rules=none><tr><th><font color=\"Black\">%@监测详细信息</font></th></tr><table><table width=\"%@\" bgcolor=\"#893f7e\" border=0 cellpadding=\"1\"><tr bgcolor=\"#e6e7d5\" ><th>监测时间</th><th>监测数据</th></tr>",width,self.itemName,width];
    
    BOOL boolColor = true;
    for (NSDictionary *tmpDic in self.resultDataAry)
    {
        [self.html appendFormat:@"<tr bgcolor=\"%@\">",boolColor ? @"#cfeeff" : @"#ffffff"];
        if ([self.typeStr isEqualToString:@"D"])
        {
            [self.html appendFormat:@"<td align=center>%@</td><td align=center>%@</td>",[tmpDic objectForKey:@"JCSJ"],[NSString stringWithFormat:@"%@%@",[tmpDic objectForKey:self.jclx],@""]];
        }
        else
        {
            [self.html appendFormat:@"<td align=center>%@:00</td><td align=center>%@</td>",[tmpDic objectForKey:@"JCSJ"],[NSString stringWithFormat:@"%@%@",[tmpDic objectForKey:self.jclx],@""]];
        }
        
        [self.html appendString:@"</tr>"];
        
    }
    
    [self.html appendString:@"</table></body></html>"];
    //NSLog(@"*******%@",self.html);
   // NSLog(@"valueary===%@\ntimeary===%@",self.valueAry,self.timeAry);
    [self.valueAry removeAllObjects];
    [self.timeAry removeAllObjects];
    
    for (int i = 0 ; i<self.resultDataAry.count ; i++)
        
    {
        NSDictionary *tmpDic = [self.resultDataAry objectAtIndex:i];
        NSString *time = [tmpDic objectForKey:@"JCSJ"];
        NSString *count = [tmpDic objectForKey:self.jclx];
        
        if ([count hasPrefix:@"0.0"]) {
            
            NSRange range = [count rangeOfString:@"0.0"];
            if (range.length > 0) {
                
                count = [count stringByReplacingCharactersInRange:range withString:@"00"];
            }
        }
        if (count != nil && count.length > 0) {
            //因为count可能为空
            [self.valueAry addObject:count];
            [self.timeAry addObject:time];
        }
    }
   // NSLog(@"valueary===%@\ntimeary===%@",self.valueAry,self.timeAry);

    [self.graphView reloadData];
    [self addView:self.graphView type:@"rippleEffect" subType:kCATransitionFromTop];
    
    //添加webview
    
    [self.resultWebView loadHTMLString:self.html baseURL:nil];

    [self addView:self.resultWebView type:@"pageCurl" subType:kCATransitionFromRight];
}

////////////////////////
- (void)addView:(UIView *)view type:(NSString *)type subType:(NSString *)subType
{
    if(view.superview !=nil)
        [view removeFromSuperview];
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;
    transition.subtype = subType;
    [self.view addSubview:view];
    [[view layer] addAnimation:transition forKey:@"ADD"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 列表数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // NSLog(@"typeary.count===%d",self.typeAry.count);
    return self.typeAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.textLabel.text = [self.typeAry objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.jclx = [self.typeAry objectAtIndex:indexPath.row];
    //NSLog(@"jclx===%@",self.jclx);
    self.itemName = [self.typeAry objectAtIndex:indexPath.row];
    //NSLog(@"itemname===%@",self.itemName);
    [self parserData];
    
}
@end
