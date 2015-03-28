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
        self.infectionDate = [NSDate date];
    }

    return self;
}

- (instancetype)initWithType:(NSString *)type originCoordinates:(CLLocationCoordinate2D)originCoordinates infectionDate:(NSDate *)infectionDate {
    self = [super init];
    if (self) {
        self.type = type;
        self.originCoordinates = originCoordinates;
        self.infectionDate = infectionDate;
    }

    return self;
}

+ (instancetype)infoWithType:(NSString *)type originCoordinates:(CLLocationCoordinate2D)originCoordinates infectionDate:(NSDate *)infectionDate {
    return [[self alloc] initWithType:type originCoordinates:originCoordinates infectionDate:infectionDate];
}


+ (instancetype)infoWithType:(NSString *)type {
    return [[self alloc] initWithType:type];
}


- (NSDictionary *)encodeToDictionary {
    return @{
            @"deviceId": [AppDelegate instance].deviceInfo.deviceId,
            @"location": @{
                    @"lat": @(self.originCoordinates.latitude),
                    @"ln": @(self.originCoordinates.longitude),
            },
            @"type": self.type,
            @"time": [[AppDelegate instance].defaultDateFormatter stringFromDate:self.infectionDate],
    };
}

+ (VirusInfo *)infoWithDictionary:(NSDictionary *)dictionary {
    NSString *type = dictionary[@"type"];
    CLLocationCoordinate2D coordinate2D = {
            [dictionary[@"location"][@"lat"] doubleValue],
            [dictionary[@"location"][@"ln"] doubleValue]
    };
    NSDate *date = [[AppDelegate instance].defaultDateFormatter dateFromString:dictionary[@"time"]];
    NSString *devId = dictionary[@"deviceId"];
    if (type && date && devId) {
        return [VirusInfo infoWithType:type originCoordinates:coordinate2D infectionDate:date];
    } else {
        return nil;
    }
}


@end
