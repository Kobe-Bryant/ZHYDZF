//
//  DetailRightPanelView.m
//  HBBXXPT
//
//  Created by zhang on 13-3-12.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import "DetailRightPanelView.h"
#import <QuartzCore/QuartzCore.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"

@interface DetailRightPanelView()
@property(nonatomic,assign)BOOL bShow;
@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,retain) ASINetworkQueue * networkQueue ;
@property(nonatomic,retain)MBProgressHUD *HUD;
@property(nonatomic,retain)UILabel *newsTitleLab;
@property(nonatomic,retain)UILabel *subTitleLab;
@property(nonatomic,retain)UILabel *sourceDateLab;
@property(nonatomic,copy) NSString *contentStr;
@property(nonatomic,copy) NSString *picturePath;
@property(nonatomic,assign)BOOL hasPic;
@property(nonatomic,assign)BOOL bWrong;
@end


@implementation DetailRightPanelView
@synthesize bShow,webView,networkQueue,HUD;
@synthesize newsTitleLab,subTitleLab,sourceDateLab;
@synthesize contentStr,picturePath,bWrong;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0;
        self.layer.masksToBounds = NO;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 12;
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(5,5);
        self.layer.cornerRadius = 4.0;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 312, 595)];
        imgView.image = [UIImage imageNamed:@"popbanner.png"];
        [self addSubview:imgView];

        
        UIButton *exitBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 45)];
        exitBtn.showsTouchWhenHighlighted = YES;
        [exitBtn addTarget:self action:@selector(exitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:exitBtn];

        self.bShow = NO;
  
 
        UIWebView *tmpWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10,60,292,515)];
        tmpWebView.backgroundColor = [UIColor clearColor];
        self.webView = tmpWebView;
        webView.scalesPageToFit = YES;
        webView.delegate = self;
        [self addSubview:webView];

        
        UISwipeGestureRecognizer *swipGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(exitBtnPressed:)];
        swipGesture.direction =  UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipGesture];

    }
    return self;
}

-(void)exitBtnPressed:(id)sender{
    CGFloat xPos;
    
    if(bShow){
        xPos = 768;
        if (networkQueue)
            [networkQueue cancelAllOperations];
        if(HUD)
        {
            [HUD hide:YES];
            [HUD removeFromSuperview];
        }
    }else{
        xPos = 768-312;
    }
    
    [UIView beginAnimations:@"kshowRight" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGRect rect = CGRectMake(xPos, 53, 312, 595);
    self.frame = rect;
    [UIView commitAnimations];
    
    self.bShow = !bShow;
}

-(void)showView:(BOOL)isShow{
    
    if(bShow != isShow){
        [self exitBtnPressed:nil];
    }
}
-(void)showDetail:(NSDictionary *)item
{
    NSString *str = [NSString stringWithFormat:@"<html><head><style type=\"text/css\"><!--body,  p{margin:0;padding:0; list-style:none; width:900px;font-size:55px; color:#1b1b1b;}</style></head><body><p>违法行为：%@</p></br><p>违反条款：%@</p></br><p>处罚适用条款：%@</p></br><p>处罚或措施：%@</p></br><p>注意要点：%@</p> </body></html>",[item objectForKey:@"WFXW"],[item objectForKey:@"WFTK"],[item objectForKey:@"CFSYCK"],[item objectForKey:@"CFHCS"],[item objectForKey:@"ZYYD"]];
    
    [webView loadHTMLString:str baseURL:nil];
                            
    
    if(bShow == NO){
        [self exitBtnPressed:nil];
    }
}


@end
