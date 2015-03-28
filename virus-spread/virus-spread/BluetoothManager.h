//
// Created by Илья Михальцов on 27.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BluetoothManager : NSObject

- (void)requestActivatePeripheralManager;

- (void)requestActivateCentralManager;

- (void)deactivatePeripheralManager;

- (void)deactivateCentralManager;

@end
