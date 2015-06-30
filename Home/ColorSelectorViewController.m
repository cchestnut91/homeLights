//
//  ColorSelectorViewController.m
//  Home
//
//  Created by Calvin Chestnut on 6/26/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import "ColorSelectorViewController.h"

@interface ColorSelectorViewController ()

@property (strong, nonatomic) NSDate *buffer;
@property (strong, nonatomic) NSDate *briBuffer;
@property float waitingBri;
@property (strong, nonatomic) UIColor *waiting;
@property (strong, nonatomic) NSTimer *bufferTimer;
@property (strong, nonatomic) NSTimer *briBufferTimer;

@end

@implementation ColorSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NKOColorPickerDidChangeColorBlock colorDidChangeBlock = ^(UIColor *color){
        CGFloat hue;
        CGFloat saturation;
        CGFloat brightness;
        CGFloat alpha;
        [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        
        BOOL shouldChange = self.buffer == nil || [[NSDate date] timeIntervalSinceDate:self.buffer] > 0.5;
        
        if (shouldChange){
            self.buffer = [NSDate date];
            [self.brightnessSlider setTintColor:color];
            for (Light *light in self.group){
                [light changeColor:color];
            }
        } else {
            self.waiting = color;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self setWaitingColor];
            });
        }
    };
    
    [self.navigationItem setLeftBarButtonItem:[self.splitViewController displayModeButtonItem]];
    
    [self.navigationItem setLeftItemsSupplementBackButton:YES];
    
    UIColor *current = [self.light lightColor];
    [self.colorPickerView setColor:current];
    [self.colorPickerView setDidChangeColorBlock:colorDidChangeBlock];
    
    if (self.group.count != 1 || ![self.light.type isEqualToString:@"LIGHT"]){
        [self.brightnessSlider setTintColor:current];
    } else {
        [self.colorLabel setHidden:YES];
        [self.colorPickerView setHidden:YES];
    }
    [self.brightnessSlider setValue:self.light.brightness.floatValue];
    
    if (self.light){
        [self.brightnessSlider setHidden:NO];
        [self.brightnessLabel setHidden:NO];
        [self.colorPickerView setHidden:NO];
        [self.colorLabel setHidden:NO];
    } else {
        [self.brightnessSlider setHidden:YES];
        [self.brightnessLabel setHidden:YES];
        [self.colorPickerView setHidden:YES];
        [self.colorLabel setHidden:YES];
        [self setTitle:@"Select Light"];
    }
}

- (void)setWaitingColor {
    if (self.buffer == nil || [[NSDate date] timeIntervalSinceDate:self.buffer] > 0.5){
        [self.colorPickerView setColor:self.waiting];
        self.buffer = [NSDate date];
        [self.brightnessSlider setTintColor:self.waiting];
        for (Light *light in self.group){
            [light changeColor:self.waiting];
        }
    }
}

- (void)setWaitingBrightness {
    if (self.briBuffer == nil || [[NSDate date] timeIntervalSinceDate:self.briBuffer] > 0.5){
        [self.brightnessSlider setValue:self.waitingBri];
        self.briBuffer = [NSDate date];
        for (Light *light in self.group){
            [light changeBrightness:self.waitingBri];
        }
    }
    [self.briBufferTimer invalidate];
}

- (IBAction)updateSlider:(id)sender {
    
    BOOL shouldChange = self.briBuffer == nil || [[NSDate date] timeIntervalSinceDate:self.briBuffer] > 0.5;
    
    if (shouldChange){
        self.briBuffer = [NSDate date];
        for (Light *light in self.group){
            [light changeBrightness:[(UISlider *)sender value]];
        }
    } else {
        self.waitingBri = [(UISlider *)sender value];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self setWaitingBrightness];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressDone:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
