
### Quick Start with CocoaPods

```
cd CocoapodsExample/MotionDnaSDKCocoaPodsExample
pod install
open CocoapodsExample/MotionDnaSDKCocoaPodsExample.xcworkspace
```

### Quick Start with Carthage

```
cd CarthageExample/MotionDnaSDKCarthageExample
carthage update --platform iOS
```
### Documentation

http://docs.navisens.com

### Framework download

https://github.com/navisens/iOS-SDK/releases

### Usage
1.Have your class inherit from our MotionDnaSDK class: 
```
@interface MotionDnaObject : MotionDnaSDK
```
2.Implement the following methods: 
```
-(void)receiveMotionDna:(MotionDna*)motionDna; // You will receive the data from this method.
-(void)failureToAuthenticate:(NSString*)msg; // If ever the SDK fails to authenticate the callback will be triggered with the appropriate error message.
```
3.Initialize the SDK: 
```
MotionDnaObject * motionDnaObject_ = [[MotionDnaObject alloc] init];
```
4.Run the SDK: 
```
-(void)runMotionDna:(NSString*)ID;
```
5.Choose an initilization system: 
```
-(void)setLocationNavisens; //This lets us figure out the location from our prioprietary sensor fusion algorithms (may require walking 1-2 blocks) (recommended).
-(void)setLocationLatitude:(double)latitude Longitude:(double)longitude AndHeadingInDegrees:(double)heading; // This allows you to enter a location and heading manually.
-(void)setLocationAndHeadingGPSMag; // This will initialize by setting the position to the latest GPS position and magnetic heading
```