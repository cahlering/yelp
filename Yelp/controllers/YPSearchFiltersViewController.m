//
//  YPSearchFiltersViewController.m
//  Yelp
//
//  Created by Chris Ahlering on 3/23/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "YPSearchFiltersViewController.h"

enum SettingSection {
    priceSection,
    mostPopular,
    distance,
    sortBy,
    categories
};

@interface YPSearchFiltersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *priceTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *switchTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *pickerTableViewCell;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerControl;

@end

@implementation YPSearchFiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case priceSection:
            return 1;
            break;
        case mostPopular:
            return 2;
        case distance:
            return 4;
        case sortBy:
            return 1;
        case categories:
            return 1;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case priceSection:
            return _priceTableViewCell;
            break;
        case mostPopular:
            return _pickerTableViewCell;
        case distance:
            return _pickerTableViewCell;
        case sortBy:
            return _switchTableViewCell;
        case categories:
            return _switchTableViewCell;
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case priceSection:
            return @"Price";
        case mostPopular:
            return @"Most Popular";
        case distance:
            return @"Distance";
        case sortBy:
            return @"Sort by";
        case categories:
            return @"Categories";
        default:
            break;
    }
    return @"Filters";
}

@end

