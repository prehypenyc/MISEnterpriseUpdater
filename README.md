MISEnterpriseUpdater
=============

Simple component to check if an iOS Enterprise build needs an update.

MISDropdownViewController uses ARC and supports iOS 7.0+

## Installing

MISEnterpriseUpdater can be installed by [CocoaPods](http://cocoapods.org). Simply add this line to your `Podfile`:
````
pod 'MISEnterpriseUpdater'
````

And run `pod install`.

Or just add the files from the MISEnterpriseUpdater-ObjC or MISEnterpriseUpdater-Swift folder to your project.


## Usage

```objective-c
static NSString * const MISEnterpriseUpdaterPlistFileURLString = @"URL to plist";

NSURL *url = [NSURL URLWithString:MISEnterpriseUpdaterPlistFileURLString];

[MISEnterpriseUpdater checkVersionWithURL:url success:^(BOOL requiresUpdate, NSString *versionString, NSURL *updateURL) {
    NSLog(@"Requires Update: %d", requiresUpdate);
    NSLog(@"Version String: %@", versionString);
    NSLog(@"Update URL: %@", updateURL);

    // No update required
    if (!requiresUpdate) { return; }

    // Update required
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
```


## Creator

[Michael Schneider](http://mischneider.net)
[@maicki](https://twitter.com/maicki)

## License

MISEnterpriseUpdater is available under the MIT license. See the LICENSE file for more info.
