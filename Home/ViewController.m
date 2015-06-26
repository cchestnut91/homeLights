//
//  ViewController.m
//  Home
//
//  Created by Calvin Chestnut on 6/25/15.
//  Copyright © 2015 Calvin Chestnut. All rights reserved.
//

#import "ViewController.h"
#import "BaseStation.h"
#import "Light.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://10.0.0.95/api/newdeveloper"]];
    
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&connectionError];
        if (json){
            BaseStation *baseStation = [[BaseStation alloc] initWithDictionary:json];
            dispatch_async(dispatch_get_main_queue(), ^{
                [(Light *)[baseStation.lights objectForKey:@"6"] changeBrightness:5];
            });
            NSLog(@"Not an error, dummy");
        } else {
            NSLog(@"Failed with error: %@", [connectionError localizedDescription]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
