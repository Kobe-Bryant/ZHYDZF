//
//  WryQueryViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-17.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "WryQueryViewController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "UITableViewCell+Custom.h"
#import "WryDetailCategoryViewController.h"
#import "SystemConfigContext.h"
#import <ZXingWidgetController.h>
#import <QRCodeReader.h>


@interface WryQueryViewController ()<ZXingDelegate>
@property (nonatomic,strong) UIPopoverController *wordsPopover;
@property (nonatomic,strong) CommenWordsViewController *wordSelectCtrl;

@property (nonatomic, strong) NSMutableArray *listDataArray;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) int totalCount;//总记录条数
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) int currentPage;//当前页
@property (nonatomic, assign) int currentTag;

@property (nonatomic, assign) int selectedDWLX;
@property (nonatomic, assign) int selectedJGJB;
@end

#define kTag_DWLX_Field 1 //单位类型
#define kTag_JGJB_Field 2 //监管级别

@implementation WryQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initQueryArea
{
    self.dwlxField.tag = kTag_DWLX_Field;
    self.dwlxField.delegate = self;
    self.jgjbField.tag = kTag_JGJB_Field;
    self.jgjbField.delegate = self;
    
    [self.searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.dwlxField addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    [self.jgjbField addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    
    CommenWordsViewController *wordCtrl = [[CommenWordsViewController alloc] initWithStyle:UITableViewStylePlain];
    [wordCtrl setContentSizeForViewInPopover:CGSizeMake(320, 400)];
    self.wordSelectCtrl = wordCtrl;
    self.wordSelectCtrl.delegate = self;
    UIPopoverController *popCtrl = [[UIPopoverController alloc] initWithContentViewController:self.wordSelectCtrl];
    self.wordsPopover = popCtrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"一源一档";
    [self initQueryArea];
    
    self.totalCount = 0;
    self.currentPage = 1;
    self.listDataArray = [[NSMutableArray alloc] init];
    
    self.isLoading = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"扫描二维码" style:UIBarButtonItemStylePlain target:self action:@selector(scanQRCode)];
    
    [self requestData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)scanQRCode{
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    NSMutableSet *readers = [[NSMutableSet alloc] init];
    QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
    [readers addObject:qrcodeReader];
    widController.readers = readers;
    [self presentViewController:widController animated:YES completion:^{}];
}

- (void)outPutResult:(NSString *)result
{
    NSLog(@"result:%@", result);
    
    WryDetailCategoryViewController *detail = [[WryDetailCategoryViewController alloc] initWithNibName:@"WryDetailCategoryViewController" bundle:nil];
    detail.link = @"wry/wryDetailCategory.jsp";
    detail.primaryKey = result;
    detail.wrymc = @"";
  
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - ZXingDelegate

- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{[self outPutResult:result];}];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"cancel!");}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //确保弹出框是隐藏起来的
    if(self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setListTableView:nil];
    [self setNameLabel:nil];
    [self setNameField:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
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
    headerView.text = [NSString stringWithFormat:@"  查询结果:%d条", self.totalCount];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.listDataArray objectAtIndex:indexPath.row];
    NSString *wrymc_value = [item objectForKey:@"WRYMC"];
    NSString *wrydz_value = [NSString stringWithFormat:@"地址：%@", [item objectForKey:@"DWDZ"]];
    NSString *wryhylx_value = [NSString stringWithFormat:@"所属区县：%@", [item objectForKey:@"SSQX"]];
    NSString *wryszqy_value = [NSString stringWithFormat:@"法人代表：%@", [item objectForKey:@"FRDB"]];
    NSString *wryjgjb_value = [NSString stringWithFormat:@"监管级别：%@", [item objectForKey:@"TAG_01"]];
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:wrymc_value  andSubvalue1:wrydz_value andSubvalue2:wryhylx_value andSubvalue3:wryszqy_value  andSubvalue4:wryjgjb_value andNoteCount:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int pages = self.totalCount%ONE_PAGE_SIZE == 0 ? self.totalCount/ONE_PAGE_SIZE : self.totalCount/ONE_PAGE_SIZE+1;
    if(self.currentPage == pages || pages == 0 || self.totalCount <= 25)
    {
        return;
    }
	if (self.isLoading)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        self.currentPage++;
        NSString *strUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",self.urlString, self.currentPage];
        self.isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.listDataArray objectAtIndex:indexPath.row];
    WryDetailCategoryViewController *detail = [[WryDetailCategoryViewController alloc] initWithNibName:@"WryDetailCategoryViewController" bundle:nil];
    detail.link = [item objectForKey:@"LINK"];
    detail.primaryKey = [item objectForKey:@"PRIMARY_KEY"];
    detail.wrymc = [item objectForKey:@"WRYMC"];
    detail.dataItem = item;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - Network Handler Methods

/**
 * 获取污染源企业数据
 * 参数1:service(这里固定为QUERY_WRY_LIST, 必选)
 * 参数2:WRYMC(污染源名称, 可选)
 * 参数3:jgjb(污染源监管级别, 可选)
 * 参数3:dwdz(污染源企业地址, 可选)
 * 参数3:hylx(污染源行业类型, 可选)
 * ...
 */
- (void)requestData
{
    self.isLoading = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_WRY_LIST" forKey:@"service"];
  //  NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
  //  [params setObject:[userInfo objectForKey:@"sjqx"] forKey:@"SJQX"];
    NSString *UrlStr = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = UrlStr;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
{
    self.isLoading = NO;
    if(webData.length <= 0)
    {
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSDictionary *detailDict = [jsonStr objectFromJSONString];
    BOOL bParsedError = NO;
    if(detailDict != nil)
    {
        self.totalCount = [[detailDict objectForKey:@"totalCount"] intValue];
        NSArray *tmpAry = [detailDict objectForKey:@"data"];
        if(tmpAry.count > 0)
        {
            [self.listDataArray addObjectsFromArray:tmpAry];
        }
    }
    else
    {
        bParsedError = YES;
    }
    [self.listTableView reloadData];
    if(bParsedError)
    {
        [self showAlertMessage:@"解析数据出错!"];
    }
}

- (void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self showAlertMessage:@"获取数据出错!"];
}

#pragma mark - Event Handler Methods

- (IBAction)searchButtonClick:(id)sender
{
    if(self.listDataArray)
    {
        [self.listDataArray removeAllObjects];
    }
    [self.listTableView reloadData];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_WRY_LIST" forKey:@"service"];
  //   NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];

   // [params setObject:[userInfo objectForKey:@"sjqx"] forKey:@"SJQX"];
    //单位名称
    if(self.nameField.text != nil && self.nameField.text.length > 0)
    {
        [params setObject:self.nameField.text forKey:@"WRYMC"];
    }
    //监管级别
    if(self.jgjbField.text != nil && self.jgjbField.text.length > 0)
    {
        if([self.jgjbField.text isEqualToString:@"国控"])
        {
            [params setObject:@"1" forKey:@"JGJB"];
        }
        else if([self.jgjbField.text isEqualToString:@"省控"])
        {
            [params setObject:@"2" forKey:@"JGJB"];
        }
        else if([self.jgjbField.text isEqualToString:@"市控"])
        {
            [params setObject:@"3" forKey:@"JGJB"];
        }
        else if([self.jgjbField.text isEqualToString:@"区控"])
        {
            [params setObject:@"4" forKey:@"JGJB"];
        }
        else if([self.jgjbField.text isEqualToString:@"非控"])
        {
            [params setObject:@"9" forKey:@"JGJB"];
        }
        
    }
    //地址
    if(self.addressField.text != nil && self.addressField.text.length > 0)
    {
        [params setObject:self.addressField.text forKey:@"WRYDZ"];
    }
    //单位类型
    if(self.dwlxField.text != nil && self.dwlxField.text.length > 0)
    {
        [params setObject:[NSString stringWithFormat:@"%d", self.selectedDWLX] forKey:@"dwlx"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
//    NSLog(@"ssssstrUrl=%@",strUrl);
    self.urlString = strUrl;
    self.totalCount = 0;
    self.currentPage = 1;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self];
}

- (void)selectWord:(id)sender
{
    if (self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
    
    UITextField *field = (UITextField *)sender;
    field.text = @"";
    self.currentTag = field.tag;
    
    switch (self.currentTag)
    {
        case kTag_DWLX_Field:
            self.wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"工业",@"三产",@"市政设施",@"医疗机构",@"其他", nil];
            break;
        case kTag_JGJB_Field:
            self.wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"国控",@"省控",@"市控",@"区控",@"非控", nil];
            break;
        default:
            break;
    }
    [self.wordSelectCtrl.tableView reloadData];
    [self.wordsPopover presentPopoverFromRect:[field bounds] inView:field permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - Words Delegate

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    switch (self.currentTag)
    {
        case kTag_DWLX_Field:
            self.dwlxField.text = words;
            self.selectedDWLX = row;
            break;
        case kTag_JGJB_Field:
            self.jgjbField.text = words;
            self.selectedJGJB = row + 1;
            break;
        default:
            break;
    }
    
    if(self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
}

#pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;//保证可以弹出选择框，没有键盘
}

@end
