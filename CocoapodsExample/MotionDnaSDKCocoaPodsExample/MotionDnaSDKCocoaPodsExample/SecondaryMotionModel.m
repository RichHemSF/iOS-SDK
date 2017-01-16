//
//  MotionModel.m
//  Training
//
//  Created by Peter Wang on 9/7/16.
//  Copyright © 2016 Navisens Inc. All rights reserved.
//

#import "SecondaryMotionModel.h"

@implementation SecondaryMotionModel

+(NSArray<NSString*>*)types
{
    static NSArray<NSString*>* motionTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
    });
    return motionTypes;
}
@end
