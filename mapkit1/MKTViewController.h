//
//  MKTViewController.h
//  mapkit1
//
//  Created by clacknonbow on 12-11-12.
//  Copyright (c) 2012 clacknonbow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MKTViewController : UIViewController
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *myDoSomethingButton;
@property (strong, nonatomic) CLRegion *mySavedRegion;
@property (nonatomic) CLLocationDegrees *myRadius;
- (IBAction)doSomethingButton:(id)sender;

@property (nonatomic, retain) UIAlertView* myAlertView;

-(void) dismssAndShowAlert : (NSString*) mystr;

@end
