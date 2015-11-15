//
//  TextDrawingInfo.h


#import <Foundation/Foundation.h>
#import "Drawable.h"

@interface TextDrawingInfo : NSObject <Drawable>

@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) UIColor *strokeColor;
@property (strong, nonatomic) UIFont *font;
@property (copy, nonatomic) NSString *text;

- (id)initWithPath:(UIBezierPath*)p text:(NSString*)t strokeColor:(UIColor*)s font:(UIFont*)f;
+ (id)textDrawingInfoWithPath:(UIBezierPath *)p text:t strokeColor:(UIColor *)s font:(UIFont *)f;

@end
