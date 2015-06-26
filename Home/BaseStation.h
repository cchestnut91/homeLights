//
//  BaseStation.h
//  Home
//
//  Created by Calvin Chestnut on 6/25/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseStation : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)json;

@property (strong, nonatomic) NSDictionary *groups;
@property (strong, nonatomic) NSDictionary *lights;

@end
