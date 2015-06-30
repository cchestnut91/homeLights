//
//  SwitchControlTableViewController.m
//  Home
//
//  Created by Calvin Chestnut on 6/26/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import "SwitchControlTableViewController.h"
#import "ColorSelectorViewController.h"
#import "BaseStation.h"

@interface SwitchControlTableViewController ()

@property (strong, nonatomic) NSTimer *pollingTimer;

@end

@implementation SwitchControlTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.switches = @{@"all" : self.allSwitch,
                      @"upstairs" : self.upstairsSwitch,
                      @"downstairs" : self.downstairsSwitch,
                      @"kitchen" : self.kitchenSwitch,
                      @"livingRoomLamp" : self.livingRoomLampSwitch,
                      @"bar" : self.barSwitch,
                      @"portable" : self.portableSwitch,
                      @"bedroom" : self.bedroomSwitch,
                      @"desk" : self.deskSwitch,
                      @"rosie" : self.rosieSwitch,
                      @"calvin" : self.calvinSwitch,
                      @"livingRoom" : self.livingRoomSwitch,
                      @"guest" : self.guestSwitch,
                      @"linin" : self.lininSwitch};
    
    self.colorButtons = @{@"all" : self.allColorButton,
                          @"upstairs" : self.upstairsColorButton,
                          @"downstairs" : self.downstairsColorButton,
                          @"kitchen" : self.kitchenColorButton,
                          @"livingRoomLamp" : self.livingRoomLampColorButton,
                          @"bar" : self.barColorButton,
                          @"portable" : self.portableColorButton,
                          @"bedroom" : self.bedroomColorButton,
                          @"desk" : self.deskColorButton,
                          @"rosie" : self.rosieColorButton,
                          @"calvin" : self.calvinColorButton,
                          @"livingRoom" : self.livingRoomColorButton,
                          @"guest" : self.guestColorButton,
                          @"linin" : self.linenColorButton};
    
    for (UISwitch *aSwitch in self.switches.allValues){
        [aSwitch addTarget:self action:@selector(toggleLightSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    
    for (UIButton *aButton in self.colorButtons.allValues){
        [aButton addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Show loading view
    [self.tableView setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self createPollingTimer];
}

- (void)setUpSwitches {
    if ([[BaseStation sharedInstance] isReady]){
        // Remove laoding veiw
        [self.tableView setHidden:NO];
        for (NSString *key in [BaseStation sharedInstance].groups.allKeys){
            NSArray *lightGroup = [[BaseStation sharedInstance].groups objectForKey:key];
            UISwitch *lightSwitch = [self.switches objectForKey:key];
            
            BOOL lightIsOn = false;
            for (Light *light in lightGroup){
                if (light.isOn.boolValue){
                    lightIsOn = YES;
                    break;
                }
            }
            
            [lightSwitch setOn:lightIsOn animated:YES];
            
            if ([self.colorButtons objectForKey:key]){
                UIButton *colorButton = [self.colorButtons objectForKey:key];
                [colorButton setEnabled:YES];
            }
        }
        
        [self.tableView reloadData];
    }
}

- (void)pollForLightsUpdates {
    [[BaseStation sharedInstance] updateWithCompletion:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUpSwitches];
        });
    }];
}

- (IBAction)toggleLightSwitch:(id)sender {
    self.pollingTimer = nil;
    NSString *key;
    for (NSString *checkKey in self.switches.allKeys){
        if ([self.switches[checkKey] isEqual:sender]){
            key = checkKey;
            break;
        }
    }
    BOOL on = [(UISwitch *)sender isOn];
    if (key){
        NSArray *lights = [[[BaseStation sharedInstance] groups] objectForKey:key];
        for (Light *light in lights){
            light.isOn = [NSNumber numberWithBool:on];
            [light setOn:on];
        }
        [self setUpSwitches];
    }
}

- (IBAction)selectColor:(id)sender {
    self.pollingTimer = nil;
    NSString *key;
    for (NSString *checkKey in self.colorButtons.allKeys){
        if ([self.colorButtons[checkKey] isEqual:sender]){
            key = checkKey;
            break;
        }
    }
    if (key){
        NSArray *lights = [[[BaseStation sharedInstance] groups] objectForKey:key];
        [self updateColorViewWithSender:@{key : lights}];
    }
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UIButton *colorButton;
    for (UIView *view in [tableView cellForRowAtIndexPath:indexPath].contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]){
            colorButton = (UIButton *)view;
            break;
        }
    }
    
    [self selectColor:colorButton];
}

- (void)createPollingTimer {
    if (!self.pollingTimer) {
        self.pollingTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(pollForLightsUpdates) userInfo:nil repeats:YES];
        [self.pollingTimer fire];
    }
}

- (void)updateColorViewWithSender:(NSDictionary *)sender {
    [self performSegueWithIdentifier:@"colorSelectorSegue" sender:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"colorSelectorSegue"]){
        NSArray *lights = [[(NSDictionary *)sender allValues] firstObject];
        NSString *key = [[(NSDictionary *)sender allKeys] firstObject];
        
        ColorSelectorViewController *destination = [(UINavigationController *)segue.destinationViewController viewControllers][0];
        
        [destination setKey:key];
        [destination setLight:lights.firstObject];
        [destination setGroup:lights];
    }
}

@end
