//
//  MISEnterpriseUpdater.m
//  MISEnterpriseUpdater
//
//  Created by Michael Schneider on 7/20/15.
//
//

#import "MISEnterpriseUpdater.h"

static NSString * const PKTEnterpriseUpdaterErrorDomain = @"net.mischneider.MISEnterpriseUpdater";
static NSString * const PKTEnterpriseUpdaterErrorInvalidPlistDescription = @"Invalid plist file";

@implementation MISEnterpriseUpdater


#pragma mark - API

+ (void)checkVersionWithURL:(NSURL * __nonnull)url success:(void (^ __nonnull)(BOOL requiresUpdate, NSString * __nonnull versionString, NSURL *__nonnull updateURL))success failure:(void (^ __nonnull)(NSError * __nullable error))failure
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPShouldHandleCookies = NO;
    urlRequest.HTTPShouldUsePipelining = YES;
    urlRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [urlRequest addValue:@"application/x-plist" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{

            if (error != nil) {
                failure(error);
                return;
            }
            
            NSError *parsingError;
            id plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:&parsingError];
            if (parsingError != nil) {
                failure(parsingError);
                return;
            }
            
            if ([plist isKindOfClass:NSDictionary.class]) {
                NSDictionary *plistDictionary = plist;
                NSArray *items = plistDictionary[@"items"];
                
                if (items.count > 0) {
                    NSDictionary *itemDictionary = items[0];
                    
                    if ([itemDictionary isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *metadata = itemDictionary[@"metadata"];
                        NSString *versionString = metadata[@"bundle-version"];
                        NSURL *updateURL = [self updateURLForPlistURL:url];
                        
                        if (metadata != nil && versionString != nil && updateURL != nil) {
                            success([self requiresUpdateForRemoteVersion:versionString], versionString, updateURL);
                            return;
                        }
                    }
                }
            }

            // Invalid plist error
            NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey : NSLocalizedString(PKTEnterpriseUpdaterErrorInvalidPlistDescription, nil)
            };
            failure([NSError errorWithDomain:PKTEnterpriseUpdaterErrorDomain code:0 userInfo:userInfo]);
        });
    }];
    
    [downloadTask resume];
}


#pragma mark - Private

+ (BOOL)requiresUpdateForRemoteVersion:(NSString *)remoteVersion
{
    NSString *requiredVersion = remoteVersion;
    NSString *currentVersion = [self currentVersion];
    
    if ([requiredVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
        return YES;
    }
    
    return NO;
}

+ (NSURL *)updateURLForPlistURL:(NSURL *)url
{
    NSString *updateString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", url.absoluteString];
    return [NSURL URLWithString:updateString];
}

+ (NSString *)currentVersion
{
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    if (currentVersion.length == 0) {
        currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    return currentVersion;
}

@end
