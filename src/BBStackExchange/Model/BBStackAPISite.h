//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackAPIModelBase.h"

typedef enum {
    BBStackAPISiteStateUnknown,
    BBStackAPISiteStateNormal,
    BBStackAPISiteStateLinkedMeta,
    BBStackAPISiteStateOpenBeta
} BBStackAPISiteState;

@interface BBStackAPISite : BBStackAPIModelBase

@property (nonatomic, readonly) NSString *apiSiteParameter;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSURL *logoURL;
@property (nonatomic, readonly) NSURL *siteURL;
@property (nonatomic, readonly) NSString *siteDescription;
@property (nonatomic, readonly) NSURL *iconURL;
@property (nonatomic, readonly) BBStackAPISiteState state;
@property (nonatomic, readonly) NSURL *faviconURL;
@property (nonatomic, readonly) NSDate *creationDate;
@property (nonatomic, readonly) NSString *twitterAccount;

- (id)initWithApiSiteParameter:(NSString *)apiSiteParameter siteURL:(NSURL *)siteURL siteName:(NSString *)siteName;

@end