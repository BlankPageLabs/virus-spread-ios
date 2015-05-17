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
#import "RegistrationManager.h"


@implementation RegistrationProgressViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];


//    if (![AppDelegate instance].deviceInfo) {
//        // Try downloading first
//        [[AppDelegate instance].registrationManager requestUserRetrievalOrRegistrationWithSuccess:^{
//            [self performSegueWithIdentifier:@"registrationFinished" sender:self];
//        } failure:^{
//            UIAlertController *alert = [UIAlertController
//                    alertControllerWithTitle:NSLocalizedString(@"errorTitle", @"Error")
//                                     message:NSLocalizedString(@"serverError", @"Unknown server error")
//                              preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction
//                    actionWithTitle:@"OK"
//                              style:UIAlertActionStyleCancel
//                            handler:^(UIAlertAction *action) {
//                                [self performSegueWithIdentifier:@"registrationFailed" sender:self];
//                            }]];
//            [self presentViewController:alert animated:YES completion:nil];
//        }];
//    } else {
//        // Send info
//        [[AppDelegate instance].registrationManager requestUserRegistrationWithSuccess:^{
//            [self performSegueWithIdentifier:@"registrationFinished" sender:self];
//        } failure:^{
//            UIAlertController *alert = [UIAlertController
//                    alertControllerWithTitle:NSLocalizedString(@"errorTitle", @"Error")
//                                     message:NSLocalizedString(@"serverError", @"Unknown server error")
//                              preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction
//                    actionWithTitle:@"OK"
//                              style:UIAlertActionStyleCancel
//                            handler:^(UIAlertAction *action) {
//                                [self performSegueWithIdentifier:@"registrationFailed" sender:self];
//                            }]];
//            [self presentViewController:alert animated:YES completion:nil];
//        }];
//    }
}

@end
