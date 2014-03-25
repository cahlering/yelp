//
//  YPSearchFiltersViewController.m
//  Yelp
//
//  Created by Chris Ahlering on 3/23/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "YPSearchFiltersViewController.h"
#import "../views/YPSwitchTableViewCell.h"

enum SettingSections {
//    priceSection,
    hasDeals,
    distance,
    sortBy,
    categories
};

@interface YPSearchFiltersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *switchTableViewCell;
@property (strong, nonatomic) NSMutableDictionary *sectionExpandedState;

@end

@implementation YPSearchFiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sectionExpandedState = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *switchTableViewCellNib = [UINib nibWithNibName:@"YPSwitchTableViewCell" bundle:nil];
    [[self tableView]registerNib:switchTableViewCellNib forCellReuseIdentifier:@"SwitchCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)sectionCanExpand:(NSInteger)section
{
    switch (section) {
//        case priceSection:
//            return NO;
        case hasDeals:
            return NO;
        case distance:
            return YES;
        case sortBy:
            return YES;
        case categories:
            return YES;
        default:
            return NO;
            break;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
//        case priceSection:
//            return 1;
        case hasDeals:
        {
            return 1;
        }
        case distance:
        {
            if ([self sectionIsExpanded:section]) {
                return 4;
            }
            return 1;
        }
        case sortBy:
        {
            return 1;
        }
        case categories:
        {
            return 1;
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
//        case priceSection:
        case hasDeals: {
            YPSwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            switchCell.switchControl.onTintColor = [UIColor redColor];
            switchCell.switchControl.on = self.settings.deals;
            switchCell.switchLabel.text = @"Has Deal";
            return switchCell;
        }
        case categories:
        case distance:
        case sortBy:
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
//        case priceSection:
//            return @"Price";
        case hasDeals:
            return @"Deals";
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

- (BOOL) sectionIsExpanded: (NSInteger)section
{
    return [[self.sectionExpandedState objectForKey:[NSNumber numberWithInteger:section]]boolValue];
}

- (void) toggleSectionExpandedState: (NSInteger)section
{
    [self.sectionExpandedState setObject:@(![self sectionIsExpanded:section]) forKey:[NSNumber numberWithInteger:section]];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self sectionIsExpanded:indexPath.section]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
        int retainPosition = indexPath.row;
        for (int i = 0; i < [self.tableView numberOfRowsInSection:indexPath.section]; i++) {
            if (i != retainPosition) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            }
        }
        [self toggleSectionExpandedState:indexPath.section];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
        int insertPosition = indexPath.row + 1;
        for (int i = 0; i < 3; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:insertPosition++ inSection:indexPath.section]];
        }
        [self toggleSectionExpandedState:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end

