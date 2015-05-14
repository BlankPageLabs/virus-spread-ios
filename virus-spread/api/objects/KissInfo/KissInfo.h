//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class VirusInfo;


@interface KissInfo : NSObject

@property(nonatomic, retain) NSString *deviceId;

@property(nonatomic, retain) NSString *foreignId;

@property(nonatomic, assign) CLLocationCoordinate2D location;

@property(nonatomic, retain) NSDate *time;

- (instancetype)initWithForeignId:(NSString *)foreignId
                         location:(CLLocationCoordinate2D)location
                             time:(NSDate *)time
                         deviceId:(NSString *)deviceId;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithVirusInfo:(VirusInfo *)strain;

+ (instancetype)infoWithForeignId:(NSString *)foreignId
                         location:(CLLocationCoordinate2D)location
                             time:(NSDate *)time
                         deviceId:(NSString *)deviceId;

+ (instancetype)infoWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)infoWithVirusInfo:(VirusInfo *)strain;

- (NSDictionary *)encodeToDictionary;

@end
