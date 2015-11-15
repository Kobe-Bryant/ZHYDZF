//
//  MoreInfoViewController.m
//  BoandaProject
//
//  Created by BOBO on 13-12-19.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "MoreInfoViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>


@interface MoreInfoViewController ()
@property (nonatomic,retain) UIPopoverController *popController;
@property (nonatomic,retain) UITableView *dataTableView;
@property (nonatomic,retain) UIWebView *resultWebView;
@property (nonatomic,strong) S7GraphView *graphView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UISegmentedControl *segmented;
@property (nonatomic,strong) NSMutableString *html;
@property (nonatomic,strong) ChooseTimeRangeVC *dateController;
@property (nonatomic,strong) UIButton *pwkButton;

@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic,strong)NSArray *typeAry;
@property (nonatomic,strong)NSMutableArray *keyAry;
@property (nonatomic,strong)NSMutableArray *resultDataAry;
@property (nonatomic,strong)NSMutableArray *valueAry;
@property (nonatomic,strong)NSMutableArray *timeAry;
@property (nonatomic,strong)NSMutableArray *standardAry;    //存放标准值字典的数组，用于接收网络解析出来的字符串


@property (nonatomic,assign)BOOL isGotJsonString;
@property (nonatomic,copy)NSString *itemName;
@property (nonatomic,strong)NSString *unit;
@property (nonatomic,strong)NSString *jclx;
@property (nonatomic,strong)NSString *qsrq;
@property (nonatomic,strong)NSString *jzrq;
@property (nonatomic,strong)NSString *orgStr;
@property (nonatomic,strong)NSString *typeStr;

@end

@implementation MoreInfoViewController
@synthesize infoDic,pwkId,titleLab,onejcdwmc,IDStr;

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
    self.keyAry = [[NSMutableArray alloc]init];
    self.resultDataAry = [[NSMutableArray alloc]initWithCapacity:0];
    self.tmpArray = [[NSMutableArray alloc]init];
    self.unit = @"";
    self.keyString = @"";
    self.typeStr = @"HOUR";
 
    self.segmented = [[UISegmentedControl alloc]initWithItems:@[@"  时数据  ",@"  日数据  "]];
    [self.segmented addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmented.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmented.selectedSegmentIndex = 0;
    
    self.navigationItem.titleView = self.segmented;

    self.html = [NSMutableString string];

    self.valueAry = [NSMutableArray array];
    self.timeAry = [NSMutableArray array];
    
    [self initView];
    [self requestData];
}

-(void)segmentedValueChanged:(UISegmentedControl *)segmented{
    switch (segmented.selectedSegmentIndex) {
        case 0:
            self.typeStr = @"HOUR";
            break;
            
        default:
            self.typeStr = @"DAY";
            break;
    }
    [self requestData];
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:ss"];
    self.jzrq = [dateFormatter stringFromDate:nowDate];
    self.qsrq = [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:nowDate]];
    
    
    self.imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.imgView];
    
    self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(11, 503, 289, 400) style:UITableViewStyleGrouped] ;
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    [self.view addSubview:self.dataTableView];
    
    self.resultWebView = [[UIWebView alloc] initWithFrame:CGRectMake(305, 504, 452, 421)];
    [self.view addSubview:self.resultWebView];
    
    self.graphView = [[S7GraphView alloc] initWithFrame:CGRectMake(30, 10, 740, 480)];
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
    self.titleLab.text = [NSString stringWithFormat:@"%@(%@ ~ %@)", self.onejcdwmc,self.qsrq,self.jzrq ];
    [self.view addSubview:self.titleLab];
    
    self.graphView.frame = CGRectMake(11, 40, 746, 440);
    self.dataTableView.frame = CGRectMake(11, 503, 289, 421);
    self.resultWebView.frame = CGRectMake(305, 504, 452, 421);
    self.imgView.image = [UIImage imageNamed:@"zxjc_BG.jpg"];

}
-(void)requestData
{
//    self.qsrq = fromTime;
//    self.jzrq = endTime;
//    self.typeStr = type;
    self.titleLab.text = [NSString stringWithFormat:@"%@(%@ ~ %@)", self.onejcdwmc,self.qsrq,self.jzrq ];
    if ([self.valueAry count] > 0)
        [self.valueAry removeAllObjects];
    if ([self.timeAry count] > 0)
        [self.timeAry removeAllObjects];
    if ([self.resultDataAry count] > 0)
    {
        [self.resultDataAry removeAllObjects];
    }
    self.isLoading = YES;

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"ONLINE_SITE_DETAIL" forKey:@"service"];
    [params setObject:self.pwkId forKey:@"PRIMARY_KEY"];
    [params setObject:self.qsrq forKey:@"DATE_START"];
    [params setObject:self.jzrq forKey:@"DATE_END"];
    [params setObject:self.typeStr forKey:@"AVG_TYPE"];

    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    NSLog(@"时间strUrl-----%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}
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
	/* Return the number of plots you are going to have in the view. 1+ */
	if (self.valueAry == nil || 0 == [self.valueAry count]) {
		return 0;//还未取到数据
	}else if (_hasStandValue)           //该污染因子有标准值，画两条线
        return 2;
    else
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
        }else{
        
            NSLog(@"error1");
        }
	}
	return array;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
    //两条线代码示例
    if (plotIndex == 0) {
        NSMutableArray* ary = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSString *value in self.valueAry) {
            if (nil != value) {
                [ary insertObject:[NSNumber numberWithFloat:[value floatValue]] atIndex:0];
            }else{
            
                NSLog(@"error2");
            }
        }
        return ary ;
    }else{                  //因为污染因子的标准值是一个数值，所以构造画线用的数组，数组中每个值一样
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *value in self.valueAry) {//让构建的数组和污染因子的值数组一样大
            if (nil != value) {
                
                [arr insertObject:[NSNumber numberWithFloat:[_standValue floatValue]] atIndex:0];
            }else{
            
                NSLog(@"error3");
            }
//            NSLog(@"##########################%@",_standValue);
        }
        NSLog(@"kkkkk3");
        return arr;
    }
}

#pragma mark - Network Handler Methods

- (void)processWebData:(NSData *)webData
{
    
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [jsonStr objectFromJSONString];
    NSLog(@"jsonstr==%@",jsonStr);
    NSString *typeStr = [jsonDic objectForKey:@"DYNA_COL"];
    self.typeAry = [NSArray arrayWithArray:[typeStr componentsSeparatedByString:@";"]];
    NSArray *itemArry = [jsonDic objectForKey:@"data"];
    BOOL bParsedError = NO;
    if(itemArry.count > 0)
        [self.resultDataAry addObjectsFromArray:itemArry];
        
    if (!self.keyAry.count && itemArry.count) {
        for (NSString *str in self.typeAry) {
            NSArray *array = [NSArray arrayWithArray:[str componentsSeparatedByString:@"("]];
            NSString *key = [array objectAtIndex:0];
            [self.keyAry addObject:key];
        }
        [self.dataTableView reloadData];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0 ];
        [self.dataTableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
        self.keyString = [self.keyAry objectAtIndex:0];
        NSLog(@"keyary===%@",self.keyAry);
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
    NSLog(@"self.resultDataAry===%@",self.resultDataAry);

    //每次切换处理数据都重新查找当然被选中的污染因子是否有标准值

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
    
    [self.html appendFormat:@"<html><body topmargin=0 leftmargin=0><table width=\"%@\" bgcolor=\"#FFCC32\" border=1 bordercolor=\"#893f7e\" frame=below rules=none><tr><th><font color=\"Black\">%@监测详细信息</font></th></tr><table><table width=\"%@\" bgcolor=\"#893f7e\" border=0 cellpadding=\"1\"><tr bgcolor=\"#e6e7d5\" ><th>监测时间</th><th>监测数据</th></tr>",width,self.keyString,width];
    
    BOOL boolColor = true;
    for (NSDictionary *tmpDic in self.resultDataAry)
    {
        NSString *time = [tmpDic objectForKey:@"监测时间"];
        NSString *count = [tmpDic objectForKey:self.keyString];
        [self.html appendFormat:@"<tr bgcolor=\"%@\">",boolColor ? @"#cfeeff" : @"#ffffff"];
        if ([self.typeStr isEqualToString:@"D"])
        {
           [self.html appendFormat:@"<td align=center>%@</td><td align=center>%@</td>",time,[NSString stringWithFormat:@"%@%@",count,@""]];
        }
        else
        {
            [self.html appendFormat:@"<td align=center>%@:00</td><td align=center>%@</td>",time,[NSString stringWithFormat:@"%@%@",count,@""]];
        }
        
        [self.html appendString:@"</tr>"];
        
    }
    
    [self.html appendString:@"</table></body></html>"];
    //NSLog(@"*******%@",self.html);

    [self.valueAry removeAllObjects];
    [self.timeAry removeAllObjects];
    NSLog(@"self.resultDataAry===%@",self.resultDataAry);

    for (int i = 0 ; i<self.resultDataAry.count ; i++)

    {
        NSDictionary *tmpDic = [self.resultDataAry objectAtIndex:i];
        NSString *time = [tmpDic objectForKey:@"监测时间"];
        NSString *count = [tmpDic objectForKey:self.keyString];
        if (count != nil) {
            //因为count可能为空
            [self.valueAry addObject:count];
            [self.timeAry addObject:time];
        }
    }
    [self.graphView reloadData];
    [self addView:self.graphView type:@"rippleEffect" subType:kCATransitionFromTop];
    
    //添加webview
    
    [self.resultWebView loadHTMLString:self.html baseURL:nil];
 
    [self addView:self.resultWebView type:@"pageCurl" subType:kCATransitionFromRight];
}


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
    return self.keyAry.count;
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
    if ([[self.typeAry objectAtIndex:indexPath.row] isEqualToString:@"PH(null)"]) {
        cell.textLabel.text = @"PH";
    }else{
        
        cell.textLabel.text = [self.typeAry objectAtIndex:indexPath.row];

    }
    
    NSLog(@"cell.text===%@",cell.textLabel.text);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.keyString = [self.keyAry objectAtIndex:indexPath.row];
    [self parserData];
}
@end
