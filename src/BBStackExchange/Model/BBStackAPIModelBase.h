//
//  Created by Brian Romanko on 12/1/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface BBStackAPIModelBase : NSObject {
@private
    NSDictionary *_attributes;
}
- (id)initWithAttributes:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSDictionary *attributes;

+ (NSMutableArray *)getObjectArrayFromAttributes:(NSDictionary *)attributes;

+ (NSMutableArray *)getObjectArrayFromAttributes:(NSDictionary *)attributes containerKey:(NSString *)containerKey;


- (NSDate *)dateForKey:(NSString *)key;


@end
