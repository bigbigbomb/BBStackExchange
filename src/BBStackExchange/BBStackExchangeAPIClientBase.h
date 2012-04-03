//
//  Created by Brian Romanko on 4/3/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

#ifndef BBSTACKEXCHANGE_SITE_API_KEY
#define BBSTACKEXCHANGE_SITE_API_KEY  @"You should have defined BBSTACKEXCHANGE_SITE_API_KEY in your code. You can register for one at http://stackapps.com/apps/oauth/register"
#endif


@class BBStackAPICallData;

typedef void(^BBStackAPISuccessHandler)(AFHTTPRequestOperation *operation, BBStackAPICallData *callData, NSArray * results);
typedef void(^BBStackAPIFailureHandler)(NSHTTPURLResponse *response, NSError *error);


/**
* The current version of the API implemented by this client.
*/
extern NSString * const kBBStackExchangeAPIVersion;


@interface BBStackExchangeAPIClientBase : AFHTTPClient

/**
* The request key sent with each API call. This is not required but omitting it severly restricts the number of allowed requests.
* You can register for an API key at http://stackapps.com/apps/oauth/register.
*/
@property (nonatomic, copy) NSString *apiKey;

/**
* An OAUTH access token that can be provided for API calls requiring authentication.
* See https://api.stackexchange.com/docs/authentication for instructions on getting an access token.
* This API client does not cover the OAUTH process of obtaining an access token.
*/
@property(nonatomic, copy) NSString *accessToken;


/**
* Initializes and returns a BBStackExchangeAPIClient for the specified user access token.
* @param accessToken The access token that will be used for all API calls.
*/
- (id)initWithAccessToken:(NSString *)accessToken;

@end