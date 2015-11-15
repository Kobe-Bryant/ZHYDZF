//
//  WendaDetailsViewController.m
//  GMEPS_HZ
//
//  Created by apple on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WendaDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIAlertView+Blocks.h"

@implementation WendaDetailsViewController
@synthesize scrollView,wordsPopoverController,wordsSelectViewController;
@synthesize quesAry,ansAry,wdDelegate,QYMC,saveButton;
@synthesize quesValueAry,ansValueAry,buttonAry,quesLabelAry,ansLabelAry,deleteAry;
/*
-(IBAction)beginEditing:(id)sender{
	UIControl *ctrl = (UIControl*)sender;
  //   [ctrl resignFirstResponder];
	currentFieldTag = ctrl.tag;
	CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;
    rect.origin.y = ctrl.frame.origin.y+70;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
    if (rect.origin.y  > 650 ) {
        rect.origin.y  -= 650;
    }
	[wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:rect
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionLeft
											   animated:YES];
    
}
*/
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    
    
	UITextField *tmpField;
	int sizeQA = [quesAry count];
	for (int i=0; i< sizeQA; i++) {
		tmpField = [quesAry objectAtIndex:i];
		if (currentFieldTag == tmpField.tag) {
			tmpField.text = words;
			if (wordsPopoverController != nil) {
				[wordsPopoverController dismissPopoverAnimated:YES];
			}
			break;
		}
	}
    
	
}



-(IBAction)addNewQuestion:(id)sender
{
    [self addQAViewWithOrigValue:NO andQues:@"" andAns:@""];
}

//插入和删除控件时移动
-(void)moveDown:(UIView*)sender tag:(int)tag data:(int)da
{
    CGRect rectF ;
    rectF.origin.y = sender.frame.origin.y+da;
    rectF.origin.x = sender.frame.origin.x;
    rectF.size.width = sender.frame.size.width;
    rectF.size.height = sender.frame.size.height;
    sender.frame = rectF;
    sender.tag =tag;

}

//删除控件和数组里的值
-(void)deleteUiAndAry:(int)tag
{
    UITextField *nowQA =  [quesAry objectAtIndex:tag];
    UITextView *nowView = [ansAry objectAtIndex:tag];
    UIButton *nowButton = [buttonAry objectAtIndex:tag];
    UIButton *nowDeleteB = [deleteAry objectAtIndex:tag];
    UILabel *nowQues = [quesLabelAry objectAtIndex:tag];
    UILabel *nowAns = [ansLabelAry objectAtIndex:tag];
    [nowQA removeFromSuperview];
    [nowView removeFromSuperview];
    [nowButton removeFromSuperview];
    [nowDeleteB removeFromSuperview];
    [nowQues removeFromSuperview];
    [nowAns removeFromSuperview];
    
    [quesAry removeObjectAtIndex:tag];
    [ansAry removeObjectAtIndex:tag];
    [deleteAry removeObjectAtIndex:tag];
    [buttonAry removeObjectAtIndex:tag];
    [quesLabelAry removeObjectAtIndex:tag];
    [ansLabelAry removeObjectAtIndex:tag];
}

//在上一行插入问答
-(void)biaozhunBtnPressed:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    UITextField *nowQA =  [quesAry objectAtIndex:btn.tag];
    yAxs = nowQA.frame.origin.y;
    tagCount = btn.tag;
    [self addQAViewWithOrigValue:NO andQues:@"" andAns:@""];
    
    for (int tag = btn.tag+1; tag<[quesAry count]; tag++) {
        UITextField *nowQA =  [quesAry objectAtIndex:tag];
        UITextView *nowView = [ansAry objectAtIndex:tag];
        UIButton *nowButton = [buttonAry objectAtIndex:tag];
        UIButton *nowDeleteB = [deleteAry objectAtIndex:tag];
        UILabel *nowQues = [quesLabelAry objectAtIndex:tag];
        UILabel *nowAns = [ansLabelAry objectAtIndex:tag];
        
        [self moveDown:nowQA tag:tag data:125];
        [self moveDown:nowView tag:tag data:125];
        [self moveDown:nowButton tag:tag data:125];
        [self moveDown:nowDeleteB tag:tag data:125];
        [self moveDown:nowQues tag:tag data:125];
        [self moveDown:nowAns tag:tag data:125];
        
        if (tag ==[quesAry count]-1) {
            
            yAxs = nowQA.frame.origin.y+125;
            tagCount =  nowQA.tag+1;
        }
                
    }
    
    
}
//删除问答
-(void)deleteData:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"提示"
                                message:@"您确定删除此条问答吗？"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{
        UIButton *btn = (UIButton*)sender;
        
        [self deleteUiAndAry:btn.tag];//删除控件和数组里的值
        for (int tag = btn.tag; tag<[quesAry count]; tag++) {
            UITextField *nowQA =  [quesAry objectAtIndex:tag];
            UITextView *nowView = [ansAry objectAtIndex:tag];
            UIButton *nowButton = [buttonAry objectAtIndex:tag];
            UIButton *nowDeleteB = [deleteAry objectAtIndex:tag];
            UILabel *nowQues = [quesLabelAry objectAtIndex:tag];
            UILabel *nowAns = [ansLabelAry objectAtIndex:tag];
            
            [self moveDown:nowQA tag:tag data:-125];
            [self moveDown:nowView tag:tag data:-125];
            [self moveDown:nowButton tag:tag data:-125];
            [self moveDown:nowDeleteB tag:tag data:-125];
            [self moveDown:nowQues tag:tag data:-125];
            [self moveDown:nowAns tag:tag data:-125];
            
            if (tag ==[quesAry count]-1) {
                yAxs = nowQA.frame.origin.y+125;
                tagCount =  nowQA.tag+1;
            }
        }
        
        if (btn.tag>=[quesAry count]) {
            yAxs-=125;
            tagCount = btn.tag;
        }
    }]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"取消" action:^{
        
    }], nil] show];
    
   
    
}

//添加问答
-(void)addQAViewWithOrigValue:(BOOL)bOrigValue andQues:(NSString*)queStr 
                      andAns:(NSString*)ansStr{
	UILabel *quesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, yAxs, 45, 35)];
    quesLabel.tag = tagCount;
	[quesLabel setBackgroundColor:[UIColor clearColor]];
	[quesLabel setTextColor:[UIColor blackColor]];
	quesLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
	quesLabel.textAlignment = UITextAlignmentLeft;
	quesLabel.text = @"问";
	
	UITextField *quesField = [[UITextField alloc] initWithFrame:CGRectMake(50, yAxs, 600, 35)];
//	quesField.backgroundColor = [UIColor blackColor];
	quesField.tag = tagCount++;
	//[quesField addTarget:self action:@selector(beginEditing:) forControlEvents: UIControlEventTouchDown];
    [quesField setDelegate:self];
    quesField.borderStyle = UITextBorderStyleLine;

        
    UIButton *opinion = [UIButton buttonWithType:UIButtonTypeContactAdd];
    opinion.frame = CGRectMake(655, yAxs, 35, 35);
    //[opinion setTitle:@"标准语句" forState:UIControlStateNormal]; 
    opinion.tag = quesField.tag;
    [opinion addTarget:self action:@selector(biaozhunBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteQA = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteQA.frame = CGRectMake(655, yAxs+35+5, 30, 30);
    //deleteQA.imageView.image = [UIImage imageNamed:@"minus.png"];
    [deleteQA setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
    //[opinion setTitle:@"标准语句" forState:UIControlStateNormal]; 
    deleteQA.tag = quesField.tag;
    [deleteQA addTarget:self action:@selector(deleteData:) forControlEvents:UIControlEventTouchUpInside];
    
	UILabel *ansLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, yAxs+45, 45, 35)];
    ansLabel.tag = quesField.tag;
	[ansLabel setBackgroundColor:[UIColor clearColor]];
	[ansLabel setTextColor:[UIColor blackColor]];
	ansLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
	ansLabel.textAlignment = UITextAlignmentLeft;
	ansLabel.text = @"答";
    
	UITextView *ansView = [[UITextView alloc] initWithFrame:CGRectMake(50, yAxs+45, 600, 70)];
	ansView.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    ansView.tag = quesField.tag;
	yAxs += 125;
    [ansView setDelegate:self];
    ansView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:opinion];
	[self.scrollView addSubview:quesLabel];
	[self.scrollView addSubview:quesField];
	[self.scrollView addSubview:ansLabel];
	[self.scrollView addSubview:ansView];
    [self.scrollView addSubview:deleteQA];
	if (bOrigValue) {
        quesField.text = queStr;
        ansView.text = ansStr;
    }
    [quesAry insertObject:quesField atIndex:quesField.tag];
    [ansAry insertObject:ansView atIndex:quesField.tag];
    [buttonAry insertObject:opinion atIndex:quesField.tag];
    [quesLabelAry insertObject:quesLabel atIndex:quesField.tag];
    [ansLabelAry insertObject:ansLabel atIndex:quesField.tag];
    [deleteAry insertObject:deleteQA atIndex:quesField.tag];
    
	
    int qaCount =  [quesAry count];
	[scrollView setContentSize:CGSizeMake(640,qaCount*125+260)];//多加260 是键盘的高度 防止遮住输入框
	
    
	
}

-(void)initWithOriginalQAs{
    tagCount = 0;
    //NSLog(@"count :%d %d",[quesValueAry count],[ansValueAry count]);
    for (int i=0; i<[quesValueAry count]; i++) {
        [self addQAViewWithOrigValue:YES 
                             andQues:[quesValueAry objectAtIndex:i] 
                              andAns:[ansValueAry  objectAtIndex:i]]; 
    }
    
}



- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.QYMC;
    yAxs = 10.0f;
    ansAry = [[NSMutableArray alloc]initWithCapacity:10];
	quesAry = [[NSMutableArray alloc]initWithCapacity:10];
    buttonAry = [[NSMutableArray alloc]initWithCapacity:10];
    quesLabelAry = [[NSMutableArray alloc]initWithCapacity:10];
    ansLabelAry = [[NSMutableArray alloc]initWithCapacity:10];
    deleteAry = [[NSMutableArray alloc]initWithCapacity:10];
    scrollView.layer.borderColor = UIColor.grayColor.CGColor;  //设置边框颜色
    scrollView.layer.borderWidth = 2;
    
    NSArray *wordsArray =  [[NSArray alloc] initWithObjects:@"你在单位担任什么职务？",
                          @"你单位全称是什么？",@"法定代表人是谁？是否具有政治身份？",@"你单位何时建成投产？是否经过环保部门的环评审批和竣工验收？",@"主要从事何种生产？",@"有几条生产线（或有几个生产车间），生产工艺如何？",@"废水处理工艺如何，最终排放至哪里？",@"废水排放量每天约多少？",@"你单位污染源在线监控设备是委托什么单位进行运维？",@"在线设备工作人员的运维频次如何？",@"你单位 月份运维工作是否正常？",@"为何会出现这种情况？",@"这种情况持续多久？",@"根据浙江省环保厅《关于规范污染源自动监测设备量程设定的通知》(浙环发[2009]86号)或其他等相关规定，你单位**会造成污染源自动监控设备不正常运行？",@"你单位最近一个时段的废水排污费是多少？",@"是否知道污染源自动监控设备是你单位污染防治措施的一部分，应当确保其正常运行？",@"有无需要陈述申辩的？",nil];
    
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController.contentSizeForViewInPopover = CGSizeMake(620, 400);
	tmpController.delegate = self;
	tmpController.wordsAry = wordsArray;
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
	
    UIBarButtonItem *aButton = [[UIBarButtonItem alloc] initWithTitle:@"保存并返回" style:UIBarButtonItemStyleDone  
                                                               target:self action:@selector(save:)];
    self.saveButton = aButton;
    self.navigationItem.rightBarButtonItem = aButton;	

    [self initWithOriginalQAs];
        // Do any additional setup after loading the view from its nib.
}

-(BOOL)saveQA{
    
    UITextField *tmpField;
    UITextView  *txtView;
    [quesValueAry removeAllObjects];
    [ansValueAry  removeAllObjects];
	int sizeQA = [quesAry count];
    NSString *msgStr;
    if (sizeQA == 0) {
        
        msgStr = @"未添加任何问答";
        
    }else{

        for (int i=0; i< sizeQA; i++) {
            tmpField = [quesAry objectAtIndex:i];
            txtView  = [ansAry  objectAtIndex:i];
            if (tmpField.text.length == 0 || txtView.text.length == 0) {
                
                msgStr = @"请把问题和答案填写完整";
                break;
            }
            [quesValueAry addObject:tmpField.text];
            [ansValueAry  addObject:txtView.text];
        }
    }
	if (msgStr.length > 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:msgStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    [wdDelegate returnquesAry:quesValueAry returnansAry:ansValueAry];
    return YES;
}

- (void)isHaveBlank{

    
}

-(void)save:(id)sender
{
    
    if ([self saveQA]) {
        self.saveButton.enabled = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self saveQA];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITextField *ctrl = (UITextField*)textField;
    //   [ctrl resignFirstResponder];
	currentFieldTag = ctrl.tag;
	CGRect rect;
	rect.origin.x = ctrl.frame.origin.x-300;
    rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
    /* if (rect.origin.y  > 650 ) {
     rect.origin.y  -= 650;
     }*/
	[wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:rect
												 inView:scrollView
							   permittedArrowDirections:UIPopoverArrowDirectionLeft
											   animated:YES];
    
}


@end
