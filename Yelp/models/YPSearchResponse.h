//
//  YPSearchResponse.h
//  Yelp
//
//  Created by Chris Ahlering on 3/23/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "MUJSONResponseSerializer.h"

@interface YPSearchResponse : MUJSONResponseObject

@property (strong, nonatomic) NSArray *businesses;

@end
