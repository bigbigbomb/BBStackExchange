//
//  Created by Brian Romanko on 12/27/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackAPIModelBase.h"
#import "BBStackExchangeModel.h"


@interface BBStackAPITagWiki : BBStackExchangeModel {

}

@property(nonatomic, readonly) NSString *tagName;
@property(nonatomic, readonly) NSString *excerpt;

@end