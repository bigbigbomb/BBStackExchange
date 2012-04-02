//
//  Created by Brian Romanko on 12/27/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackAPITagWiki.h"


@implementation BBStackAPITagWiki

- (NSString *)tagName {
    return [self.attributes valueForKey:@"tag_name"];
}

- (NSString *)excerpt {
    return [self.attributes valueForKey:@"excerpt"];
}

@end