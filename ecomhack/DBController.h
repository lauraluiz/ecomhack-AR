//
//  DBController.h
//  Pods
//
//  Created by ANDREW KUCHARSKI on 5/22/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DBController : NSObject;

-(NSArray*)getARObjectsNear:(CLLocation*)location;
-(NSArray*)getAllARObjectsAndSetupWithLoc:(CLLocation*)location;

@end
