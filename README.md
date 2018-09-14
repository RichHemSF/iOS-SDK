

<img align="left"  src="https://miro.medium.com/fit/c/240/240/1*w3dfg7v3CuRXchzrjwqOOw.png">
<img align="right" src="https://camo.githubusercontent.com/b39d4ce762b8b1de914b2c8e338f9ad95ad1cf20/68747470733a2f2f7777772e6e61766973656e732e636f6d2f696d672f686f772d646f65732d69742d776f726b2d6d6f62696c652e676966">
![](https://www.navisens.com/img/how-does-it-work-mobile.gif)

The Navisens™ motionDNA™ SDK is a software-only location platform that operates indoors and outdoors without relying on infrastructure such as WiFi Access Points (APs), Bluetooth beacons, or GPS. Our SDK can be embedded into mobile apps to unlock hyper accurate location. Our simple to use SDK allows developers to build location applications to interact with the user, guiding them indoors and outdoors, detecting proximity to items, and triggering actions and notifications based on the user's location and motion. For any technical questions please contact us at: support@navisens.com.

### Quick Start with CocoaPods

```
cd CocoapodsExample/MotionDnaSDKCocoaPodsExample
pod install
open CocoapodsExample/MotionDnaSDKCocoaPodsExample.xcworkspace
```

### Documentation

http://docs.navisens.com

### Framework download

https://github.com/navisens/iOS-SDK/releases

### Usage
1.Have your class inherit from our MotionDnaSDK class: 
```objectivec
@interface MotionDnaObject : MotionDnaSDK
```
2.Implement the following methods: 
```objectivec
-(void)receiveMotionDna:(MotionDna*)motionDna; // You will receive the data from this method.
// Method reports and error from the SDK signaling some type of issue.
// Errors:
// SENSOR_TIMING -> if timing between samples becomes inconsistent
// AUTHENTICATION_FAILED -> if authenticating to server failed
// SENSOR_MISSING -> if a crucial sensor is missing
// SDK_EXPIRED -> if the SDK expired
-(void)reportError:(ErrorCode)error WithMessage(NSString*)message;
// Location data from other devices in the room.
-(void)receiveNetworkData:(MotionDna *)motionDna;
// Receive custom messages from server and other devices.
-(void)receiveNetworkData:(NetworkCode)opcode WithPayload:(NSDictionary *)payload;
```
3.Initialize the SDK: 
```objectivec
MotionDnaObject * motionDnaObject_ = [[MotionDnaObject alloc] init];
```
4.Run the SDK: 
```objectivec
-(void)runMotionDna:(NSString*)ID;
```
5.Choose an initilization system: 
```objectivec
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
###2/External location source<br/>
###2.1/ Using setLocationNavisens
```

When using setLocationNavisens, initialize our SDK with setExternalPositioningState:HIGH_ACCURACY (which is set by default),
after walking a bit you should receive NAVISENS_INITIALIZED as the [motionDna getLocation].locationStatus.

Once this has been received it means our SDK no longer requires external positioning sources, therefore
it is now safe call setExternalPositioningState with LOW_ACCURACY which will reduce the frequency at which
the GPS data is being polled to kilometer accuracy and still have our SDK work in background.

Note: setting the external positioning state to OFF will prevent our SDK from running in the background.

```
### 2.2/ Using other input sources
```
If you wish to initialize without our auto initialization you can call setExternalPositioningState:LOW_ACCURACY
at startup and call our other initialization methods.

```
### 2.3/ Swift

```swift
MotionDnaManager Class:

import Foundation
import MotionDnaSDK

class MotionDnaManager: MotionDnaSDK {

    func start() {
        runMotionDna("your-dev-key", receiver: self)
    }

    override func receive(_ motionDna: MotionDna!) {
        NSLog("%.8f %.8f %.8f %.8f\n", motionDna.getLocation().heading, motionDna.getLocation().localLocation.x, motionDna.getLocation().localLocation.y, motionDna.getLocation().localLocation.z)
    }

    override func failure(toAuthenticate msg: String!) {
    }

    override func reportSensorTiming(_ dt: Double, msg: String!) {
    }
}

ViewController Class:
class ViewController: UIViewController {

      var manager : MotionDnaManager!

      override func viewDidLoad() {
      	  super.viewDidLoad()
	  manager = MotionDnaManager()
	  manager.start()
      }

      override func didReceiveMemoryWarning() {
      	  super.didReceiveMemoryWarning()
      }
}

```
