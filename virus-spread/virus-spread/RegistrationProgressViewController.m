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


    if (![AppDelegate instance].deviceInfo) {
        // Try downloading first
        [self retreiveTask];
    } else {
        // Send info
        [self registerTask];
    }
}

- (void)retreiveTask {
    [[ApiSession instance] GET:@"device/"
                    parameters:@{@"id": [[UIDevice currentDevice].identifierForVendor UUIDString]}
                       success:^(NSURLSessionDataTask *task, id responseObject) {
                           if ([responseObject[@"status"] isEqual:@200]) {
                               NSDictionary *infoDict = responseObject[@"info"];
                               if (infoDict) {
                                   DeviceInfo *info = [DeviceInfo infoWithDictionary:infoDict];
                                   [self setDeviceInfo:info permanent:YES];
                                   return;
                               }
                           }
                           [self registerTask];
                       }
                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                           [self registerTask];
                       }];
}

- (void)setDeviceInfo:(DeviceInfo *)info permanent:(BOOL)permanent {
    [AppDelegate instance].deviceInfo = info;
    if (permanent) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[info encodeToDictionary] forKey:@"deviceInfo"];
    }
}

- (void)registerTask {

    DeviceInfo *info;

    if ([AppDelegate instance].deviceInfo) {
        info = [AppDelegate instance].deviceInfo;
    } else {
        info = [[DeviceInfo alloc] init];

        info.userName = @"(unregistered)";
        info.age = 0;
        info.gender = @"male";
        info.deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    }

    [[ApiSession instance] POST:@"device/reg"
                     parameters: [info encodeToDictionary]
                        success: ^(NSURLSessionTask *task, id responseObject) {
                            if ([responseObject[@"status"] isEqual:@200]) {
                                NSLog(@"Registration succeeded: %@, %@", task, responseObject);
                                [self setDeviceInfo:info permanent:YES];
                                [self performSegueWithIdentifier:@"registrationFinished" sender:self];
                            } else {
                                NSLog(@"Registration failed: %@, %@, %@", task, task.originalRequest, responseObject);
                                UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:NSLocalizedString(@"errorTitle", @"Error")
                                                         message:NSLocalizedString(@"serverError", @"Unknown server error")
                                                  preferredStyle:UIAlertControllerStyleAlert];
                                [alert addAction:[UIAlertAction
                                        actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction *action) {
                                                    [self performSegueWithIdentifier:@"registrationFailed" sender:self];
                                                }]];
                                [self setDeviceInfo:nil permanent:YES];
                                [self presentViewController:alert animated:YES completion:nil];
                            }
                        }
                        failure: ^(NSURLSessionTask *task, NSError *error) {
                            NSLog(@"Network error for task %@: %@, %@", task, error, error.userInfo);
                            defaultError(NSLocalizedString(@"networkUnreachable", @"Network is unreachable"));

                            // Retry in 1 sec
                            [self performSelector:@selector(registerTask) withObject:nil afterDelay:1.0];
                        }];
}

@end
