//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VirusInfo;


@interface InfectionManager : NSObject

@property(nonatomic, assign, getter=isInfected) BOOL infected;

@property(nonatomic, retain) VirusInfo *virus;

- (void)infectWith:(VirusInfo *)virus;

- (void)cure;

@end
