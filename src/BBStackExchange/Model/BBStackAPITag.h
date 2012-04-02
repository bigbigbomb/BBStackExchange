//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackExchangeModel.h"


@interface BBStackAPITag : BBStackExchangeModel

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger count;

@end