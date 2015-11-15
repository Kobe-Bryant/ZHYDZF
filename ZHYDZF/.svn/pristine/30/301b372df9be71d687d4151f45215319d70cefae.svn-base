//
//  DudelView.m
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "DudelView.h"
#import "BackgroundDrawingInfo.h"
#import "Drawable.h"

@implementation DudelView
@synthesize bgImage;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
      self.drawables = [[NSMutableArray alloc] initWithCapacity:100];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder]))
  {
      self.drawables = [[NSMutableArray alloc] initWithCapacity:100];   
  }
  return self;
}

-(void)drawRect:(CGRect)rect
{
    if (self.bDrawBgImage)
    {
         
        BackgroundDrawingInfo *info = [[BackgroundDrawingInfo alloc] initWithImage:self.bgImage];
        [self.drawables addObject:info];
  
        self.bDrawBgImage = NO;
    }

    for (id<Drawable> d in self.drawables)
    {
        [d draw];
    }
    [self.delegate drawTemporary];
}

-(void)drawImage
{
    for (id<Drawable> d in self.drawables)
    {
        [d draw];
    }
    [self.delegate drawTemporary];
}

- (void)saveImageToFile:(NSString*)fileName 
{

}

@end
