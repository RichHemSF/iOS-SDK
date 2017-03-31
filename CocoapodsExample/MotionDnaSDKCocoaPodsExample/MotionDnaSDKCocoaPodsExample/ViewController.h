//
//  ViewController.h
//  MotionDnaSDKCocoaPodsExample
//
//  Created by Peter Wang on 11/1/16.
//  Copyright © 2016 Navisens Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

@class MotionDna;

@interface ViewController : UIViewController

-(void)receiveMotionDna:(MotionDna*)motionDna;
@end

