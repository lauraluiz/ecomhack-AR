//
//  DataController.m
//  PrometAR
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

#import "DataController.h"

@implementation DataController


#pragma mark - Main methods

-(id)init {
    self = [super init];
    if (self) {        
        self.dbController = [[DBController alloc] init];
    }
    return self;
}

#pragma mark - Data Callbacks

-(void)passARObjectsToDelegateOnMainThread:(NSArray*)arObjects {
    [self.dbController.delegate gotNearData:arObjects];
}
-(void)passAllARObjectsToDelegateOnMainThread:(NSArray*)arObjects {
    [self.dbController.delegate gotAllData:arObjects];
}

-(void)getNearARObjects_IN_BACKGROUND:(CLLocation*)location {
    [self.dbController getARObjectsNear:location];
}

-(void)getNearARObjects:(CLLocationCoordinate2D)coordinates {
    [self performSelectorInBackground:@selector(getNearARObjects_IN_BACKGROUND:)
                           withObject:[[CLLocation alloc] initWithLatitude:coordinates.latitude
                                                                 longitude:coordinates.longitude]];
}

-(void)getAllARObjects_IN_BACKGROUND:(CLLocation*)location {
    [self.dbController getAllARObjectsAndSetupWithLoc:location];
}

-(void)getAllARObjects:(CLLocationCoordinate2D)coordinates {
    [self performSelectorInBackground:@selector(getAllARObjects_IN_BACKGROUND:)
                           withObject:[[CLLocation alloc] initWithLatitude:coordinates.latitude
                                                                 longitude:coordinates.longitude]];
}

@end
