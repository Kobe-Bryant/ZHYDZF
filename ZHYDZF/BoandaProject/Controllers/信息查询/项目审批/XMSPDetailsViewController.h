//
//  ExamineDetailsView.h
//  RetrieveExamine
//
//  Created by hejunhua on 11-9-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface XMSPDetailsViewController : BaseViewController <UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>{

}


@property (nonatomic,copy) NSString *primaryKey;
@property (nonatomic,copy) NSString *wrybh;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSMutableArray *aryFiles;

@end
