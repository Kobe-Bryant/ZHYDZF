//
//  BaserecordViewController.m
//  GMEPS_HZ
//
//  Created by 文 克远 on 13-4-12.
//   查询数据先从本地暂存的查询，如果没有，就从网络获取
//

#import "BaseRecordViewController.h"
#import "WebServiceHelper.h"
#import "PDJsonkit.h"
#import "SharedInformations.h"
#import "GUIDGenerator.h"
#import "OMGToast.h"
#import "RecordsHelper.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "NSDateUtil.h"
#import "UIAlertView+Blocks.h"
#import "RIButtonItem.h"
#import "DisplayAttachFileController.h"
#import "AHAlertView.h"
#import "WrySiteOnInspectionController.h"

@interface BaseRecordViewController ()
@property(nonatomic,retain)NSMutableString *currentdata;
@property(nonatomic,assign) NSInteger alertType;
@property(nonatomic, retain) UIBarButtonItem *backItem;


@property(nonatomic,retain)UIPopoverController *popRecordController;
@property(nonatomic,assign)BOOL isDTBD;//是否是动态表单
@property(nonatomic,assign)BOOL showSaveTip;
@property(nonatomic,assign)BOOL showHistoryBilu;
@end

@implementation BaseRecordViewController
@synthesize currentdata,alertType,tableName,isHisRecord,dicWryInfo,isDTBD;
@synthesize recordStatus,popRecordController,dwbh,wrymc,xczfbh,menuTagID,basebh,kckssj,showSaveTip,displayFromLocal,unCommitedBilu,rDic,showHistoryBilu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        showSaveTip = NO;
        unCommitedBilu = NO;
    }
    return self;
}

-(void)returnSites:(NSDictionary*)values outsideComp:(BOOL)bOutside{
    displayFromLocal = YES;
    //从本地带入暂存的数据
    [self queryRecordFromLocal];
}

-(void)backItemPressed{
    if(recordStatus == Record_SaveLocal || recordStatus == Record_Commited_Success || isHisRecord == YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    alertType = kAlert_Choose;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"您输入的数据还未提交或暂存，确定要退出吗？"
                          delegate:self
                          cancelButtonTitle:@"是"
                          otherButtonTitles:@"否",nil];
    alert.alpha = 1.0f;
    [alert show];
    return;
}
//提交数据到对应的笔录表中
-(void)commitRecordDatas:(NSDictionary*)value{
    
  
}

//提交数据到主表中
-(void)commitBaseRecordData:(NSDictionary*)value{

     
     NSString *jsonStr = [value JSONString];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"COMIT_BL_BASE_DATA" forKey:@"service"];
    [params setObject:jsonStr forKey:@"jsonString"];
    
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"STURL====%@",strUrl );
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在提交笔录..." tagID:COMIT_BL_BASE_DATA] ;
}

-(NSDictionary*)getValueData{
    return self.dicWryInfo;
}


-(void)saveLocalRecord:(id)valueDatas{
   
    RecordsHelper *helper = [[RecordsHelper alloc] init];
    BOOL res = [helper saveRecord:valueDatas andTableName:tableName ];
 
    //在未提交笔录中也增加一条记录
    if (res && unCommitedBilu == NO&&recordStatus!=Record_Commited_Success) {
        NSDictionary *dicValue = [self getValueData];
        NSDictionary *baseValues = [self createBaseTableFromWryData:dicValue];
        NSString *jsonStr = [baseValues JSONString];
        NSDictionary *usrInfo = [[SystemConfigContext sharedInstance] getUserInfo];
        
        NSString* lrr = [usrInfo objectForKey:@"uname"];
        [helper insertRecordByBH:self.basebh andTableName:self.tableName andJBXXJson:jsonStr andWryMC:self.wrymc andLRR:lrr];
    }
    
    if(res&&showSaveTip){
        recordStatus= Record_SaveLocal;
        [OMGToast showWithText:@"记录已暂存在本地！" duration:1.0];
    }
}

-(void)saveLocalRecord:(id)valueDatas andPath:(NSString *)path{
    
    RecordsHelper *helper = [[RecordsHelper alloc] init];
    BOOL res = [helper saveRecord:valueDatas andTableName:tableName ];
    
    //在未提交笔录中也增加一条记录
    if (res && unCommitedBilu == NO&&recordStatus!=Record_Commited_Success) {
        NSDictionary *dicValue = [self getValueData];
        NSDictionary *baseValues = [self createBaseTableFromWryData:dicValue];
        NSString *jsonStr = [baseValues JSONString];
        NSDictionary *usrInfo = [[SystemConfigContext sharedInstance] getUserInfo];
        
        NSString* lrr = [usrInfo objectForKey:@"uname"];
        [helper insertRecordByBH:self.basebh andTableName:self.tableName andJBXXJson:jsonStr andWryMC:self.wrymc andLRR:lrr andPath:path];
    }
    
    if(res&&showSaveTip){
        recordStatus= Record_SaveLocal;
        [OMGToast showWithText:@"记录已暂存在本地!" duration:1.0];
    }
}

-(void)queryRecordFromLocal{
    RecordsHelper *helper = [[RecordsHelper alloc] init];
    NSDictionary *result = [helper queryRecordByWrymc:self.wrymc andWryBH:dwbh andTableName:tableName andBH:self.basebh];
    if (result != nil) {

        [self displayRecordDatas:result];
    }
}

-(NSDictionary*)modifyDicValues:(NSDictionary*)val{
    NSMutableDictionary *dicVal = [NSMutableDictionary dictionaryWithDictionary:val];
    //处理为<null> 或者nil的情况
    NSArray *keys = [dicVal allKeys];
    if ([keys count] > 0) {
        for(NSString *aKey in keys){
            id val = [dicVal objectForKey:aKey];
            if( val == nil || [val isKindOfClass:[NSNull class]]){
                [dicVal setObject:@"" forKey:aKey];
            }
        }
    }
    return dicVal;
}

//根据值来显示值
-(void)displayRecordDatas:(NSDictionary*)values{
    
}

-(void)generateBaseBH{
    self.basebh = [GUIDGenerator generateGUID];
}

-(void)generateXCZFBH{

    self.xczfbh = [GUIDGenerator generateBHByWryName:wrymc andWrybh:dwbh];
}

-(NSMutableDictionary*)createBaseTableFromWryData:(NSDictionary*)value{

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:25];
    if(value != nil){
        [dicParams setValue:[value objectForKey:@"WRYBH"] forKey:@"WRYBH"];
        [dicParams setValue:[value objectForKey:@"WRYMC"] forKey:@"WRYMC"];
        if(bOutSide == NO){
            [dicParams setValue:[value objectForKey:@"DWDZ"] forKey:@"WRYDZ"];
            [dicParams setValue:[value objectForKey:@"FDDBR"] forKey:@"FDDBR"];
            [dicParams setValue:[value objectForKey:@"HBLXR"] forKey:@"HBFZR"];
            [dicParams setValue:[value objectForKey:@"HBRLXDH"] forKey:@"HBFZRDH"];
            [dicParams setValue:[value objectForKey:@"JDD"] forKey:@"JDD"];
            [dicParams setValue:[value objectForKey:@"JDF"] forKey:@"JDF"];
            [dicParams setValue:[value objectForKey:@"JDM"] forKey:@"JDM"];
            [dicParams setValue:[value objectForKey:@"WDD"] forKey:@"WDD"];
            [dicParams setValue:[value objectForKey:@"WDF"] forKey:@"WDF"];
            [dicParams setValue:[value objectForKey:@"WDM"] forKey:@"WDM"];
            [dicParams setValue:[value objectForKey:@"XZQY"] forKey:@"XZQY"];//行政区域
            [dicParams setValue:[value objectForKey:@"SSHY"] forKey:@"SSHY"];
            [dicParams setValue:[value objectForKey:@"QYLX"] forKey:@"QYLX"];
        }
        
        

    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    
    [dicParams setObject:[userInfo objectForKey:@"uname"] forKey:@"CJR"];
    [dicParams setObject:[userInfo objectForKey:@"uname"] forKey:@"JCR"];
    [dicParams setObject:[userInfo objectForKey:@"depart"] forKey:@"JCRBM"];
    [dicParams setObject:dateString forKey:@"CJSJ"];
    [dicParams setObject:[userInfo objectForKey:@"uname"]  forKey:@"XGR"];
    [dicParams setObject:dateString forKey:@"XGSJ"];
    [dicParams setObject:[userInfo objectForKey:@"orgid"] forKey:@"ORGID"];
    [dicParams setObject:@"手机" forKey:@"ZDLX"];
    [dicParams setObject:[userInfo objectForKey:@"sjqx"] forKey:@"SJQX"];
    [dicParams setObject:dateString forKey:@"JSSJ"];
    
    [dicParams setObject:xczfbh forKey:@"XCZFBH"];
    if (basebh.length > 0) {
        [dicParams setObject:basebh forKey:@"BH"];
    }
    
   
    
    return dicParams;
}

-(NSDictionary*)parseBaseTableFromJsonstr:(NSString*)jsonStr{
    NSDictionary *value = [jsonStr objectFromJSONString];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:25];
    if(value != nil){
        [dicParams setValue:[value objectForKey:@"WRYBH"] forKey:@"WRYBH"];
        [dicParams setValue:[value objectForKey:@"WRYMC"] forKey:@"WRYMC"];
        [dicParams setValue:[value objectForKey:@"WRYDZ"] forKey:@"DWDZ"];
        [dicParams setValue:[value objectForKey:@"FDDBR"] forKey:@"FDDBR"];
        [dicParams setValue:[value objectForKey:@"HBFZR"] forKey:@"HBLXR"];
        [dicParams setValue:[value objectForKey:@"HBFZRDH"] forKey:@"HBRLXDH"];
        [dicParams setValue:[value objectForKey:@"JDD"] forKey:@"JDD"];
        [dicParams setValue:[value objectForKey:@"JDF"] forKey:@"JDF"];
        [dicParams setValue:[value objectForKey:@"JDM"] forKey:@"JDM"];
        [dicParams setValue:[value objectForKey:@"WDD"] forKey:@"WDD"];
        [dicParams setValue:[value objectForKey:@"WDF"] forKey:@"WDF"];
        [dicParams setValue:[value objectForKey:@"WDM"] forKey:@"WDM"];
        [dicParams setValue:[value objectForKey:@"XZQY"] forKey:@"XZQY"];
        [dicParams setValue:[value objectForKey:@"SSHY"] forKey:@"SSHY"];
        [dicParams setValue:[value objectForKey:@"QYLX"] forKey:@"QYLX"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    
    [dicParams setObject:[userInfo objectForKey:@"uname"] forKey:@"CJR"];
    [dicParams setObject:dateString forKey:@"CJSJ"];
    [dicParams setObject:[userInfo objectForKey:@"uname"]  forKey:@"XGR"];
    [dicParams setObject:dateString forKey:@"XGSJ"];
    [dicParams setObject:[userInfo objectForKey:@"orgid"] forKey:@"ORGID"];
    [dicParams setObject:@"手机" forKey:@"ZDLX"];
    [dicParams setObject:[userInfo objectForKey:@"sjqx"] forKey:@"SJQX"];
    [dicParams setObject:dateString forKey:@"JSSJ"];
    

    return dicParams;
}


//查看暂存记录
-(void)historyBilu:(id)sender{
    if (!showHistoryBilu) {
        ChooseRecordViewController *tmpController =
        [[ChooseRecordViewController alloc] initWithStyle:UITableViewStylePlain];
        
        tmpController.blName = tableName;
        tmpController.wrymc = wrymc;
        tmpController.wrybh = self.dwbh;
            
        tmpController.contentSizeForViewInPopover = CGSizeMake(600, 400);
        tmpController.delegate = self;
        
        UINavigationController *tmpNav = [[UINavigationController alloc] initWithRootViewController:tmpController];
        UIPopoverController *tmpPopover = [[UIPopoverController alloc] initWithContentViewController:tmpNav];
        self.popRecordController = tmpPopover;
        [tmpController.tableView reloadData];
    
	[self.popRecordController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
    
        [self.popRecordController dismissPopoverAnimated:YES];
    }
    showHistoryBilu = !showHistoryBilu;
}

-(void)saveBilu:(id)sender{
    if (sender == nil) {
        showSaveTip = NO;
    }
    else
        showSaveTip = YES;
}

-(void)commitBilu:(id)sender{
    
    _backItem.enabled = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (alertType == kAlert_Choose) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(buttonIndex == 1){
            

        }
    }
    else if(alertType == kAlert_GenXCZFBH){
        if (buttonIndex == 0) {
            self.xczfbh = [GUIDGenerator generateBHByWryName:self.wrymc];
            
        }else{
            [self selectPolutionSrc];
        }
    }
    
    if (recordStatus == Record_Commited_Success) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)selectPolutionSrc{
	
	UISearchSitesController *formViewController = [[UISearchSitesController alloc] initWithNibName:@"UISearchSitesController" bundle:nil];
	[formViewController setDelegate:self];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:formViewController];
	nav.modalPresentationStyle =  UIModalPresentationFormSheet;
	[self presentModalViewController:nav animated:YES];
    CGRect frame = self.view.frame;
	nav.view.superview.frame = CGRectMake(frame.size.width/2-300, 160, 600, 600);
	// nav.view.superview.center = self.view.center;
	
}

-(void)requestHistoryData{
    displayFromLocal = NO;
    isHisRecord = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    showHistoryBilu = NO;
	// Do any additional setup after loading the view.
    self.title = wrymc;
    
    if(unCommitedBilu || [basebh length] == 0){ //做笔录
        
        UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
        
        UIBarButtonItem *qyButton = [[UIBarButtonItem alloc] initWithTitle:@"历史笔录" style:UIBarButtonItemStyleDone
                                                                    target:self action:@selector(historyBilu:)];
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"暂存" style:UIBarButtonItemStyleDone target:self action:@selector(saveBilu:)];
        UIBarButtonItem *commitButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commitBilu:)];
        
        NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
        [buttons addObject:qyButton];
        [buttons addObject:saveButton];
        [buttons addObject:commitButton];
        
        [tool setItems:buttons animated:NO];
        
        UIBarButtonItem *myBItem = [[UIBarButtonItem alloc] initWithCustomView:tool];
        self.navigationItem.rightBarButtonItem = myBItem;
        
        //导航左边部分
        UIToolbar *tool1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        _backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backItemPressed)];
        NSMutableArray* buttons1 = [[NSMutableArray alloc] initWithCapacity:8];
        [buttons1 addObject:_backItem];
        [tool1 setItems:buttons1 animated:NO];
       
        UIBarButtonItem *myBItem1 = [[UIBarButtonItem alloc] initWithCustomView:tool1];
        self.navigationItem.leftBarButtonItem = myBItem1;
        
        btnTitleView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnTitleView.tintColor = [UIColor lightGrayColor];
        btnTitleView.frame = CGRectMake(0, 0, 350, 35);
       
        [btnTitleView setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.navigationItem.titleView  = btnTitleView;
        
        if ([wrymc length] > 0)
        {
            NSLog(@"dwbh====%@,\n",dwbh);
            //企业已经确定，从任务或污染源详情做笔录
            if([dwbh isEqualToString:@""])
            {
                //查询外执法，没有wrybh
                NSMutableDictionary *dicTmp = [NSMutableDictionary dictionaryWithCapacity:3];
                [dicTmp setObject:wrymc forKey:@"WRYMC"];
                [self returnSites:dicTmp outsideComp:YES];
                
                return;
            }
            else
            {
                //从指定的污染源做笔录
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
                [params setObject:@"QUERY_YDZF_WRY_DATA" forKey:@"service"];
                [params setObject:dwbh forKey:@"wrybh"];
                NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
                self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:QUERY_YDZF_WRY_DATA] ;
            }
        }
        else
        {
            // 选择污染源做笔录
            [btnTitleView addTarget:self action:@selector(selectPolutionSrc) forControlEvents:UIControlEventTouchUpInside];
            [self selectPolutionSrc];
        }
        
    }
    else
    {
        // 查看详情，不是做笔录
        [self requestHistoryData];
        isHisRecord = YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}
#pragma mark -
#pragma mark ChooseRecordDelegate delegate
-(void)returnHistoryRecord:(NSDictionary*)valuesData{
    self.displayFromLocal = NO;
    [self displayRecordDatas:valuesData];
    [popRecordController dismissPopoverAnimated:YES];
}

//网络查询现场执法编号
-(void)queryXCZFBH{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_XCZFBH" forKey:@"service"];
    if([xczfbh length] > 0)
         [params setObject:xczfbh forKey:@"xczfbh"];
    else{
        if([dwbh length] > 0)
            [params setObject:dwbh forKey:@"wrybh"];
        else
            [params setObject:wrymc forKey:@"wrymc"];
    }
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];

    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:QUERY_XCZFBH] ;
}

-(void)processError:(NSError *)error{
     [self showAlertMessage:@"获取数据出错，请检查网络设置!"];
}

-(void)processWebData:(NSData*)webData andTag:(NSInteger)tag
{
    if([webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    NSLog(@"zaizheli");
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    /*
    NSDictionary *dicResult1 = [resultJSON objectFromJSONString];
    
    
    NSArray *resultA = [dicResult1 objectForKey:@"data"];
    if ([resultA count] == 0) {
        
//        NSString *msg = @"无记录数据";
//        [self showAlertMessage:msg];
        return;
    }
    self.rDic = [[dicResult1 objectForKey:@"data"] objectAtIndex:0];
    */
    if(tag == QUERY_XCZFBH){
        NSDictionary *dicResult = [resultJSON objectFromJSONString];
       // NSLog(@"%@",[dicResult allKeys]);
        if(dicResult && [dicResult isKindOfClass:[NSDictionary class]])
        {
            
            if([xczfbh length] > 0){ //说明是从任务中来的 执法编号已经确定，不用再判断
                if([basebh length] <=0)
                     [self generateBaseBH];
                [self xczfbhHasGenerated];
                return;
            }
            
            self.xczfbh = [dicResult objectForKey:@"XCZFBH"];
            self.basebh = [dicResult objectForKey:@"BH"];
            
            NSString *tmpXgsj = [dicResult objectForKey:@"XGSJ"];
            self.kckssj = [dicResult objectForKey:@"KSSJ"];
            NSDate *xgsj = [NSDateUtil dateFromString:tmpXgsj andTimeFMT:@"yyyy-MM-dd HH:mm"];
            if(xgsj == nil )
                xgsj = [NSDateUtil dateFromString:tmpXgsj andTimeFMT:@"yyyy-MM-dd"];
            NSDate *nowDate =[NSDate date];
            NSInteger days = [nowDate timeIntervalSinceDate:xgsj]/(24*60*60);
             
            if (days == 0) {// 表示同一天任务
                if([xczfbh length] <= 0)
                    [self generateXCZFBH];
                if([basebh length] <= 0)
                    [self generateBaseBH];
            } else if (days > 0 && days < 3) {// 表示三天内的任务
                NSString *tip = [NSString stringWithFormat:@"系统检测您在%@对当前污染源做过执法记录，请问是否为同一执法行为？",tmpXgsj];
                [[[UIAlertView alloc] initWithTitle:@"提示"
                                            message:tip
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"是" action:^{
                    
                    if([xczfbh length] <= 0)
                        [self generateXCZFBH];
                    if([basebh length] <= 0)
                        [self generateBaseBH];
                    
                }]
                                   otherButtonItems:[RIButtonItem itemWithLabel:@"否" action:^{
                    
                    [self generateXCZFBH];
                    [self generateBaseBH];
                    
                    
                }], nil] show];
            }else{
                [self generateXCZFBH];
                [self generateBaseBH];
            }
            
        }else{
            [self generateXCZFBH];
            [self generateBaseBH];
        }
        
        [self xczfbhHasGenerated];
    }
    else  if(tag == QUERY_YDZF_WRY_DATA){
        NSDictionary *dicResult = [resultJSON objectFromJSONString];
        if([dicResult isKindOfClass:[NSDictionary class]])
        {
            
            NSDictionary *dicTotal = [dicResult objectForKey:@"totalCount"];
            NSInteger totalCount = 0;
            if(dicTotal)
                totalCount = [[dicTotal objectForKey:@"ZS"] integerValue];
            if(totalCount > 0){
                NSArray *ary = [dicResult objectForKey:@"data"];
                if([ary count] > 0){
                    NSDictionary *wryInfo = [ary objectAtIndex:0];
                    [self returnSites:wryInfo outsideComp:NO];
                    return;
                }
            }
        }else{
        
            NSString *msg = @"获取污染源数据失败123";
            [self showAlertMessage:msg];
            return;
        }
    }
    else if(tag == COMIT_BL_BASE_DATA){

        NSRange result = [resultJSON rangeOfString:@"success"];
        if ( result.location!= NSNotFound) {
            recordStatus = Record_Commited_Success;
           
            
            //删除未提交笔录中暂存的数据
            RecordsHelper *helper = [[RecordsHelper alloc] init];
            [helper deleteRecordByBH:self.basebh andTableName:self.tableName];
            
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"提示" message:@"笔录提交成功！"];            
            
            
            [alert setCancelButtonTitle:@"确定" block:^{
                [self saveBilu:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert show];

            return;
        }
        else{
            
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"错误" message:@"笔录提交失败！"];
            
            [alert setCancelButtonTitle:@"确定" block:^{
                
            }];
            [alert setTitleTextAttributes:[AHAlertView textAttributesWithFont:[UIFont boldSystemFontOfSize:18]
                                                              foregroundColor:[UIColor redColor]
                                                                  shadowColor:[UIColor redColor]
                                                                 shadowOffset:CGSizeMake(0, -1)]];
            
            [alert setMessageTextAttributes:[AHAlertView textAttributesWithFont:[UIFont systemFontOfSize:14]
                                                                foregroundColor:[UIColor redColor]
                                                                    shadowColor:[UIColor redColor]
                                                                   shadowOffset:CGSizeMake(0, -1)]];
            [alert show];
            

            
        }
       
    }
}

//从本地查询现场执法编号
-(void)queryXCZFBHFromLocal{
    
}

-(void)xczfbhHasGenerated{
    
}

-(void)printPreview{

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:@"XCZF_DATA_PRINT" forKey:@"service"];
    [params setObject:self.xczfbh forKey:@"GLBH"];
    if ([self.tableName isEqualToString:@"T_YDZF_XCKCBL"]) {
        [params setObject:@"XCKCBL" forKey:@"TYPE"];
    }
    else if ([self.tableName isEqualToString:@"T_YDZF_DCXWBL"]) {
        [params setObject:@"DCXWBL" forKey:@"TYPE"];
    }
    else if ([self.tableName isEqualToString:@"T_YDZF_WRYXCJCJL"]) {
        [params setObject:@"WRYXCJCJL" forKey:@"TYPE"];
    }
    
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:strUrl andFileName:[NSString stringWithFormat:@"%@.pdf",self.wrymc]];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
