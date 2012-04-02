//
//  Created by Brian Romanko on 12/1/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackAPICallData.h"


@implementation BBStackAPICallData {
@private
    NSUInteger _total;
    NSUInteger _page;
    NSUInteger _pageSize;
    NSUInteger _quotaRemaining;
    NSUInteger _quotaMax;
    bool _hasMore;
    NSString *_type;
}


@synthesize total = _total;
@synthesize page = _page;
@synthesize pageSize = _pageSize;
@synthesize quotaRemaining = _quotaRemaining;
@synthesize quotaMax = _quotaMax;
@synthesize hasMore = _hasMore;
@synthesize type = _type;


- (void)dealloc {
    [_type release];
    [super dealloc];
}

- (id)initWithQuotaRemaining:(NSUInteger)quotaRemaining quotaMax:(NSUInteger)quotaMax hasMore:(bool)hasMore {
    self = [super init];
    if (self) {
        self.quotaRemaining = quotaRemaining;
        self.quotaMax = quotaMax;
        self.hasMore = hasMore;
    }

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n\tQuota Remaining: %d\n\tQuota Max: %d\n\tHas More: %d",
                    [super description], self.quotaRemaining, self.quotaMax, self.hasMore];
}


@end