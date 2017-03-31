//
//  PrimaryMotionModel.h
//  Training
//
//  Created by Peter Wang on 9/19/16.
//  Copyright © 2016 Navisens Inc. All rights reserved.
//
#import "NVSSDataTypes.h"

#import <Foundation/Foundation.h>

static CGSize MotionImageSize={.width=18.f,.height=18.f};
static CGFloat LineWidth=5.0f;
static CGFloat FillColorAlpha=.95f;
static CGFloat StrokeColorAlpha=.05f;

@interface PrimaryMotionModel : NSObject
+(NSArray<NSString*>*)types;
+(NSArray<NSString*>*)subTypesForIndex:(NSInteger)index;

+(MotionColor)colorForIndex:(NSInteger)index;
+(MotionColor)colorForType:(NSString*)type;
+(UIImage*)imageForType:(NSString*)type;
+(UIImage *)circleWithSize:(CGSize)imageSize
                 lineWidth:(float)lineWidth
                 lineColor:(UIColor*)lineColor
                 fillColor:(UIColor*)fillColor;
@end
