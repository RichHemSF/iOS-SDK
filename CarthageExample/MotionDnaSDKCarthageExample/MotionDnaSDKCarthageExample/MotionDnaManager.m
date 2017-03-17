//
//  MotionDnaManager.m
//  test001
//
//  Created by Lucas mc kenna on 9/21/15.
//  Copyright © 2015 LucasMCKENNA. All rights reserved.
//

#import <MotionDnaSDK/MotionDna.h>
#import "ViewController.h"
#import "MotionDnaManager.h"


@implementation MotionDnaManager

@synthesize controller;

-(void)receiveMotionDna:(MotionDna* )motionDna
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @try {
            if ([[motionDna getID] containsString:[self getDeviceID]])
                [controller receiveMotionDna:motionDna];
        }@catch (NSException *exception) {
                NSLog(@"failed to call getID on motionDna: %@",exception);
        }@finally {
        
        }
        
        
    });
}
-(void)failureToAuthenticate:(NSString*)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Navisens"
                                                         message:[NSString stringWithFormat:@"auth error:%@",msg]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];

    });
}

-(void)reportSensorTiming:(double)dt Msg:(NSString*)msg
{
    
}

@end
