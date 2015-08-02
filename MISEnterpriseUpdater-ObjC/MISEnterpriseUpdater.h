//
//  MISEnterpriseUpdater.h
//  MISEnterpriseUpdater
//
//  Created by Michael Schneider on 7/20/15.
//
//

#import <Foundation/Foundation.h>

@interface MISEnterpriseUpdater : NSObject

+ (void)checkVersionWithURL:(NSURL * __nonnull)url success:(void (^ __nonnull)(BOOL requiresUpdate, NSString * __nonnull versionString, NSURL *__nonnull updateURL))success failure:(void (^ __nonnull)(NSError * __nullable error))failure;

@end
