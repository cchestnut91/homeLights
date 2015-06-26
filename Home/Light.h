//
//  Light.h
//  Home
//
//  Created by Calvin Chestnut on 6/25/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Light : NSObject

+ (NSDictionary *)lightsFromDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)setOn:(BOOL)on;
- (void)changeColor:(UIColor *)color;
- (void)changeBrightness:(CGFloat)brightness;

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *brightness;
@property (strong, nonatomic) NSNumber *saturation;
@property (strong, nonatomic) NSNumber *isOn;
@property (strong, nonatomic) NSNumber *hue;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *uniqueId;
@property (strong, nonatomic) UIColor *lightColor;

@end
