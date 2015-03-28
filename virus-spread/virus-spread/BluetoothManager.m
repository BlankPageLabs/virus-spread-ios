//
// Created by Илья Михальцов on 27.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import "BluetoothManager.h"
@import CoreBluetooth;
@import UIKit;

@interface BluetoothManager () <CBPeripheralManagerDelegate, CBCentralManagerDelegate>

@property(nonatomic, retain) CBPeripheralManager *peripheralManager;
@property(nonatomic, retain) CBCentralManager *centralManager;

@property(nonatomic, assign, getter=isCentralManagerRegistered) BOOL centralManagerRegistered;
@property(nonatomic, assign, getter=isPeripheralManagerRegistered) BOOL peripheralManagerRegistered;

@end


@implementation BluetoothManager  {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManagerRegistered = NO;
        self.peripheralManagerRegistered = NO;
        self.peripheralManager = nil;
        self.centralManager = nil;
    }

    return self;
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            [self registerPeripheralManager];
            break;
        case CBPeripheralManagerStateUnknown:
        case CBPeripheralManagerStateResetting:
            // Unregister, wait for registration once again
            [self unregisterCentralManager];
            break;
        case CBPeripheralManagerStateUnsupported:
            // TODO: device has no BTLE, give up
            break;
        case CBPeripheralManagerStateUnauthorized:
            // TODO: alert error, user disabled app access to bluetooth
            break;
        case CBPeripheralManagerStatePoweredOff:
            // Unregister
            [self unregisterPeripheralManager];
            // TODO: add alert with error
            break;
    }
}

- (void)registerPeripheralManager {
    if (!self.peripheralManagerRegistered) {
        self.peripheralManagerRegistered = YES;
    }
}

- (void)unregisterPeripheralManager {
    if (self.peripheralManagerRegistered) {
        self.peripheralManagerRegistered = NO;
    }
}

- (void)requestActivatePeripheralManager {
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [self registerCentralManager];
            break;
        case CBCentralManagerStateUnknown:
        case CBCentralManagerStateResetting:
            // Unregister, wait for registration once again
            [self unregisterCentralManager];
            break;
        case CBCentralManagerStateUnsupported:
            // TODO: device has no BTLE, give up
            break;
        case CBCentralManagerStateUnauthorized:
            // TODO: alert error, user disabled app access to bluetooth
            break;
        case CBCentralManagerStatePoweredOff:
            // Unregister
            [self unregisterCentralManager];
            // TODO: add alert with error
            break;
    }
}

- (void)registerCentralManager {
    if (!self.centralManagerRegistered) {
        self.centralManagerRegistered = YES;
    }
}

- (void)unregisterCentralManager {
    if (self.centralManagerRegistered) {
        self.centralManagerRegistered = NO;
    }
}

- (void)requestActivateCentralManager {
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)deactivatePeripheralManager {
    self.peripheralManager = nil;

}

- (void)deactivateCentralManager {
    self.centralManager = nil;
}

- (NSDictionary *)compileAdvertisingInfo {
    NSMutableDictionary *advertisingInfo = [[NSMutableDictionary alloc] init];
    return nil;
}

@end
