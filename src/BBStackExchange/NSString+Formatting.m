//
//  Created by Brian Romanko on 12/1/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSString+Formatting.h"


@implementation NSString (Formatting)

+ (NSString *)stringWithbool:(bool)abool {
    return abool ? @"true" : @"false";
}

+ (NSString *)stringWithBBStackAPISortOrder:(BBStackAPISortOrder)sortOrder {
    switch (sortOrder) {
        case BBStackAPISortOrderDescending: return @"desc";
        default:
        case BBStackAPISortOrderAscending: return @"asc";
    }
}

+ (NSString *)stringWithBBStackAPIQuestionSort:(BBStackAPIQuestionSort)sort {
    switch (sort) {
        case BBStackAPIQuestionSortVotes: return @"votes";
        case BBStackAPIQuestionSortCreation: return @"creation";
        case BBStackAPIQuestionSortHot: return @"hot";
        case BBStackAPIQuestionSortWeek: return @"week";
        case BBStackAPIQuestionSortMonth: return @"month";
        default:
        case BBStackAPIQuestionSortActivity: return @"activity";
    }
}

+ (NSString *)stringWithBBStackAPIAnswerSort:(BBStackAPIAnswerSort)sort {
    switch (sort) {
        case BBStackAPIAnswerSortVotes: return @"votes";
        case BBStackAPIAnswerSortCreation: return @"creation";
        case BBStackAPIAnswerSortViews: return @"featured";
        default:
        case BBStackAPIAnswerSortActivity: return @"activity";
    }
}

+ (NSString *)stringWithBBStackAPITagSort:(BBStackAPITagSort)sort {
    switch (sort) {
        case BBStackAPITagSortName: return @"name";
        case BBStackAPITagSortPopular: return @"popular";
        default:
        case BBStackAPITagSortActivity: return @"activity";
    }
}


@end