//
//  BuildProjectDetailViewController.h
//  BoandaProject
//
//  Created by 熊熙 on 14-2-8.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupDateViewController.h"

@protocol DoneValueDelegate
- (void)returnValues:(NSDictionary *)values index:(NSInteger)row  modify:(BOOL)enable Tag:(NSInteger)tag;
@end

@interface BuildProjectDetailViewController : UIViewController<PopupDateDelegate> {
    //新建项目
    IBOutlet UITextField *hpspdwTxt;
    IBOutlet UITextField *xmmcTxt;
    IBOutlet UISegmentedControl *jsjdSegment;
    IBOutlet UISegmentedControl *sscSegment;
    IBOutlet UITextField *sscsjTxt;
    IBOutlet UITextField *spsjTxt;
    IBOutlet UISegmentedControl *xmpjSegment;
    IBOutlet UITextField *xmpjRemark;
    IBOutlet UISegmentedControl *xmysSegment;
    IBOutlet UITextField *xmysRemark;
    IBOutlet UITextField *jsnrTxt;
    IBOutlet UITextField *jssjTxt;
    IBOutlet UITextView  *qtView;
}

@property (nonatomic, assign) id<DoneValueDelegate> delegate;
@property (nonatomic, strong) NSDictionary *projectInfo;
@property (nonatomic, assign) BOOL modify;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy)   NSString *xcjcbh;
@property (nonatomic, assign) BOOL isApproval;
- (IBAction)touchFromDate:(id)sender;
@end
