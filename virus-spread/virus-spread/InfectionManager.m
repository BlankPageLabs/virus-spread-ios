//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

@import UIKit;
@import AFNetworking;

#import <JSONKit/JSONKit.h>

#import "InfectionManager.h"
#import "virus_spread-Swift.h"
#import "BluetoothManager.h"
#import "VirusInfo.h"
#import "ApiSession.h"


@implementation InfectionManager {

}


- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *virusDict = [[NSData
                dataWithContentsOfURL:[[AppDelegate applicationDocumentsDirectory]
                        URLByAppendingPathComponent:@"current_virus.json"]] objectFromJSONData];
        if (virusDict) {
            self.virus = [VirusInfo infoWithDictionary:virusDict];
            self.infected = YES;
        }
        if (self.infected) {
            [[AppDelegate instance].bluetoothManager requestActivatePeripheralManager];
            [[AppDelegate instance].bluetoothManager deactivateCentralManager];
        } else {
            [[AppDelegate instance].bluetoothManager deactivatePeripheralManager];
            [[AppDelegate instance].bluetoothManager requestActivateCentralManager];
        }
    }

    return self;
}


- (void)infectWith:(VirusInfo *)virus {
    self.infected = YES;
    self.virus = virus;

    [[[virus encodeToDictionary] JSONData]
            writeToURL:[[AppDelegate applicationDocumentsDirectory]
                    URLByAppendingPathComponent:@"current_virus.json"]
            atomically:NO];

    [[AppDelegate instance].bluetoothManager requestActivatePeripheralManager];
    [[AppDelegate instance].bluetoothManager deactivateCentralManager];

    [[ApiSession instance] POST:@"virus/sick" parameters:[self.virus encodeToDictionary]
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                            NSLog(@"Virus event sent successfully. Response: %@", responseObject);
                        }
                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                            NSLog(@"Error communicating with %@: %@, %@", task, error, error.userInfo);
                        }];
}

- (void)cure {
    self.infected = NO;
    self.virus = nil;

    NSError *error = nil;
    [[NSFileManager defaultManager]
            removeItemAtURL:[[AppDelegate applicationDocumentsDirectory]
                    URLByAppendingPathComponent:@"current_virus.json"]
                      error:&error];

    [[AppDelegate instance].bluetoothManager deactivatePeripheralManager];
    [[AppDelegate instance].bluetoothManager requestActivateCentralManager];
}


@end
