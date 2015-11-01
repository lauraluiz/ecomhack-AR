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
- (void)gotAllData:(NSArray*)arObjects;

- (void)gotUpdatedData;

@end

@interface DBController : NSObject;


@property (weak, nonatomic) id <DBControllerDelegate> delegate;

-(void)getAllARObjectsAndSetup:(NSString*) email;

@end
