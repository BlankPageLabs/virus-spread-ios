//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "swift-shim.h"


@interface DeviceInfo : NSObject

@property(nonatomic, retain) __nullable NSString *deviceId;
@property(nonatomic, retain) __nullable NSString *userName;
@property(nonatomic, retain) __nullable NSString *gender;
@property(nonatomic, assign) NSUInteger age;

- (__nonnull NSDictionary *)encodeToDictionary;

- (__nonnull id)initWithDictionary:(__nonnull NSDictionary *)dataDictionary;

+ (__nonnull id)infoWithDictionary:(__nonnull NSDictionary *)dataDictionary;


@end
