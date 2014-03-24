//
//  YPSearchResultTableViewCell.h
//  Yelp
//
//  Created by Chris Ahlering on 3/23/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../models/YPSearchResultBusiness.h"

@interface YPSearchResultTableViewCell : UITableViewCell

@property (nonatomic, weak) YPSearchResultBusiness *business;

@end
