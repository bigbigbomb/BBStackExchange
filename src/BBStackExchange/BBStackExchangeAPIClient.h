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

@interface BBStackExchangeAPIClient : AFHTTPClient

@property (nonatomic, copy) NSString *apiKey;
@property(nonatomic, copy) NSString *accessToken;
@property(nonatomic, readonly, retain) BBStackAPISite *site;

- (id)initWithAccessToken:(NSString *)accessToken;

- (id)initWithSite:(BBStackAPISite *)site accessToken:(NSString *)accessToken;

- (AFHTTPRequestOperation *)operationForGetMeTagsFromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min
                                                    order:(BBStackAPISortOrder)order page:(NSNumber *)page
                                                 pageSize:(NSNumber *)pageSize sort:(BBStackAPITagSort)sort
                                                   toDate:(NSDate *)toDate
                                                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (void)getMeTagsFromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min order:(BBStackAPISortOrder)order
                     page:(NSNumber *)page pageSize:(NSNumber *)pageSize sort:(BBStackAPITagSort)sort
                   toDate:(NSDate *)toDate
                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (AFHTTPRequestOperation *)operationForGetTagsWithInName:(NSString *)inName fromDate:(NSDate *)fromDate max:(NSNumber *)max
                                                      min:(NSNumber *)min order:(BBStackAPISortOrder)order
                                                     page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                                                     sort:(BBStackAPITagSort)sort toDate:(NSDate *)toDate
                                                  success:(BBStackAPISuccessHandler)success
                                                  failure:(BBStackAPIFailureHandler)failure;

- (void)getTagsWithInName:(NSString *)inName fromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min
                    order:(BBStackAPISortOrder)order page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                     sort:(BBStackAPITagSort)sort toDate:(NSDate *)toDate
                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (AFHTTPRequestOperation *)operationForGetWikisForTags:(NSArray *)tags
                                                success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (void)getWikisForTags:(NSArray *)tags
                success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (AFHTTPRequestOperation *)operationForGetInfoWithFilter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (void)getInfoWithFilter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (AFHTTPRequestOperation *)getQuestionsAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIQuestionSort)sort tagged:(NSArray *)tagged filter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (AFHTTPRequestOperation *)operationForGetQuestionsAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIQuestionSort)sort tagged:(NSArray *)tagged filter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;


- (AFHTTPRequestOperation *)getQuestionIDs:(NSArray *)questionIDs page:(NSNumber *)page pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIQuestionSort)sort filter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (AFHTTPRequestOperation *)operationForGetQuestionIDs:(NSArray *)questionIDs page:(NSNumber *)page pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIQuestionSort)sort filter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (AFHTTPRequestOperation *)getAnswerIDs:(NSArray *)answerIDs page:(NSNumber *)page pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIAnswerSort)sort filter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (AFHTTPRequestOperation *)operationForGetAnswerIDs:(NSArray *)answerIDs page:(NSNumber *)page pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIAnswerSort)sort filter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

- (void)getAnswersForQuestions:(NSArray *)questions page:(NSNumber *)page pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIAnswerSort)sort filter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

//- (AFHTTPRequestOperation *)searchForQuestionsTagged:(NSArray *)tags notTagged:(NSArray *)notTagged inTitle:(NSString *)inTitle
//                             max:(NSNumber *)max min:(NSNumber *)min order:(BBStackAPISortOrder)order
//                            page:(NSNumber *)page pageSize:(NSNumber *)pageSize sort:(BBStackAPIQuestionSort)sort
//                          toDate:(NSDate *)toDate
//                         success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;
//
//- (AFHTTPRequestOperation *)operationForSearchForQuestionsTagged:(NSArray *)tags notTagged:(NSArray *)notTagged
//                                                         inTitle:(NSString *)inTitle max:(NSNumber *)max
//                                                             min:(NSNumber *)min order:(BBStackAPISortOrder)order
//                                                            page:(NSNumber *)page pageSize:(NSNumber *)pageSize
//                                                            sort:(BBStackAPIQuestionSort)sort toDate:(NSDate *)toDate
//                                                         success:(BBStackAPISuccessHandler)success
//                                                         failure:(BBStackAPIFailureHandler)failure;


- (void)getSitesAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize filter:(NSString *)filter
               success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure;

@end