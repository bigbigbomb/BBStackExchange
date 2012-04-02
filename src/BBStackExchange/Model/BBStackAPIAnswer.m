//
//  Created by Brian Romanko on 12/4/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackAPIAnswer.h"
#import "BBStackAPIUser.h"
#import "BBStackAPIComment.h"


@implementation BBStackAPIAnswer

- (NSString *)answerID {
    return [self.attributes valueForKey:@"answer_id"];
}

- (NSString *)questionID {
    return [self.attributes valueForKey:@"question_id"];
}

- (NSString *)body {
    return [self.attributes valueForKey:@"body"];
}

- (NSInteger)score {
    return [[self.attributes valueForKey:@"score"] integerValue];
}

- (bool)accepted {
    return [[self.attributes valueForKey:@"is_accepted"] boolValue];
}

- (NSArray *)comments {
    return [BBStackAPIComment getObjectArrayFromAttributes:self.attributes containerKey:@"comments"];
}

- (NSDate *)creationDate {
    return [self dateForKey:@"creation_date"];
}

- (BBStackAPIUser *)owner {
    return [[[BBStackAPIUser alloc] initWithAttributes:[self.attributes objectForKey:@"owner"]] autorelease];
}


@end