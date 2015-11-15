//
//  TextTool.h


#import <Foundation/Foundation.h>
#import "Tool.h"

@interface TextTool : NSObject <Tool, UITextViewDelegate> 

@property (assign, nonatomic) id <ToolDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *trackingTouches;
@property (strong, nonatomic) NSMutableArray *startPoints;
@property (strong, nonatomic) UIBezierPath *completedPath;
@property (assign, nonatomic) CGFloat viewSlideDistance;
@property (strong, nonatomic) UITextView *textView;

+(TextTool*)sharedTextTool;

@end
