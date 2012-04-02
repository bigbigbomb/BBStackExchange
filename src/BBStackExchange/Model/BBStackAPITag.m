//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackAPITag.h"


@implementation BBStackAPITag {
}

- (NSString *)name {
    return [self.attributes valueForKey:@"name"];
}

- (NSInteger)count {
    return [[self.attributes valueForKey:@"count"] integerValue];
}

@end