//
//  Created by Brian Romanko on 4/3/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackExchangeAPIClientBase.h"

/**
 * An API client for accessing the StackExchange API network methods.
 * These methods return data across the entire Stack Exchange network of sites. Accordingly, you do not pass a site parameter to them.
 * https://api.stackexchange.com/
 */
@interface BBStackExchangeNetworkAPIClient : BBStackExchangeAPIClientBase

/**
* Creates a request for the /sites API call and enqueues it in the default operation pool.
* Get all the sites in the Stack Exchange network.
* @returns an NSOperation for the /sites API call.
*/
- (AFHTTPRequestOperation *)getSitesAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize filter:(NSString *)filter
               success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;


@end