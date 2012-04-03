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

NSString * const kBBStackExchangeAPIURL = @"https://api.stackexchange.com";
NSString * const kBBStackExchangeAPIVersion = @"2.0";
NSString * const kBBStackExchangeSiteAPIKey = BBSTACKEXCHANGE_SITE_API_KEY;

@interface BBStackExchangeAPIClient ()

@property(nonatomic, readwrite, retain) BBStackAPISite *site;

- (NSDictionary *)buildParameters:(NSDictionary *)parameters;

+ (BBStackAPICallData *)callDataFromAttributes:(NSDictionary *)dictionary;

- (void)handleFailure:(AFHTTPRequestOperation *)request error:(NSError *)error failure:(BBStackAPIFailureHandler)failure;

- (AFHTTPRequestOperation *)operationForGetPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;


@end


@implementation BBStackExchangeAPIClient {

@private
    NSString *_apiKey;
    BBStackAPISite *_site;
    NSString *_accessToken;
}

@synthesize apiKey = _apiKey;
@synthesize site = _site;
@synthesize accessToken = _accessToken;

- (id)initWithAccessToken:(NSString *)accessToken {
    self = [self initWithSite:nil accessToken:accessToken];
    return self;
}

- (id)initWithSite:(BBStackAPISite *)site accessToken:(NSString *)accessToken {
    NSString *urlWithVersion = [NSString stringWithFormat:@"%@/%@/", kBBStackExchangeAPIURL, kBBStackExchangeAPIVersion];
    self = [self initWithBaseURL:[NSURL URLWithString:urlWithVersion]];
    if (self) {
        _site = [site retain];
        _accessToken = [accessToken copy];
        self.apiKey = kBBStackExchangeSiteAPIKey;
    }

    return self;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Content-Type" value:@"application/json"];
        [self setDefaultHeader:@"Accept-Encoding" value:@"gzip"];
    }

    return self;
}

- (void)dealloc {
    [_apiKey release];
    [_site release];
    [_accessToken release];
    [super dealloc];
}

- (NSDictionary *)buildParameters:(NSDictionary *)parameters {
    NSMutableDictionary *updatedParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [updatedParameters setValue:self.apiKey forKey:@"key"];
    if (!(self.accessToken == nil || [self.accessToken length] == 0))
        [updatedParameters setValue:self.accessToken forKey:@"access_token"];
    [updatedParameters setValue:self.site.apiSiteParameter forKey:@"site"];
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
              BBStackAPICallData *callData = [BBStackExchangeAPIClient callDataFromAttributes:body];
              NSArray *results = [BBStackAPITag getObjectArrayFromAttributes:body inSite:self.site];
              if (success)
                success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}


- (void)getMeTagsFromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min
                                            order:(BBStackAPISortOrder)order page:(NSNumber *)page
                                         pageSize:(NSNumber *)pageSize sort:(BBStackAPITagSort)sort
                                           toDate:(NSDate *)toDate
                                          success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    AFHTTPRequestOperation *operation = [self operationForGetMeTagsFromDate:fromDate max:max min:min
                                  order:order page:page pageSize:pageSize
                                   sort:sort toDate:toDate
                                success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];

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
              BBStackAPICallData *callData = [BBStackExchangeAPIClient callDataFromAttributes:body];
              NSArray *results = [BBStackAPITag getObjectArrayFromAttributes:body inSite:self.site];
              if (success)
                success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}


- (void)getTagsWithInName:(NSString *)inName fromDate:(NSDate *)fromDate max:(NSNumber *)max min:(NSNumber *)min
                    order:(BBStackAPISortOrder)order page:(NSNumber *)page pageSize:(NSNumber *)pageSize
                     sort:(BBStackAPITagSort)sort toDate:(NSDate *)toDate
                  success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    AFHTTPRequestOperation *operation = [self operationForGetTagsWithInName:inName fromDate:fromDate max:max min:min
                                  order:order page:page pageSize:pageSize
                                   sort:sort toDate:toDate
                                success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];

}

- (AFHTTPRequestOperation *)operationForGetWikisForTags:(NSArray *)tags
                success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSString *tagNames = [tags asStringWithObjectsFromBlock:^(id item, NSUInteger index) {
        BBStackAPITag *tag = item;
        return AFURLEncodedStringFromStringWithEncoding(tag.name, NSUTF8StringEncoding);
    } joinedByString:@";"];
    NSDictionary *queryString = [self buildParameters:nil];
    return [self operationForGetPath:[NSString stringWithFormat:@"tags/%@/wikis", tagNames] parameters:queryString
          success:^(AFHTTPRequestOperation *request, id successBody) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClient callDataFromAttributes:successBody];
              NSArray *results = [BBStackAPITagWiki getObjectArrayFromAttributes:successBody inSite:self.site];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}

- (void)getWikisForTags:(NSArray *)tags
                success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    AFHTTPRequestOperation *operation = [self operationForGetWikisForTags:tags success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (AFHTTPRequestOperation *)operationForGetInfoWithFilter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:12];
    [userParams setValue:filter forKey:@"filter"];
    NSDictionary *queryString = [self buildParameters:userParams];
    return [self operationForGetPath:@"info" parameters:queryString
          success:^(AFHTTPRequestOperation *request, id body) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClient callDataFromAttributes:body];
              NSArray *results = [BBStackAPISiteInfo getObjectArrayFromAttributes:body inSite:self.site];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}

- (void)getInfoWithFilter:(NSString *)filter success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    AFHTTPRequestOperation *operation = [self operationForGetInfoWithFilter:nil success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
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
              BBStackAPICallData *callData = [BBStackExchangeAPIClient callDataFromAttributes:successBody];
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
              BBStackAPICallData *callData = [BBStackExchangeAPIClient callDataFromAttributes:successBody];
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
              BBStackAPICallData *callData = [BBStackExchangeAPIClient callDataFromAttributes:successBody];
              NSArray *results = [BBStackAPIAnswer getObjectArrayFromAttributes:successBody inSite:self.site];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}

- (void)getAnswersForQuestions:(NSArray *)questions page:(NSNumber *)page pageSize:(NSNumber *)pageSize
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
    [self getPath:[NSString stringWithFormat:@"questions/%@/answers", questionIDs] parameters:queryString
          success:^(AFHTTPRequestOperation *request, id successBody) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClient callDataFromAttributes:successBody];
              NSArray *results = [BBStackAPIAnswer getObjectArrayFromAttributes:successBody inSite:self.site];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error) {
              [self handleFailure:request error:error failure:failure];
          }
    ];
}

//- (AFHTTPRequestOperation *)searchForQuestionsTagged:(NSArray *)tags notTagged:(NSArray *)notTagged inTitle:(NSString *)inTitle
//                             max:(NSNumber *)max min:(NSNumber *)min order:(BBStackAPISortOrder)order page:(NSNumber *)page
//                        pageSize:(NSNumber *)pageSize sort:(BBStackAPIQuestionSort)sort toDate:(NSDate *)toDate
//                         success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
//    AFHTTPRequestOperation *operation = [self operationForSearchForQuestionsTagged:tags notTagged:notTagged inTitle:inTitle
//                                                                              max:max min:min order:order page:page pageSize:pageSize
//                                                                             sort:sort toDate:toDate success:success failure:failure];
//    [self enqueueHTTPRequestOperation:operation];
//    return operation;
//}
//
//- (AFHTTPRequestOperation *)operationForSearchForQuestionsTagged:(NSArray *)tags notTagged:(NSArray *)notTagged inTitle:(NSString *)inTitle
//                             max:(NSNumber *)max min:(NSNumber *)min order:(BBStackAPISortOrder)order page:(NSNumber *)page
//                        pageSize:(NSNumber *)pageSize sort:(BBStackAPIQuestionSort)sort toDate:(NSDate *)toDate
//                         success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
//    NSString *tagIDs = [tags componentsJoinedByString:@";"];
//    NSString *notTagIDs = [notTagged componentsJoinedByString:@";"];
//
//    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:10];
//    [userParams setValue:tagIDs forKey:@"tagged"];
//    [userParams setValue:notTagIDs forKey:@"notagged"];
//    [userParams setValue:inTitle forKey:@"intitle"];
//    [userParams setValue:max forKey:@"max"];
//    [userParams setValue:min forKey:@"min"];
//    [userParams setValue:[NSString stringWithBBStackAPISortOrder:order] forKey:@"order"];
//    [userParams setValue:page forKey:@"page"];
//    [userParams setValue:pageSize forKey:@"pagesize"];
//    [userParams setValue:[NSString stringWithBBStackAPIQuestionSort:sort] forKey:@"sort"];
//    if (toDate != nil)
//        [userParams setValue:[NSNumber numberWithDouble:[toDate timeIntervalSince1970]] forKey:@"toDate"];
//
//    NSDictionary *queryString = [self buildParameters:userParams];
//    return [self operationForGetPath:@"search" parameters:queryString
//          success:^(AFHTTPRequestOperation *request, id successBody) {
//              BBStackAPICallData *callData = [BBStackExchangeAPIClient callDataFromAttributes:successBody];
//              NSArray *results = [BBStackAPIQuestion getObjectArrayFromAttributes:successBody inSite:self.site];
//              success(request, callData, results);
//          }
//          failure:^(AFHTTPRequestOperation *request, NSError *error) {
//              [self handleFailure:request error:error failure:failure];
//          }
//    ];
//}

- (void)getSitesAtPage:(NSNumber *)page pageSize:(NSNumber *)pageSize filter:(NSString *)filter
               success:(BBStackAPISuccessHandler)success failure:(BBStackAPIFailureHandler)failure {
    NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [userParams setValue:page forKey:@"page"];
    [userParams setValue:pageSize forKey:@"pagesize"];
    [userParams setValue:filter forKey:@"filter"];

    NSDictionary *queryString = [self buildParameters:userParams];
    [self getPath:@"sites" parameters:queryString
          success:^(AFHTTPRequestOperation *request, id body) {
              BBStackAPICallData *callData = [BBStackExchangeAPIClient callDataFromAttributes:body];
              NSArray *results = [BBStackAPISite getObjectArrayFromAttributes:body];
              success(request, callData, results);
          }
          failure:^(AFHTTPRequestOperation *request, NSError *error){
              [self handleFailure:request error:error failure:failure];
        }
    ];
}

@end