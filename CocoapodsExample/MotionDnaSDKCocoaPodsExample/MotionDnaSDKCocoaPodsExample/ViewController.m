//
//  ViewController.m
//  MotionDnaSDKCocoaPodsExample
//
//  Created by Peter Wang on 11/1/16.
//  Copyright © 2016 Navisens Inc. All rights reserved.
//
#import "MotionDnaManager.h"
#import "PrimaryMotionModel.h"
#import "SecondaryMotionModel.h"

#import "ViewController.h"

@interface ViewController ()

@property NSDateFormatter *dateFormatter;
@property MotionDnaManager* motionDnaManager;
    
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *SDKVersionLabel;

@end

@implementation ViewController

-(void)dealloc
{   
        [self.motionDnaManager stop];
}
#error put your developer key in runMotionDna call
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dateFormatter=[[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    
    self.motionDnaManager=[[MotionDnaManager alloc] init];
    self.SDKVersionLabel.text= [[MotionDnaManager checkSDKVersion] stringByReplacingOccurrencesOfString:@"NAVISENS-" withString:@""];
    self.motionDnaManager.controller = self;
    [self.motionDnaManager runMotionDna:@"yourdeveloperkey"];
    [self.motionDnaManager setBinaryFileLoggingEnabled:YES];
    [self.motionDnaManager setLocationAndHeadingGPSMag];
    [self.motionDnaManager setBackgroundModeEnabled:YES];
    [self.motionDnaManager setCallbackUpdateRateInMs:100];
    [self.motionDnaManager setNetworkUpdateRateInMs:100];
    [self.motionDnaManager setExternalPositioningState:HIGH_ACCURACY];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveMotionDna:(MotionDna*)motionDna
{
        NSLog(@"receiveMotionDna got called");
        Location location = [motionDna getLocation];
        NSString* dateString = [self.dateFormatter stringFromDate:[NSDate date]];
        MotionStatistics motionStatistics=[motionDna getMotionStatistics];
        NSString* locationString=[NSString stringWithFormat:@"%@\nx:%f\ny:%f\nz:%f\n\ndwelling:%f\nwalking:%f\nstationary:%f",dateString,location.localLocation.x,location.localLocation.y,location.localLocation.z,motionStatistics.dwelling,motionStatistics.walking,motionStatistics.stationary];
        
        PrimaryMotion primaryMotion=motionDna.getMotion.primaryMotion;
        NSString* primaryMotionType=[PrimaryMotionModel types][primaryMotion];
        
        SecondaryMotion secondaryMotion=motionDna.getMotion.secondaryMotion;
        NSString* secondaryMotionType;
        if(secondaryMotion){
            secondaryMotionType=[SecondaryMotionModel types][secondaryMotion];
        }
        
        self.label.text=[NSString stringWithFormat:@"%@recognized:S/%@,\nP/%@",locationString,secondaryMotionType,primaryMotionType];
}

@end
