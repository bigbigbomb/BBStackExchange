//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackAPISite.h"


@implementation BBStackAPISite {

}

- (id)initWithApiSiteParameter:(NSString *)apiSiteParameter siteURL:(NSURL *)siteURL siteName:(NSString *)siteName {
    NSArray *values = [NSArray arrayWithObjects:apiSiteParameter, [siteURL absoluteString], siteName, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"api_site_parameter", @"site_url", @"name", nil];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    self = [super initWithAttributes:attributes];

    if (self) {

    }

    return self;
}

- (NSString *)apiSiteParameter {
    return [self.attributes valueForKey:@"api_site_parameter"];
}

- (NSString *)name {
    return [self.attributes valueForKeyPath:@"name"];
}

- (NSURL *)logoURL {
    return [NSURL URLWithString:[self.attributes valueForKeyPath:@"logo_url"]];
}

- (NSURL *)siteURL {
    return [NSURL URLWithString:[self.attributes valueForKeyPath:@"site_url"]];
}

- (NSString *)siteDescription {
    return [self.attributes valueForKeyPath:@"description"];
}

- (NSURL *)iconURL {
    return [NSURL URLWithString:[self.attributes valueForKeyPath:@"icon_url"]];
}

- (BBStackAPISiteState)state {
    if ([[self.attributes valueForKeyPath:@"state"] isEqualToString:@"linked_meta"])
        return BBStackAPISiteStateLinkedMeta;
    else if ([[self.attributes valueForKeyPath:@"state"] isEqualToString:@"normal"])
        return BBStackAPISiteStateNormal;
    else if ([[self.attributes valueForKeyPath:@"state"] isEqualToString:@"open_beta"])
        return BBStackAPISiteStateOpenBeta;
    else
        return BBStackAPISiteStateUnknown;
}

- (NSURL *)faviconURL {
    return [NSURL URLWithString:[self.attributes valueForKeyPath:@"favicon_url"]];
}

- (NSDate *)creationDate {
    return [self.attributes valueForKeyPath:@"creation_date"];
}

- (NSString *)twitterAccount {
    return [self.attributes valueForKeyPath:@"twitter_account"];
}


@end