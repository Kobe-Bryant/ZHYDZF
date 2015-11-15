//
//  PersonChooseVC.h
//  BoandaProject
//
//  Created by 张仁松 on 13-10-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersHelper.h"

@protocol  PersonChooseResult

- (void)personChoosed:(NSArray*)aryChoosed;
- (void)getBMMC:(NSString *)bmmcStr;
@end



@interface PersonChooseVC : UITableViewController{
    UsersHelper *usersHelper;
    int count;
}
@property(nonatomic,strong)NSString *parentBMBH;
@property(nonatomic,assign)BOOL multiUsers;
@property(nonatomic,assign)id<PersonChooseResult> delegate;
@property(nonatomic,strong)NSMutableArray *aryChoosedPersons;
@end
