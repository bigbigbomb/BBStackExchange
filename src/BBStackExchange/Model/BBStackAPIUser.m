//
//  Created by Brian Romanko on 12/16/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackAPIUser.h"


@implementation BBStackAPIUser

- (NSString *)displayName {
    return [self.attributes valueForKey:@"display_name"];
}

- (NSInteger)userID {
    return [[self.attributes valueForKey:@"user_id"] integerValue];
}
@end