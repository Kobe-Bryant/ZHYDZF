//
//  WryMapViewController.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WryMapViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import "WryDetailCategoryViewController.h"
#import "ZHAGSGraphicEntity.h"
@interface WryMapViewController ()

//GIS定位
@property (nonatomic, assign) BOOL haveShowLocation;
@property (nonatomic,assign) BOOL isAdd;
@property (nonatomic,strong)AGSTiledMapServiceLayer *baseLayer;
@property (nonatomic,strong)NSMutableArray *locationArr;


@end

@implementation WryMapViewController{
        
}
@synthesize urlConnHelper,aryWryItems,listTableView,agsMapView,graphicsLayer;
@synthesize mcField,mcLabel,dzField,dzLabel,searchBtn,roundField,roundLabel,CLController,userCoordinate;
@synthesize bHaveShow,isAdd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.locationArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}
-(IBAction)searchWry:(id)sender{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    [params setObject:@"QUERY_WRY_LIST" forKey:@"service"];
    if ([mcField.text length] > 0) {
        [params setObject:mcField.text forKey:@"WRYMC"];
    }
    if ([dzField.text length] > 0) {
        [params setObject:dzField.text forKey:@"dwdz"];
    }
    if ([roundField.text length] > 0) {
        CGFloat jd = userCoordinate.longitude;
        CGFloat wd = userCoordinate.latitude;
        if (jd > 0 && wd > 0) {
            [params setObject:roundField.text forKey:@"RADIUS"];
            
            [params setObject:[NSString stringWithFormat:@"%f",jd] forKey: @"C_LONGITUDE"];
            [params setObject:[NSString stringWithFormat:@"%f",wd] forKey: @"C_LATITUDE"];
        }
    }
    if ([mcField.text length] == 0 && [dzField.text length] == 0 && [roundField.text length] == 0) {
        
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示：" message:@"请输入查询的内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alt show];
        return;
    }
    //NSString *jsonStr = [params JSONString];
    [params setObject:@"200" forKey:@"P_PAGESIZE"];
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
    self.urlConnHelper = [[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self];
    NSLog(@"urlstr===%@",urlStr);
}

-(void)wryList:(id)sender{
    
    [UIView animateWithDuration:0.2 animations:
     ^{
         if(listTableView.frame.origin.x == 768){
             listTableView.frame = CGRectMake(768-240, 0, 240, 960);
             
             [listTableView reloadData];
         }else {
             listTableView.frame = CGRectMake(768, 0, 240, 960);
         }
     }
     ];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    mcField.hidden = NO;
    mcLabel.hidden = NO;
    dzField.hidden = NO;
    dzLabel.hidden = NO;
    roundField.hidden = NO;
    roundLabel.hidden = NO;        
    searchBtn.hidden = NO;
}



- (void)showSearchBar:(id)sender {
    listTableView.frame = CGRectMake(768, 0, 240, 960);
    
    UIBarButtonItem *aItem = (UIBarButtonItem *)sender; 
    if(bHaveShow)
    {
        [mcField resignFirstResponder];
        [dzField resignFirstResponder];
        [roundField resignFirstResponder];
        
        bHaveShow = NO;
        aItem.title = @"开启查询";
        mcField.hidden = YES;
        mcLabel.hidden = YES;
        dzField.hidden = YES;
        dzLabel.hidden = YES;
        roundField.hidden = YES;
        roundLabel.hidden = YES;        
        searchBtn.hidden = YES;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        agsMapView.frame = CGRectMake(0, 0, 768, 960);
        [UIView commitAnimations];
    }
    else{
        aItem.title = @"关闭查询";
        bHaveShow = YES;

        [UIView beginAnimations:@"kshowSearchBarAnimation" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        agsMapView.frame = CGRectMake(0, 120, 768, 960);
        [UIView commitAnimations];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"污染源地图查询";
    
    //导航栏按钮
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem  alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStyleBordered  target:self action:@selector(showSearchBar:)];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"污染源列表" style:UIBarButtonItemStyleBordered target:self action:@selector(wryList:)];
    
    toolBar.items = [NSArray arrayWithObjects:item3,flexItem,item2,nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
    
    self.agsMapView = [[AGSMapView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
   
    NSURL *url_Tiled = [NSURL URLWithString:kTiledMapServiceURL];
    AGSTiledMapServiceLayer *tiledLyr = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url_Tiled];
    [agsMapView addMapLayer:tiledLyr withName:@"TiledLayer"];
    
     [self.view addSubview:agsMapView];
    agsMapView.calloutDelegate = self;
    graphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [agsMapView addMapLayer:graphicsLayer withName:@"graphicsLayer"];
    
    [self.view bringSubviewToFront:listTableView];
    listTableView.frame = CGRectMake(768, 0, 240, 960);
    
    bHaveShow = YES;
    [self showSearchBar:item2];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_WRY_LIST" forKey:@"service"];
    [params setObject:@"200" forKey:@"P_PAGESIZE"];
    [params setObject:@"1" forKey:@"JGJB"]; //默认国控数据
    
    CLController = [[CoreLocationController alloc] init];
	CLController.delegate = self;
    [CLController.locMgr startUpdatingLocation];
    
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"地图url = %@",urlStr);
    if (urlConnHelper)
        [urlConnHelper cancel];
    
    self.urlConnHelper =[[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self];
    
}
 
-(void)getLocation:(NSDictionary *)item
{
    
    AGSPoint *point = [[AGSPoint alloc] initWithX:[[item objectForKey:@"JD"] doubleValue] y:[[item objectForKey:@"WD"] doubleValue] spatialReference:Nil];
    AGSSimpleMarkerSymbol *mySymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"wry_pin.png"];
    ZHAGSGraphicEntity *entity = [[ZHAGSGraphicEntity alloc] init];
    
    entity.title = [NSString stringWithFormat:@"%@",item[@"TITLE"]];
    
    entity.coustromImg = [UIImage imageNamed:@"minus.png"];
    if (![self.locationArr containsObject:entity]) {
        
        [self.locationArr addObject:entity];
    }
    
    
    AGSGraphic *myGraphic = [AGSGraphic graphicWithGeometry:point symbol:mySymbol attributes:Nil infoTemplateDelegate:entity];
    
    [graphicsLayer addGraphic:myGraphic];
    
}


- (void)locationUpdate:(CLLocation *)location {
	userCoordinate = location.coordinate;
    
}

- (void)locationError:(NSError *)error{
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (urlConnHelper)
        [urlConnHelper cancel];
    if (CLController) {
       [CLController.locMgr stopUpdatingLocation];
    }
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - URLConnHelper delegate
-(void)processWebData:(NSData*)webData
{
    NSString *resultJSON =[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:webData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Dic =====%@",Dic);
    NSLog(@"resultJson = %@",resultJSON);
    //NSLog(@"JSONString：%@",resultJSON);
    NSDictionary *dicData = [resultJSON objectFromJSONString];
    self.aryWryItems = [dicData objectForKey:@"data"];

    if (aryWryItems == nil||[aryWryItems count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未查到相关污染源" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [graphicsLayer removeAllGraphics];
    
    for (NSDictionary *dic in aryWryItems) {
        
        [self getLocation:dic];
    }
    [graphicsLayer refresh];
}

-(void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败,请检查网络连接并重试。" 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    return;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark--污染源列表
-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"污染源列表(%d)个",[aryWryItems count]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [aryWryItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines =2;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    NSDictionary *dic = [aryWryItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"WRYMC"];
        
    return cell;
}


#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *item = [aryWryItems objectAtIndex:indexPath.row];

    WryDetailCategoryViewController *detail = [[WryDetailCategoryViewController alloc] initWithNibName:@"WryDetailCategoryViewController" bundle:nil];
    detail.jd = [item objectForKey:@"JD"];
    detail.wd = [item objectForKey:@"WD"];
    detail.link = [item objectForKey:@"LINK"];
    detail.primaryKey = [item objectForKey:@"PRIMARY_KEY"];
    detail.wrymc = [item objectForKey:@"WRYMC"];
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark--- Calloutdelegate
- (void)didClickAccessoryButtonForCallout:(AGSCallout *)callout{

    NSLog(@"hello world");


}



@end
