//
//  YPSwitchTableViewCell.h
//  Yelp
//
//  Created by Chris Ahlering on 3/24/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPSwitchTableViewCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;

@end
