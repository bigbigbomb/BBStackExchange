//
//  Created by Brian Romanko on 12/7/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSArray+Formatting.h"


@implementation NSArray (Formatting)

- (NSString *)asStringWithObjectsFromBlock:(NSString * (^)(id, NSUInteger))block joinedByString:(NSString *)joinString {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL * stop) {
        [objects addObject:block(item, index)];
    }];

    return [objects componentsJoinedByString:joinString];
}

@end