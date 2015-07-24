//
//  LocationManagerSingleton.h
//  connectProject
//
//  Created by Vanny Nguyen on 7/23/15.
//  Copyright (c) 2015 Vanny Nguyen. All rights reserved.
//

#import <MapKit/MapKit.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface LocationManagerSingleton : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

+ (LocationManagerSingleton*)sharedSingleton;
@end
