//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "swift-shim.h"


@interface DeviceInfo : NSObject

@property(nonatomic, retain) NSString * __nullable deviceId;
@property(nonatomic, retain) NSString * __nullable userName;
@property(nonatomic, retain) NSString * __nullable gender;
@property(nonatomic, assign) NSUInteger age;

- (NSDictionary * __nonnull)encodeToDictionary;

- (id __nonnull)initWithDictionary:(NSDictionary * __nonnull)dataDictionary;

+ (id __nonnull)infoWithDictionary:(NSDictionary * __nonnull)dataDictionary;


@end
