//
//  MotionModel.m
//  Training
//
//  Created by Peter Wang on 9/7/16.
//  Copyright © 2016 Navisens Inc. All rights reserved.
//
#import "PrimaryMotionModel.h"
#import "SecondaryMotionModel.h"

static NSArray<NSString*>* motionTypes;
static MotionColor* motionColors;
static __strong UIImage** motionImages;

@implementation SecondaryMotionModel


+ (void)initialize {
    motionTypes = @[
                    @"UNDEFINED",
                    @"FORWARD_IN_HAND",
                    @"FORWARD_IN_HAND_SWINGING",
                    @"FORWARD_IN_POCKET",
                    @"FORWARD_IN_CALL",
                    //@"FORWARD_IN_BAG",
                    //@"FORWARD_ON_ARM_BAND",
                    @"DWELLING",
                    @"JUMPING"
                    ];
    
    motionColors=calloc(motionTypes.count, sizeof(MotionColor));
    
    motionColors[0]=(MotionColor){.r=1.0,.g=.7,.b=.2};
    
    //FORWARD_IN_HAND
    motionColors[1]=(MotionColor){.r=.0,.g=1.0,.b=.0};
    //FORWARD_IN_HAND_SWINGING
    //---motionColors[2]=(MotionColor){.r=.1,.g=.1,.b=1.0};
    motionColors[2]=(MotionColor){.r=1.0,.g=1.0,.b=1.0};
    //FORWARD_IN_POCKET
    motionColors[3]=(MotionColor){.r=.0,.g=.5,.b=1.0};
    //FORWARD_IN_CALL
    motionColors[4]=(MotionColor){.r=1.0,.g=.0,.b=1.0};
    
    //FORWARD_IN_BAG
    //motionColors[5]=(MotionColor){.r=1.0,.g=.5,.b=.0};
    //FORWARD_ON_ARM_BAND,DWELLING,JUMPING
    //motionColors[6]=(MotionColor){.r=.0,.g=.0,.b=1.0};
    motionColors[5]=(MotionColor){.r=.0,.g=.0,.b=1.0};
    motionColors[6]=(MotionColor){.r=.0,.g=.0,.b=1.0};
    
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
    return [SecondaryMotionModel colorForIndex:[motionTypes indexOfObject:type]];
}

+(MotionColor)colorForIndex:(NSInteger)index
{
    return motionColors[index];
}
+(UIImage*)imageForType:(NSString*)type
{
    return motionImages[[motionTypes indexOfObject:type]];
}
@end
