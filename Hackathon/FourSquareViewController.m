//
//  FourSquareViewController.m
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "FourSquareViewController.h"
#import "MBProgressHUD.h"
#import "CacheData.h"
#import "NSObject+DataFetch.h"
#import "AFNetworking.h"
#import "ObjectMapperContainer.h"
#import "ObjectMapper.h"
#import "IIViewDeckController.h"
#import "FourSquareTableCellTableViewCell.h"
#import "FourSquareVenueObjects.h"

@interface FourSquareViewController ()

@end

@implementation FourSquareViewController

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
    [self.navigationItem setTitle:@"Don't get bored"];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                              target:self.viewDeckController
                                                                              action:@selector(toggleRightView)];
    [self.navigationItem setRightBarButtonItem:menuItem];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=552ZFLEF3N0AFLQGNEMCUBJNWK0HKM0JL1ZCZZPRRPBO0YCC&client_secret=NK4FPPNUOABX2GP00XLGJVO1TQLRES1OKJWU2WRFKOZ4RF2V%%20&v=20130815%%20&ll=40.7,-74%%20"];
    if (!self.fourSquareRestaurantObj) {
        URLObject *_urlObject = [URLObject defaultGETForURLPath:url forcedFecth:YES internalClass:@"FourSquareFullObjects"];
        ObjectMapperContainer *_objMapperContainer = [ObjectMapperContainer objectMapperContainer];
        [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"response" toInternalClass:@"FourSquareResponseObject"]];
        [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"categories" toInternalClass:@"FourSquareCategories"]];
        [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"venues" toInternalClass:@"FourSquareVenueObjects"]];
        [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"contact" toInternalClass:@"FourSquareContactObject"]];
        [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"location" toInternalClass:@"FourSquareLocation"]];
        [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"categories" toInternalClass:@"FourSquareCategories"]];
        [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"icon" toInternalClass:@"FourSquareIconObject"]];
        [_urlObject setObjectMapperContainer:_objMapperContainer];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self requestDataFromURLObject:_urlObject  completionBlock:^(id aObject, NSError *error) {
            CacheData *_cachedData = (CacheData*)aObject;
            self.fourSquareRestaurantObj = (FourSquareFullObjects*)_cachedData.cachedData;
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        }];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FourSquareTableCellTableViewCell *sampleTableCell = [tableView dequeueReusableCellWithIdentifier:@"FourSquareTableCellTableViewCell"];
    if(sampleTableCell == nil) {
        sampleTableCell = (FourSquareTableCellTableViewCell *) [[FourSquareTableCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FourSquareTableCellTableViewCell"];
    }
    
    if (self.fourSquareRestaurantObj) {
        FourSquareVenueObjects *result = (FourSquareVenueObjects *)[self.fourSquareRestaurantObj.response.venues objectAtIndex:indexPath.row];
        [sampleTableCell setDataForVenueObject:result];
        if (result.categories && result.categories.count) {
            FourSquareCategories *category = (FourSquareCategories *)[result.categories objectAtIndex:0];
            UIImage *_image = [[URLCache sharedInstance] getImageForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@bg_64%@",category.icon.prefix,category.icon.suffix]]];
            if (_image) {
                [sampleTableCell.fourSquareImage setImage:_image];
            }else{
//                [sampleTableCell.fourSquareImage setImage:[UIImage imageNamed:@"image_placeholder.png"]];
                NSURLRequest *_urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@bg_64%@",category.icon.prefix,category.icon.suffix]]];
                AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:_urlRequest success:^(UIImage *image) {
                    //                        MainTableCell *sampleTableCell = [tableView dequeueReusableCellWithIdentifier:@"MainTableCell"];
                    if (sampleTableCell!=nil) {
                        [sampleTableCell.fourSquareImage setImage:image];
                    }
                    
                    [[URLCache sharedInstance] addImageToCache:image forURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@bg_64%@",category.icon.prefix,category.icon.suffix]]];
                    
                    //[self.imageDictionary setObject:image forKey:_newsItem.Photo];
                }];
                [operation start];
        }
        }
    }
    
    
    
    return sampleTableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fourSquareRestaurantObj.response.venues count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
