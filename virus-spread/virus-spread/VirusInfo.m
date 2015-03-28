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
        self.deviceId = [AppDelegate instance].deviceInfo.deviceId;
    }

    return self;
}

- (instancetype)initWithType:(NSString *)type
           originCoordinates:(CLLocationCoordinate2D)originCoordinates
               infectionDate:(NSDate *)infectionDate
                    deviceId:(NSString *)deviceId {
    self = [super init];
    if (self) {
        self.type = type;
        self.originCoordinates = originCoordinates;
        self.infectionDate = infectionDate;
        self.deviceId = deviceId;
    }

    return self;
}

+ (instancetype)infoWithType:(NSString *)type
           originCoordinates:(CLLocationCoordinate2D)originCoordinates
               infectionDate:(NSDate *)infectionDate
                    deviceId:(NSString *)deviceId {
    return [[self alloc] initWithType:type
                    originCoordinates:originCoordinates
                        infectionDate:infectionDate
                             deviceId: deviceId];
}


+ (instancetype)infoWithType:(NSString *)type {
    return [[self alloc] initWithType:type];
}


- (NSDictionary *)encodeToDictionary {
    return @{
            @"deviceId": self.deviceId,
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
        return [VirusInfo infoWithType:type originCoordinates:coordinate2D infectionDate:date deviceId:devId];
    } else {
        return nil;
    }
}


@end
