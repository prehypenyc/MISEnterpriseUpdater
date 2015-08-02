//
//  ViewController.m
//  MISEnterpriseUpdater
//
//  Created by Michael Schneider on 7/29/15.
//  Copyright (c) 2015 mischneider. All rights reserved.
//

#import "ViewController.h"
#import "MISEnterpriseUpdater.h"
#import "MISEnterpriseUpdater-Swift.h"

static NSString * const MISEnterpriseUpdaterPlistFileURLString = @"URL to plist";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSURL *url = [NSURL URLWithString:MISEnterpriseUpdaterPlistFileURLString];

    // Objective-C
    // [MISEnterpriseUpdater checkVersionWithURL:url success:^(BOOL requiresUpdate, NSString *versionString, NSURL *updateURL) {
        
    // Swift
    [EnterpriseUpdater checkVersion:url success:^(BOOL requiresUpdate, NSString *versionString, NSURL *updateURL) {

        NSLog(@"Requires Update: %d", requiresUpdate);
        NSLog(@"Version String: %@", versionString);
        NSLog(@"Update URL: %@", updateURL);
        
        // No update required
        if (!requiresUpdate) { return; }
        
        // Update required popup alert view
        NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"Version %@ is available.", nil), versionString];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Update Available", nil) message:messageString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *installAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Install", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [[UIApplication sharedApplication] openURL:updateURL];
           }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
         
        [alert addAction:installAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"MISEnterpriseUpdater Error: %@", error);
    }];
}

@end
