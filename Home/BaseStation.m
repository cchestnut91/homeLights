//
//  BaseStation.m
//  Home
//
//  Created by Calvin Chestnut on 6/25/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import "BaseStation.h"
#import "Light.h"

@implementation BaseStation

- (instancetype)initWithDictionary:(NSDictionary *)json
{
    self = [super init];
    
    self.lights = [Light lightsFromDictionary:json[@"lights"]];
    
    NSMutableDictionary *groups = [NSMutableDictionary new];
    
    [groups setObject:self.lights.allValues forKey:@"all"];
    
    [groups setObject:@[self.lights[@"1"], self.lights[@"3"], self.lights[@"9"], self.lights[@"12"]] forKey:@"kitchen"];
    [groups setObject:@[self.lights[@"2"]] forKey:@"livingRoomLamp"];
    [groups setObject:@[self.lights[@"14"], self.lights[@"13"]] forKey:@"bar"];
    [groups setObject:@[self.lights[@"10"]] forKey:@"portable"];
    [groups setObject:@[self.lights[@"10"], self.lights[@"13"], self.lights[@"14"], self.lights[@"2"], self.lights[@"1"], self.lights[@"3"], self.lights[@"9"], self.lights[@"12"]] forKey:@"upstairs"];
    
    [groups setObject:@[self.lights[@"15"], self.lights[@"7"], self.lights[@"6"]] forKey:@"bedroom"];
    [groups setObject:@[self.lights[@"15"]] forKey:@"desk"];
    [groups setObject:@[self.lights[@"7"]] forKey:@"calvin"];
    [groups setObject:@[self.lights[@"6"]] forKey:@"rosie"];
    [groups setObject:@[self.lights[@"5"]] forKey:@"linin"];
    [groups setObject:@[self.lights[@"11"]] forKey:@"guest"];
    [groups setObject:@[self.lights[@"8"]] forKey:@"livingRoom"];
    
    [groups setObject:@[self.lights[@"15"], self.lights[@"7"], self.lights[@"6"], self.lights[@"11"], self.lights[@"5"], self.lights[@"8"]] forKey:@"downstairs"];
    
    [self setGroups:[NSDictionary dictionaryWithDictionary:groups]];
    
    return self;
}

@end
