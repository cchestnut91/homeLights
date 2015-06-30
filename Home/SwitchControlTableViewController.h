//
//  SwitchControlTableViewController.h
//  Home
//
//  Created by Calvin Chestnut on 6/26/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchControlTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIButton *livingRoomColorButton;
@property (weak, nonatomic) IBOutlet UIButton *calvinColorButton;
@property (weak, nonatomic) IBOutlet UIButton *rosieColorButton;
@property (weak, nonatomic) IBOutlet UIButton *deskColorButton;
@property (weak, nonatomic) IBOutlet UIButton *bedroomColorButton;
@property (weak, nonatomic) IBOutlet UIButton *portableColorButton;
@property (weak, nonatomic) IBOutlet UIButton *barColorButton;
@property (weak, nonatomic) IBOutlet UIButton *livingRoomLampColorButton;
@property (weak, nonatomic) IBOutlet UIButton *kitchenColorButton;
@property (weak, nonatomic) IBOutlet UIButton *downstairsColorButton;
@property (weak, nonatomic) IBOutlet UIButton *upstairsColorButton;
@property (weak, nonatomic) IBOutlet UIButton *allColorButton;
@property (weak, nonatomic) IBOutlet UIButton *guestColorButton;
@property (weak, nonatomic) IBOutlet UIButton *linenColorButton;

@property (weak, nonatomic) IBOutlet UISwitch *guestSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *livingRoomSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lininSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *calvinSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rosieSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *deskSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *bedroomSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *portableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *barSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *livingRoomLampSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *kitchenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *downstairsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *upstairsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *allSwitch;

@property (strong, nonatomic) NSDictionary *switches;
@property (strong, nonatomic) NSDictionary *colorButtons;

@end
