//
//  SiteInforcementConroller.h
//  EPad
//
//  Created by chen on 11-4-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommenWordsViewController.h"
#import "BaseRecordViewController.h"
#import "PopupDateViewController.h"
#import "PersonChooseVC.h"

@interface SiteInforcementConroller : BaseRecordViewController
<UITextFieldDelegate,UITextViewDelegate,PopupDateDelegate,WordsDelegate,PersonChooseResult>

{

    int currentTag;
    
    UIPopoverController *wordsPopoverController;
	CommenWordsViewController* wordsSelectViewController;
    UITextField *QYMC;

    int _textFTag;
    BOOL _isHaveSelect;
}

@property (nonatomic,assign) BOOL isCKXQ;
@property (nonatomic,retain) NSArray *jbxx;
@property (nonatomic, retain) IBOutlet UITextField * XCFZR;	//现场负责人
@property (nonatomic, retain) IBOutlet UITextField * NL;	//年龄
@property (nonatomic, retain) IBOutlet UITextField * SFZHM;	//身份证号码
@property (nonatomic, retain) IBOutlet UITextField *KCDWFDMC;//被检查单位法定名称
@property (nonatomic, retain) IBOutlet UITextField *FDDBR;//法定代表人
@property (nonatomic, retain) IBOutlet UITextField *FDDBRDH;//法定代表人电话
@property (nonatomic, retain) IBOutlet UITextField * GZDW;	//工作单位
@property (nonatomic, retain) IBOutlet UITextField * ZW;	//职务
@property (nonatomic, retain) IBOutlet UITextField * YBAGX;	//与本案关系

@property (nonatomic, retain) IBOutlet UITextField * JTZZ;	//家庭住址
@property (nonatomic, retain) IBOutlet UITextField * DH;	//电话
@property (nonatomic, retain) IBOutlet UITextField * JCR;//检查人
@property (nonatomic, copy) NSString *JCRBM;

@property (nonatomic, retain) IBOutlet UITextField * JLR;//记录人

@property (nonatomic, retain) IBOutlet UITextField * QTJZR;	//其他见证人
@property (nonatomic, retain) IBOutlet UITextField * ZFRY;
@property (nonatomic, retain) IBOutlet UITextField * ZFZH;	//执法证号
@property (nonatomic, retain) IBOutlet UITextField * HBBM;//环境保护主管部门
@property (nonatomic, retain) IBOutlet UITextField * QRSF;	//对执法人身份的确认
@property (nonatomic, retain) IBOutlet UITextField * SQHB;	//申请回避答案
@property (nonatomic, retain) IBOutlet UITextView  * XCQK;	//现场情况

@property (nonatomic, retain) IBOutlet UITextField *KYKSSJ; //勘验开始时间
@property (nonatomic, retain) IBOutlet UITextField *KYJSSJ; //勘验结束时间
@property (nonatomic, retain) IBOutlet UITextField *KYDD;   //勘验地点

@property (nonatomic, retain) UIPopoverController *popController;

@property (nonatomic, retain) IBOutlet UIButton *btnDraw;
-(IBAction)choosePerson:(id)sender;
-(IBAction)beginEditing:(id)sender;
-(IBAction)touchFromDate:(id)sender;

-(IBAction)drawKYT:(id)sender;

//获取界面数据
-(NSDictionary*)getValueData;
@end
