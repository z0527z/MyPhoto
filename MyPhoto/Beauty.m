//
//  Beauty.m
//  MyPhoto
//
//  Created by dingql on 14-2-16.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "Beauty.h"

@implementation Beauty

+ (id)beautyWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.url = [NSURL URLWithString:dict[@"url"]];
        self.name = dict[@"name"];
        self.desc = dict[@"desc"];
    }
    return self;
}

@end
