//
//  RightViewController.m
//  Hackathon
//
//  Created by sushil kundu on 4/5/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "RightViewController.h"
#import "RightViewTableCellTableViewCell.h"
#import "NSObject+DataFetch.h"
#import "NYTimesFullObject.h"
#import "IIViewDeckController.h"
#import "MainViewController.H"
#import "AFNetworking.h"
#import "ObjectMapperContainer.h"
#import "ObjectMapper.h"
#import "FourSquareFullObjects.h"
#import "FourSquareViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "JokesViewController.h"
#import "RottenTomatoFullObject.h"
#import "MovieReviewViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

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
    self.menuArray = [NSArray arrayWithObjects:@"",@"News", @"Restaurants",@"Jokes",@"Recent Movies", nil];
    [self.rightTable setBackgroundColor:[UIColor blackColor]];
    [self.rightTable setScrollEnabled:NO];
    // Do any additional setup after loading the view from its nib.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RightViewTableCellTableViewCell *sampleTableCell = [tableView dequeueReusableCellWithIdentifier:@"RightViewTableCellTableViewCell"];
    if(sampleTableCell == nil) {
        sampleTableCell = (RightViewTableCellTableViewCell *) [[RightViewTableCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RightViewTableCellTableViewCell"];
    }
    sampleTableCell.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 10)];
    [sampleTableCell.cellLabel setFont:[UIFont systemFontOfSize:10]];
    [sampleTableCell addSubview:sampleTableCell.cellLabel];
//    [sampleTableCell.cellLabel setFrame:CGRectMake(100, 5, 300, 20)];
    sampleTableCell.cellLabel.text = [self.menuArray objectAtIndex:indexPath.row];
    [sampleTableCell.cellLabel setTextColor:[UIColor whiteColor]];
    
    return sampleTableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor blackColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:{
            URLObject *_urlObject = [URLObject defaultGETForURLPath:@"http://api.nytimes.com/svc/news/v3/content/all/all/24?limit=20&api-key=a13b56bcd438a646bb79fbcf1f252e5f:11:69144331" forcedFecth:YES internalClass:@"NYTimesFullObject"];
            ObjectMapperContainer *_objMapperContainer = [ObjectMapperContainer objectMapperContainer];
            [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"results" toInternalClass:@"Result"]];
            [_urlObject setObjectMapperContainer:_objMapperContainer];
            [self requestDataFromURLObject:_urlObject  completionBlock:^(id aObject, NSError *error) {
                CacheData *_cachedData = (CacheData*)aObject;
                self.newsObject = (NYTimesFullObject*)_cachedData.cachedData;
                [self shiftToCenter:indexPath];
            }];
            
        }
        break;
            
        case 2:{
            [self getlocation];
            NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=552ZFLEF3N0AFLQGNEMCUBJNWK0HKM0JL1ZCZZPRRPBO0YCC&client_secret=NK4FPPNUOABX2GP00XLGJVO1TQLRES1OKJWU2WRFKOZ4RF2V%%20&v=20130815%%20&ll=40.7,-74%%20"];
            URLObject *_urlObject = [URLObject defaultGETForURLPath:url forcedFecth:YES internalClass:@"FourSquareFullObjects"];
            ObjectMapperContainer *_objMapperContainer = [ObjectMapperContainer objectMapperContainer];
            [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"response" toInternalClass:@"FourSquareResponseObject"]];
             [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"response" toInternalClass:@"FourSquareResponseObject"]];
            [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"venues" toInternalClass:@"FourSquareVenueObjects"]];
            [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"contact" toInternalClass:@"FourSquareContactObject"]];
            [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"location" toInternalClass:@"FourSquareLocation"]];
            [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"categories" toInternalClass:@"FourSquareCategories"]];
            [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"icon" toInternalClass:@"FourSquareIconObject"]];
            [_urlObject setObjectMapperContainer:_objMapperContainer];
            [self requestDataFromURLObject:_urlObject  completionBlock:^(id aObject, NSError *error) {
                CacheData *_cachedData = (CacheData*)aObject;
                self.fourSquareRestaurantObj = (FourSquareFullObjects*)_cachedData.cachedData;
                [self shiftToCenter:indexPath];
            }];
        }
            break;
        case 3:{
            URLObject *_urlObject = [URLObject defaultGETForURLPath:@"http://api.icndb.com/jokes/random/20" forcedFecth:YES internalClass:@"JokesCompleteObject"];
            ObjectMapperContainer *_objMapperContainer = [ObjectMapperContainer objectMapperContainer];
            [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"value" toInternalClass:@"JokeStringObject"]];
            [_urlObject setObjectMapperContainer:_objMapperContainer];
            [self requestDataFromURLObject:_urlObject  completionBlock:^(id aObject, NSError *error) {
                CacheData *_cachedData = (CacheData*)aObject;
                self.jokesObject = (JokesCompleteObject*)_cachedData.cachedData;
                [self shiftToCenter:indexPath];
            }];
        }
            break;
        case 4:{
            URLObject *_urlObject = [URLObject defaultGETForURLPath:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/opening.json?apikey=5ghk4e6prb79h2ghwfyygcc4" forcedFecth:YES internalClass:@"RottenTomatoFullObject"];
            ObjectMapperContainer *_objMapperContainer = [ObjectMapperContainer objectMapperContainer];
            [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"movies" toInternalClass:@"RottenTomatoMovieObject"]];
              [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"posters" toInternalClass:@"RottenTomatoPosterObject"]];
                [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"links" toInternalClass:@"RottenTomatoMovieLinks"]];
            [_urlObject setObjectMapperContainer:_objMapperContainer];
            [self requestDataFromURLObject:_urlObject  completionBlock:^(id aObject, NSError *error) {
                CacheData *_cachedData = (CacheData*)aObject;
                self.rottenTomatoFullObject = (RottenTomatoFullObject*)_cachedData.cachedData;
                [self shiftToCenter:indexPath];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)shiftToCenter:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:{
            [self.viewDeckController closeRightViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success){
                MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
                mainViewController.newsObject = self.newsObject;
                mainViewController.optionChosen = 0;
                mainViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
                controller.centerController = mainViewController;
            }];
        }
            break;
        case 2:{
            [self.viewDeckController closeRightViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success){
                FourSquareViewController *mainViewController = [[FourSquareViewController alloc] initWithNibName:@"FourSquareViewController" bundle:nil];
                mainViewController.fourSquareRestaurantObj = self.fourSquareRestaurantObj;
                mainViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
                controller.centerController = mainViewController;
            }];
        }
            break;
        case 3: {
            [self.viewDeckController closeRightViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success){
                JokesViewController *mainViewController = [[JokesViewController alloc] initWithNibName:@"JokesViewController" bundle:nil];
                mainViewController.jokeObject = self.jokesObject;
                mainViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
                controller.centerController = mainViewController;
            }];
        }
            break;
        case 4:{
            [self.viewDeckController closeRightViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success){
                MovieReviewViewController *mainViewController = [[MovieReviewViewController alloc] initWithNibName:@"MovieReviewViewController" bundle:nil];
                mainViewController.rottenTomatoFullObject = self.rottenTomatoFullObject;
                mainViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
                controller.centerController = mainViewController;
            }];
        }
            break;
        default:
            break;
    }
}

- (void) getlocation{
    CLLocationManager *lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    lm.distanceFilter = kCLDistanceFilterNone;
    [lm startUpdatingLocation];
    
    CLLocation *location = [lm location];
    
    CLLocationCoordinate2D coord;
    coord.longitude = location.coordinate.longitude;
    coord.latitude = location.coordinate.latitude;
    // or a one shot fill
    coord = [location coordinate];
    self.coord = coord;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
