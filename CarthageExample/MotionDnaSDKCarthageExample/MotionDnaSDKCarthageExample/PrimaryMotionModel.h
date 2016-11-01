//
//  PrimaryMotionModel.h
//  Training
//
//  Created by Peter Wang on 9/19/16.
//  Copyright © 2016 Navisens Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrimaryMotionModel : NSObject
+(NSArray<NSString*>*)types;
+(NSArray<NSString*>*)subTypesForIndex:(NSInteger)index;
@end
