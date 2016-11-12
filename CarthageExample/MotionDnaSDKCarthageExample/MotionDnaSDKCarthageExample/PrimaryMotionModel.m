//
//  PrimaryMotionModel.m
//  Training
//
//  Created by Peter Wang on 9/19/16.
//  Copyright © 2016 Navisens Inc. All rights reserved.
//
#import "SecondaryMotionModel.h"
#import "PrimaryMotionModel.h"

@implementation PrimaryMotionModel

static NSArray<NSString*>* motionTypes;

+ (void)initialize {
    motionTypes = @[
                    @"STATIONARY",
                    @"FIDGETING",
                    @"FORWARD"
    ];

}

+(NSArray<NSString*>*)types
{
    return motionTypes;
}

+(NSArray<NSString*>*)subTypesForIndex:(NSInteger)index
{
    static NSArray<NSArray<NSString*>*>* subMotionTypes;

    static dispatch_once_t onceToken_subTypes;
    dispatch_once(&onceToken_subTypes, ^{
        subMotionTypes = @[
                           [NSArray array],
                           @[[SecondaryMotionModel types][1],
                             [SecondaryMotionModel types][2],
                             [SecondaryMotionModel types][3],
                             [SecondaryMotionModel types][4],
                             [SecondaryMotionModel types][5],
                             [SecondaryMotionModel types][6]
                            ],
                           @[[SecondaryMotionModel types][7],
                             [SecondaryMotionModel types][8]
                             ]
                           ];
    });
    return subMotionTypes[index];
}
@end
