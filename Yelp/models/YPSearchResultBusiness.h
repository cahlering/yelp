//
//  YPSearchResultBusiness.h
//  Yelp
//
//  Created by Chris Ahlering on 3/23/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "MUJSONResponseSerializer.h"

@interface YPSearchResultBusiness : MUJSONResponseObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address1;
@property (nonatomic, strong) NSString *address2;
@property (nonatomic, strong) NSString *address3;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *ratingImageUrlSmall;
@property (nonatomic, strong) NSNumber *reviewCount;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *averageRating;
@property (nonatomic, strong) NSArray *neighborhoods;
@property (nonatomic, strong) NSArray *categories;


@end
