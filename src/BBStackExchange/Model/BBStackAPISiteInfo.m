//
//  Created by Brian Romanko on 12/3/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackAPISiteInfo.h"
#import "BBStackAPISite.h"


@implementation BBStackAPISiteInfo{
    BBStackAPISite *_siteDetail;
}

- (void)dealloc {
    [_siteDetail release];
    [super dealloc];
}

- (NSInteger)totalQuestions {
    return [[self.attributes valueForKey:@"total_questions"] integerValue];
}

- (NSInteger)totalUnanswered {
    return [[self.attributes valueForKey:@"total_unanswered"] integerValue];
}

- (NSInteger)totalAccepted {
    return [[self.attributes valueForKey:@"total_accepted"] integerValue];
}

- (NSInteger)totalAnswers {
    return [[self.attributes valueForKey:@"total_answers"] integerValue];
}

- (NSInteger)totalComments {
    return  [[self.attributes valueForKey:@"total_comments"] integerValue];
}

- (NSInteger)totalVotes {
    return  [[self.attributes valueForKey:@"total_votes"] integerValue];
}

- (NSInteger)totalBadges {
    return  [[self.attributes valueForKey:@"total_badges"] integerValue];
}

- (NSInteger)totalUsers {
    return [[self.attributes valueForKey:@"total_users"] integerValue];
}

- (CGFloat)questionsPerMinute {
    return  [[self.attributes valueForKey:@"questions_per_minute"] floatValue];
}

- (CGFloat)answersPerMinute {
    return [[self.attributes valueForKey:@"answers_per_minute"] floatValue];
}

- (CGFloat)badgesPerMinute {
    return  [[self.attributes valueForKey:@"badges_per_minute"] floatValue];
}

- (BBStackAPISite *)siteDetail {
    if (!_siteDetail)
        _siteDetail = [[BBStackAPISite alloc] initWithAttributes:[self.attributes valueForKey:@"site"]];

    return _siteDetail;
}

@end