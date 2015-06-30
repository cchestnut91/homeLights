//
//  URLRequestManager.h
//  Home
//
//  Created by Calvin Chestnut on 6/25/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLRequestManager : NSObject <NSURLSessionDataDelegate>

@property (strong, nonatomic) NSOperationQueue * __nonnull pollingQueue;
@property (strong, nonatomic) NSOperationQueue * __nonnull stateChangeQueue;

typedef void (^completionBlock)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable connectionError);

+(URLRequestManager * __nonnull) sharedInstance;

- (void)getAllLightsWithCompletion:(completionBlock __nullable) completion;

- (void)performStateUpdateWithLightKey:(NSString * __nonnull)lightKey
                              andState:(NSDictionary * __nonnull)state
                        withCompletion:(completionBlock __nullable) completion;

@end
