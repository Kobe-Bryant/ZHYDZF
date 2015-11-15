//
//  MultiCommonPicker.m
//  BoandaProject
//
//  Created by ZHONGWEN on 14-2-19.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "MultiCommonPicker.h"

@interface MultiCommonPicker ()

@end

@implementation MultiCommonPicker

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.commonWords1 = @[ @"1次", @"2次", @"3次", @"4次", @"5次", @"6次", @"7次", @"8次", @"9次"];
        self.commonWords2 = @[ @"年", @"月", @"周", @"日" ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissSNSelectView)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSNSelect)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.multiCommonView = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 0, 360, 216)];
    self.multiCommonView.dataSource = self;
    self.multiCommonView.delegate = self;
    self.multiCommonView.showsSelectionIndicator = YES;
    
    [self.view addSubview:self.multiCommonView];
	// Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark Event Handle
- (void)dismissSNSelectView {
    [self.delegate returnJCPC:@""];
}

- (void)DoneSNSelect{
    NSInteger numberRow = [self.multiCommonView selectedRowInComponent:0];
    NSInteger dateRow = [self.multiCommonView selectedRowInComponent:1];
    
    NSString *numberStr = [self.commonWords1 objectAtIndex:numberRow];
    NSString *dateStr = [self.commonWords2 objectAtIndex:dateRow];
    NSString *jcpcStr = [NSString stringWithFormat:@"%@/%@",numberStr,dateStr];
    [self.delegate returnJCPC:jcpcStr];
}

#pragma mark -
#pragma mark UIPickerViewController DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.commonWords1 count];
    }

    return [self.commonWords2 count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.commonWords1 objectAtIndex:row];
    }
    
        return [self.commonWords2 objectAtIndex:row];
}

//返回三列各列宽度
-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(component==0)
    {
        return 140.0f;
    }

    return 140.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if (component == 0) {
//        NSInteger yearRow = [pickerView selectedRowInComponent:1];
//        NSString *year = [self.yearArray objectAtIndex:yearRow];
//        NSString *type = [self.typeArray objectAtIndex:row];
//        for (NSDictionary *snDict in self.listArray) {
//            
//            NSString *typeStr = [snDict objectForKey:@"fwlb"];
//            NSString *yearStr = [snDict objectForKey:@"year"];
//            NSString *snStr  = [snDict objectForKey:@"serial"];
//            
//            if ([year isEqualToString:yearStr] && [type isEqualToString:typeStr]) {
//                self.serial = snStr;
//            }
//        }
//        
//        
//        [self.multiCommonView reloadComponent:1];
//        [self.multiCommonView reloadComponent:2];
//    }
//    return;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
