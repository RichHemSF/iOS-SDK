//
//  ViewController.m
//  MotionDnaSDKCocoaPodsExample
//
//  Created by Peter Wang on 11/1/16.
//  Copyright © 2016 Navisens Inc. All rights reserved.
//
@import OpenGLES;

@import SceneKit;

#import "MotionDnaManager.h"
#import "PrimaryMotionModel.h"
#import "SecondaryMotionModel.h"

#import "ViewController.h"

static CGFloat const InitialCameraScale=32.f;
static CGFloat const MinCameraScale=2.f;

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

@interface ViewController ()<UIGestureRecognizerDelegate,SCNSceneRendererDelegate,SCNProgramDelegate>

@property NSDateFormatter *dateFormatter;
@property MotionDnaManager* motionDnaManager;

@property (weak, nonatomic) IBOutlet UILabel *SDKVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet SCNView *sceneView;
@property SCNScene* scene;
@property SCNNode* cameraNode;
@property SCNNode* axisNode;
@property NSMutableData* vertexData;
@property SCNNode *pointsNode;
@property SCNProgram *pointSCNProgram;
@property SCNNode *currentPointNode;
@property double currentX;
@property double currentY;
@property BOOL lookAtSwitched;
@property BOOL lookAtCurrentPointEnabled;

@end

@implementation ViewController

-(void)dealloc
{   
        [self.motionDnaManager stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dateFormatter=[[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    
    self.scene=[[SCNScene alloc] init];
    self.sceneView.scene=self.scene;
    self.sceneView.autoenablesDefaultLighting=YES;
    self.sceneView.delegate=self;
    
    [self addCameraNode];
    [self addAxisNode];
    [self addPointNode];
    [self addCurrentPointNode];
    
    self.motionDnaManager=[[MotionDnaManager alloc] init];
    self.SDKVersionLabel.text= [[MotionDnaManager checkSDKVersion] stringByReplacingOccurrencesOfString:@"NAVISENS-" withString:@""];
    self.motionDnaManager.controller = self;
    
#error put your developer key in runMotionDna call and comment out this line
    [self.motionDnaManager runMotionDna:@"your developer key"];
    
    [self.motionDnaManager setBinaryFileLoggingEnabled:YES];
    //[self.motionDnaManager setLocationAndHeadingGPSMag];
    //[self.motionDnaManager setLocationNavisens];
    [self.motionDnaManager setLocalHeadingOffsetInDegrees:90];
    
    [self.motionDnaManager setBackgroundModeEnabled:YES];
    [self.motionDnaManager setCallbackUpdateRateInMs:100];
    [self.motionDnaManager setNetworkUpdateRateInMs:100];
    [self.motionDnaManager setExternalPositioningState:HIGH_ACCURACY];
    
}
-(void)addCameraNode
{
    self.cameraNode = [SCNNode node];
    self.cameraNode.camera = [SCNCamera camera];
    self.cameraNode.camera.usesOrthographicProjection=YES;
    self.cameraNode.position = SCNVector3Make(0, 0, 128);
    self.cameraNode.camera.orthographicScale = InitialCameraScale;    
    self.cameraNode.camera.zNear=10;
    self.cameraNode.camera.zFar=256;
    
    [self.scene.rootNode addChildNode:self.cameraNode];
}
-(void)addPointNode
{   self.vertexData=[NSMutableData data];
    
    self.pointSCNProgram = [SCNProgram program];
    self.pointSCNProgram.delegate = self;
    self.pointSCNProgram.vertexShader=[self loadShaderSourceWithFileName:@"Point.vsh"];
    self.pointSCNProgram.fragmentShader =[self loadShaderSourceWithFileName:@"Point.fsh"];
    [self.pointSCNProgram setSemantic:SCNModelViewProjectionTransform forSymbol:@"MVP" options:nil];
    [self.pointSCNProgram setSemantic:SCNGeometrySourceSemanticVertex forSymbol:@"position" options:nil];
    [self.pointSCNProgram setSemantic:SCNGeometrySourceSemanticColor forSymbol:@"color" options:nil];
    
    self.pointsNode=[SCNNode node];
    self.pointsNode.position=SCNVector3Make(0.0f, 0.0f, 0.0f);
    
    SCNBillboardConstraint* billboardConstraint=[SCNBillboardConstraint billboardConstraint];
    self.pointsNode.constraints =@[billboardConstraint];
    [self.scene.rootNode addChildNode:self.pointsNode];
}

-(void)addCurrentPointNode
{
    self.currentPointNode=[SCNNode node];
    self.currentPointNode.position=SCNVector3Make(0.0f, 0.0f, 0.0f);
    SCNBillboardConstraint* billboardConstraint=[SCNBillboardConstraint billboardConstraint];
     self.currentPointNode.constraints =@[billboardConstraint];

    [self.scene.rootNode addChildNode:self.currentPointNode];
}

-(void)addAxisNode
{
    self.axisNode= [SCNNode node];
    
    SCNCylinder *xAxis = [SCNCylinder cylinderWithRadius:0.001*self.cameraNode.camera.orthographicScale height:128];
    xAxis.firstMaterial.diffuse.contents = [UIColor redColor];
    xAxis.firstMaterial.ambient.contents = [UIColor redColor];
    SCNNode *xNode = [SCNNode nodeWithGeometry:xAxis];
    xNode.eulerAngles = SCNVector3Make(0,0,DegreesToRadians(90.0));
    [self.axisNode addChildNode:xNode];
    
    SCNCylinder *yAxis = [SCNCylinder cylinderWithRadius:0.001*self.cameraNode.camera.orthographicScale height:128];
    yAxis.firstMaterial.diffuse.contents = [UIColor greenColor];
    yAxis.firstMaterial.ambient.contents = [UIColor greenColor];
    SCNNode *yNode = [SCNNode nodeWithGeometry:yAxis];
    yNode.eulerAngles = SCNVector3Make(0,0,DegreesToRadians(180.0));
    [self.axisNode addChildNode:yNode];
    
    SCNBillboardConstraint* billboardConstraint=[SCNBillboardConstraint billboardConstraint];
    self.axisNode.constraints =@[billboardConstraint];
    
    [self.scene.rootNode addChildNode:self.axisNode];
}

-(void)updateAxisNode
{
    [self.axisNode removeFromParentNode];
    [self addAxisNode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveMotionDna:(MotionDna*)motionDna
{
    NSString* locatoinStatusString;
    switch ([motionDna getLocation].locationStatus) {
        case UNINITIALIZED:
            locatoinStatusString=@"UNINITIALIZED";
            break;
        case USER_INITIALIZED:
            locatoinStatusString=@"USER_INITIALIZED";
            break;
        case GPS_INITIALIZED:
            locatoinStatusString=@"GPS_INITIALIZED";
            break;
        case NAVISENS_INITIALIZING:
            locatoinStatusString=@"NAVISENS_INITIALIZING";
            break;
        case NAVISENS_INITIALIZED:
            locatoinStatusString=@"NAVISENS_INITIALIZED";
            break;
        case BEACON_INITIALIZED:
            locatoinStatusString=@"BEACON_INITIALIZED";
            break;
            
        default:
            break;
    }
    
        Location location = [motionDna getLocation];
        NSString* dateString = [self.dateFormatter stringFromDate:[NSDate date]];
        MotionStatistics motionStatistics=[motionDna getMotionStatistics];
        NSString* locationString=[NSString stringWithFormat:@"%@\n%@\nx:%f\ny:%f\nlocalHeading:%f\n\ndwelling:%f\nwalking:%f\nstationary:%f",dateString,locatoinStatusString,location.localLocation.x,location.localLocation.y,location.localHeading,
                                  motionStatistics.dwelling,motionStatistics.walking,motionStatistics.stationary];
        
        PrimaryMotion primaryMotion=motionDna.getMotion.primaryMotion;
        NSString* primaryMotionType=[PrimaryMotionModel types][primaryMotion];
        
        SecondaryMotion secondaryMotion=motionDna.getMotion.secondaryMotion;
        NSString* secondaryMotionType;
        if(secondaryMotion){
            secondaryMotionType=[SecondaryMotionModel types][secondaryMotion];
        }
        
        self.locationLabel.text=[NSString stringWithFormat:@"%@\nrecognized:\nS/%@,\nP/%@",locationString,secondaryMotionType,primaryMotionType];
    //
    MotionColor motionColor;
    if(secondaryMotion)
    {
        motionColor=[SecondaryMotionModel colorForIndex:secondaryMotion];
    }else{
        motionColor=[PrimaryMotionModel colorForIndex:primaryMotion];
    }
    
    [self appendPointWithX:location.localLocation.x y:location.localLocation.y z:0 r:motionColor.r g:motionColor.g b:motionColor.b a:.85f];
    
    [self updateCurrentPointWithX:location.localLocation.x y:location.localLocation.y z:0 r:motionColor.r g:motionColor.g b:motionColor.b a:1.0f];
    self.currentX=location.localLocation.x;
    self.currentY=location.localLocation.y;
    
    if(self.lookAtCurrentPointEnabled){
        [self lookAtCurrentPoint];
    }
}

-(void)updateCurrentPointWithX:(double)x y:(double)y z:(double)z
                             r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a
{
    PointVertex currentVertex;
    currentVertex.x=(float)x;
    currentVertex.y=(float)y;
    currentVertex.z=(float)z;
    currentVertex.r=(float)r;
    currentVertex.g=(float)g;
    currentVertex.b=(float)b;
    currentVertex.a=(float)a;
    
    
    NSData* currentPointData=[NSData dataWithBytes:&currentVertex length:sizeof(PointVertex)];
    SCNGeometrySource *currentVertexSource = [SCNGeometrySource geometrySourceWithData:currentPointData
                                                                              semantic:SCNGeometrySourceSemanticVertex
                                                                           vectorCount:1
                                                                       floatComponents:YES
                                                                   componentsPerVector:3
                                                                     bytesPerComponent:sizeof(float)
                                                                            dataOffset:offsetof(PointVertex, x)
                                                                            dataStride:sizeof(PointVertex)];
    
    SCNGeometrySource *currentColorSource = [SCNGeometrySource geometrySourceWithData:currentPointData
                                                                             semantic:SCNGeometrySourceSemanticColor
                                                                          vectorCount:1
                                                                      floatComponents:YES
                                                                  componentsPerVector:4
                                                                    bytesPerComponent:sizeof(float)
                                                                           dataOffset:offsetof(PointVertex, r)
                                                                           dataStride:sizeof(PointVertex)];
    
    SCNGeometryElement *element = [SCNGeometryElement geometryElementWithData:nil
                                                                primitiveType:SCNGeometryPrimitiveTypePoint
                                                               primitiveCount:1
                                                                bytesPerIndex:4];
    
    
    SCNGeometry *currentPointGeometry = [SCNGeometry geometryWithSources:@[currentVertexSource, currentColorSource] elements:@[element]];
    
    currentPointGeometry.shaderModifiers=@{SCNShaderModifierEntryPointGeometry : @"gl_PointSize = 16.0;"};
    
    self.currentPointNode.geometry=currentPointGeometry;
}

-(NSString *)loadShaderSourceWithFileName:(NSString *)fileName
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:[fileName stringByDeletingPathExtension] withExtension:[fileName pathExtension]];
    assert(fileURL);
    NSError *error;
    NSString *sourceString = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    if (!sourceString){
        NSLog(@"===error loading program file %@: %@", fileName, error);
    }
    
    return sourceString;
}

#
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#
- (void)renderer:(id<SCNSceneRenderer>)renderer
 willRenderScene:(SCNScene *)scene
          atTime:(NSTimeInterval)time
{
  
}
- (void)renderer:(id<SCNSceneRenderer>)renderer
    updateAtTime:(NSTimeInterval)time
{
    
}

- (void)program:(SCNProgram *)program handleError:(NSError *)error
{
    NSLog(@"===program error:%@",error.localizedDescription);
}
#
- (void)appendPointWithX:(double)x y:(double)y z:(double)z
                    r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a
{
    static NSInteger dataCount;
    dataCount++;
    
    PointVertex vertex;
    vertex.x=(float)x;
    vertex.y=(float)y;
    vertex.z=(float)z;
    vertex.r=(float)r;
    vertex.g=(float)g;
    vertex.b=(float)b;
    vertex.a=(float)a;
    
    [self.vertexData appendBytes:&vertex length:sizeof(PointVertex)];
    
    SCNGeometrySource *vertexSource = [SCNGeometrySource geometrySourceWithData:self.vertexData
                                                                       semantic:SCNGeometrySourceSemanticVertex
                                                                    vectorCount:dataCount
                                                                floatComponents:YES
                                                            componentsPerVector:3
                                                              bytesPerComponent:sizeof(float)
                                                                     dataOffset:offsetof(PointVertex, x)
                                                                     dataStride:sizeof(PointVertex)];
    
    SCNGeometrySource *colorSource = [SCNGeometrySource geometrySourceWithData:self.vertexData
                                                                      semantic:SCNGeometrySourceSemanticColor
                                                                   vectorCount:dataCount
                                                               floatComponents:YES
                                                           componentsPerVector:4
                                                             bytesPerComponent:sizeof(float)
                                                                    dataOffset:offsetof(PointVertex, r)
                                                                    dataStride:sizeof(PointVertex)];
    
    SCNGeometryElement *element = [SCNGeometryElement geometryElementWithData:nil
                                                                primitiveType:SCNGeometryPrimitiveTypePoint
                                                               primitiveCount:dataCount
                                                                bytesPerIndex:4];
    
    
    SCNGeometry *pointGeometry = [SCNGeometry geometryWithSources:@[vertexSource, colorSource] elements:@[element]];
    pointGeometry.program=self.pointSCNProgram;
    self.pointsNode.geometry=pointGeometry;
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)panRecognizer {
    self.lookAtCurrentPointEnabled=NO;
    
    CGPoint panRecognizerTranslation=[panRecognizer translationInView:self.view];
    SCNVector3 cameraNodePositionVec3=SCNVector3Make(self.cameraNode.position.x-panRecognizerTranslation.x*self.cameraNode.camera.orthographicScale*2/self.sceneView.frame.size.width, self.cameraNode.position.y+panRecognizerTranslation.y*self.cameraNode.camera.orthographicScale*2/self.sceneView.frame.size.width, self.cameraNode.position.z);
    
    self.cameraNode.position=cameraNodePositionVec3;
    [panRecognizer setTranslation:CGPointZero inView:self.sceneView];
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)pinchRecognizer {

    self.lookAtCurrentPointEnabled=NO;

    static CGFloat cameraScaleBeforePinch;
    static CGPoint pinchLocation;
    static SCNVector3 unprojPinchLocation;
    
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        cameraScaleBeforePinch=self.cameraNode.camera.orthographicScale;
        pinchLocation = [pinchRecognizer locationInView:self.sceneView];
        unprojPinchLocation=[self.sceneView unprojectPoint:SCNVector3Make(pinchLocation.x, pinchLocation.y, 0)];
    }

    if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat scaleRequest=cameraScaleBeforePinch/pinchRecognizer.scale;
        self.cameraNode.camera.orthographicScale=scaleRequest<MinCameraScale?MinCameraScale:scaleRequest;
        UIOffset pinchLocationOffset=UIOffsetMake(pinchLocation.x-self.sceneView.frame.size.width/2,
        pinchLocation.y-self.sceneView.frame.size.height/2);
        
        SCNVector3 cameraNodePositionVec3=SCNVector3Make(unprojPinchLocation.x-pinchLocationOffset.horizontal*self.cameraNode.camera.orthographicScale*2/self.sceneView.frame.size.width, unprojPinchLocation.y+pinchLocationOffset.vertical*self.cameraNode.camera.orthographicScale*2/self.sceneView.frame.size.width, self.cameraNode.position.z);
        self.cameraNode.position=cameraNodePositionVec3;
    }
    
    if ((pinchRecognizer.state == UIGestureRecognizerStateCancelled) || (pinchRecognizer.state == UIGestureRecognizerStateEnded)) {
        [self updateAxisNode];
    }
}

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)doubleTapRecognizer {
    
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];
    [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    if(self.lookAtSwitched){
        self.lookAtCurrentPointEnabled=NO;
        
        self.cameraNode.position = SCNVector3Make(0, 0, self.cameraNode.position.z);
        self.cameraNode.camera.orthographicScale =InitialCameraScale;
        [self updateAxisNode];
    }else{
        self.lookAtCurrentPointEnabled=YES;
        [self lookAtCurrentPoint];
    }
    [SCNTransaction commit];
    
    self.lookAtSwitched=!self.lookAtSwitched;
}

-(void)lookAtCurrentPoint
{
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.25];
    [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
   
    self.cameraNode.position = SCNVector3Make(self.currentX, self.currentY, self.cameraNode.position.z);
    self.cameraNode.camera.orthographicScale =5;
    
    [self updateAxisNode];
    [SCNTransaction commit];
   
}
@end
