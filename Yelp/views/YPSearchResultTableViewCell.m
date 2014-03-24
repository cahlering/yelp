//
//  YPSearchResultTableViewCell.m
//  Yelp
//
//  Created by Chris Ahlering on 3/23/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "YPSearchResultTableViewCell.h"
#import "../models/YPSearchResultBusiness.h"

@interface YPSearchResultTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *businessImage;
@property (weak, nonatomic) IBOutlet UILabel *businessTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation YPSearchResultTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public methods

-(void)setBusiness:(YPSearchResultBusiness *)business {
    _business = business;
    
    self.businessTitleLabel.text = self.business.name;
    self.reviewCountLabel.text = [NSString stringWithFormat:@"%@", self.business.reviewCount];
    self.addressLabel.text = [NSString stringWithFormat:@"%@, %@", self.business.address1, self.business.city];
    
    NSURL *thumbNailUrl = [NSURL URLWithString:self.business.photoUrl];
    NSURLRequest *thumbnailRequest = [NSURLRequest requestWithURL:thumbNailUrl];
    UIImage *placeHolderImage = [UIImage imageNamed:@"loading"];
    
    [self.businessImage setImageWithURLRequest:thumbnailRequest placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.businessImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        nil;
    }];
    
    NSURL *ratingUrl = [NSURL URLWithString:self.business.ratingImageUrlSmall];
    NSURLRequest *ratingUrlRequest = [NSURLRequest requestWithURL:ratingUrl];
    
    [self.ratingImage setImageWithURLRequest:ratingUrlRequest placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.ratingImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        nil;
    }];
    
}

@end
