//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

@import UIKit;
@import AFNetworking;

#import "InfectionManager.h"
#import "virus_spread-Swift.h"
#import "BluetoothManager.h"
#import "VirusInfo.h"
#import "ApiSession.h"


@implementation InfectionManager {

}

- (void)infectWith:(VirusInfo *)virus {
    self.infected = YES;
    self.virus = virus;

    [[AppDelegate instance].bluetoothManager requestActivatePeripheralManager];
    [[AppDelegate instance].bluetoothManager deactivateCentralManager];

    [[ApiSession instance] POST:@"virus" parameters:@[]
                        success:^(NSURLSessionDataTask *task, id responseObject) {

                        }
                        failure:^(NSURLSessionDataTask *task, NSError *error) {

                        }];
}

- (void)cure {
    self.infected = NO;

    [[AppDelegate instance].bluetoothManager deactivatePeripheralManager];
    [[AppDelegate instance].bluetoothManager requestActivateCentralManager];
}


@end
