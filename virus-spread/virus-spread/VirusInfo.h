//
// Created by Илья Михальцов on 27.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface VirusInfo : NSObject <NSCoding>

@property(nonatomic, retain) NSString *type;

@property(nonatomic, assign) CLLocationCoordinate2D originCoordinates;

- (NSDictionary *)encodeToDictionary;

@end
