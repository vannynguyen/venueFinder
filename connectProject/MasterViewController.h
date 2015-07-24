//
//  MasterViewController.h
//  connectProject
//
//  Created by Vanny Nguyen on 7/13/15.
//  Copyright (c) 2015 Vanny Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MasterViewController : UITableViewController
-(float)randomCoord:(int) range;
-(void)getVenues:(CLLocation*) userLoc;
@end

