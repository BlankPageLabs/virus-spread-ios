//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "swift-shim.h"


@interface DeviceInfo : NSObject

@property(nonatomic, retain, nullable) NSString *deviceId;
@property(nonatomic, retain, nullable) NSString *userName;
@property(nonatomic, retain, nullable) NSString *gender;
@property(nonatomic, retain, nullable) NSDate *birthdate;

- (nonnull NSDictionary *)encodeToDictionary;

- (nonnull id)initWithDictionary:(nonnull NSDictionary *)dataDictionary;

+ (nonnull id)infoWithDictionary:(nonnull NSDictionary *)dataDictionary;


@end
