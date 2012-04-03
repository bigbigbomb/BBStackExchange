//
//  Created by Brian Romanko on 4/3/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackExchangeAPIClientBase.h"

@interface BBStackExchangeAPIClientBase (Protected)

- (NSDictionary *)buildParameters:(NSDictionary *)parameters;

+ (BBStackAPICallData *)callDataFromAttributes:(NSDictionary *)dictionary;

- (void)handleFailure:(AFHTTPRequestOperation *)request error:(NSError *)error failure:(BBStackAPIFailureHandler)failure;

- (AFHTTPRequestOperation *)operationForGetPath:(NSString *)path parameters:(NSDictionary *)parameters
                                        success:(void (^)(AFHTTPRequestOperation *, id))success
                                        failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;


@end