//
//  ErrorControllerExceptionShim.h
//  velo
//
//  Created by Илья Михальцов on 12.11.14.
//  Copyright (c) 2014 CommonSense Projects. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ErrorController;

@interface ErrorControllerExceptionShim : NSObject

- (instancetype)initWithErrorController:(ErrorController *)controller;

- (NSUncaughtExceptionHandler *)exceptionHandlerShim;

- (void(*)(int))signalHandlerShim;

- (void)invokeSignalHandler:(void(*)(int))handler withSignal:(int)signal;

- (void)invokeExceptionHandler:(NSUncaughtExceptionHandler *)handler withException:(NSException *)exception;

@end

