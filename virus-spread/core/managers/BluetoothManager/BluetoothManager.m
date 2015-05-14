//
// Created by Илья Михальцов on 27.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import "BluetoothManager.h"
#import "VirusInfo.h"
#import "virus_spread-Swift.h"
#import "InfectionManager.h"
#import "KissInfo.h"
#import "ApiSession.h"

@import CoreBluetooth;
@import UIKit;

#import <JSONKit/JSONKit.h>


static NSString *const bt_ServiceId = @"D89EDBCB-8128-4122-94E1-94E388843CF6";
static NSString *const bt_VirusInfoCharacteristicId = @"1C5EB049-9D10-488C-9709-647B63916539";


@interface BluetoothManager () <CBPeripheralManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>

@property(nonatomic, retain) CBPeripheralManager *peripheralManager;
@property(nonatomic, retain) CBCentralManager *centralManager;

@property(nonatomic, assign, getter=isCentralManagerRegistered) BOOL centralManagerRegistered;
@property(nonatomic, assign, getter=isPeripheralManagerRegistered) BOOL peripheralManagerRegistered;

@property(nonatomic, retain) NSMutableDictionary *activePeripherals;

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
        self.activePeripherals = [NSMutableDictionary new];
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
        [self.peripheralManager addService:[self compileAdvertisingInfo]];
        [self.peripheralManager startAdvertising:@{
                CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:bt_ServiceId]]}];
        self.peripheralManagerRegistered = YES;
    }
}

- (void)unregisterPeripheralManager {
    if (self.peripheralManagerRegistered) {
        [self.peripheralManager stopAdvertising];
        [self.peripheralManager removeAllServices];
        self.peripheralManagerRegistered = NO;
    }
}

- (void)requestActivatePeripheralManager {
    [self unregisterPeripheralManager];
    self.peripheralManager = [[CBPeripheralManager alloc]
            initWithDelegate:self
                       queue:nil
                     options:@{
                             CBPeripheralManagerOptionShowPowerAlertKey: @YES,
                             CBPeripheralManagerOptionRestoreIdentifierKey: @"peripheralManagerRestoreId",
                     }];
    self.peripheralManager.delegate = self;
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
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:bt_ServiceId]]
                                                    options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @NO}];
        self.centralManagerRegistered = YES;
    }
}

- (void)unregisterCentralManager {
    if (self.centralManagerRegistered) {
        [self.centralManager stopScan];
        self.centralManagerRegistered = NO;
    }
}

- (void)requestActivateCentralManager {
    [self unregisterCentralManager];
    self.centralManager = [[CBCentralManager alloc]
            initWithDelegate:self
                       queue:nil
                     options:@{
                             CBCentralManagerOptionShowPowerAlertKey: @YES,
                             CBCentralManagerOptionRestoreIdentifierKey: @"centralManagerRestorationId",
                     }];
    self.centralManager.delegate = self;
}

- (void)deactivatePeripheralManager {
    self.peripheralManager = nil;

}

- (void)deactivateCentralManager {
    self.centralManager = nil;
}

- (CBMutableService *)compileAdvertisingInfo {
    VirusInfo *virus = [AppDelegate instance].infectionManager.virus;

    CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:bt_ServiceId]
                                                               primary:YES];
    CBMutableCharacteristic *idCharacteristic = [[CBMutableCharacteristic alloc]
            initWithType:[CBUUID UUIDWithString:bt_VirusInfoCharacteristicId]
              properties:CBCharacteristicPropertyRead
                   value:[[virus encodeToDictionary] JSONData]
             permissions:CBAttributePermissionsReadable];

    service.characteristics = @[idCharacteristic];

    return service;
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    NSLog(@"Discovered: %@, RSSI: %@", peripheral, RSSI);

    if (![self.activePeripherals objectForKey:peripheral.identifier]) {
        self.activePeripherals[peripheral.identifier] = peripheral;
        [self requestConnectPeripheral:peripheral];
    }
}

- (void)requestConnectPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"Error adding service %@: %@, %@", service, error, error.userInfo);
    } else {
        NSLog(@"Added service %@", service);
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if (error) {
        NSLog(@"Error starting advertising: %@, %@", error, error.userInfo);
    } else {
        NSLog(@"Started advertising");
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Connected to %@", peripheral);
    [self requestDiscoverServices:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Peripheral %@ disconnected due to %@, %@", peripheral, error, error.userInfo);
    [self.activePeripherals removeObjectForKey:peripheral.identifier];
}

- (void)requestDiscoverServices:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString:bt_ServiceId]]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Failed to connect with %@: %@, %@", peripheral, error, error.userInfo);
    [self.activePeripherals removeObjectForKey:peripheral.identifier];
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices {
    NSLog(@"Peripheral %@ changed services, requesting re-discovery", peripheral);
    [self requestDiscoverServices:peripheral];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        NSLog(@"Failed to discover services on %@: %@, %@", peripheral, error, error.userInfo);
    } else {
        NSLog(@"Discovered on %@: %@", peripheral, peripheral.services);
        CBService *service = peripheral.services.firstObject;
        [self requestDiscoverCharacteristics:peripheral forService:service];
    }
}

- (void)requestDiscoverCharacteristics:(CBPeripheral *)peripheral forService:(CBService *)service {
    [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:bt_VirusInfoCharacteristicId]] forService:service];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"Failed to discover characteristics for service %@ on %@: %@, %@", service, peripheral,
                error, error.userInfo);
    } else {
        NSLog(@"Discovered characteristics for %@ on %@: %@", service, peripheral, service.characteristics);
        CBCharacteristic *characteristic = service.characteristics.firstObject;
        [self requestReadValueForCharacteristic:characteristic onPeripheral:peripheral];
    }
}

- (void)requestReadValueForCharacteristic:(CBCharacteristic *)characteristic onPeripheral:(CBPeripheral *)peripheral {
    [peripheral readValueForCharacteristic:characteristic];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Failed to read characteristic %@ on %@: %@, %@", characteristic, peripheral, error, error.userInfo);
    } else {
        NSData *data = characteristic.value;
        [self kiss:data];

        NSLog(@"Removing peripheral %@", peripheral);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)kiss:(NSData *)data {
    NSDictionary *virusDict = [data objectFromJSONData];
    NSLog(@"Read virus: %@", virusDict);
    VirusInfo *virus = [VirusInfo infoWithDictionary:virusDict];

    // Mark possible infection
    [AppDelegate instance].infectionManager.possibleInfection = YES;

    __block UIBackgroundTaskIdentifier bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[[ApiSession instance] operationQueue] cancelAllOperations];
        [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
    }];

    [[NSOperationQueue new] addOperationWithBlock:^{
        KissInfo *kissInfo = [KissInfo infoWithVirusInfo:virus];
        [[ApiSession instance] POST:@"kiss"
                         parameters:[kissInfo encodeToDictionary]
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
                                NSLog(@"Kiss, response: %@, kiss: %@", responseObject, [kissInfo encodeToDictionary]);
                            }
                            failure:^(NSURLSessionDataTask *task, NSError *error) {
                                NSLog(@"Couldn't send kiss: %@, %@", error, error.userInfo);
                                [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
                            }];
    }];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary *)dict {
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict {
    CBPeripheral *peripheral = [dict[CBCentralManagerRestoredStatePeripheralsKey] firstObject];
    // TODO: there may be several peripherals
    self.activePeripherals[peripheral.identifier] = peripheral;
    if (peripheral.state == CBPeripheralStateConnected) {
        peripheral.delegate = self;
        if (peripheral.services.count == 0) {
            [self requestDiscoverServices:peripheral];
        } else {
            CBService *service = peripheral.services.firstObject;
            if (service.characteristics.count == 0) {
                [self requestDiscoverCharacteristics:peripheral
                                          forService:service];
            } else {
                CBCharacteristic *characteristic = service.characteristics.firstObject;
                if (characteristic.value == nil) {
                    [self requestReadValueForCharacteristic:characteristic
                                               onPeripheral:peripheral];
                } else {
                    // Well, data is there. Just kiss
                    [self kiss:characteristic.value];
                }
            }
        }
    }

}

@end
