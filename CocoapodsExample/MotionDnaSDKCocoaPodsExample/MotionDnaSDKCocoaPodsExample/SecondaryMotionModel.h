//
//  MotionModel.h
//  Training
//
//  Created by Peter Wang on 9/7/16.
//  Copyright © 2016 Navisens Inc. All rights reserved.
//
#import "NVSSDataTypes.h"

#import <Foundation/Foundation.h>

@interface SecondaryMotionModel : NSObject

+(NSArray<NSString*>*)types;

+(MotionColor)colorForIndex:(NSInteger)index;
+(MotionColor)colorForType:(NSString*)type;
+(UIImage*)imageForType:(NSString*)type;
@end
