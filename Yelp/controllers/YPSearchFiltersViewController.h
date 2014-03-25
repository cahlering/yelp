//
//  YPSearchFiltersViewController.h
//  Yelp
//
//  Created by Chris Ahlering on 3/23/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../models/YPFilterSettings.h"

@interface YPSearchFiltersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) YPFilterSettings *settings;

@end
