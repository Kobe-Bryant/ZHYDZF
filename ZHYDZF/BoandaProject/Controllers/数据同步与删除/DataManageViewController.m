//
//  DataManageViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-12-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "DataManageViewController.h"
#import "DataSyncManager.h"
#import "MBProgressHUD.h"
#import "SqliteHelper.h"
#import "SystemConfigContext.h"

@interface DataManageViewController ()
@property(nonatomic,strong)DataSyncManager *syncManager;

@property(nonatomic,strong)MBProgressHUD *HUD;
@end

@implementation DataManageViewController
@synthesize HUD,syncManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)okBtnClick
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"数据处理";
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *commitButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"确定"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(okBtnClick)];
    self.navigationItem.rightBarButtonItem = commitButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)syncData:(id)sender{
    if(syncManager == nil)
        self.syncManager = [[DataSyncManager alloc] init];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = @"正在同步数据，请稍候...";
    [HUD show:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSyncFinished:) name:kNotifyDataSyncFininshed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSyncFailed:) name:kNotifyDataSyncFailed object:nil];
    
    [syncManager reSyncAllTables];
}

-(IBAction)clearData:(id)sender{
    SqliteHelper *helper = [[SqliteHelper alloc] init];
    [helper clearAllDatas];
    
    NSString *dbName = [[SystemConfigContext sharedInstance] getString:@"DBName"];
    
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"];
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum =
    [localFileManager enumeratorAtPath:docsDir];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if (![file isEqualToString: dbName]) {
            // process the document
            [localFileManager removeItemAtPath:[docsDir stringByAppendingPathComponent:file] error:nil ];
        }
    }
    
    infoLabel.text = @"数据清空完毕！";
    infoLabel.textColor = [UIColor greenColor];
    
   [[NSUserDefaults standardUserDefaults] setObject:@"2008-08-08 18:18:18.888" forKey:kLoginSyncDate];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"200-08-08 18:18:18.888" forKey:kLastSyncDate];
    
    
}


- (void)dataSyncFinished:(NSNotificationCenter *)notification{
    if(HUD)  [HUD hide:YES];
    
    infoLabel.text = @"数据同步成功！";
    infoLabel.textColor = [UIColor greenColor];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyDataSyncFininshed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyDataSyncFailed object:nil];
    
}

- (void)dataSyncFailed:(NSNotificationCenter *)notification{
    
    if(HUD)  [HUD hide:YES];
    
    infoLabel.text = @"数据同步失败，请重新同步数据。";
    infoLabel.textColor = [UIColor redColor];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyDataSyncFininshed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyDataSyncFailed object:nil];
    
    
}
@end
