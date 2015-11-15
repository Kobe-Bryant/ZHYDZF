//
//  NSString+MD5Addition.h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableViewCell(Custom)

+(UITableViewCell*)makeSubCell:(UITableView *)tableView
					 withTitle:(NSString *)aTitle
						 value:(NSString *)aValue
                     andHeight:(CGFloat)theHeight;

+(UITableViewCell*)makeTextViewSubCell:(UITableView *)tableView
                             withTitle:(NSString *)aTitle
                                 value:(NSString *)aValue
                             andHeight:(CGFloat)theHeight;

+(UITableViewCell*)makeSubCell:(UITableView *)tableView withTitle:(NSString *)title
                     SubValue1:(NSString *)value1 SubValue2:(NSString*) value2 SubValue3:(NSString*)value3 andHeight:(CGFloat)height;

//一周的cell
+(UITableViewCell*)makeWeekCell:(UITableView *)tableView
                      withTexts:(NSArray *)titleAry
                       andImage:(UIImage*)image
                  andPTRYHeight:(CGFloat)nHeight;

+ (UITableViewCell*)makeSubCell:(UITableView *)tableView
                     withValue1:(NSString *)aTitle
                         value2:(NSString *)aTitle2
                         value3:(NSString *)aValue
                         value4:(NSString *)aValue2
                         height:(NSInteger)aHeight;


+ (UITableViewCell *)makeSubCell:(UITableView *)tableView
                       withTitle:(NSString *)aTitle
                    andSubvalue1:(NSString *)aCode
                    andSubvalue2:(NSString *)aCDate
                    andSubvalue3:(NSString *)aEDate
                    andSubvalue4:(NSString *)aMode;

+(UITableViewCell*)makeMultiLabelsCell:(UITableView *)tableView
                             withTexts:(NSArray *)valueAry
                     andTableviewWidth:(CGFloat)tablewidth
                             andHeight:(CGFloat)height
                         andIdentifier:(NSString *)identifier;

+(UITableViewCell*)makeSubCell:(UITableView *)tableView
                     withTitle:(NSString *)title
                     SubValue1:(NSString *)value1
                     SubValue2:(NSString *)value2
                     SubValue3:(NSString *)value3;

+ (UITableViewCell *)makeSubCell:(UITableView *)tableView
                       withTitle:(NSString *)aTitle
                    andSubvalue1:(NSString *)aCode
                    andSubvalue2:(NSString *)aCDate
                    andSubvalue3:(NSString *)aEDate
                    andSubvalue4:(NSString *)aMode
                    andNoteCount:(NSInteger)num;

+ (UITableViewCell *)makeNewSubCell:(UITableView *)tableView
                          withTitle:(NSString *)aTitle
                     andBottomValue:(NSString *)aCode
                   andRightTopValue:(NSString *)aCDate
                andRightMiddleValue:(NSString *)aEDate
                andRightBottomValue:(NSString *)aMode;

+ (UITableViewCell *)makeSubCell:(UITableView *)tableView
                           Hight:(NSInteger)aHight
                           Title:(NSString *)aTitle
                           Array:(NSArray *)aArray;

+(UITableViewCell*)makeSubCell:(UITableView *)tableView
                     withTitle:(NSString *)title
                     LblValue1:(NSString *)value1
                     LblValue2:(NSString*) value2
                     LblValue3:(NSString*)value3
                     andHeight:(CGFloat)height;

@end
