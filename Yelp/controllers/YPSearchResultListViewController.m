//
//  RTSearchResultListViewController.m
//  Yelp
//
//  Created by Chris Ahlering on 3/23/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "YPSearchResultListViewController.h"
#import "YPSearchFiltersViewController.h"
#import "../views/YPSearchResultTableViewCell.h"
#import "../models/YPSearchResultBusiness.h"
#import "../models/YPSearchResponse.h"
#import "MBAlertView.h"
#import <CoreLocation/CoreLocation.h>
#import "../models/YPFilterSettings.h"

@interface YPSearchResultListViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) YPSearchResponse *businessResponse;
@property (strong, nonatomic) YPSearchResultTableViewCell *offScreenCell;
@property (strong, nonatomic) NSString *latitudeString;
@property (strong, nonatomic) NSString *longitudeString;
@property (strong, nonatomic) YPFilterSettings *filterSettings;
@property (strong, nonatomic) NSDictionary *categoryListing;

@end

NSString *const CustomCellName = @"YPSearchResultTableViewCell";



@implementation YPSearchResultListViewController {

    CLLocationManager *manager;
    CLGeocoder *geocoder;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    UINib *ypBusinessCellNib = [UINib nibWithNibName:CustomCellName bundle:nil];
    [self.tableView registerNib:ypBusinessCellNib forCellReuseIdentifier:CustomCellName];
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = self;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationItem.titleView = searchBar;
    UIBarButtonItem *filterButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    [filterButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = filterButtonItem;
    
    manager = [[CLLocationManager alloc]init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc]init];
    
    self.filterSettings = [[YPFilterSettings alloc]init];
    self.filterSettings.radiusInMiles = [NSNumber numberWithInt:5];
    self.filterSettings.sortMethod = @"Best Match";
    self.filterSettings.selectedCategories = [@[@"burgers", @"british"] mutableCopy];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"];
    self.categoryListing = [[NSDictionary alloc] initWithContentsOfFile:path];
    
}

- (void)onFilterButton {
    YPSearchFiltersViewController *searchFiltersViewController = [[YPSearchFiltersViewController alloc]init];
    [searchFiltersViewController setSettings:self.filterSettings];
    [searchFiltersViewController setCategories:self.categoryListing];
    [self.navigationController pushViewController:searchFiltersViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getBusinessesWithSearchTerm:(NSString *)searchTerm
{
    
    self.title = @"Businesses";
    
    searchTerm = [searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([searchTerm length] == 0) {
        MBAlertView *inputAlert = [MBAlertView alertWithBody:@"Please Provide a Search Term" cancelTitle:nil cancelBlock:nil];
        [inputAlert addButtonWithText:@"OK" type:MBAlertViewItemTypePositive block:^{}];
        return;
    }
    
    NSMutableString *categoryFilterString = [[NSMutableString alloc]init];
    if ([self.filterSettings.selectedCategories count] > 0) {
        for (NSString *category in self.filterSettings.selectedCategories) {
            NSString *appendFormat;
            if ([categoryFilterString length] == 0) {
                appendFormat = @"&category=%@";
            } else {
                appendFormat = @"+%@";
            }
           [categoryFilterString appendString:[NSString stringWithFormat:appendFormat, category]];
        }
    }
    
    //NSString *url = @"http://api.yelp.com/business_review_search?term=steak&location=499%20Marina%20Blvd%2ASan%20Francisco%2A%20CA&ywsid=KZ4sEVlAV54Ofp2q9rA4CQ";
    //NSString *url = @"http://localhost:10088/yelp.json";
    NSString *url = [NSString stringWithFormat:@"http://api.yelp.com/business_review_search?term=%@&lat=%@&long=%@&radius=%@%@&ywsid=KZ4sEVlAV54Ofp2q9rA4CQ", searchTerm, _latitudeString, _longitudeString, self.filterSettings.radiusInMiles, categoryFilterString];
    NSURL *nsUrl = [NSURL URLWithString: url];
    NSURLRequest *request = [NSURLRequest requestWithURL: nsUrl];
    
    AFHTTPRequestOperation *afRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    MUJSONResponseSerializer *businessSerializer = [[MUJSONResponseSerializer alloc] init] ;
    [businessSerializer setResponseObjectClass:[YPSearchResponse class]];
    
    afRequestOperation.responseSerializer = businessSerializer;
    [afRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        YPSearchResponse *response = (YPSearchResponse *)responseObject;
        self.businessResponse = response;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MBAlertView* alert = [MBAlertView alertWithBody:@"Error Contacting Yelp" cancelTitle:nil cancelBlock:nil];
        [alert addButtonWithText:@"Dismiss" type:MBAlertViewItemTypePositive block:^{}];
        [alert addToDisplayQueue];
    }];
    
    [afRequestOperation start];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businessResponse.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
//    return cell;
    YPSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellName forIndexPath:indexPath];
    YPSearchResultBusiness *business = self.businessResponse.businesses[indexPath.row];
    [cell setBusiness:business];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_offScreenCell == Nil) {
        _offScreenCell = [[YPSearchResultTableViewCell alloc]init];
    }
    [_offScreenCell setBusiness:self.businessResponse.businesses[indexPath.row]];
    [_offScreenCell setNeedsLayout];
    [_offScreenCell layoutIfNeeded];
    
    CGFloat height = [_offScreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height += 100.0f; //Add extra height for the cell separator
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search clicked");
    [searchBar resignFirstResponder];
    [self getBusinessesWithSearchTerm:searchBar.text];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:true];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:true];
}

#pragma mark CLLocationManagerDelegate methods

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Failed to get location. Error: %@", error);
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *mostRecentLocation = (CLLocation *)locations.firstObject;
    _latitudeString = [NSString stringWithFormat:@"%.8f", mostRecentLocation.coordinate.latitude];
    _longitudeString = [NSString stringWithFormat:@"%.8f", mostRecentLocation.coordinate.longitude];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
