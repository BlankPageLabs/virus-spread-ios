//
// Created by Илья Михальцов on 27.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import "VirusInfo.h"
#import "virus_spread-Swift.h"
#import "DeviceInfo.h"


@implementation VirusInfo {

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
