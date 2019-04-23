//
//  Analytics.m
//  Coffup
//
//  Created by Roderic Campbell on 4/22/19.
//

#import "Analytics.h"
#import "Amplitude.h"
#import "SecretsStore.h"

@implementation Analytics

- (void)start {
    SecretsStore *store = [[SecretsStore alloc] init];
    [[Amplitude instance] initializeApiKey:store.amplitudeToken];
}

- (void)trackEvent:(NSString *)event {
    [self trackEvent:event withProperties:@{}];
}

- (void)trackEvent:(NSString *)event withProperties:(NSDictionary <NSString *, NSString *> *)properties {
    [[Amplitude instance] logEvent:event withEventProperties:properties];
}

@end
