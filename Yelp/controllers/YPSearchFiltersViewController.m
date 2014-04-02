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

enum SortBy {
    BestMatch,
    Distance,
    HighestRated
};

@interface YPSearchFiltersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *switchTableViewCell;
@property (strong, nonatomic) NSMutableDictionary *sectionExpandedState;
@property (nonatomic) BOOL moreClicked;

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

- (NSArray *) sortMethodStringArray
{
    return @[@"Best Match", @"Distance", @"Highest Rated"];
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
            if ([self sectionIsExpanded:section]) {
                return 3;
            }
            return 1;
        }
        case categories:
        {
            if ([self sectionIsExpanded:section]) {
                return [self.categories allKeys].count;
            }
            return 4 - (self.moreClicked ? 1 : 0);
        }
        default:
            return 0;
    }
}

-(void) setDeals:(id)sender
{
    self.settings.deals = [sender isOn];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
//        case priceSection:
        case hasDeals: {
            YPSwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            switchCell.switchControl.onTintColor = [UIColor redColor];
            switchCell.switchControl.on = self.settings.deals;
            [switchCell.switchControl addTarget:self action:@selector(setDeals:) forControlEvents:UIControlEventValueChanged];
            switchCell.switchLabel.text = @"Has Deal";
            return switchCell;
        }
        case distance:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            NSNumber *displayNumber;
            if ([self sectionIsExpanded:indexPath.section]) {
                displayNumber = [NSNumber numberWithInt:5 * (indexPath.row + 1)];
            } else {
                displayNumber = self.settings.radiusInMiles;
            }
            cell.textLabel.text = [NSString stringWithFormat:[NSString stringWithFormat:@"%@ Miles", displayNumber], indexPath.row];
            cell.tag = [displayNumber integerValue];
            return cell;
        }
        case categories:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            if ([self sectionIsExpanded:indexPath.section] || indexPath.row < 3) {
                cell.textLabel.text = [self.categories allKeys][indexPath.row];
            } else {
                cell.textLabel.text = @"More...";
            }
            return cell;
            
        }
        case sortBy:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            NSString *displaySortMethod = self.settings.sortMethod;
            if ([self sectionIsExpanded:indexPath.section]) {
                displaySortMethod = [self sortMethodStringArray][indexPath.row];
            }
            cell.textLabel.text = displaySortMethod;
            return cell;
        }
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
    switch (indexPath.section) {
        case categories:
        {
            if (![self sectionIsExpanded:indexPath.section] && indexPath.row == 3) {
                NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc]init];
                [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:3 inSection:indexPath.section]];
                NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
                
                for (int i = 3; i < [self.categories allKeys].count; i++) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                }
                self.moreClicked = YES;
                [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                [self toggleSectionExpandedState:indexPath.section];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
        }
        case distance:
        {
            UITableViewCell *displayedCell = [tableView cellForRowAtIndexPath:indexPath];
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
                self.settings.radiusInMiles = [NSNumber numberWithInteger:displayedCell.tag];
            } else {
                NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
                int insertPosition = indexPath.row;
                for (int i = 0; i < 4; i++) {
                    if (displayedCell.tag != 5 * (i + 1)) {
                        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPosition+i inSection:indexPath.section]];
                    }
                }
                [self toggleSectionExpandedState:indexPath.section];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
        }
        case sortBy:
        {
            UITableViewCell *displayedCell = [tableView cellForRowAtIndexPath:indexPath];
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
                self.settings.sortMethod = displayedCell.textLabel.text;
            } else {
                NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
                int insertPosition = indexPath.row;
                for (int i = 0; i < 3; i++) {
                    if (displayedCell.textLabel.text != [self sortMethodStringArray][i]) {
                        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPosition+i inSection:indexPath.section]];
                    }
                }
                [self toggleSectionExpandedState:indexPath.section];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
        }
        case hasDeals:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

