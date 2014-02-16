//
//  Beauty.h
//  MyPhoto
//
//  Created by dingql on 14-2-16.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beauty : NSObject
@property(nonatomic, copy) NSURL * url;
@property(nonatomic, copy) NSString * name;
@property(nonatomic, copy) NSString * desc;

+ (id) beautyWithDictionary: (NSDictionary *) dict;

- (id) initWithDictionary: (NSDictionary *) dict;

@end
