//
//  URLRequestManager.h
//  Home
//
//  Created by Calvin Chestnut on 6/25/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLRequestManager : NSObject <NSURLSessionDataDelegate>

typedef void (^completionBlock)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable connectionError);

+(URLRequestManager * __nonnull) sharedInstance;

- (void)performStateUpdateWithLightKey:(NSString * __nonnull)lightKey
                              andState:(NSDictionary * __nonnull)state
                        withCompletion:(completionBlock __nullable) completion;

@end
