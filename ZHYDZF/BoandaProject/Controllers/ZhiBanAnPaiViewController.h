//
//  ZhiBanAnPaiViewController.h
//  BoandaProject
//
//  Created by 李凌辉 on 14-7-2.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "BaseViewController.h"
#import "NSURLConnHelper.h"
#import "BaseViewController.h"
#import "PopupDateViewController.h"

#define kTag_StartDate_Field 1001 //开始日期
#define kTag_EndDate_Field 1002 //结束日期

@interface ZhiBanAnPaiViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,UIScrollViewDelegate,UITextFieldDelegate,PopupDateDelegate>{
    
    UITableView *listTable;
    int count;
    
    UITextField *rwmcTxt;
    UITextField *kssjTxt;
    UITextField *jssjTxt;
}
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,unsafe_unretained) BOOL isLoading;
@property (nonatomic,unsafe_unretained) NSInteger pageCount;
@property (nonatomic,unsafe_unretained) NSInteger currentPage;
@end
