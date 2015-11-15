//
//  DangerWasteDetailViewController.m
//  BoandaProject
//
//  Created by 熊熙 on 14-2-10.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "DangerWasteViewController.h"
#import "GUIDGenerator.h"
@interface DangerWasteViewController ()

@end

@implementation DangerWasteViewController

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
    self.title = @"危险废物情况";
    [self loadValue:self.dangerWasteInfo];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAdd:)];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAdd:)];
    
    self.navigationItem.leftBarButtonItem = cancel;
	self.navigationItem.rightBarButtonItem = done;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Event Handle
- (void)cancelAdd:(id)sender{
	[self dismissModalViewControllerAnimated:NO];
}

- (void)doneAdd:(id)sender{
    [self dismissModalViewControllerAnimated:NO];
    NSDictionary *valueDict = [self getValue];
    [self.delegate returnValues:valueDict index:self.index modify:self.modify Tag:1];
}

- (NSDictionary *)getValue{
    //危险废物
    NSMutableDictionary *valueDict = [NSMutableDictionary dictionaryWithCapacity:4];
    
    NSString *bh =  [GUIDGenerator generateGUID];
    [valueDict setValue:bh forKey:@"BH"];
    [valueDict setValue:self.xcjcbh forKey:@"XCJCBH"];
    [valueDict setValue:wxfwmcTxt.text forKey:@"WXFWFWMC"];
    
    if (wxfwsfcsSegment.selectedSegmentIndex != -1) {
        [valueDict setValue:[wxfwsfcsSegment titleForSegmentAtIndex:wxfwsfcsSegment.selectedSegmentIndex] forKey:@"WXFWSFBS"];
    }
    
    if (wxfwbzbsSegment.selectedSegmentIndex != -1) {
        [valueDict setValue:[wxfwbzbsSegment titleForSegmentAtIndex:wxfwbzbsSegment.selectedSegmentIndex] forKey:@"WXFWBZBS"];
    }
    
    if (wxfwzyldSegment.selectedSegmentIndex != -1) {
        [valueDict setValue:[wxfwzyldSegment titleForSegmentAtIndex:wxfwzyldSegment.selectedSegmentIndex] forKey:@"WXFWZYLD"];
    }
    
    if (zccsSegment.selectedSegmentIndex != -1) {
        [valueDict setValue:[zccsSegment titleForSegmentAtIndex:zccsSegment.selectedSegmentIndex] forKey:@"WXFWZCCS"];
    }
    
    if (czdwzzSegment.selectedSegmentIndex != -1) {
        [valueDict setValue:[czdwzzSegment titleForSegmentAtIndex:czdwzzSegment.selectedSegmentIndex] forKey:@"WXFWCZDWZZ"];
    }
    
    [valueDict setValue:sfbsInfo.text forKey:@"WXFWSFBSXQ"];
    [valueDict setValue:bzbsInfo.text forKey:@"WXFWBZBSXQ"];
    [valueDict setValue:zyldInfo.text forKey:@"WXFWZYLDXQ"];
    [valueDict setValue:zccsInfo.text forKey:@"WXFWZCCSXQ"];
    [valueDict setValue:qtView.text forKey:@"QT"];
    return valueDict;
}

- (void)loadValue:(NSDictionary *)valueData{
    //危险废物
    wxfwmcTxt.text =[valueData objectForKey:@"WXFWFWMC"];
    sfbsInfo.text =[valueData objectForKey:@"WXFWSFBSXQ"];
    bzbsInfo.text =[valueData objectForKey:@"WXFWBZBSXQ"];
    zyldInfo.text =[valueData objectForKey:@"WXFWZYLDXQ"];
    zccsInfo.text =[valueData objectForKey:@"WXFWZCCSXQ"];
    qtView.text = [valueData objectForKey:@"QT"];

    NSString *selectTitle = [valueData objectForKey:@"WXFWSFBS"];
    for (int n=0; n < wxfwsfcsSegment.numberOfSegments; n++) {
        NSString *title = [wxfwsfcsSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            wxfwsfcsSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueData objectForKey:@"WXFWBZBS"];
    for (int n=0; n < wxfwbzbsSegment.numberOfSegments; n++) {
        NSString *title = [wxfwbzbsSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            wxfwbzbsSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueData objectForKey:@"WXFWZYLD"];
    for (int n=0; n < wxfwzyldSegment.numberOfSegments; n++) {
        NSString *title = [wxfwzyldSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            wxfwzyldSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueData objectForKey:@"WXFWCZDWZZ"];
    for (int n=0; n < czdwzzSegment.numberOfSegments; n++) {
        NSString *title = [czdwzzSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            czdwzzSegment.selectedSegmentIndex = n;
        }
    }
    
    selectTitle = [valueData objectForKey:@"WXFWZCCS"];
    for (int n=0; n < zccsSegment.numberOfSegments; n++) {
        NSString *title = [zccsSegment titleForSegmentAtIndex:n];
        if ([title isEqualToString:selectTitle]) {
            zccsSegment.selectedSegmentIndex = n;
        }
    }
    
}

@end
