//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

@import UIKit;

#import "RegistrationViewController.h"
#import "DeviceInfo.h"
#import "ApiSession.h"
#import "virus_spread-Swift.h"
#import "Error-objc.h"


@interface RegistrationViewController ()

@property(nonatomic, retain) IBOutlet UITextField *nameField;
@property(nonatomic, retain) IBOutlet UITextField *ageField;
@property(nonatomic, retain) IBOutlet UISegmentedControl *genderField;

@end


@implementation RegistrationViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([AppDelegate instance].deviceInfo) {
        DeviceInfo *info = [AppDelegate instance].deviceInfo;

        self.nameField.text = info.userName;
        self.ageField.text = [NSString stringWithFormat:@"%d", info.age];
        self.genderField.selectedSegmentIndex = [info.gender isEqualToString:@"male"]
                ? 0
                : [info.gender isEqualToString:@"female"]
                ? 1
                : -1;
    }
}

- (DeviceInfo *)deviceInfo {
    DeviceInfo *info = [[DeviceInfo alloc] init];
    BOOL valid = YES;

    if ([self.nameField.text length]) {
        info.userName = self.nameField.text;
    } else {
        valid = NO;
    }

    if ([self.ageField.text length]) {
        info.age = (NSUInteger) [self.ageField.text integerValue];
    } else {
        valid = NO;
    }

    switch (self.genderField.selectedSegmentIndex) {
        case 0:
            info.gender = @"male";
            break;
        case 1:
            info.gender = @"female";
            break;
        default:
            valid = NO;
            break;
    }

    return valid ? info : nil;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    DeviceInfo *info = self.deviceInfo;
    if (info) {
        info.deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [AppDelegate instance].deviceInfo = info;
        return YES;
    } else {
        defaultError(NSLocalizedString(@"notallfields", @"not all fields entered"));
        return NO;
    }
}

- (IBAction)unwindOneStep:(UIStoryboardSegue *)segue {

}

@end
