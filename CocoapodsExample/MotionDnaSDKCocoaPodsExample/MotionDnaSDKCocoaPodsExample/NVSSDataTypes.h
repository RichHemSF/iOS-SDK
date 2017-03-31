//
//  NVSSDataTypes.h
//  MotionDnaSDKCocoaPodsExample
//
//  Created by Peter Wang on 3/20/17.
//  Copyright © 2016 Navisens Inc. All rights reserved.
//

#ifndef NVSSDataTypes_h
#define NVSSDataTypes_h

#import <UIKit/UIKit.h>

typedef struct PointVertex
{
    float x, y, z;
    float r, g, b, a;
} PointVertex;

struct MotionColor
{
    CGFloat r;
    CGFloat g;
    CGFloat b;
};
typedef struct MotionColor MotionColor;


#endif /* NVSSDataTypes_h */
