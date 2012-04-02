//
//  Created by Brian Romanko on 2/14/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSURL+StackExchange.h"
#import "BBStackAPISite.h"


@implementation NSURL (StackExchange)

// TODO: This whole file needs to be made dynamic

- (BOOL)isStackExchangeQuestionURL {
    if ([@"stackoverflow.com" isEqualToString:[self.host lowercaseString]]) {
        if (self.pathComponents.count >= 3) {
            NSString *pathPart = [[self.pathComponents objectAtIndex:1] lowercaseString];
            if ([@"questions" isEqualToString:pathPart] || [@"q" isEqualToString:pathPart]) {
                // http://stackoverflow.com/questions/5068251/android-what-are-the-recommended-configurations-for-proguard
                NSString *questionID = [self.pathComponents objectAtIndex:2];
                return [[NSScanner scannerWithString:questionID] scanInt:nil];
            }
        }
    }
    return NO;
}

- (BOOL)isStackExchangeAnswerURL {
    if ([@"stackoverflow.com" isEqualToString:[self.host lowercaseString]]) {
        if (self.pathComponents.count >= 3) {
            NSString *pathPart = [[self.pathComponents objectAtIndex:1] lowercaseString];
            if ([@"a" isEqualToString:pathPart]) {
                // http://stackoverflow.com/a/6492478/500865
                NSString *answerID = [self.pathComponents objectAtIndex:2];
                return [[NSScanner scannerWithString:answerID] scanInt:nil];
            }
        }
    }
    return NO;
}

- (NSString *)getStackExchangeQuestionID {
    NSString *questionID = nil;
    if ([self isStackExchangeQuestionURL]) {
        questionID = [self.pathComponents objectAtIndex:2];
    }

    return questionID;
}

- (NSString *)getStackExchangeAnswerID {
    NSString *answerID = nil;
    if ([self isStackExchangeAnswerURL]) {
        answerID = [self.pathComponents objectAtIndex:2];
    }

    return answerID;
}

- (BBStackAPISite *)getStackExchangeSite {
    return [[[BBStackAPISite alloc] initWithApiSiteParameter:@"stackoverflow"
                                                      siteURL:[NSURL URLWithString:@"http://stackoverflow.com"]
                                                     siteName:@"Stack Overflow"] autorelease];
}

@end