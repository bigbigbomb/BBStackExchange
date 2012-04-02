//
//  Created by Brian Romanko on 1/31/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackAPIComment.h"
#import "BBStackAPIUser.h"


@implementation BBStackAPIComment {

}

- (NSString *)body {
    return [self.attributes valueForKey:@"body"];
}

- (NSInteger)score {
    return [[self.attributes valueForKey:@"score"] integerValue];
}

- (NSDate *)creationDate {
    return [self dateForKey:@"creation_date"];
}

- (BBStackAPIUser *)owner {
    return [[[BBStackAPIUser alloc] initWithAttributes:[self.attributes objectForKey:@"owner"]] autorelease];
}

- (BBStackAPICommentPostType)postType {
    if ([[self.attributes valueForKeyPath:@"post_type"] isEqualToString:@"answer"])
        return BBStackAPICommentPostTypeAnswer;
    else
        return BBStackAPICommentPostTypeQuestion;
}

@end