//
// Created by Илья Михальцов on 27.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface VirusInfo : NSObject



@property(nonatomic, retain) NSString *type;

@property(nonatomic, assign) CLLocationCoordinate2D originCoordinates;

@property(nonatomic, retain) NSDate *infectionDate;

- (instancetype)initWithType:(NSString *)type;

+ (instancetype)infoWithType:(NSString *)type;


- (NSDictionary *)encodeToDictionary;

+ (VirusInfo *)infoWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithType:(NSString *)type originCoordinates:(CLLocationCoordinate2D)originCoordinates infectionDate:(NSDate *)infectionDate;

+ (instancetype)infoWithType:(NSString *)type originCoordinates:(CLLocationCoordinate2D)originCoordinates infectionDate:(NSDate *)infectionDate;


@end
