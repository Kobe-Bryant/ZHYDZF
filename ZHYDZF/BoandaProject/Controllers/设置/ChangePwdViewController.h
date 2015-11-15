//
//  ChangePwdViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-12-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ChangePwdViewController : BaseViewController{
    IBOutlet UITextField *oldPwdField;
    IBOutlet UITextField *newPwdField;
    IBOutlet UITextField *againPwdField;
    IBOutlet UILabel *infoLabel;
}

-(IBAction)changePwd:(id)sender;
@end
