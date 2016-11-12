//
//  MotionDnaManager.h
//  test001
//
//  Created by Lucas mc kenna on 9/21/15.
//  Copyright © 2015 LucasMCKENNA. All rights reserved.
//


#import <MotionDnaSDK/MotionDnaSDK.h>
#import <MotionDnaSDK/MotionDna.h>
#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@class ViewController;

@interface MotionDnaManager : MotionDnaSDK

@property ViewController* controller;

-(void)receiveMotionDna:(MotionDna*)motionDna;
@end
