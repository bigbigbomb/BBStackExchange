//
//  Created by Brian Romanko on 12/7/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSArray (Formatting)

- (NSString *)asStringWithObjectsFromBlock:(NSString * (^)(id, NSUInteger))block joinedByString:(NSString *)joinString;

@end