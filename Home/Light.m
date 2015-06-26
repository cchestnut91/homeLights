//
//  Light.m
//  Home
//
//  Created by Calvin Chestnut on 6/25/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import "Light.h"
#import "URLRequestManager.h"

@implementation Light

+ (NSDictionary *)lightsFromDictionary:(NSDictionary *)dict {
    NSMutableDictionary *ret = [NSMutableDictionary new];
    
    for (NSString *key in dict.allKeys){
        Light *light = [[Light alloc] initWithDictionary:[dict objectForKey:key]];
        [light setKey:key];
        [ret setObject:light forKey:key];
    }
    
    return [NSDictionary dictionaryWithDictionary:ret];
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.name = [dictionary objectForKey:@"name"];
    NSDictionary *state = [dictionary objectForKey:@"state"];
    self.brightness = [state objectForKey:@"bri"];
    self.saturation = [state objectForKey:@"sat"];
    self.isOn = [NSNumber numberWithBool:[[state objectForKey:@"on"] boolValue]];
    self.hue = [state objectForKey:@"hue"];
    NSString *type;
    
    if ([dictionary[@"type"] isEqualToString:@"Color light"] || [dictionary[@"type"] isEqualToString:@"Extended color light"]){
        type = @"COLOR";
    } else {
        type = @"LIGHT";
    }
    self.type = type;
    
    self.uniqueId = [dictionary objectForKey:@"uniqueid"];
    
    CGFloat colorHue = self.hue.floatValue / 65535.0;
    CGFloat colorSat = self.saturation.floatValue / 255.0;
    CGFloat colorBri = self.brightness.floatValue / 255.0;
    self.lightColor = [[UIColor alloc] initWithHue:colorHue saturation:colorSat brightness:colorBri alpha:1];
    
    return self;
}

- (void)setOn:(BOOL)on {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://10.0.0.95/api/newdeveloper/lights/%@/state", self.key]]];
    
    [request setHTTPMethod:@"PUT"];
    NSArray *keys = [NSArray arrayWithObjects: @"on", nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithBool:on], nil];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    [request setHTTPBody:postData];
    
    [[[NSURLSession alloc] init] dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&error];
        if ([json count] > 0 && [[json objectAtIndex:0] objectForKey:@"success"]){
            NSLog(@"Not an error, dummy");
        } else {
            NSLog(@"Failed with error: %@", [error localizedDescription]);
            [self setOn:[NSNumber numberWithBool:!on]];
        }
    }];
}

- (void)changeColor:(UIColor *)color {
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    BOOL success = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if (success){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://10.0.0.95/api/newdeveloper/lights/%@/state", self.key]]];
        
        [request setHTTPMethod:@"PUT"];
        NSArray *keys = [NSArray arrayWithObjects: @"on", @"hue", @"sat", @"bri", nil];
        NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithInt:(int)(hue * 65535)], [NSNumber numberWithInt:(int)(saturation * 255)], [NSNumber numberWithInt:(int)(brightness * 255)], nil];
        NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        [request setHTTPBody:postData];
        
        [[[NSURLSession alloc] init] dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable connectionError) {
            
            NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                            options:kNilOptions
                                                              error:&connectionError];
            if ([json count] > 0 && [[json objectAtIndex:0] objectForKey:@"success"]){
                NSLog(@"Changed Lights");
                [self setLightColor:color];
            } else {
                NSLog(@"Failed with error: %@", [connectionError localizedDescription]);
            }
        }];
    }
    NSLog(@"Change");
}

- (void)changeBrightness:(CGFloat)brightness {
    
    NSDictionary *json = @{@"on" : @1,
                           @"bri": [NSNumber numberWithInt:(int)brightness]};
    
    [[URLRequestManager sharedInstance] performStateUpdateWithLightKey:self.key andState:json withCompletion:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable connectionError) {
        NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&connectionError];
        if ([json count] > 0 && [[json objectAtIndex:0] objectForKey:@"success"]){
            NSLog(@"Changed Lights");
            [self setBrightness:[NSNumber numberWithFloat:brightness]];
        } else {
            NSLog(@"Failed with error: %@", [connectionError localizedDescription]);
        }
    }];
}

@end
