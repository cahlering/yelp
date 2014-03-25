//
//  YPBusinessCategory.m
//  Yelp
//
//  Created by Chris Ahlering on 3/25/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "YPBusinessCategory.h"

@implementation YPBusinessCategory

-(id)init {
    if (self = [super init]) {
        self.propertyMap = @{
                             @"category_filter": @"categoryFilter",
                             @"search_url": @"searchUrl"
                             };
    }
    return self;
}

@end
