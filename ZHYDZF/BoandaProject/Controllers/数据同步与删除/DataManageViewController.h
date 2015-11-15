//
//  DataManageViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-12-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataManageViewController : UIViewController{
    IBOutlet UILabel *infoLabel;
}

-(IBAction)syncData:(id)sender;

-(IBAction)clearData:(id)sender;
@end
