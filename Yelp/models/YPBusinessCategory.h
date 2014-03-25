//
//  YPBusinessCategory.h
//  Yelp
//
//  Created by Chris Ahlering on 3/25/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "MUJSONResponseSerializer.h"

@interface YPBusinessCategory : MUJSONResponseObject

@property (nonatomic, strong) NSString *categoryFilter;
@property (nonatomic, strong) NSString *searchUrl;
@property (nonatomic, strong) NSString *name;

@end
