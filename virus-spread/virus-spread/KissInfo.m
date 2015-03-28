//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import "KissInfo.h"
#import "VirusInfo.h"
#import "virus_spread-Swift.h"
#import "DeviceInfo.h"


@implementation KissInfo {

}
- (instancetype)initWithForeignId:(NSString *)foreignId
                         location:(CLLocationCoordinate2D)location
                             time:(NSDate *)time
                         deviceId:(NSString *)deviceId {
    self = [super init];
    if (self) {
        self.foreignId = foreignId;
        self.location = location;
        self.time = time;
        self.deviceId = deviceId;
    }

    return self;
}

+ (instancetype)infoWithForeignId:(NSString *)foreignId
                         location:(CLLocationCoordinate2D)location
                             time:(NSDate *)time
                         deviceId:(NSString *)deviceId {
    return [[self alloc] initWithForeignId:foreignId location:location time:time deviceId:deviceId];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.deviceId = dictionary[@"deviceId"];
        self.foreignId = dictionary[@"foreignId"];
        self.location = CLLocationCoordinate2DMake(
                [dictionary[@"location"][@"lat"] doubleValue],
                [dictionary[@"location"][@"ln"] doubleValue]
        );
        self.time = [[AppDelegate instance].defaultDateFormatter dateFromString:dictionary[@"time"]];
        if (!self.deviceId || !self.foreignId || !self.time) {
            self = nil;
        }
    }
    return self;
}

+ (instancetype)infoWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (NSDictionary *)encodeToDictionary {
    return @{
            @"foreignId": self.foreignId,
            @"location": @{@"lat": @(self.location.latitude), @"ln": @(self.location.longitude)},
            @"time": [[AppDelegate instance].defaultDateFormatter stringFromDate:self.time],
            @"deviceId": self.deviceId,
    };
}

- (instancetype)initWithVirusInfo:(VirusInfo *)strain {
    self = [super init];
    if (self) {
        self.deviceId = [AppDelegate instance].deviceInfo.deviceId;
        self.foreignId = strain.deviceId;
        self.location = [LocationHelper locationSynchronous:[AppDelegate instance].locaionManager];
        self.time = [NSDate date];
    }
    return self;
}

+ (instancetype)infoWithVirusInfo:(VirusInfo *)strain {
    return [[self alloc] initWithVirusInfo:strain];
}


@end
