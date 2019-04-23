//
//  SecretsStore.h
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const secretsFileName = @"secrets";

/**
 An access wrapper for the Secrets/secrets.plist.
 If you are seeing warnings about missing secrets, and correspondingly,
 missing functionality, please follow instructions in Readme to setup secrets.
 */
@interface SecretsStore : NSObject

@property (readonly, nonatomic) NSString *amplitudeToken;
@property (readonly, nonatomic) NSString *uberClientID;
@property (readonly, nonatomic) NSString *uberServerToken;
@property (readonly, nonatomic) NSString *lyftClientID;
@property (readonly, nonatomic) NSString *lyftServerToken;

@end

NS_ASSUME_NONNULL_END
