//
// Created by Илья Михальцов on 27.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import "VirusInfo.h"
#import "virus_spread-Swift.h"
#import "DeviceInfo.h"


@implementation VirusInfo {

}
- (instancetype)initWithType:(NSString *)type {
    self = [super init];
    if (self) {
        self.type = type;
        self.originCoordinates = [LocationHelper locationSynchronous:[AppDelegate instance].locaionManager];
    }

    return self;
}

+ (instancetype)infoWithType:(NSString *)type {
    return [[self alloc] initWithType:type];
}


- (NSDictionary *)encodeToDictionary {
    return @{
            @"deviceId": [AppDelegate instance].deviceInfo.deviceId,
            @"location": @{
                    @"lat": @(self.originCoordinates.latitude),
                    @"lon": @(self.originCoordinates.longitude),
            },
            @"type": self.type,
            @"time": [[AppDelegate instance].defaultDateFormatter stringFromDate:self.infectionDate],
    };
}

@end
