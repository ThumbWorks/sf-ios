//
//  SecretsStore.m
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "SecretsStore.h"

@interface SecretsStore ()

@property (nonatomic) NSDictionary<NSString *, NSString *> *secrets;

@end

@implementation SecretsStore

- (instancetype)init {
    if (self = [super init]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:secretsFileName ofType:@"plist"];
        self.secrets = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        NSAssert(self.secrets != nil, @"Configure secrets by following instructions in Readme.");
    }
    return self;
}

- (NSString *)amplitudeToken {
    return self.secrets[@"amplitude-token"];
}

- (NSString *)uberClientID {
    return self.secrets[@"uber-client-id"];
}

- (NSString *)uberServerToken {
    return self.secrets[@"uber-server-token"];
}

- (NSString *)lyftClientID {
    return self.secrets[@"lyft-client-id"];
}

-(NSString *)lyftServerToken {
    return self.secrets[@"lyft-client-secret"];
}

@end
