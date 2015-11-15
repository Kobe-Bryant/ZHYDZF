//
//  TextTool.m


#import "TextTool.h"
#import "TextDrawingInfo.h"
#import <QuartzCore/QuartzCore.h>

#define SHADE_TAG 10000

static CGFloat distanceBetween(const CGPoint p1, const CGPoint p2) {
  return sqrt(pow(p1.x-p2.x, 2) + pow(p1.y-p2.y, 2));
}
 static TextTool *_sharedInstance = nil;
@implementation TextTool

+ (TextTool *)sharedTextTool
{
   
    @synchronized(self)
    {
        if(_sharedInstance == nil)
        {
            _sharedInstance = [[TextTool alloc] init];
        }
        
    }
    return _sharedInstance;
}

- init {
  if ((self = [super init])) {
    self.trackingTouches = [NSMutableArray arrayWithCapacity:100];
    self.startPoints = [NSMutableArray arrayWithCapacity:100];
  }
  return self;
}

- (void)activate {
}

-(void)deleteLastPoint:(BOOL)isDelete{
}

- (void)deactivate {
  [self.trackingTouches removeAllObjects];
  [self.startPoints removeAllObjects];
  self.completedPath = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

  UIView *touchedView = [self.delegate viewForUseWithTool:self];
  [touchedView endEditing:YES];
    if (self.textView != nil) {
        [self.textView removeFromSuperview];
        self.textView  = nil;
    }
  // we only track one touch at a time for this tool.
  UITouch *touch = [[event allTouches] anyObject];
  // remember the touch, and its original start point, for future
  [self.trackingTouches addObject:touch];
  CGPoint location = [touch locationInView:touchedView];
  [self.startPoints addObject:[NSValue valueWithCGPoint:location]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [self.delegate viewForUseWithTool:self];
  for (UITouch *touch in [event allTouches]) {
    // make a rect from the start point to the current point
    NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
    // only if we actually remember the start of this touch...
    if (touchIndex != NSNotFound) {
      CGPoint startPoint = [[self.startPoints objectAtIndex:touchIndex] CGPointValue];
      CGPoint endPoint = [touch locationInView:touchedView];
      [self.trackingTouches removeObjectAtIndex:touchIndex];
      [self.startPoints removeObjectAtIndex:touchIndex];
      
      // detect short taps that are too small to contain any text;
      // these are probably accidents
      if (distanceBetween(startPoint, endPoint) < 50.0) return;
        float width =  endPoint.x - startPoint.x;
        float height = endPoint.y - startPoint.y;
        if (width<20 && width>-20) return;
        if (height<20 && height>-20) return;
        
      CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
      self.completedPath = [UIBezierPath bezierPathWithRect:rect];
      
      // draw a shaded area over the entire view, so that the user can
      // easily see where to focus their attention.
        /*
      UIView *backgroundShade = [[[UIView alloc] initWithFrame:touchedView.bounds] autorelease];
      backgroundShade.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
      backgroundShade.tag = SHADE_TAG;
      backgroundShade.userInteractionEnabled = NO;
      [touchedView addSubview:backgroundShade];*/
      
      // now comes the fun part.  we make a temporary UITextView for the
      // actual text input.
      self.textView = [[UITextView alloc] initWithFrame:rect];
      // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
      //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

		// in case the chosen view is going to be below the keyboard, we need to
		// make an effort to determine how far the display area should slide when
		// the keyboard is going to be shown.
		//
		// keyboard heights:
		//
		// 352 landscape
		// 264 portrait
		CGFloat keyboardHeight = 0;
		UIInterfaceOrientation orientation = ((UIViewController*)self.delegate).interfaceOrientation;
		if (UIInterfaceOrientationIsPortrait(orientation)) {
			keyboardHeight = 320;
		} else {
			keyboardHeight = 352;
		}
		CGRect viewBounds = touchedView.bounds;
		CGFloat rectMaxY = rect.origin.y + rect.size.height;
		CGFloat availableHeight = viewBounds.size.height - keyboardHeight;
		if (rectMaxY > availableHeight) {
			// calculate a slide distance so that the dragged box is centered vertically
			self.viewSlideDistance = keyboardHeight;//rectMaxY - availableHeight;
		} else {
			self.viewSlideDistance = 0;
		}		
		
      self.textView.delegate = self;
      [touchedView addSubview:self.textView];
      self.textView.editable = NO;
      self.textView.editable = YES;
      self.textView.scrollEnabled = NO;
      self.textView.font = [UIFont systemFontOfSize:24.0];
      self.textView.layer.borderColor = UIColor.grayColor.CGColor;  //textview边框颜色
      self.textView.layer.borderWidth = 2;
      //UIView *ownerView = [delegate viewForOwner:self];
      //[touchedView becomeFirstResponder];
      [self deactivate];
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)drawTemporary {
  if (self.completedPath) {
    [self.delegate.strokeColor setStroke];
    [self.completedPath stroke];
  } else {
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    for (int i = 0; i<[self.trackingTouches count]; i++) {
      UITouch *touch = [self.trackingTouches objectAtIndex:i];
      CGPoint startPoint = [[self.startPoints objectAtIndex:i] CGPointValue];
      CGPoint endPoint = [touch locationInView:touchedView];
      CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
      UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
      [self.delegate.strokeColor setStroke];
      [path stroke];
    }
  }
}

#pragma mark Sliding the view


// this isn't quite working right.  will revisit this later.
// for now, just going to plough ahead as if it works.
- (void)keyboardWillShow:(NSNotification *)aNotification {	
  UIInterfaceOrientation orientation = ((UIViewController*)self.delegate).interfaceOrientation;
	[UIView beginAnimations:@"viewSlideUp" context:NULL];
  UIView *view = [self.delegate viewForOwner:self];
  CGRect frame = [view frame];
  switch (orientation) {
    case UIInterfaceOrientationLandscapeLeft:
      frame.origin.x -= self.viewSlideDistance; 
      break;
    case UIInterfaceOrientationLandscapeRight:
      frame.origin.x += self.viewSlideDistance; 
      break;
    case UIInterfaceOrientationPortrait:
          frame.origin.y = -self.viewSlideDistance; 
      break;
    case UIInterfaceOrientationPortraitUpsideDown:
          frame.origin.y = self.viewSlideDistance; 
      break;
    default:
      break;
  }
  [view setFrame:frame];
	[UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)aNotification {
  UIInterfaceOrientation orientation = ((UIViewController*)self.delegate).interfaceOrientation;
	[UIView beginAnimations:@"viewSlideDown" context:NULL];
  UIView *view = [self.delegate viewForOwner:self];
  CGRect frame = [view frame];
  switch (orientation) {
    case UIInterfaceOrientationLandscapeLeft:
      frame.origin.x += self.viewSlideDistance; 
      break;
    case UIInterfaceOrientationLandscapeRight:
      frame.origin.x -= self.viewSlideDistance; 
      break;
    case UIInterfaceOrientationPortrait:
          frame.origin.y =0;//+= viewSlideDistance; 
      break;
    case UIInterfaceOrientationPortraitUpsideDown:
          frame.origin.y =0;//-= viewSlideDistance; 
      break;
    default:
      break;
  }

  [view setFrame:frame];
	[UIView commitAnimations];
}


#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {

}

// This is called when the user taps outside the textView, or dismisses
// the keyboard.
- (void)textViewDidEndEditing:(UITextView *)aTextView {
    
    if([aTextView.text isEqualToString:@""])
        return;
    CGSize size = [aTextView.text sizeWithFont:aTextView.font constrainedToSize:aTextView.frame.size];
    CGRect rect = aTextView.frame;
    rect.size.height = aTextView.contentSize.height;
    rect.size.width = size.width+20;
    
    
    UITextView *aLabel = [[UITextView alloc] initWithFrame:rect];
    aLabel.backgroundColor = [UIColor whiteColor];
    aLabel.font = [UIFont systemFontOfSize:24.0];
    //aLabel.showsVerticalScrollIndicator = NO;
    [aLabel setContentMode:UIViewContentModeTop];
    aLabel.editable = NO;
    aLabel.scrollEnabled = NO;
    aLabel.userInteractionEnabled = NO;
    aLabel.text = aTextView.text;
    [self.delegate addTextLabel:aLabel];
    self.completedPath = nil;
    UIView *superView = [aTextView superview];
    [[superView viewWithTag:SHADE_TAG] removeFromSuperview];
    [aTextView resignFirstResponder];
    [self.textView removeFromSuperview];
    self.textView = nil;

}

@end
