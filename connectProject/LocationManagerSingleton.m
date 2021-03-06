
//
//  LocationManagerSingleton.m
//  connectProject
//
//  Created by Vanny Nguyen on 7/23/15.
//  Copyright (c) 2015 Vanny Nguyen. All rights reserved.
//

#import "LocationManagerSingleton.h"

@implementation LocationManagerSingleton{

}

@synthesize locationManager;

+ (LocationManagerSingleton*)sharedSingleton {
    static LocationManagerSingleton* sharedSingleton;
    if(!sharedSingleton) {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            sharedSingleton = [[self alloc] init];
        });
    }
    
    return sharedSingleton;
}

- (id)init {
    self = [super init];
    
    if(self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        //request permission for iOS8+ users
        #ifdef __IPHONE_8_0
            if(IS_OS_8_OR_LATER) {
                [self.locationManager requestWhenInUseAuthorization];
            }
        #endif
        
        
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setHeadingFilter:kCLHeadingFilterNone];
        [self.locationManager startUpdatingLocation];
        
    }
    
    return self;
}

/*
 * Notify MasterViewController to generate venues each time locations updated
*/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        CLLocation *newLocation = [locations lastObject];
        
        //check time since last location was recorded
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        
        if (fabs(locationAge) < .5) {
            return;
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"permissionUpdated" object:nil];
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {

}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    //load table in MasterViewController according to location permissions 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"permissionUpdated" object:nil];
    
    
}


@end