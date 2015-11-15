//
//  BaserecordViewController.h
//  GMEPS_HZ
//
//  Created by 张仁松 on 13-4-12.
//  笔录数据分两步提交： 主表表单数据、对应的笔录表单
//


#import <UIKit/UIKit.h>

#import "ChooseRecordViewController.h"
#import "UISearchSitesController.h"
#import "BaseViewController.h"


#define QUERY_XCZFBH         1001
#define COMIT_BL_BASE_DATA   1002
#define  QUERY_YDZF_WRY_DATA 1003
#define  COMIT_BL_XCKCBL     1004
#define  COMIT_BL_DCXWBL     1005
#define  LIST_WRY_ZFBD       1006
#define  QUERY_XCKCBL_HISTORY 1007
#define  QUERY_DCXWBL_HISTORY 1008
#define  COMMIT_BL_XCJCJL      1009
#define  QUERY_DCXWBL_WD_HISTORY 1010
#define  QUERY_XCJCJL_HISTORY     1011
#define  QUERY_YDZF_PIC_DATA     1012
#define  QUERY_YDZF_PIC_MC       1013
#define  OPERATE_ZFBD            1014
#define  QUERY_ZFBD_TEMPLATE_LIST 1015
#define  COMIT_BL_XCJCBL     1016

@interface BaseRecordViewController : BaseViewController
<NSXMLParserDelegate,ChooseRecordDelegate,SelectSitesDelegate>{
    UIButton *btnTitleView;
    BOOL bOutSide;//是否查询外执法
}

//生产现场执法编号
-(void)generateXCZFBH;
//生成主表编号
-(void)generateBaseBH;

//网络查询现场执法编号
-(void)queryXCZFBH;

//从本地查询现场执法编号
-(void)queryXCZFBHFromLocal;

//提交记录
-(void)commitRecordDatas:(NSDictionary*)value;
//提交主表数据
-(void)commitBaseRecordData:(NSDictionary*)value;


//根据值来显示值
-(void)displayRecordDatas:(NSDictionary*)values;
//保存表单数据
-(void)saveLocalRecord:(id)valueDatas;
-(void)saveLocalRecord:(id)valueDatas andPath:(NSString *)path;
//获取界面数据
-(NSDictionary*)getValueData;

-(NSDictionary*)parseBaseTableFromJsonstr:(NSString*)jsonStr;

-(NSMutableDictionary*)createBaseTableFromWryData:(NSDictionary*)value;

-(void)xczfbhHasGenerated;//现场执法证号已经生产

-(void)requestHistoryData;//获取历史笔录信息

-(void)saveBilu:(id)sender;

-(void)queryRecordFromLocal;

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(NSDictionary*)modifyDicValues:(NSDictionary*)val;

@property(nonatomic,assign) NSInteger recordStatus;
@property(nonatomic,copy) NSString *tableName;//数据库表名
@property(nonatomic,copy) NSString *dwbh;
@property(nonatomic,copy) NSString *wrymc;
@property(nonatomic,copy) NSString *kckssj;//勘察开始时间
@property(nonatomic,copy) NSString *xczfbh;// 现场 执法编号
@property(nonatomic,copy) NSString *basebh;// 主表的编号BH
@property(nonatomic,assign) NSInteger menuTagID;//对应按钮的tag
@property(nonatomic,assign)BOOL isHisRecord;//YES 台账中调用此界面
@property(nonatomic,retain)NSDictionary *dicWryInfo;
@property(nonatomic,assign)BOOL displayFromLocal;//yes从本地获取，no从服务器历史笔录获取
@property(nonatomic,assign)BOOL unCommitedBilu;//未提交的笔录
@property(nonatomic,strong)NSDictionary *rDic;//后台填写后，这里使用数据
@end
