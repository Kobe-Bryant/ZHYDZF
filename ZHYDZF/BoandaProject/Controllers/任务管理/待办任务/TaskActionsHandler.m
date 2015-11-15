//
//  TaskActionsHandler.m
//  BoandaProject
//
//  Created by 张仁松 on 13-10-18.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "TaskActionsHandler.h"

#import "PDJsonkit.h"

#import "StepUserItem.h"

#import "FinishActionController.h"
#import "TransitionActionControllerNew.h"
#import "CounterSignActionController.h"
#import "FeedbackActionController.h"
#import "EndorseActionController.h"
#import "ReturnBackViewController.h"



@interface TaskActionsHandler()

@property(nonatomic,retain) UIView *parentView;
@property(nonatomic,retain) UIViewController* target;
@property(nonatomic,copy)NSString *title;
@property (nonatomic,strong) NSString *typeStr;
@property(nonatomic,strong) NSArray *aryAttachFiles;//附件

@property (nonatomic,strong) NSDictionary *dicActionInfo;

@end

@implementation TaskActionsHandler
@synthesize parentView,target,title,typeStr,aryAttachFiles,dicActionInfo;

-(id)initWithTarget:(UIViewController*)atarget andParentView:(UIView*)inView {
    self = [super init];
    if(self){
        self.parentView = inView;
        self.target = atarget;
        
    }
    return self;
}



-(void)finishAction:(id)sender{
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
    controller.bzbh = [dicActionInfo objectForKey:@"BZBH"];
    controller.serviceType = 1;
    controller.delegate = (id<HandleGWDelegate>)self.target;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
    
}

-(void)transitionAction:(id)sender{
    TransitionActionControllerNew *controller = [[TransitionActionControllerNew alloc] initWithNibName:@"TransitionActionControllerNew" bundle:nil];
    controller.bzbh = [dicActionInfo objectForKey:@"BZBH"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
    
}

-(void)countersignAction:(id)sender{
    /*  CounterSignActionController *controller = [[CounterSignActionController alloc] initWithNibName:@"CounterSignActionController" bundle:nil];
     controller.bzbh = [params objectForKey:@"BZBH"];
     controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
     [self.navigationController pushViewController:controller animated:YES];
     [controller release];*/
}


-(void)sendBackAction:(id)sender{
    ReturnBackViewController *controller = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    controller.bzbh = [dicActionInfo objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
    
}

-(void)feedbackAction:(id)sender{
    FeedbackActionController *controller = [[FeedbackActionController alloc] initWithNibName:@"FeedbackActionController" bundle:nil];
    controller.bzbh = [dicActionInfo objectForKey:@"BZBH"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
    
}

-(void)endorseAction:(id)sender{
    EndorseActionController *controller = [[EndorseActionController alloc] initWithNibName:@"EndorseActionController" bundle:nil];
    controller.bzbh = [dicActionInfo objectForKey:@"BZBH"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
    
}


-(void)handleActionInfo:(NSDictionary *)actionInfo{
    self.dicActionInfo = actionInfo;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 350, 44)];
    NSMutableArray *aryBarItems = [NSMutableArray arrayWithCapacity:5];
    UIBarButtonItem *flexItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [aryBarItems addObject:flexItem];
    
    NSNumber *isFirstStep = [dicActionInfo objectForKey:@"IS_FIRST_STEP"];
    NSNumber *canFinish = [dicActionInfo objectForKey:@"CAN_FINISH"];
    if([canFinish boolValue]){
        if(![isFirstStep boolValue]){
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   结  束   " style:UIBarButtonItemStyleBordered target:self action:@selector(finishAction:)];
            [aryBarItems addObject:aBarItem];
        }
        
        
    }
    
    NSNumber *canTransition = [dicActionInfo objectForKey:@"CAN_TRANSITION"];
    if([canTransition boolValue]){
        
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"手工流转" style:UIBarButtonItemStyleBordered target:self action:@selector(transitionAction:)];
        [aryBarItems addObject:aBarItem];
        
    }
    
    NSNumber *canSendback = [dicActionInfo objectForKey:@"CAN_SEND_BACK"];
    if([canSendback boolValue]){
        
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   退  回   " style:UIBarButtonItemStyleBordered target:self action:@selector(sendBackAction:)];
        [aryBarItems addObject:aBarItem];
        
    }
    
    NSNumber *canCountersign = [dicActionInfo objectForKey:@"canCountersign"];
    if([canCountersign boolValue]){
        /*
         UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   会  签   " style:UIBarButtonItemStyleBordered target:self action:@selector(countersignAction:)];
         [aryBarItems addObject:aBarItem];*/
        
    }
    
    NSNumber *isCanFeedback = [dicActionInfo objectForKey:@"IS_CAN_FEEDBACK"];
    if([isCanFeedback boolValue]){
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   反  馈   " style:UIBarButtonItemStyleBordered target:self action:@selector(feedbackAction:)];
        [aryBarItems addObject:aBarItem];
        
    }
    
    NSNumber *isCanEndorse = [dicActionInfo objectForKey:@"IS_CAN_ENDORSE"];
    if([isCanEndorse boolValue]){
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   加  签   " style:UIBarButtonItemStyleBordered target:self action:@selector(endorseAction:)];
        [aryBarItems addObject:aBarItem];
        
    }
    // [aryBarItems addObject:flexItem];
    toolBar.items = aryBarItems;
    
    //[self.view addSubview:toolBar];
    target.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
    
    
}


@end
