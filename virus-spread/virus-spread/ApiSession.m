//
// Created by Илья Михальцов on 28.3.15.
// Copyright (c) 2015 morpheby. All rights reserved.
//

#import "ApiSession.h"
@import AFNetworking;

@implementation ApiSession {
}

- (instancetype)init {
    self = [super initWithBaseURL:[[NSURL alloc] initWithString:@"http://virusspread.blankpagelabs.com/api"]];
    if (self) {
        self.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
        self.requestSerializer.HTTPMethodsEncodingParametersInURI =
                [self.requestSerializer.HTTPMethodsEncodingParametersInURI setByAddingObject:@"POST"];
        self.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    }

    return self;
}


+ (ApiSession *)instance {
    static ApiSession *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

@end
