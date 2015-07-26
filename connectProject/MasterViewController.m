//
//  MasterViewController.m
//  connectProject
//
//  Created by Vanny Nguyen on 7/13/15.
//  Copyright (c) 2015 Vanny Nguyen. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "LocationManagerSingleton.h"
#import "Venue.h"

//constrained max latitude range from (-90,90) to (-80,80)
#define MAX_LAT 160
#define MAX_LONG 360
#define CLIENT_ID @"M5IN23SHWJDOY3HA51FWGIMP20I2QYZPQIK3W3NU5KA3NMHS"
#define CLIENT_SECRET @"0YHAYXYL0DXTGAIZV1ASYGHWHZS03TBNR3HOAE4N3THR2PFL"
#define VERSIONING @"20150724"
#define MODE @"foursquare"
#define RADIUS @"500"
@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(permissionUpdatedNotification:)
                                                 name:@"permissionUpdated"
                                               object:nil];
    //seed drand48() for random coordinates
    
    srand48(time(0));
    LocationManagerSingleton* manager = [LocationManagerSingleton sharedSingleton];
    [self getVenues:manager.locationManager.location];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

/**
 *param: range of return value
 *return: random float within given range
 */
-(float)randomCoord:(int) range{
    
    return (drand48()*(float)range)-(range/2);
}

/*
 Get venues from FourSquare API
 param: location of user for URL request
 */
-(void)getVenues:(CLLocation*) userLoc{
    
    
    //store contents of URL; request only venues within 500m
    NSData *venuesData;
    
    
    if(userLoc!=nil){
        
    venuesData = [[NSData alloc] initWithContentsOfURL:
                          [NSURL URLWithString:[[NSString alloc] initWithFormat: @"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&radius=%@&oauth_token=QELSMJL12HVK4WGDLTV1XZ4TSK25FJNIRQCZ3U4I0NEQFBIX&v=20150723",userLoc.coordinate.latitude,userLoc.coordinate.longitude,RADIUS]]];
    }
    else{
    venuesData = [[NSData alloc] initWithContentsOfURL:
                              [NSURL URLWithString:[[NSString alloc] initWithFormat: @"https://api.foursquare.com/v2/venues/search?ll=40.7,-74&radius=%@&oauth_token=QELSMJL12HVK4WGDLTV1XZ4TSK25FJNIRQCZ3U4I0NEQFBIX&v=20150725",RADIUS]]];
    }
    
    
    NSError *error;

    
    //serialize JSON
    NSMutableDictionary *venues = [NSJSONSerialization JSONObjectWithData:venuesData options:NSJSONReadingMutableContainers error:&error];
    
    if(error){
        NSLog(@"%@",[error localizedDescription]);
    }
    else{
        //Begin parsing JSON
        NSArray *items = [[[[venues objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
        //NSLog(@"%li",(long)[items count]);
        for(NSDictionary *venue in items){
            
            Venue *venueObj = [[Venue alloc] initWithName:[[venue objectForKey:@"venue"] objectForKey:@"name"]];
            
            venueObj.latitude = [[[[venue objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
            venueObj.longitude = [[[[venue objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
            venueObj.distance = [[[[venue objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"distance"] floatValue];
            [self insertNewObject:self venue:venueObj];
        }
        
        
    }
}

/*
 * If LocationManagerSingleton has obtained new user location, receive notification and add new venues.
 */
- (void)permissionUpdatedNotification:(NSNotification *)note {
    LocationManagerSingleton *manager = [LocationManagerSingleton sharedSingleton];
   
    //reset table view for new locations
    NSMutableArray* indexPathsToDelete = [[NSMutableArray alloc] init];
    for(unsigned int i = 0; i < [self.objects count]; i++)
    {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.tableView beginUpdates];
    [self.objects removeAllObjects];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    
     //Pull data from FourSquare
    [self getVenues:manager.locationManager.location];
    [self.tableView reloadData];
    
}
/*
 Insert new random coordinate
 */
- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    Venue *newVenue = [[Venue alloc] initWithName:@"Random Coordinate"];
    newVenue.latitude = [self randomCoord:MAX_LAT];
    newVenue.longitude = [self randomCoord:MAX_LAT];
    [self.objects insertObject:newVenue atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/*
 Insert new FourSquare venue
 */
- (void)insertNewObject:(id)sender venue:(Venue*)ven{
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:ven atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Venue *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Venue *ven = self.objects[indexPath.row];
    
    //format display of cells
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",ven.name];
    
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 2;
    if(ven.distance>0)
    cell.detailTextLabel.text =[NSString stringWithFormat:@"Lat: %0.6f Long: %0.6f\nDistance: %0.1f",ven.latitude,ven.longitude,ven.distance];
    else
    cell.detailTextLabel.text =[NSString stringWithFormat:@"Lat: %0.6f Long: %0.6f",ven.latitude,ven.longitude];
    
    //cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
