//
//  Venue.h
//  connectProject
//
//  Created by Vanny Nguyen on 7/24/15.
//  Copyright (c) 2015 Vanny Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject{
    float latitude;
    float longitude;
    float distance;
}

@property (nonatomic, copy) NSString *name;
@property (readwrite) float latitude;
@property (readwrite) float longitude;
@property (readwrite) float distance;

-initWithName:(NSString*)venueName;


@end