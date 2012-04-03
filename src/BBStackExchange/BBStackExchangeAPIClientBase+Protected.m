//
//  Created by Brian Romanko on 4/3/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackExchangeAPIClientBase+Protected.h"
#import "BBStackAPICallData.h"
#import "AFHTTPRequestOperation.h"


@implementation BBStackExchangeAPIClientBase (Protected)

- (NSDictionary *)buildParameters:(NSDictionary *)parameters {
    NSMutableDictionary *updatedParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [updatedParameters setValue:self.apiKey forKey:@"key"];
    if (!(self.accessToken == nil || [self.accessToken length] == 0))
        [updatedParameters setValue:self.accessToken forKey:@"access_token"];
    return updatedParameters;
}

+ (BBStackAPICallData *)callDataFromAttributes:(NSDictionary *)attributes {
    NSUInteger quotaRemaining = (NSUInteger) [[attributes valueForKey:@"quota_remaining"] unsignedIntValue];
    NSUInteger quotaMax = (NSUInteger) [[attributes valueForKey:@"quota_max"] unsignedIntValue];
    bool hasMore = (bool) [[attributes valueForKey:@"has_more"] boolValue];

    BBStackAPICallData *callData = [[[BBStackAPICallData alloc] initWithQuotaRemaining:quotaRemaining quotaMax:quotaMax hasMore:hasMore] autorelease];

    callData.total = (NSUInteger) [[attributes valueForKey:@"total"] intValue];
    callData.page = (NSUInteger) [[attributes valueForKey:@"page"] intValue];
    callData.pageSize = (NSUInteger) [[attributes valueForKey:@"page_size"] intValue];
    callData.type = [attributes valueForKey:@"type"];

    return callData;
}

- (void)handleFailure:(AFHTTPRequestOperation *)request error:(NSError *)error failure:(BBStackAPIFailureHandler)failure {
    NSLog(@"An error occurred making an API call. %@", error);
    NSLog(@"Error response was %@", request.responseString);
    if (failure != nil)
        failure(request.response, error);
}

- (AFHTTPRequestOperation *)operationForGetPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    return [self HTTPRequestOperationWithRequest:request success:success failure:failure];
}

@end