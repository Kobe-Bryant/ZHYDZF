//
//  DudelView.h
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DudelViewDelegate

- (void)drawTemporary;

@end

@interface DudelView : UIView

@property (nonatomic, strong) NSMutableArray *drawables;
@property (nonatomic, assign) BOOL bDrawBgImage;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, assign) id<DudelViewDelegate> delegate;

- (void)saveImageToFile:(NSString*)fileName ;
- (void)drawImage;

@end
