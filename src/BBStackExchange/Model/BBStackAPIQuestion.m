//
//  Created by Brian Romanko on 12/4/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackAPIQuestion.h"
#import "BBStackAPIUser.h"
#import "BBStackAPIAnswer.h"
#import "BBStackAPIComment.h"
#import "BBStackAPISite.h"


@implementation BBStackAPIQuestion {
}

- (NSDate *)creationDate {
    return [self dateForKey:@"creation_date"];
}

- (BBStackAPIUser *)owner {
    return [[[BBStackAPIUser alloc] initWithAttributes:[self.attributes objectForKey:@"owner"]] autorelease];
}

- (NSArray *)answers {
    return [BBStackAPIAnswer getObjectArrayFromAttributes:self.attributes];
}

- (NSArray *)comments {
    return [BBStackAPIComment getObjectArrayFromAttributes:self.attributes containerKey:@"comments"];
}

- (NSURL *)URL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"questions/%d", self.questionID] relativeToURL:self.site.siteURL];
}

- (NSArray *)tags {
    return [[[NSArray alloc] initWithArray:[self.attributes objectForKey:@"tags"]] autorelease];
}

- (NSString *)body {
    return [self.attributes valueForKey:@"body"];
}

- (NSString *)title {
    return [self.attributes valueForKey:@"title"];
}

- (NSInteger)questionID {
    return [[self.attributes valueForKey:@"question_id"] integerValue];
}

- (bool)isAnswered {
    return [[self.attributes valueForKey:@"is_answered"] boolValue];
}

- (NSInteger)answerCount {
    return [[self.attributes valueForKey:@"answer_count"] integerValue];
}

- (NSInteger)score {
    return [[self.attributes valueForKey:@"score"] integerValue];
}

- (bool)hasAcceptedAnswer {
    return [[self.attributes valueForKey:@"accepted_answer_id"] integerValue] > 0;
}


@end