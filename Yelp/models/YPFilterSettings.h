//
//  YPFilterSettings.h
//  Yelp
//
//  Created by Chris Ahlering on 3/25/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPFilterSettings : NSObject

@property (nonatomic) BOOL deals;
@property (nonatomic, strong) NSArray *selectedCategories;
@property (nonatomic, strong) NSString *sortMethod;
@property (nonatomic, strong) NSNumber *radiusInMeters;

@end
