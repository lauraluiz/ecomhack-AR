//
//  DBController.m
//  Pods
//
//  Created by ANDREW KUCHARSKI on 5/22/13.
//
//

#import "DBController.h"
#import "ecomhack-Swift.h"

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

-(void)getAllARObjectsAndSetup:(NSString*) email {
    NSLog(@"Get all objects...");

    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    query[@"where"] = [NSString stringWithFormat:@"customerEmail = \"%@\"", email];
    query[@"sort"] = @"lastModifiedAt desc";
    NSLog(@"customerEmail = \"%@\"", email);
    [Carts queryObjc:query completionBlock:^(NSDictionary* _Nonnull json) {
        NSMutableArray *arObjects = [[NSMutableArray alloc] init];
        
        NSUInteger i = 0;
        if ([json[@"results"] count] > 0) {
            for (id product in json[@"results"][0][@"lineItems"]) {
                NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
                tempDict[@"id"] = @(i);
                tempDict[@"title"] = product[@"name"][@"en"];
                for (id attribute in product[@"variant"][@"attributes"]) {
                    if ([attribute[@"name"] isEqualToString:@"latitude"]) {
                        tempDict[@"lat"] = attribute[@"value"];
                    }
                    if ([attribute[@"name"] isEqualToString:@"longitude"]) {
                        tempDict[@"lon"] = attribute[@"value"];
                    }
                }
                NSLog(@"%@", tempDict);
                [arObjects addObject:tempDict];
                i++;
            }
        }
        
        [self.delegate gotAllData:arObjects];
    }];
}

@end
