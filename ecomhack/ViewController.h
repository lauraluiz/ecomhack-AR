//
//  ViewController.h
//  ecomhack
//
//  Created by Laura Luiz on 31/10/15.
//  Copyright © 2015 Laura Luiz. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "ARView.h"
#import "DataController.h"

@interface ViewController : UIViewController <ARViewDelegate, DataControllerDelegate, MKMapViewDelegate>
{
    
    DataController *dataController;
    IBOutlet MKMapView *_mapView;
    
    IBOutlet UIActivityIndicatorView *loadingI;
    
    IBOutlet UILabel *statusL;
    IBOutlet UISwitch *prarSwitch;
    IBOutlet UIButton *arB;
    
    NSArray *arData;
    
    NSTimer *locRefreshTimer;
}


-(IBAction)startPRAR:(id)sender;


@end
