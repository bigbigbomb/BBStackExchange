//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

#ifndef BBSTACKEXCHANGE_SITE_API_KEY
#define BBSTACKEXCHANGE_SITE_API_KEY  @"You should have defined BBSTACKEXCHANGE_SITE_API_KEY in your code. You can register for one at http://stackapps.com/apps/oauth/register"
#endif

@class BBStackAPISite;
@class BBStackAPICallData;

typedef void(^BBStackAPISuccessHandler)(AFHTTPRequestOperation *operation, BBStackAPICallData *callData, NSArray * results);
typedef void(^BBStackAPIFailureHandler)(NSHTTPURLResponse *response, NSError *error);

typedef enum {
    BBStackAPIUserSortReputation = 0,
    BBStackAPIUserSortCreation = 1,
    BBStackAPIUserSortName = 2,
    BBStackAPIUserSortModified = 3
} BBStackAPIUserSort;

typedef enum {
    BBStackAPISortOrderDescending = 0,
    BBStackAPISortOrderAscending = 1,
} BBStackAPISortOrder;

typedef enum {
    BBStackAPIQuestionSortActivity = 0,
    BBStackAPIQuestionSortVotes = 1,
    BBStackAPIQuestionSortCreation = 2,
    BBStackAPIQuestionSortHot = 3,
    BBStackAPIQuestionSortWeek = 4,
    BBStackAPIQuestionSortMonth = 5
} BBStackAPIQuestionSort;

typedef enum {
    BBStackAPIAnswerSortActivity = 0,
    BBStackAPIAnswerSortViews = 1,
    BBStackAPIAnswerSortCreation = 2,
    BBStackAPIAnswerSortVotes = 3
} BBStackAPIAnswerSort;

typedef enum {
    BBStackAPITagSortPopular = 0,
    BBStackAPITagSortActivity = 1,
    BBStackAPITagSortName = 2
} BBStackAPITagSort;

extern NSString * const kBBStackExchangeAPIVersion;

/**
 * An API client for accessing the StackExchange API
 * https://api.stackexchange.com/
 */
@interface BBStackExchangeAPIClient : AFHTTPClient


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
* A BBStackAPISite instance that correlates with the configuration for this API client. (read-only)
*/
@property(nonatomic, readonly, retain) BBStackAPISite *site;


/**
* Initializes and returns a BBStackExchangeAPIClient for the specified BBStackAPISite and access token.
* @param site The site this API client will make calls against.
* @param accessToken The access token that will be used for all API calls.
*/
- (id)initWithSite:(BBStackAPISite *)site accessToken:(NSString *)accessToken;

/**
* Get the tags that the user specified by the current accessToken has been active in.
* This call will fail if the API client does not have a valid accessToken.
* @returns an NSOperation for the /usrs/me/tags API call.
*/
- (AFHTTPRequestOperation *)operationForGetMeTagsFromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min
                                                    order:(BBStackAPISortOrder)order page:(NSNumber *)page
                                                 pageSize:(NSNumber *)pageSize sort:(BBStackAPITagSort)sort
                                                   toDate:(NSDate *)toDate
                                                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

/**
* Creates a request for the /usrs/me/tags API call and enqueues it in the default operation pool.
* Get the tags that the user specified by the current accessToken has been active in.
* This call will fail if the API client does not have a valid accessToken.
*/
- (void)getMeTagsFromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min order:(BBStackAPISortOrder)order
                     page:(NSNumber *)page pageSize:(NSNumber *)pageSize sort:(BBStackAPITagSort)sort
                   toDate:(NSDate *)toDate
                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;


/**
* Get the tags on the site.
* @returns an NSOperation for the /tags API call.
*/
- (AFHTTPRequestOperation *)operationForGetTagsWithInName:(NSString *)inName fromDate:(NSDate *)fromDate max:(NSNumber *)max
                                                      min:(NSNumber *)min order:(BBStackAPISortOrder)order
                                                     page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                                                     sort:(BBStackAPITagSort)sort toDate:(NSDate *)toDate
                                                  success:(BBStackAPISuccessHandler)success
                                                  failure:(BBStackAPIFailureHandler)failure;

/**
* Creates a request for the /tags API call and enqueues it in the default operation pool.
* Get the tags on the site.
*/
- (void)getTagsWithInName:(NSString *)inName fromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min
                    order:(BBStackAPISortOrder)order page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                     sort:(BBStackAPITagSort)sort toDate:(NSDate *)toDate
                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

/**
* Get the wiki entries for a set of tags.
* @returns an NSOperation for the /tags/{tags}/wikis API call.
*/
- (AFHTTPRequestOperation *)operationForGetWikisForTags:(NSArray *)tags
                                                success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

/**
* Creates a request for the /tags/{tags}/wikis API call and enqueues it in the default operation pool.
* Get the wiki entries for a set of tags.
*/
- (void)getWikisForTags:(NSArray *)tags
                success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

/**
* Get information about the entire site.
* @returns an NSOperation for the /info API call.
*/
- (AFHTTPRequestOperation *)operationForGetInfoWithFilter:(NSString *)filter
                                                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

/**
* Creates a request for the /info API call and enqueues it in the default operation pool.
* Get information about the entire site.
*/
- (void)getInfoWithFilter:(NSString *)filter
                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;


/**
* Get all questions on the site.
* @returns an NSOperation for the /questions API call.
*/
- (AFHTTPRequestOperation *)operationForGetQuestionsAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize
                                                  fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
                                                     order:(BBStackAPISortOrder)order min:(NSNumber *)min
                                                       max:(NSNumber *)max sort:(BBStackAPIQuestionSort)sort
                                                    tagged:(NSArray *)tagged filter:(NSString *)filter
                                                   success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

/**
* Creates a request for the /questions API call and enqueues it in the default operation pool.
* Get all questions on the site.
* @returns an NSOperation for the /questions API call.
*/
- (AFHTTPRequestOperation *)getQuestionsAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize
                                      fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
                                         order:(BBStackAPISortOrder)order min:(NSNumber *)min max:(NSNumber *)max
                                          sort:(BBStackAPIQuestionSort)sort tagged:(NSArray *)tagged
                                        filter:(NSString *)filter
                                       success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;


/**
* Get the questions identified by a set of ids.
* @returns an NSOperation for the /questions/{ids} API call.
*/
- (AFHTTPRequestOperation *)getQuestionIDs:(NSArray *)questionIDs page:(NSNumber *)page
                                  pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
                                     order:(BBStackAPISortOrder)order min:(NSNumber *)min max:(NSNumber *)max
                                      sort:(BBStackAPIQuestionSort)sort filter:(NSString *)filter
                                   success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

/**
* Creates a request for the /questions/{ids} API call and enqueues it in the default operation pool.
* Get the questions identified by a set of ids.
* @returns an NSOperation for the /questions/{ids} API call.
*/
- (AFHTTPRequestOperation *)operationForGetQuestionIDs:(NSArray *)questionIDs page:(NSNumber *)page
                                              pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate
                                                toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order
                                                   min:(NSNumber *)min max:(NSNumber *)max
                                                  sort:(BBStackAPIQuestionSort)sort filter:(NSString *)filter
                                               success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

/**
* Get answers identified by a set of ids.
* @returns an NSOperation for the /answers/{ids} API call.
*/
- (AFHTTPRequestOperation *)getAnswerIDs:(NSArray *)answerIDs page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                                fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order
                                     min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIAnswerSort)sort
                                  filter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

/**
* Creates a request for the /answers/{ids} API call and enqueues it in the default operation pool.
* Get answers identified by a set of ids.
* @returns an NSOperation for the /answers/{ids} API call.
*/
- (AFHTTPRequestOperation *)operationForGetAnswerIDs:(NSArray *)answerIDs page:(NSNumber *)page
                                            pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate
                                              toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order
                                                 min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIAnswerSort)sort
                                              filter:(NSString *)filter
                                             success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

/**
* Creates a request for the /questions/{ids}/answers API call and enqueues it in the default operation pool.
* Get the answers to the questions identified by an array of BBStackAPIQuestion objects.
* @returns an NSOperation for the /questions/{ids}/answers API call.
*/
- (void)getAnswersForQuestions:(NSArray *)questions page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                      fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order
                           min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIAnswerSort)sort
                        filter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

/**
* Creates a request for the /sites API call and enqueues it in the default operation pool.
* Get all the sites in the Stack Exchange network.
* @returns an NSOperation for the /sites API call.
*/
- (void)getSitesAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize minimal:(bool)minimal
               success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

@end