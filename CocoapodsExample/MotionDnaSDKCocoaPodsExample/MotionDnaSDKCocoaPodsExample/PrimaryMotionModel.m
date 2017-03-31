//
//  PrimaryMotionModel.m
//  Training
//
//  Created by Peter Wang on 9/19/16.
//  Copyright © 2016 Navisens Inc. All rights reserved.
//
#import "SecondaryMotionModel.h"
#import "PrimaryMotionModel.h"

static NSArray<NSString*>* motionTypes;
static MotionColor* motionColors;
static __strong UIImage** motionImages;

@implementation PrimaryMotionModel

static NSArray<NSString*>* motionTypes;

+ (void)initialize {
    motionTypes = @[
                    @"STATIONARY",
                    @"FIDGETING",
                    @"FORWARD"
                    ];
    
    motionColors=calloc(motionTypes.count, sizeof(MotionColor));
    //STATIONARY
    motionColors[0]=(MotionColor){.r=1.0,.g=.0,.b=.0};
    //FIDGETING
    motionColors[1]=(MotionColor){.r=.0,.g=.0,.b=1.0};
    
    //FORWARD
    motionColors[2]=(MotionColor){.r=1.0,.g=1.0,.b=.0};
    
    motionImages=(__strong UIImage**)(calloc(motionTypes.count, sizeof(UIImage*)));
    for(int i=0;i<motionTypes.count;i++){
        UIColor* fillColor=[UIColor colorWithRed:motionColors[i].r green:motionColors[i].g blue:motionColors[i].b alpha:FillColorAlpha];
        UIColor* strokeColor = [UIColor colorWithRed:motionColors[i].r green:motionColors[i].g blue:motionColors[i].b alpha:StrokeColorAlpha];
        motionImages[i]=[PrimaryMotionModel circleWithSize:MotionImageSize lineWidth:LineWidth lineColor:strokeColor fillColor:fillColor];
    }
}

+(NSArray<NSString*>*)types
{
    return motionTypes;
}

+(MotionColor)colorForType:(NSString*)type
{
    return [PrimaryMotionModel colorForIndex:[motionTypes indexOfObject:type]];
}

+(MotionColor)colorForIndex:(NSInteger)index
{
    return motionColors[index];
}

+(NSArray<NSString*>*)subTypesForIndex:(NSInteger)index
{
    static NSArray<NSArray<NSString*>*>* subMotionTypes;

    static dispatch_once_t onceToken_subTypes;
    dispatch_once(&onceToken_subTypes, ^{
        subMotionTypes = @[
                            [NSArray array],
                            [[SecondaryMotionModel types] subarrayWithRange:NSMakeRange(5, 2)],
                            [[SecondaryMotionModel types] subarrayWithRange:NSMakeRange(1, 4)]
                        ];
    });
    return subMotionTypes[index];
}

+(UIImage*)imageForType:(NSString*)type
{
    return motionImages[[motionTypes indexOfObject:type]];
}

+(UIImage *)circleWithSize:(CGSize)imageSize
                 lineWidth:(float)lineWidth
                 lineColor:(UIColor*)lineColor
                 fillColor:(UIColor*)fillColor
{
    
    UIGraphicsBeginImageContext(CGSizeMake(imageSize.width,imageSize.height));
      
    [[UIColor clearColor] setFill];
    
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(lineWidth/2,lineWidth/2,imageSize.width-lineWidth,imageSize.height-lineWidth)];
    
    [fillColor setFill];
    [path fill];
    
    [lineColor setStroke];
    path.lineWidth=lineWidth;
    [path stroke];
    
    UIImage *circle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return circle;
}
@end
