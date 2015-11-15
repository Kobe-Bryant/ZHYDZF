//
//  ModifyTipViewController.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"

@interface ModifyTipViewController : UIViewController<NSURLConnHelperDelegate>
@property(nonatomic,strong)  NSURLConnHelper *urlConnHelper;
@property(nonatomic,strong) NSString *wrybh;
@property(nonatomic,strong) NSString *wrymc;
@property(nonatomic,strong) NSString *oldJD;
@property(nonatomic,strong) NSString *oldWD;
@property(nonatomic,strong) NSString *toModifyJD;
@property(nonatomic,strong) NSString *toModifyWD;

@property(nonatomic,strong) IBOutlet UITextField  *oldJDField;
@property(nonatomic,strong) IBOutlet UITextField  *oldWDField;
@property(nonatomic,strong) IBOutlet UITextField  *toModifyJDField;
@property(nonatomic,strong) IBOutlet UITextField  *toModifyWDField;

-(IBAction)modifyLocation:(id)sender;
@end
