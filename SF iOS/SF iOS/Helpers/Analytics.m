//
//  Analytics.m
//  Coffup
//
//  Created by Roderic Campbell on 4/22/19.
//

#import "Analytics.h"
#import "SecretsStore.h"
#import <CloudKit/CloudKit.h>

@implementation Analytics

- (void)trackEvent:(NSString *)event
    withProperties:(NSDictionary <NSString *, id> *)properties
      onCompletion:(TrackingComplete)onCompletion {

    CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
    CKRecord *record = [[CKRecord alloc] initWithRecordType:@"backgroundFetchComplete"];
    [record setValuesForKeysWithDictionary:properties];
    [database saveRecord:record
       completionHandler:^(CKRecord * _Nullable record,
                           NSError * _Nullable error) {
           if (onCompletion) {
               onCompletion(error);
           }
    }];
}

@end
