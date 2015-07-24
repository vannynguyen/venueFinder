//
//  Venue.m
//  connectProject
//
//  Created by Vanny Nguyen on 7/24/15.
//  Copyright (c) 2015 Vanny Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Venue.h"
@implementation Venue

@synthesize name;
@synthesize latitude;
@synthesize longitude;
@synthesize distance;
-initWithName:(NSString*)venueName{
    if(self=[super init]){
        self.name = venueName;
    }
    return self;
}

@end