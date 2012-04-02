//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackAPIModelBase.h"

@class BBStackAPISite;


@interface BBStackExchangeModel : BBStackAPIModelBase

@property(nonatomic, retain) BBStackAPISite *site;

- (id)initWithSite:(BBStackAPISite *)site attributes:(NSDictionary *)attributes;

+ (NSMutableArray *)getObjectArrayFromAttributes:(NSDictionary *)attributes inSite:(BBStackAPISite *)site;
@end