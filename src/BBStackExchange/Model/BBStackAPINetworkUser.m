//
//  Created by Lee Fastenau on 4/3/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackAPIAssociated.h"


@implementation BBStackAPINetworkUser

+ (NSString *)attributeContainerKey {
    return @"items";
}

- (NSString *)siteName {
    return [self.attributes valueForKeyPath:@"site_name"];
}

- (NSURL *)siteURL {
    return [NSURL URLWithString:[self.attributes valueForKeyPath:@"site_url"]];
}

@end