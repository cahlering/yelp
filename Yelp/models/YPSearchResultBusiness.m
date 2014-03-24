//
//  YPSearchResultBusiness.m
//  Yelp
//
//  Created by Chris Ahlering on 3/23/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "YPSearchResultBusiness.h"

@implementation YPSearchResultBusiness

-(id)init {
    if (self = [super init]) {
        self.propertyMap = @{
                             @"photo_url": @"photoUrl",
                             @"rating_img_url_small": @"ratingImageUrlSmall",
                             @"review_count": @"reviewCount",
                             @"avg_rating" : @"averageRating"
                             };
    }
    return self;
}

@end
