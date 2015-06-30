//
//  Light.m
//  Home
//
//  Created by Calvin Chestnut on 6/25/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import "Light.h"
#import "URLRequestManager.h"

@interface Light ()

@property (strong, nonatomic) NSDate *buffer;
@property (strong, nonatomic) NSDictionary *queuedState;

@end

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
    NSArray *keys = [NSArray arrayWithObjects: @"on", nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithBool:on], nil];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [[URLRequestManager sharedInstance] performStateUpdateWithLightKey:self.key andState:jsonDictionary withCompletion:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable connectionError) {
        if (data) {
            NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                            options:kNilOptions
                                                              error:&connectionError];
            if ([json count] > 0 && [[json objectAtIndex:0] objectForKey:@"success"]){
                NSLog(@"Set Light %@ %@", self.key, on ? @"On" : @"Off");
                [self setIsOn:[NSNumber numberWithBool:on]];
            } else {
                NSLog(@"Failed to set Light %@ %@ with error: %@\nAttempted State: %@", self.key, on ? @"On" : @"Off", [connectionError localizedDescription], jsonDictionary);
                
                [self queueState:jsonDictionary];
            }
        } else {
            NSLog(@"Failed to set Light %@ %@ with error: %@\nAttempted State: %@", self.key, on ? @"On" : @"Off", [connectionError localizedDescription], jsonDictionary);
            
            [self queueState:jsonDictionary];
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
        NSArray *keys = [NSArray arrayWithObjects: @"on", @"hue", @"sat", @"bri", nil];
        NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithInt:(int)(hue * 65535)], [NSNumber numberWithInt:(int)(saturation * 255)], [NSNumber numberWithInt:(int)(brightness * 255)], nil];
        NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        [[URLRequestManager sharedInstance] performStateUpdateWithLightKey:self.key
                                                                  andState:jsonDictionary
                                                            withCompletion:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable connectionError) {
                                                                
                                                                if (data) {
                                                                    NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                    options:kNilOptions
                                                                                                                      error:&connectionError];
                                                                    if ([json count] > 0 && [[json objectAtIndex:0] objectForKey:@"success"]){
                                                                        NSLog(@"Changed Lights");
                                                                        [self setLightColor:color];
                                                                    } else {
                                                                        NSLog(@"Failed with error: %@", [connectionError localizedDescription]);
                                                                        
                                                                        [self queueState:jsonDictionary];
                                                                    }
                                                                } else {
                                                                    NSLog(@"Failed to change color of light %@ with error: %@", self.key, [connectionError localizedDescription]);
                                                                    
                                                                    [self queueState:jsonDictionary];
                                                                }
                                                            }];
    }
}

- (void)changeBrightness:(CGFloat)brightness {
    
    NSDictionary *json = @{@"on" : @1,
                           @"bri": [NSNumber numberWithInt:(int)brightness]};
    
    [[URLRequestManager sharedInstance] performStateUpdateWithLightKey:self.key andState:json withCompletion:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable connectionError) {
        if (data) {
            NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                            options:kNilOptions
                                                              error:&connectionError];
            if ([json count] > 0 && [[json objectAtIndex:0] objectForKey:@"success"]){
                NSLog(@"Changed Lights");
                [self setBrightness:[NSNumber numberWithFloat:brightness]];
            } else {
                NSLog(@"Failed to change light %@ with error: %@", self.key, [connectionError localizedDescription]);
            }
        } else {
            NSLog(@"Failed to change light %@ with error: %@", self.key, [connectionError localizedDescription]);
        }
    }];
}

- (void)changeState:(NSDictionary *)state {
    [[URLRequestManager sharedInstance] performStateUpdateWithLightKey:self.key
                                                              andState:state
                                                        withCompletion:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable connectionError) {
                                                            
                                                            if (data) {
                                                                NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                options:kNilOptions
                                                                                                                  error:&connectionError];
                                                                if ([json count] > 0 && [[json objectAtIndex:0] objectForKey:@"success"]){
                                                                    NSLog(@"Changed Light State");
                                                                } else {
                                                                    NSLog(@"Failed with error: %@", [connectionError localizedDescription]);
                                                                    
                                                                    [self queueState:state];
                                                                }
                                                            } else {
                                                                NSLog(@"Failed to change color of light %@ with error: %@", self.key, [connectionError localizedDescription]);
                                                                
                                                                [self queueState:state];
                                                            }
                                                        }];
}

- (void)queueState:(NSDictionary *)queuedState {
    if (self.queuedState != queuedState) {
        self.queuedState = queuedState;
        self.buffer = [NSDate date];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self attemptQueuedState];
        });
    }
}

- (void)attemptQueuedState {
    if (self.buffer == nil || [[NSDate date] timeIntervalSinceDate:self.buffer] > 0.5) {
        [self changeState:self.queuedState];
        NSLog(@"HOLY SHIT");
    }
}

@end
