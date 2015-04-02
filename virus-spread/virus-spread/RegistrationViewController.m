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

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        NSURLSessionDataTask *dataTask = [[ApiSession instance] POST:@"device/reg"
                         parameters: [info encodeToDictionary]
                            success: ^(NSURLSessionTask *task, id responseObject) {
                                [AppDelegate instance].deviceInfo = info;
                                [defaults setObject:[info encodeToDictionary] forKey: @"deviceInfo"];
                            }
                            failure: ^(NSURLSessionTask *task, NSError *error) {
                                NSLog(@"Network error for task %@: %@, %@", task, error, error.userInfo);
                                defaultError(NSLocalizedString(@"networkUnreachable", @"Network is unreachable"));
                                abort();
                            }];
        return YES;
    } else {
        return NO;
    }
}

@end
