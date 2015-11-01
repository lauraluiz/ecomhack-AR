//
//  ViewController.m
//  PRAR-Example
//
// Created by Geoffroy Lesage on 4/24/13.
// Copyright (c) 2013 Promet Solutions Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ViewController.h"
#import "MyLocation.h"

#define LOC_REFRESH_TIMER   10  //seconds
#define MAP_SPAN            804 // The span of the map view


@interface ViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation ViewController


- (void)alert:(NSString*) title withDetails:(NSString*)details {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:details
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:true completion:nil];
}


#pragma mark - View Management

- (void)viewDidLoad {
    NSLog(@"ViewController did load");
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    _mapView.showsUserLocation = YES;
    
    dataController = [[DataController alloc] init];
    [dataController.dbController setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"ViewController did appear");
    [super viewDidAppear:animated];
    
    [self askForEmail: dataController];
    
    locRefreshTimer = [NSTimer scheduledTimerWithTimeInterval: LOC_REFRESH_TIMER
                                                       target: self
                                                     selector: @selector(setMapToUserLocation)
                                                     userInfo: nil
                                                      repeats: YES];
    
    [self performSelector:@selector(setMapToUserLocation) withObject:nil afterDelay:1];
}

- (void)askForEmail:(DataController*)controller {
    __block UITextField *localTextField;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email" message:@"Enter your email:" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Email";
         textField.text = @"laura@email.com";
         localTextField = textField;
     }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"Customer email: %@", localTextField.text);
                                   [controller getAllARObjects:localTextField.text];
                               }];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"ViewController will disappear");
    [super viewWillDisappear:animated];
    
    [locRefreshTimer invalidate];
}


#pragma mark - View Segue delegates

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Prepare for Segue...");
    if ([[segue identifier] isEqualToString:@"showAR"]) {
        ARView *arview = [segue destinationViewController];
        
        [arview setCurrentLoc:_mapView.userLocation.location];
        [arview setArData:arData];
        [arview setDelegate:self];
    }
}
- (void)arViewControllerDidFinish:(ARView *)controller {
    NSLog(@"AR ViewController did finish");
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - PRAR system

- (IBAction)startPRAR:(id)sender {
    NSLog(@"Start PRAR...");
    if (prarSwitch.on) {
        [loadingI startAnimating];
        
        if (_mapView.userLocation.location.horizontalAccuracy > 100) {
            [statusL setText:@"Waiting for accurate location"];
            [self performSelector:@selector(startPRAR:) withObject:sender afterDelay:1];
            return;
        }
    }
}

- (void)gotAllData:(NSArray*)arObjects {
    NSLog(@"Got all data!");
    arData = [[NSArray alloc] initWithArray:arObjects];
    [statusL setText:@"Got All Data"];
    
    [loadingI stopAnimating];
    [arB setEnabled:YES];
    
    [self plotAllPlaces];
}

- (void)gotUpdatedData {
    NSLog(@"Got updated data");
}


#pragma mark - Map View Delegate

-(void)setMapToUserLocation {
    NSLog(@"Updating user location...");
    
    if (_mapView.userLocation.location.horizontalAccuracy > 100) return;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(_mapView.userLocation.location.coordinate.latitude,
                                                                                                  _mapView.userLocation.location.coordinate.longitude),
                                                                       MAP_SPAN,
                                                                       MAP_SPAN);
    [_mapView setRegion:[_mapView regionThatFits:viewRegion] animated:NO];
    
    [UIView commitAnimations];
}

-(void)plotAllPlaces {
    NSLog(@"Plotting all places...");
    for (NSDictionary *place in arData) {
        [self plotPlace:place andId:[place[@"nid"] integerValue]];
    }
}
-(void)plotPlace:(NSDictionary*)somePlace andId:(NSInteger)nid {
    NSLog(@"Plot place");
    NSString *arObjectName = somePlace[@"title"];
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [somePlace[@"lat"] doubleValue];
    coordinates.longitude = [somePlace[@"lon"] doubleValue];
    MyLocation *annotation = [[MyLocation alloc] initWithName:arObjectName coordinate:coordinates andId:nid] ;
    [_mapView addAnnotation:annotation];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    NSLog(@"Calling MapView...");
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    return nil;
}



@end
