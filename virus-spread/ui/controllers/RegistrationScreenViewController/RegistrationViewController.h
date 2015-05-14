//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "swift-shim.h"

@class DeviceInfo;

@interface RegistrationViewController : UIViewController

@property(nonatomic, retain, readonly, nullable) DeviceInfo *deviceInfo;

@end
