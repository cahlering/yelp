//
//  YPSearchResponse.m
//  Yelp
//
//  Created by Chris Ahlering on 3/23/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "YPSearchResponse.h"
#import "YPSearchResultBusiness.h"

@implementation YPSearchResponse

- (Class)classForElementsInArrayProperty:(NSString *)businesses {
    return [YPSearchResultBusiness class];
}
@end
