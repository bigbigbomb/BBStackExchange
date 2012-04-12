//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackExchangeAPIClient.h"
#import "BBStackAPISite.h"
#import "NSString+Formatting.h"
#import "BBStackAPITag.h"
#import "NSArray+Formatting.h"
#import "BBStackAPITagWiki.h"
#import "BBStackAPISiteInfo.h"
#import "BBStackAPIQuestion.h"
#import "BBStackAPIAnswer.h"
#import "AFNetworking.h"
#import "BBStackAPICallData.h"
#import "BBStackExchangeAPIClientBase+Protected.h"


@interface BBStackExchangeAPIClient ()

// \cond
@property(nonatomic, readwrite, retain) BBStackAPISite *site;
// \endcond

@end


@implementation BBStackExchangeAPIClient

@synthesize site = _site;

- (id)initWithSite:(BBStackAPISite *)site accessToken:(NSString *)accessToken {
    self = [self initWithAccessToken:accessToken];
    if (self) {
        _site = [site retain];
    }

    return self;
}

- (void)dealloc {
    [_site release];
    [super dealloc];
}

- (NSDictionary *)buildParameters:(NSDictionary *)parameters {
    NSMutableDictionary *updatedParameters = [[[super buildParameters:parameters] mutableCopy] autorelease];
    [updatedParameters setValue:self.site.apiSiteParameter forKey:@"site"];
    return updatedParameters;
}


#pragma mark - Request Operations

- (AFHTTPRequestOperation *)operationForGetMeTagsFromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min
                                                    order:(BBStackAPISortOrder)order page:(NSNumber *)page
                                                 pageSize:(NSNumber *)pageSize sort:(BBStackAPITagSort)sort
                                                   toDate:(NSDate *)toDate
                                                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:8];
    if (fromDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[fromDate timeIntervalSince1970]] forKey:@"fromDate"];
    [userParams setValue:max forKey:@"max"];
    [userParams setValue:min forKey:@"min"];
    [userParams setValue:[NSString stringWithBBStackAPISortOrder:order] forKey:@"order"];
    [userParams setValue:page forKey:@"page"];
    [userParams setValue:pageSize forKey:@"pagesize"];
    [userParams setValue:[NSString stringWithBBStackAPITagSort:sort] forKey:@"sort"];
    if (toDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[toDate timeIntervalSince1970]] forKey:@"toDate"];

    NSDictionary *queryString = [self buildParameters:userParams];
    return [self operationForGetPath:@"me/tags" parameters:queryString
          success:^(AFHTTPRequestOperation *request, id body) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClientBase callDataFromAttributes:body];
              NSArray *results = [BBStackAPITag getObjectArrayFromAttributes:body inSite:self.site];
              if (success)
                success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}


- (AFHTTPRequestOperation *)getMeTagsFromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min
                                            order:(BBStackAPISortOrder)order page:(NSNumber *)page
                                         pageSize:(NSNumber *)pageSize sort:(BBStackAPITagSort)sort
                                           toDate:(NSDate *)toDate
                                          success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    AFHTTPRequestOperation *operation = [self operationForGetMeTagsFromDate:fromDate max:max min:min
                                  order:order page:page pageSize:pageSize
                                   sort:sort toDate:toDate
                                success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)operationForGetTagsWithInName:(NSString *)inName fromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min
                    order:(BBStackAPISortOrder)order page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                     sort:(BBStackAPITagSort)sort toDate:(NSDate *)toDate
                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:9];
    NSString *modifiedInName = [[inName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    [userParams setValue:modifiedInName forKey:@"inname"];
    if (fromDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[fromDate timeIntervalSince1970]] forKey:@"fromDate"];
    [userParams setValue:max forKey:@"max"];
    [userParams setValue:min forKey:@"min"];
    [userParams setValue:[NSString stringWithBBStackAPISortOrder:order] forKey:@"order"];
    [userParams setValue:page forKey:@"page"];
    [userParams setValue:pageSize forKey:@"pagesize"];
    [userParams setValue:[NSString stringWithBBStackAPITagSort:sort] forKey:@"sort"];
    if (toDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[toDate timeIntervalSince1970]] forKey:@"toDate"];

    NSDictionary *queryString = [self buildParameters:userParams];
    return [self operationForGetPath:@"tags" parameters:queryString
          success:^(AFHTTPRequestOperation *request, id body) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClientBase callDataFromAttributes:body];
              NSArray *results = [BBStackAPITag getObjectArrayFromAttributes:body inSite:self.site];
              if (success)
                success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}


- (AFHTTPRequestOperation *)getTagsWithInName:(NSString *)inName fromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min
                    order:(BBStackAPISortOrder)order page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                     sort:(BBStackAPITagSort)sort toDate:(NSDate *)toDate
                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    AFHTTPRequestOperation *operation = [self operationForGetTagsWithInName:inName fromDate:fromDate max:max min:min
                                  order:order page:page pageSize:pageSize
                                   sort:sort toDate:toDate
                                success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)operationForGetWikisForTags:(NSArray *)tags filter:(NSString *)filter
                                                success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSString *tagNames = [tags asStringWithObjectsFromBlock:^(id item, NSUInteger index) {
        BBStackAPITag *tag = item;
        return AFURLEncodedStringFromStringWithEncoding(tag.name, NSUTF8StringEncoding);
    } joinedByString:@";"];
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [userParams setValue:filter forKey:@"filter"];
    NSDictionary *queryString = [self buildParameters:userParams];
    return [self operationForGetPath:[NSString stringWithFormat:@"tags/%@/wikis", tagNames] parameters:queryString
          success:^(AFHTTPRequestOperation *request, id successBody) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClientBase callDataFromAttributes:successBody];
              NSArray *results = [BBStackAPITagWiki getObjectArrayFromAttributes:successBody inSite:self.site];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}

- (AFHTTPRequestOperation *)getWikisForTags:(NSArray *)tags filter:(NSString *)filter
                                    success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    AFHTTPRequestOperation *operation = [self operationForGetWikisForTags:tags filter:filter success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)operationForGetInfoWithFilter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:12];
    [userParams setValue:filter forKey:@"filter"];
    NSDictionary *queryString = [self buildParameters:userParams];
    return [self operationForGetPath:@"info" parameters:queryString
          success:^(AFHTTPRequestOperation *request, id body) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClientBase callDataFromAttributes:body];
              NSArray *results = [BBStackAPISiteInfo getObjectArrayFromAttributes:body inSite:self.site];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}

- (AFHTTPRequestOperation *)getInfoWithFilter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    AFHTTPRequestOperation *operation = [self operationForGetInfoWithFilter:filter success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)getQuestionsAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate
                                        toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order min:(NSNumber *)min
                                           max:(NSNumber *)max sort:(BBStackAPIQuestionSort)sort tagged:(NSArray *)tagged
                                        filter:(NSString *)filter
                                       success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    AFHTTPRequestOperation *operation = [self operationForGetQuestionsAtPage:page pageSize:pageSize fromDate:fromDate toDate:toDate order:order min:min max:max sort:sort tagged:tagged filter:filter success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)operationForGetQuestionsAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize
                                                  fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
                                                     order:(BBStackAPISortOrder)order min:(NSNumber *)min
                                                       max:(NSNumber *)max sort:(BBStackAPIQuestionSort)sort
                                                    tagged:(NSArray *)tagged filter:(NSString *)filter
                                                   success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:10];
    if (fromDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[fromDate timeIntervalSince1970]] forKey:@"fromDate"];
    [userParams setValue:max forKey:@"max"];
    [userParams setValue:min forKey:@"min"];
    [userParams setValue:[NSString stringWithBBStackAPISortOrder:order] forKey:@"order"];
    [userParams setValue:page forKey:@"page"];
    [userParams setValue:pageSize forKey:@"pagesize"];
    [userParams setValue:[NSString stringWithBBStackAPIQuestionSort:sort] forKey:@"sort"];
    [userParams setValue:[tagged componentsJoinedByString:@";"] forKey:@"tagged"];
    if (toDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[toDate timeIntervalSince1970]] forKey:@"toDate"];
    [userParams setValue:filter forKey:@"filter"];

    NSDictionary *queryString = [self buildParameters:userParams];
    return [self operationForGetPath:@"questions" parameters:queryString
          success:^(AFHTTPRequestOperation *request, id successBody) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClientBase callDataFromAttributes:successBody];
              NSArray *results = [BBStackAPIQuestion getObjectArrayFromAttributes:successBody inSite:self.site];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}

- (AFHTTPRequestOperation *)getQuestionIDs:(NSArray *)questionIDs page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                                  fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order
                                       min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIQuestionSort)sort
                                    filter:(NSString *)filter
                                   success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    AFHTTPRequestOperation *operation = [self operationForGetQuestionIDs:questionIDs page:page pageSize:pageSize
                                                                fromDate:fromDate toDate:toDate order:order min:min
                                                                     max:max sort:sort filter:filter success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)operationForGetQuestionIDs:(NSArray *)questionIDs page:(NSNumber *)page
                                              pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate
                                                toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order
                                                   min:(NSNumber *)min max:(NSNumber *)max
                                                  sort:(BBStackAPIQuestionSort)sort filter:(NSString *)filter
                                               success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:10];
    if (fromDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[fromDate timeIntervalSince1970]] forKey:@"fromDate"];
    [userParams setValue:max forKey:@"max"];
    [userParams setValue:min forKey:@"min"];
    [userParams setValue:[NSString stringWithBBStackAPISortOrder:order] forKey:@"order"];
    [userParams setValue:page forKey:@"page"];
    [userParams setValue:pageSize forKey:@"pagesize"];
    [userParams setValue:[NSString stringWithBBStackAPIQuestionSort:sort] forKey:@"sort"];
    if (toDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[toDate timeIntervalSince1970]] forKey:@"toDate"];
    [userParams setValue:filter forKey:@"filter"];

    NSString *questionIDsJoined = [questionIDs componentsJoinedByString:@";"];
    NSDictionary *queryString = [self buildParameters:userParams];
    return [self operationForGetPath:[NSString stringWithFormat:@"questions/%@/", questionIDsJoined] parameters:queryString
          success:^(AFHTTPRequestOperation *request, id successBody) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClientBase callDataFromAttributes:successBody];
              NSArray *results = [BBStackAPIQuestion getObjectArrayFromAttributes:successBody inSite:self.site];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}

- (AFHTTPRequestOperation *)getAnswerIDs:(NSArray *)answerIDs page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                                  fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order
                                       min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIAnswerSort)sort
                                    filter:(NSString *)filter
                                   success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    AFHTTPRequestOperation *operation = [self operationForGetAnswerIDs:answerIDs page:page pageSize:pageSize
                                                                fromDate:fromDate toDate:toDate order:order min:min
                                                                     max:max sort:sort filter:filter success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)operationForGetAnswerIDs:(NSArray *)answerIDs page:(NSNumber *)page
                                              pageSize:(NSNumber *)pageSize fromDate:(NSDate *)fromDate
                                                toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order
                                                   min:(NSNumber *)min max:(NSNumber *)max
                                                  sort:(BBStackAPIAnswerSort)sort filter:(NSString *)filter
                                               success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:10];
    if (fromDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[fromDate timeIntervalSince1970]] forKey:@"fromDate"];
    [userParams setValue:max forKey:@"max"];
    [userParams setValue:min forKey:@"min"];
    [userParams setValue:[NSString stringWithBBStackAPISortOrder:order] forKey:@"order"];
    [userParams setValue:page forKey:@"page"];
    [userParams setValue:pageSize forKey:@"pagesize"];
    [userParams setValue:[NSString stringWithBBStackAPIAnswerSort:sort] forKey:@"sort"];
    if (toDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[toDate timeIntervalSince1970]] forKey:@"toDate"];
    [userParams setValue:filter forKey:@"filter"];

    NSString *answerIDsJoined = [answerIDs componentsJoinedByString:@";"];
    NSDictionary *queryString = [self buildParameters:userParams];
    return [self operationForGetPath:[NSString stringWithFormat:@"answers/%@/", answerIDsJoined] parameters:queryString
          success:^(AFHTTPRequestOperation *request, id successBody) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClientBase callDataFromAttributes:successBody];
              NSArray *results = [BBStackAPIAnswer getObjectArrayFromAttributes:successBody inSite:self.site];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}

- (AFHTTPRequestOperation *)getAnswersForQuestions:(NSArray *)questions page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                      fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate order:(BBStackAPISortOrder)order
                           min:(NSNumber *)min max:(NSNumber *)max sort:(BBStackAPIAnswerSort)sort
                        filter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:9];
    if (fromDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[fromDate timeIntervalSince1970]] forKey:@"fromDate"];
    [userParams setValue:max forKey:@"max"];
    [userParams setValue:min forKey:@"min"];
    [userParams setValue:[NSString stringWithBBStackAPISortOrder:order] forKey:@"order"];
    [userParams setValue:page forKey:@"page"];
    [userParams setValue:pageSize forKey:@"pagesize"];
    [userParams setValue:[NSString stringWithBBStackAPIAnswerSort:sort] forKey:@"sort"];
    if (toDate != nil)
        [userParams setValue:[NSNumber numberWithDouble:[toDate timeIntervalSince1970]] forKey:@"toDate"];
    [userParams setValue:filter forKey:@"filter"];

    NSString *questionIDs = [questions asStringWithObjectsFromBlock:^(id item, NSUInteger index) {
        BBStackAPIQuestion *question = item;
        NSString *questionIDAsString = [NSString stringWithFormat:@"%d", question.questionID];
        return questionIDAsString;
    } joinedByString:@";"];
    NSDictionary *queryString = [self buildParameters:userParams];
    AFHTTPRequestOperation *operation = [self operationForGetPath:[NSString stringWithFormat:@"questions/%@/answers", questionIDs] parameters:queryString
          success:^(AFHTTPRequestOperation *request, id successBody) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClientBase callDataFromAttributes:successBody];
              NSArray *results = [BBStackAPIAnswer getObjectArrayFromAttributes:successBody inSite:self.site];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

@end
