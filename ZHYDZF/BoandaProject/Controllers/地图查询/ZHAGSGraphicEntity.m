//
//  ZHAGSGraphicEntity.m
//  BoandaProject
//
//  Created by 李凌辉 on 14-7-17.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "ZHAGSGraphicEntity.h"

@implementation ZHAGSGraphicEntity
@synthesize title,subtitle,coustromImg;


-(NSString *)titleForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)mapPoint
{
    return title;
}

-(NSString *)detailForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)mapPoint
{
    return subtitle;
}
-(AGSImage*)imageForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)mapPoint{

    return coustromImg;
}

 
@end
