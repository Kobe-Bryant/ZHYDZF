//
//  SendTaskViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-10-24.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SendTaskViewController : BaseViewController{
    IBOutlet UITextField *wrymcField;
    IBOutlet UITextField *dwdzField;
    IBOutlet UITextField *frdbField;
    IBOutlet UITextField *frdbdhField;
    IBOutlet UITextField *slrField;
    IBOutlet UITextField *rwqxField;
    IBOutlet UITextField *bzField;
    IBOutlet UIButton *saveButton;
    IBOutlet UISwitch *sendShortMsgSwitch; //是否发送短信
    IBOutlet UITextField *phoneNumsField;
}

-(IBAction)touchFromDate:(id)sender;
-(IBAction) touchFromWrymcField:(id)sender;
-(IBAction) choosePersonField:(id)sender;
-(IBAction) switchCtrlChanged:(id)sender;
-(IBAction) scanQRCode:(id)sender;
@property (nonatomic,copy)NSString *JCRBM;
@end
