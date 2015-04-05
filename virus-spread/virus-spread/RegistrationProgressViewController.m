//
// Created by Илья Михальцов on 6.4.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

@import UIKit;
#import "RegistrationProgressViewController.h"
#import "ApiSession.h"
#import "Error-objc.h"
#import "DeviceInfo.h"
#import "virus_spread-Swift.h"


@implementation RegistrationProgressViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerTask];
}

- (void)registerTask {

    DeviceInfo *info = [[DeviceInfo alloc] init];

    info.userName = @"(unregistered)";
    info.age = 0;
    info.gender = @"undef";
    info.deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [[ApiSession instance] POST:@"device/reg"
                     parameters: [info encodeToDictionary]
                        success: ^(NSURLSessionTask *task, id responseObject) {
                            NSLog(@"Registration succeeded: %@, %@", task, responseObject);
                            [AppDelegate instance].deviceInfo = info;
                            [defaults setObject:[info encodeToDictionary] forKey: @"deviceInfo"];
                            [self performSegueWithIdentifier:@"registrationFinished" sender:self];
                        }
                        failure: ^(NSURLSessionTask *task, NSError *error) {
                            NSLog(@"Network error for task %@: %@, %@", task, error, error.userInfo);
                            defaultError(NSLocalizedString(@"networkUnreachable", @"Network is unreachable"));

                            // Retry in 1 sec
                            [self performSelector:@selector(registerTask) withObject:nil afterDelay:1.0];
                        }];
}

@end
