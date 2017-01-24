
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
-(void)setLocationLatitude:(double)latitude Longitude:(double)longitude AndHeadingInDegrees:(double)heading; // This allows you to enter a start location and heading.
-(void)setLocationAndHeadingGPSMag; // This will initialize by setting the position to the latest GPS position and magnetic heading.
```

##How to’s:
###Improve battery consumption:

###1/ Computation frequency

```
When initializing after having called runMotionDna, you can call setPowerMode:LOW_POWER,
this will reduce our estimation frequency therefore the amount of computations done every second.

```
###2/External location source
```

```
###2.1/ Using setLocationNavisens
```

When using setLocationNavisens, initialize our SDK with setExternalPositioningState:HIGH_ACCURACY (which is set by default),
after walking a bit you should receive NAVISENS_INITIALIZED as the [motionDna getLocation].locationStatus.

Once this has been received it means our SDK no longer requires external positioning sources, therefore
it is now safe call setExternalPositioningState with LOW_ACCURACY which will reduce the frequency at which
the GPS data is being polled to kilometer accuracy and still have our SDK work in background.

Note: setting the external positioning state to OFF will prevent our SDK from running in the background.

```
###2.2/ Using other input sources
```
If you which to initialize without our auto initialization you can safely call setExternalPositioningState:LOW_ACCURACY
at startup.