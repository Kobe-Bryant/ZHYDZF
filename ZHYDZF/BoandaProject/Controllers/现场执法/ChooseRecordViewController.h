//
//  ChooseRecordViewController.h
//  GMEPS_HZ
//
//  Created by power humor on 12-7-27.
//  Copyright (c) 2012年 powerdata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"

#define RECORD_KYBL 1 //勘验笔录 服务QUERY_XCKCBL_HISTORY wrybh
#define RECORD_XWBL 2 //询问笔录 服务 QUERY_DCXWBL_HISTORY wrybh
#define RECORD_DTBD 3 //动态表单 QUERY_ZFBD_LSJL 参数 templateId WRYBH
#define RECORD_XCQZ 4 //采样 QUERY_XCKCQYD_HISTORY wrybh
#define RECORD_XCJCJL 5 //现场取证 QUERY_XCJCJL_HISTORY wrybh
#define QUERY_KYT_HISTORY 6 //现场取证 QUERY_XCJCJL_HISTORY wrybh wrymc

@protocol ChooseRecordDelegate

-(void)returnHistoryRecord:(id)values;

@end
@interface ChooseRecordViewController : UITableViewController <NSURLConnHelperDelegate>
{

}

@property(nonatomic,assign)BOOL isSignature;
@property (nonatomic, strong) NSURLConnHelper *webHelper;
@property(nonatomic,strong)NSString *blName;  //指定的执法记录
@property(nonatomic,strong)NSString *wrymc;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *templateID;
@property(nonatomic,strong)NSArray *chooseAry;
@property (nonatomic, strong) NSString *wrybh;//污染源编号
@property (nonatomic, assign) id<ChooseRecordDelegate> delegate;

@end
