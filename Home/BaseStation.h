//
//  BaseStation.h
//  Home
//
//  Created by Calvin Chestnut on 6/25/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Light.h"
#import "URLRequestManager.h"

@interface BaseStation : NSObject

+ (BaseStation *)sharedInstance;

- (instancetype)initWithDictionary:(NSDictionary *)json;
- (void)updateWithCompletion:(completionBlock)completion;

- (BOOL)isReady;

@property (strong, nonatomic) NSDictionary *groups;
@property (strong, nonatomic) NSDictionary *lights;

@end
