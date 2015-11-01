//
//  ARView.m
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
#import "ARView.h"


@interface ARView ()

@end


@implementation ARView

@synthesize arData;
@synthesize currentLoc;


- (void)alert:(NSString*) title withDetails:(NSString*)details {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:details
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:true completion:nil];
}


#pragma mark - AR Controller Delegate

-(void)prarDidSetupAR:(UIView *)arView
      withCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer
         andRadarView:(UIView *)radar
{
    NSLog(@"Finished displaying ARObjects");
    
    [self.view.layer addSublayer:cameraLayer];
    [self.view addSubview:arView];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:AR_VIEW_TAG]];
    [self.view bringSubviewToFront:closeB];
    
    [self.view addSubview:radar];
    
    [loadingI stopAnimating];
}


- (void)prarUpdateFrame:(CGRect)arViewFrame {
    [[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
}

- (void)prarGotProblem:(NSString*)problemOrigin withDetails:(NSString*)details {
    [loadingI stopAnimating];
    
    [self alert:problemOrigin withDetails:details];
}


#pragma mark - View Management

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"ARView did appear");
    [super viewDidAppear:animated];
    
    [[PRARManager sharedManager] startARWithData:arData
                                     forLocation:CLLocationCoordinate2DMake(currentLoc.coordinate.latitude,
                                                                            currentLoc.coordinate.longitude)];
}
-(void)viewWillDisappear:(BOOL)animated {
    NSLog(@"ARView will disappear");

    [[PRARManager sharedManager] stopAR];
    
    [super viewWillDisappear:animated];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ARView did load");
    
    [PRARManager sharedManagerWithRadarAndSize:self.view.frame.size andDelegate:self];
}


#pragma mark - Actions

- (IBAction)done:(id)sender {
    NSLog(@"Action done");
    [self.delegate arViewControllerDidFinish:self];
}

@end
