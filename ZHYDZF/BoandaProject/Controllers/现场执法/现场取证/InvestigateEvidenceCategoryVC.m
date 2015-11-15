//
//  InvestigateEvidenceCategoryVC.m
//  BoandaProject
//
//  Created by 张仁松 on 13-11-12.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//  现场取证分类

#import "InvestigateEvidenceCategoryVC.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "InvestigateEvidenceVC.h"

@interface InvestigateEvidenceCategoryVC ()
@property(nonatomic,strong)NSArray *aryCategory;
@property(nonatomic,strong)UITableView *listTableView;
@end

@implementation InvestigateEvidenceCategoryVC
@synthesize aryCategory,listTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)requestCategoryData{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:5];
    [params setObject:@"QUERY_YDZF_PIC_MC" forKey:@"service"];
    NSString *strURL = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strURL andParentView:self.view delegate:self tagID:QUERY_YDZF_PIC_MC];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableName = @"T_YDZF_FJB";
    self.listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 960) style:UITableViewStyleGrouped];
    listTableView.delegate =self;
    listTableView.dataSource =self;
    [self.view addSubview:listTableView];
    

    if([self.basebh length] == 0){ //做笔录
       
        
    
        UIBarButtonItem *commitButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commitBilu:)];

        self.navigationItem.rightBarButtonItem = commitButton;
        
      
        
    }
    
    [self requestCategoryData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//选择污染源
-(void)returnSites:(NSDictionary*)values outsideComp:(BOOL)bOut
{
	if (values == nil)
    {
		[self.navigationController popViewControllerAnimated:YES];
	}
	else
    {
        if (bOut)
        {
            [btnTitleView setTitle:[values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
            self.wrymc  = [values objectForKey:@"WRYMC"];
            self.dwbh = @"";
        }
        else
        {
            self.dwbh  = [values objectForKey:@"WRYBH"];
            self.wrymc = self.title = [values objectForKey:@"WRYMC"];
            [btnTitleView setTitle: [values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
            self.dicWryInfo = values;
        }
        bOutSide = bOut;
        [self  queryXCZFBH];
        [super returnSites:values outsideComp:bOut];
	}
}

//主表的一条记录可以对应附件表的多条记录
-(void)commitBilu:(id)sender
{
    
    //提交主表数据
    NSDictionary *dict = [[SystemConfigContext sharedInstance] getUserInfo];
    NSString *uname = [dict objectForKey:@"uname"];
    NSString *ORGID = [dict objectForKey:@"orgid"];
    NSString *sjqx = [dict objectForKey:@"sjqx"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *dateStr = [df stringFromDate:now];
    
    
    NSMutableDictionary *recordData = [[NSMutableDictionary alloc] init];
    if(self.dicWryInfo)
        [recordData setDictionary:self.dicWryInfo];
   
    if (self.basebh.length > 0) {
    
        NSLog(@"11111");
        [recordData setObject:self.basebh forKey:@"BH"];
    }else{
    
        NSLog(@"2222");
    }
    
    [recordData setObject:self.xczfbh forKey:@"XCZFBH"];
    
    [recordData setObject:sjqx forKey:@"SJQX"];
    [recordData setObject:uname forKey:@"CJR"];
    [recordData setObject:dateStr forKey:@"CJSJ"];
    [recordData setObject:uname forKey:@"XGR"];
    [recordData setObject:dateStr forKey:@"XGSJ"];
    [recordData setObject:ORGID forKey:@"ORGID"];
    [self commitBaseRecordData:[self createBaseTableFromWryData:recordData]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.aryCategory.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dicInfo = [aryCategory objectAtIndex:indexPath.section];
    cell.textLabel.text = [dicInfo objectForKey:@"DMNR"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicInfo = [aryCategory objectAtIndex:indexPath.section];
    InvestigateEvidenceVC *controller = [[InvestigateEvidenceVC alloc] initWithNibName:@"InvestigateEvidenceVC" bundle:nil];
    controller.basebh = self.basebh;
    controller.xczfbh = self.xczfbh;
    controller.isHisRecord = self.isHisRecord;
    controller.category = [dicInfo objectForKey:@"DM"];
    
    NSLog(@"ISHISECDE===%c",controller.isHisRecord);
    controller.title = [dicInfo objectForKey:@"DMNR"];
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    if(tag != QUERY_YDZF_PIC_MC )
        return [super processWebData:webData andTag:tag];
    if([webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    if(tag == QUERY_YDZF_PIC_MC)
    {
        NSString *str = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSArray *tmpAry = [str objectFromJSONString];
        if(tmpAry && [tmpAry count] > 0)
            self.aryCategory = tmpAry;
        else{
            NSString *msg = @"查询数据失败";
            [self showAlertMessage:msg];
            return;
        }
        [listTableView reloadData];
    }
}

@end
