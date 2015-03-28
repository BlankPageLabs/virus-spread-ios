//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//


@import UIKit;
#import "DeviceInfo.h"


@implementation DeviceInfo {

}

- (instancetype)init {
    self = [super init];
    if (self) {
    }

    return self;
}


- (instancetype)initWithDictionary:(NSDictionary *)dataDictionary {
    self = [super init];
    if (self) {
        self.deviceId = dataDictionary[@"deviceId"];
        self.userName = dataDictionary[@"name"];
        self.age = [dataDictionary[@"age"] unsignedIntegerValue];
        self.gender = dataDictionary[@"gender"];
    }

    return self;
}

+ (instancetype)infoWithDictionary:(NSDictionary *)dataDictionary {
    return [[self alloc] initWithDictionary:dataDictionary];
}

- (NSDictionary *)encodeToDictionary {
    return @{
            @"deviceId": self.deviceId,
            @"name": self.userName,
            @"gender": self.gender,
            @"age": @(self.age),
            };
}



@end
