//
//  MKTViewController.m
//  mapkit1
//
//  Created by clacknonbow on 12-11-12.
//  Copyright (c) 2012 clacknonbow. All rights reserved.
//

#import "MKTViewController.h"

@interface MKTViewController ()

@end

@implementation MKTViewController
@synthesize locationManager;
@synthesize mySavedRegion;
@synthesize myRadius;
@synthesize myMapView;
@synthesize myAlertView;
@synthesize myDoSomethingButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.myMapView.showsUserLocation = YES;

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = (id)self;
    if ([CLLocationManager locationServicesEnabled]) {
        [locationManager startUpdatingLocation];
        NSLog(@"started location manager using startUpdatingLocation");
    } else {
        NSLog(@"location mangler didnay start");
    }
    locationManager.distanceFilter = 1;  // in metres
    
    [self registerRegionWithCircularOverlay:@"" andIdentifier:@""];

    // teebmark
    // get current location late long
    // see if it's within radius of X, Y, if it is, NSLog

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(BOOL) shouldAutorotate {
    return YES;
}
 */

-(BOOL)registerRegionWithCircularOverlay:(NSString*)overlay andIdentifier:(NSString*)identifier
{
    // Do not create regions if support is unavailable or disabled.
    if ( ![CLLocationManager regionMonitoringAvailable] )
//        ![CLLocationManager authorizationStatus] ||
//        ![CLLocationManager regionMonitoringEnabled]) //  == ????? ughmark
        return NO;
 
    // If the radius is too large, registration fails automatically,
    // so clamp the radius to the max value.
    CLLocationDistance radius = 600;

    if (radius > self.locationManager.maximumRegionMonitoringDistance)
        radius = self.locationManager.maximumRegionMonitoringDistance;
    
    // Create the region and start monitoring it.
    float myMonitorLat = 51.05;
    float myMonitorLong = -114.07;
    
    float myMapSize = 0.04;
    
    NSString* myString = @"THANG";
    
    CLLocationCoordinate2D myMonitorCentre = CLLocationCoordinate2DMake(myMonitorLat, myMonitorLong);
    
    CLRegion* asdfjh = [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(myMonitorLat, myMonitorLong) radius:radius identifier:myString];
    
    mySavedRegion = [asdfjh copy];
    
    [self.locationManager startMonitoringForRegion:mySavedRegion];

    MKCircle *myCircle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(myMonitorLat, myMonitorLong) radius:radius];
    [myMapView addOverlay:myCircle];
    
    MKCoordinateSpan mySpan = MKCoordinateSpanMake(myMapSize, myMapSize);
    
    MKCoordinateRegion myMapViewRegion = MKCoordinateRegionMake(myMonitorCentre, mySpan);
    
    [myMapView setRegion:myMapViewRegion animated:YES];
        
    [myMapView setDelegate:(id)self];
    
    double myDistanceFromTarget = [self kilometresBetweenPlace1:myMonitorCentre andPlace2:self.locationManager.location.coordinate];
//    NSLog(@"distance is %f", myDistanceFromTarget);
    if (myDistanceFromTarget < radius/1000) {
        [self dismssAndShowAlert:@"You have started the app within the region"];
    }
    
    return YES;
}

-(void) dismssAndShowAlert : (NSString*) mystr {
    // dismiss an existing alert
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
    myAlertView = nil;
    
    NSString *title = NSLocalizedString(mystr,mystr);
    myAlertView = [[UIAlertView alloc] initWithTitle:title
                                             message:nil
                                            delegate:nil
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:nil];
    [myAlertView show]; // possibly use perform selectoronmainthread
}

-(void) locationManager:(CLLocationManager*)manger didEnterRegion:(CLRegion *)region {
    NSLog(@"ENTERING K REGION");
    NSLog(@"with region identifer %@", region.identifier);
    
    [self dismssAndShowAlert:@"ENTERING K REGION"];
}

-(void) locationManager:(CLLocationManager*)manger didExitRegion:(CLRegion *)region {
    NSLog(@"EXITING K REGION");
    NSLog(@"with region identifer %@", region.identifier);
    
    [self dismssAndShowAlert:@"You are now leaving K REGION"];
}

- (IBAction)doSomethingButton:(id)sender {
   
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
    
    circleView.fillColor = [UIColor blueColor];
    circleView.alpha = 0.25;
    
    return circleView;
}

-(double)kilometresBetweenPlace1:(CLLocationCoordinate2D) place1 andPlace2:(CLLocationCoordinate2D) place2 {
    
    MKMapPoint  start, finish;
    
    
    start = MKMapPointForCoordinate(place1);
    finish = MKMapPointForCoordinate(place2);
    
    return MKMetersBetweenMapPoints(start, finish) / 1000;
}

@end
