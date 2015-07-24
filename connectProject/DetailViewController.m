//
//  DetailViewController.m
//  connectProject
//
//  Created by Vanny Nguyen on 7/13/15.
//  Copyright (c) 2015 Vanny Nguyen. All rights reserved.
//

#import "DetailViewController.h"
#import "CustomAnnotation.h"
#import "LocationManagerSingleton.h"
#import "Venue.h"
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize mapView;

#pragma mark - Managing the detail item
-(void)setMap{
    mapView.delegate = self;
    mapView.frame = self.view.bounds;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.showsUserLocation = YES;
    
    //assign region to map; center on user's current location
    MKCoordinateRegion region;
    region.center = [LocationManagerSingleton sharedSingleton].locationManager.location.coordinate;
    region.span = (MKCoordinateSpanMake(0.025, 0.025));
    
    [mapView setRegion:region animated:YES];
    
    
    //destination
    CLLocationCoordinate2D destination = CLLocationCoordinate2DMake(((Venue*)self.detailItem).latitude,((Venue*)self.detailItem).longitude);
    
    
    //annotate destination
    CustomAnnotation *pin = [[CustomAnnotation alloc] initWithPosition:destination];
    //pin.title = [[NSString alloc] initWithString:((Venue*)self.detailItem).name];
    float venDist = ((Venue*)self.detailItem).distance;
    
    //appropriate titles for venue vs coord
    if(venDist>0)
    pin.title = [NSString stringWithFormat:@"Distance: %.02fm",((Venue*)self.detailItem).distance];
    else
    pin.title = [NSString stringWithFormat:@"Lat: %.06f Long: %.06f",destination.latitude,destination.longitude];
    [self.mapView addAnnotation:pin];
    
}


- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
       

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMap];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
