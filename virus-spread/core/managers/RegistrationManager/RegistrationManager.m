//
// Created by Илья Михальцов on 10.4.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import "RegistrationManager.h"
#import "ApiSession.h"
#import "DeviceInfo.h"
#import "virus_spread-Swift.h"
#import "Error-objc.h"

@interface RegistrationManager ()

@end


@implementation RegistrationManager {

}

- (void)requestUserRetrievalWithSuccess:(void(^)())successBlock failure:(void(^)())failureBlock {
    [self retrieveTaskWithSuccess:^ {
        successBlock();
    } failure:^ {
        failureBlock();
    }];
}

- (void)requestUserRegistrationWithSuccess:(void(^)())successBlock failure:(void(^)())failureBlock {
    [self registerTaskIsFirstReg:YES success:^{
        successBlock();
    } failure:^{
        failureBlock();
    }];
}

- (void)requestUserUpdateWithSuccess:(void(^)())successBlock failure:(void(^)())failureBlock {
    [self registerTaskIsFirstReg:NO success:^{
        successBlock();
    } failure:^{
        failureBlock();
    }];
}

- (void)retrieveTaskWithSuccess:(void(^)())successBlock failure:(void(^)())failureBlock {
    NSString *devId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [[ApiSession instance] GET:@"device/"
                    parameters:@{@"id": devId}
                       success:^(NSURLSessionDataTask *task, id responseObject) {
                           NSLog(@"Requested user info for id %@: %@, %@", devId, task, responseObject);
                           if ([responseObject[@"status"] isEqual:@200]) {
                               NSDictionary *infoDict = responseObject[@"res"];
                               if (infoDict) {
                                   DeviceInfo *info = [DeviceInfo infoWithDictionary:infoDict];
                                   NSLog(@"Got user %@", info);
                                   [self setDeviceInfo:info permanent:YES];
                                   successBlock();
                                   return;
                               }
                           }
                           NSLog(@"User info not present for id %@", devId);
                           failureBlock();
                       }
                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                           NSLog(@"Network error for task %@: %@, %@", task, error, error.userInfo);
                           defaultError(NSLocalizedString(@"networkUnreachable", @"Network is unreachable"));

                           // Retry in 1 sec
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1000), dispatch_get_main_queue(), ^{
                               [self retrieveTaskWithSuccess:successBlock failure:failureBlock];
                           });
                       }];
}

- (void)setDeviceInfo:(DeviceInfo *)info permanent:(BOOL)permanent {
    [AppDelegate instance].deviceInfo = info;
    if (permanent) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[info encodeToDictionary] forKey:@"deviceInfo"];
    }
}

- (void)registerTaskIsFirstReg:(BOOL)firstReg success:(void(^)())successBlock failure:(void(^)())failureBlock {
    DeviceInfo *info = [AppDelegate instance].deviceInfo;

    NSAssert(info, @"Registration requested with no device info present");

    [[ApiSession instance] POST:firstReg ? @"device/reg" : @"device/update"
                     parameters: [info encodeToDictionaryCompatibleWithApi]
                        success: ^(NSURLSessionTask *task, id responseObject) {
                            if ([responseObject[@"status"] isEqual:@200]) {
                                NSLog(@"Registration succeeded: %@, %@", task, responseObject);
                                [self setDeviceInfo:info permanent:YES];
                                successBlock();
                            } else {
                                NSLog(@"Registration failed: %@, %@, %@", task, task.originalRequest, responseObject);
                                [self setDeviceInfo:nil permanent:YES];
                                failureBlock();
                            }
                        }
                        failure: ^(NSURLSessionTask *task, NSError *error) {
                            NSLog(@"Network error for task %@: %@, %@", task, error, error.userInfo);
                            defaultError(NSLocalizedString(@"networkUnreachable", @"Network is unreachable"));
                            failureBlock();
                        }];
}



@end
