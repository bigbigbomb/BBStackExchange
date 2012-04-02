//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackExchangeModel.h"
#import "BBStackAPISite.h"


@implementation BBStackExchangeModel {

@private
    BBStackAPISite *_site;
}

@synthesize site = _site;

+ (NSString *)attributeContainerKey {
    return @"items";
}

- (id)initWithSite:(BBStackAPISite *)site attributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (self) {
        _site = [site retain];
    }

    return self;
}

- (void)dealloc {
    [_site release];
    [super dealloc];
}

+ (NSMutableArray *)getObjectArrayFromAttributes:(NSDictionary *)attributes inSite:(BBStackAPISite *)site {
    NSMutableArray *withSite = [[[super getObjectArrayFromAttributes:attributes] mutableCopy] autorelease];
    for (BBStackExchangeModel *model in withSite) {
        model.site = site;
    }
    return withSite;
}

@end