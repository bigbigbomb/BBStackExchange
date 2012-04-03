//
//  Created by Brian Romanko on 4/3/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackExchangeAPIClientBase.h"
#import "BBStackAPICallData.h"
#import "AFNetworking.h"

NSString * const kBBStackExchangeAPIURL = @"https://api.stackexchange.com";
NSString * const kBBStackExchangeAPIVersion = @"2.0";
NSString * const kBBStackExchangeSiteAPIKey = BBSTACKEXCHANGE_SITE_API_KEY;

@implementation BBStackExchangeAPIClientBase

@synthesize apiKey = _apiKey;
@synthesize accessToken = _accessToken;

- (id)initWithAccessToken:(NSString *)accessToken {
    NSString *urlWithVersion = [NSString stringWithFormat:@"%@/%@/", kBBStackExchangeAPIURL, kBBStackExchangeAPIVersion];
    self = [self initWithBaseURL:[NSURL URLWithString:urlWithVersion]];
    if (self) {
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
    [_accessToken release];
    [super dealloc];
}




@end