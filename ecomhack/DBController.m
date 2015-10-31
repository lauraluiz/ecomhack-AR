//
//  DBController.m
//  Pods
//
//  Created by ANDREW KUCHARSKI on 5/22/13.
//
//

#import "DBController.h"

#define DB_FILE_NAME            @"db.sqlite"

#define AR_COORDINATES_TABLE    @"arct"
#define AR_DETAILS_TABLE        @"ardt"

#define REGION_RADIUS           800 // meters


@implementation DBController


#pragma mark - Main Methods

-(id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - Data callbacks

-(NSArray*)getARObjectsNear:(CLLocation*)location {
    NSLog(@"Get objects near...");

    if (!location || location == nil) return nil;
    
    CLLocationDistance regionRadius = REGION_RADIUS;
    CLCircularRegion *grRegion = [[CLCircularRegion alloc] initWithCenter:location.coordinate
                                                                 radius:regionRadius identifier:@"grRegion"];
    return [self getDummyData];
}

-(NSArray*)getDummyData {
    NSMutableArray *arObjects = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *tempDict1 = [NSMutableDictionary dictionary];
    tempDict1[@"id"] = @(0);
    tempDict1[@"lat"] = @(-48.02552565664005F);
    tempDict1[@"lon"] = @(-222.3886765213399F);
    tempDict1[@"title"] = @"Place 1";
    [arObjects addObject:tempDict1];
    
    NSMutableDictionary *tempDict2 = [NSMutableDictionary dictionary];
    tempDict2[@"id"] = @(1);
    tempDict2[@"lat"] = @(7.527896570879768F);
    tempDict2[@"lon"] = @(207.3885705083325F);
    tempDict2[@"title"] = @"Place 2";
    [arObjects addObject:tempDict2];

    return arObjects;
}

-(NSArray*)getAllARObjectsAndSetupWithLoc:(CLLocation*)location {
    NSLog(@"Get all objects...");
    if (!location || location == nil) return nil;
    return [self getDummyData];
}

@end
