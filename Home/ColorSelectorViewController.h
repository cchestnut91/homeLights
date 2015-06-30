//
//  ColorSelectorViewController.h
//  Home
//
//  Created by Calvin Chestnut on 6/26/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKOColorPickerView.h"
#import "Light.h"

@interface ColorSelectorViewController : UIViewController

@property (strong, nonatomic) Light *light;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSArray *group;
@property (weak, nonatomic) IBOutlet UILabel *brightnessLabel;
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet NKOColorPickerView *colorPickerView;

@end
