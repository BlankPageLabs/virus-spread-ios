//
//  ErrorControllerExceptionShim.m
//  velo
//
//  Created by Илья Михальцов on 12.11.14.
//  Copyright (c) 2014 CommonSense Projects. All rights reserved.
//

#import "ErrorControllerExceptionShim.h"
#import "virus_spread-Swift.h"

static ErrorController *localErrorController;


void errorControllerShim_exceptionHandler(NSException *exception) {
    [localErrorController exceptionHandler: exception];
}

void errorControllerShim_signalHandler(int signal) {
    [localErrorController signalHandler: signal];
}


@implementation ErrorControllerExceptionShim

- (instancetype)initWithErrorController:(ErrorController *)controller {
    self = [super init];

    static dispatch_once_t onceToken;

    if (self) {
        dispatch_once(&onceToken, ^{
            localErrorController = controller;
        });
    }
    return self;
}

- (NSUncaughtExceptionHandler *)exceptionHandlerShim {
    return errorControllerShim_exceptionHandler;
}

- (void(*)(int))signalHandlerShim {
    return errorControllerShim_signalHandler;
}

- (void)invokeSignalHandler:(void(*)(int))handler withSignal:(int)signal {
    if (handler) {
        handler(signal);
    }
}

- (void)invokeExceptionHandler:(NSUncaughtExceptionHandler *)handler withException:(NSException *)exception {
    if (handler) {
        handler(exception);
    }
}

@end

