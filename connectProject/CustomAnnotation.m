//
//  randomAnnotation.m
//  connectProject
//
//  Created by Vanny Nguyen on 7/13/15.
//  Copyright (c) 2015 Vanny Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAnnotation.h"
@implementation CustomAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-initWithPosition:(CLLocationCoordinate2D)coords{
    if(self=[super init]){
        self.coordinate = coords;
    }
    return self;
}

@end