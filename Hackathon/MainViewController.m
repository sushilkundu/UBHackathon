//
//  MainViewController.m
//  Hackathon
//
//  Created by sushil kundu on 4/5/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableCell.h"
#import "Result.h"
#import "CacheData.h"
#import "NSObject+DataFetch.h"
#import "AFNetworking.h"
#import "ObjectMapperContainer.h"
#import "ObjectMapper.h"
#import "EGYModalWebViewController.h"
#import "MBProgressHUD.h"
#import "IIViewDeckController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self];
        [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 50)];
        [self.navigationController.view setBackgroundColor:[UIColor blueColor]];
        // Custom initialization
    }
    return self;
        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.navigationController.view];
    [self.navigationItem setTitle:@"Have fun"];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                              target:self.viewDeckController
                                                                              action:@selector(toggleRightView)];
    [self.navigationItem setRightBarButtonItem:menuItem];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
     URLObject *_urlObject = [URLObject defaultGETForURLPath:@"http://api.nytimes.com/svc/news/v3/content/all/all/24?limit=20&api-key=a13b56bcd438a646bb79fbcf1f252e5f:11:69144331" forcedFecth:YES internalClass:@"NYTimesFullObject"];
    ObjectMapperContainer *_objMapperContainer = [ObjectMapperContainer objectMapperContainer];
    [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"results" toInternalClass:@"Result"]];
    [_urlObject setObjectMapperContainer:_objMapperContainer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestDataFromURLObject:_urlObject  completionBlock:^(id aObject, NSError *error) {
        CacheData *_cachedData = (CacheData*)aObject;
        self.newsObject = (NYTimesFullObject*)_cachedData.cachedData;
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self.MainTableView reloadData];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableCell *sampleTableCell = [tableView dequeueReusableCellWithIdentifier:@"MainTableCell"];
    if(sampleTableCell == nil) {
        sampleTableCell = (MainTableCell *) [[MainTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainTableCell"];
    }
    switch (self.optionChosen) {
        case 0:{
            if (self.newsObject) {
                Result *result = (Result *)[self.newsObject.results objectAtIndex:indexPath.row];
                [sampleTableCell setDataForNewsItem:result];
                UIImage *_image = [[URLCache sharedInstance] getImageForURL:[NSURL URLWithString:result.thumbnailStandard]];
                if (_image) {
                    [sampleTableCell.image setImage:_image];
                }else{
                    [sampleTableCell.image setImage:[UIImage imageNamed:@"image_placeholder.png"]];
                    NSURLRequest *_urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:result.thumbnailStandard]];
                    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:_urlRequest success:^(UIImage *image) {
//                        MainTableCell *sampleTableCell = [tableView dequeueReusableCellWithIdentifier:@"MainTableCell"];
                        if (sampleTableCell!=nil) {
                            [sampleTableCell.image setImage:image];
                        }
                        
                        [[URLCache sharedInstance] addImageToCache:image forURL:[NSURL URLWithString:result.thumbnailStandard]];
                        
                        //[self.imageDictionary setObject:image forKey:_newsItem.Photo];
                    }];
                    [operation start];
            }
            }
        }
        break;
            
        default:
            break;
    }
    
    
    return sampleTableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.optionChosen) {
        case 0:
            if (self.newsObject) {
                            return [MainTableCell getRowHeightForNYTimesResult:(Result *)[self.newsObject.results objectAtIndex:indexPath.row]];
            }
            break;
            
        default:
            break;
    }
    return 40.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.optionChosen) {
        case 0:
            if (self.newsObject) {
                return [self.newsObject.results count];
            }            
        break;
            
        default:
            break;
    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.optionChosen) {
        case 0:
            if (self.newsObject) {
                Result *result = (Result *)[self.newsObject.results objectAtIndex:indexPath.row];
                EGYModalWebViewController *webview = [[EGYModalWebViewController alloc] initWithAddress:result.url];
                [self presentViewController:webview animated:YES completion:NULL];
            }
            break;
            
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
