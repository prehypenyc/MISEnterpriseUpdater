//
//  EnterpriseUpdater.swift
//  MISEnterpriseUpdater
//
//  Created by Michael Schneider on 7/21/15.
//  Copyright (c) 2015 mischneider. All rights reserved.
//

import Foundation

class EnterpriseUpdater : NSObject {
    
    struct EnterpriseErrorConstants {
        static let domain = "net.mischneider.EnterpriseUpdater";
        static let invalidPlistDescription = "Invalid plist file";
    }
    
    
    // MARK: - API
    
    class func checkVersion(URL: NSURL, success: (requiresUpdate: Bool, versionString: String, updateURL: NSURL) -> Void, failure: (error: NSError!) -> Void) {

        var urlRequest = NSMutableURLRequest(URL:URL);
        urlRequest.HTTPShouldHandleCookies = false;
        urlRequest.HTTPShouldUsePipelining = true;
        urlRequest.cachePolicy = .ReloadIgnoringLocalCacheData
        urlRequest.addValue("application/x-plist", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        let sessionTask = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                
                if error != nil {
                    failure(error: error)
                    return;
                }
                
                // Parse plist
                var parsingError : NSError?
                let plist: AnyObject? = NSPropertyListSerialization.propertyListWithData(data, options:Int(NSPropertyListMutabilityOptions.MutableContainersAndLeaves.rawValue), format: nil, error: &parsingError);
                
                if let error = parsingError {
                    failure(error: error);
                    return;
                }
                
                // Try get items
                if let
                    plistDict = plist as? NSDictionary,
                    items = plistDict["items"] as? NSArray where items.count > 0
                {
                    // Unwrap all the stuff we need from the item
                    if let
                        itemDict = items[0] as? NSDictionary,
                        metadata = itemDict["metadata"] as? NSDictionary,
                        versionString = metadata["bundle-version"] as? String,
                        updateURL = self.updateURLForPlist(URL)
                    {
                        success(requiresUpdate: self.requiresUpdateForRemoteVersion(versionString), versionString: versionString, updateURL: updateURL)
                        return;
                    }
                }
                
                // Invalid plist error
                let userInfo = [
                    NSLocalizedDescriptionKey : NSLocalizedString(EnterpriseErrorConstants.invalidPlistDescription, comment:"")
                ]
                failure(error: NSError(domain: EnterpriseErrorConstants.domain, code: 0, userInfo: userInfo));
            });
        })
        sessionTask.resume()
    }
    
    
    // MARK: - Private
    
    private class func requiresUpdateForRemoteVersion(remoteVersion: String) -> Bool {
        if let currentVersion = self.currentVersion() {
            if remoteVersion.compare(currentVersion, options: NSStringCompareOptions.NumericSearch) == .OrderedDescending {
                return true;
            }
        }

        return false;
    }
    
    private class func updateURLForPlist(url: NSURL) -> NSURL? {
        if let absoluteUrlString = url.absoluteString {
            let updateString = "itms-services://?action=download-manifest&url=" + absoluteUrlString
            return NSURL(string: updateString)
        }
        
        return nil;
    }
    
    private class func currentVersion() -> String? {
//        if let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey(String(kCFBundleVersionKey)) as? String {
//            if !currentVersion.isEmpty {
//                return currentVersion;
//            }
//            
//            if let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
//                return currentVersion;
//            }
//        }
        
        if let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
            return currentVersion;
        }
        
        return nil;
    }
}