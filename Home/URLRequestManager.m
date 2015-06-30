//
//  URLRequestManager.m
//  Home
//
//  Created by Calvin Chestnut on 6/25/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import "URLRequestManager.h"

NSString *baseUrl = @"http://10.0.0.95/api/newdeveloper";

static URLRequestManager *sharedObject;

@implementation URLRequestManager

+(URLRequestManager *) sharedInstance {
    if (sharedObject == nil){
        sharedObject = [[URLRequestManager alloc] init];
        sharedObject.pollingQueue = [[NSOperationQueue alloc] init];
        sharedObject.stateChangeQueue = [[NSOperationQueue alloc] init];
    }
    
    return sharedObject;
}

- (void)getAllLightsWithCompletion:(completionBlock __nullable) completion {
    NSURL *requestUrl = [NSURL URLWithString:baseUrl];
    
    [self performBaseRequestWithURL:requestUrl
                          andMethod:@"GET"
                            andBody:nil
                           andQueue:self.pollingQueue
                     withCompletion:completion];
}

- (void)performStateUpdateWithLightKey:(NSString * __nonnull)lightKey andState:(NSDictionary * __nonnull)state withCompletion:(completionBlock __nullable)completion {
    
    NSURL *requestUrl = [self stateUpdateURLWithKey:lightKey];
    
    [self performBaseRequestWithURL:requestUrl andMethod:@"PUT" andBody:state andQueue:self.stateChangeQueue withCompletion:completion];
}

- (void)performBaseRequestWithURL:(NSURL *)requestUrl andMethod:(NSString *)method andBody:(NSDictionary *)body andQueue:(NSOperationQueue *)queue withCompletion:(completionBlock)completion {
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue:queue];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    
    [request setHTTPMethod:method];
    
    NSError *error;
    if (body) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:body
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        [request setHTTPBody:postData];
    }
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           completion(data, response, error);
                                                       }];
    [dataTask resume];
}

- (NSURL *)stateUpdateURLWithKey:(NSString *)lightKey {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/lights/%@/state", baseUrl, lightKey]];
}

@end
