//
//  DetailViewController.h
//  connectProject
//
//  Created by Vanny Nguyen on 7/13/15.
//  Copyright (c) 2015 Vanny Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DetailViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

