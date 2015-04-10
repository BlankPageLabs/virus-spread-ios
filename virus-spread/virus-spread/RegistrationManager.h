//
// Created by Илья Михальцов on 10.4.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RegistrationManager : NSObject

- (void)requestUserRetrievalWithSuccess:(void(^)())successBlock
                                failure:(void(^)())failureBlock;


- (void)requestUserRetrievalOrRegistrationWithSuccess:(void (^)())successBlock
                                              failure:(void (^)())failureBlock;

- (void)requestUserRegistrationWithSuccess:(void (^)())successBlock
                                   failure:(void (^)())failureBlock;

@end
