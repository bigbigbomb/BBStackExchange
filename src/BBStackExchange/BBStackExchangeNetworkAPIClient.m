//
//  Created by Brian Romanko on 4/3/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackExchangeNetworkAPIClient.h"
#import "BBStackExchangeAPIClientBase+Protected.h"
#import "BBStackAPISite.h"
#import "BBStackExchangeAPIClient.h"
#import "BBStackAPINetworkUser.h"


@implementation BBStackExchangeNetworkAPIClient

- (AFHTTPRequestOperation *)getSitesAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize filter:(NSString *)filter
         success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [userParams setValue:page forKey:@"page"];
    [userParams setValue:pageSize forKey:@"pagesize"];
    [userParams setValue:filter forKey:@"filter"];

    NSDictionary *queryString = [self buildParameters:userParams];
    AFHTTPRequestOperation *operation = [self operationForGetPath:@"sites" parameters:queryString
          success:^(AFHTTPRequestOperation *request, id body) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClientBase callDataFromAttributes:body];
              NSArray *results = [BBStackAPISite getObjectArrayFromAttributes:body];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error){
              [self handleFailure:request error:error failure:failure];
        }
    ];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)getMeAssociated:(NSNumber *)page pageSize:(NSNumber *)pageSize filter:(NSString *)filter
               success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [userParams setValue:page forKey:@"page"];
    [userParams setValue:pageSize forKey:@"pagesize"];
    [userParams setValue:filter forKey:@"filter"];

    NSDictionary *queryString = [self buildParameters:userParams];
    return [self operationForGetPath:@"me/associated" parameters:queryString
          success:^(AFHTTPRequestOperation *request, id body) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClient callDataFromAttributes:body];
              NSArray *results = [BBStackAPINetworkUser getObjectArrayFromAttributes:body];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error){
              [self handleFailure:request error:error failure:failure];
        }
    ];
}

@end