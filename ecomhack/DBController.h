//
//  DBController.h
//  Pods
//
//  Created by ANDREW KUCHARSKI on 5/22/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol DBControllerDelegate
- (void)gotNearData:(NSArray*)arObjects;
- (void)gotAllData:(NSArray*)arObjects;

- (void)gotUpdatedData;

@end

@interface DBController : NSObject;


@property (weak, nonatomic) id <DBControllerDelegate> delegate;

-(void)getARObjectsNear:(CLLocation*)location;
-(void)getAllARObjectsAndSetupWithLoc:(CLLocation*)location;

@end
