//
//  MovieReviewViewController.m
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "MovieReviewViewController.h"
#import "CacheData.h"
#import "NSObject+DataFetch.h"
#import "AFNetworking.h"
#import "ObjectMapperContainer.h"
#import "ObjectMapper.h"
#import "EGYModalWebViewController.h"
#import "MBProgressHUD.h"
#import "IIViewDeckController.h"
#import "RottenTomatoTableViewCell.h"

@interface MovieReviewViewController ()

@end

@implementation MovieReviewViewController

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
    [self.navigationItem setTitle:@"Movie Reviews"];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                              target:self.viewDeckController
                                                                              action:@selector(toggleRightView)];
    [self.navigationItem setRightBarButtonItem:menuItem];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    URLObject *_urlObject = [URLObject defaultGETForURLPath:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/opening.json?apikey=5ghk4e6prb79h2ghwfyygcc4" forcedFecth:YES internalClass:@"RottenTomatoFullObject"];
    ObjectMapperContainer *_objMapperContainer = [ObjectMapperContainer objectMapperContainer];
    [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"movies" toInternalClass:@"RottenTomatoMovieObject"]];
    [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"posters" toInternalClass:@"RottenTomatoPosterObject"]];
     [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"links" toInternalClass:@"RottenTomatoMovieLinks"]];
    [_urlObject setObjectMapperContainer:_objMapperContainer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestDataFromURLObject:_urlObject  completionBlock:^(id aObject, NSError *error) {
        CacheData *_cachedData = (CacheData*)aObject;
        self.rottenTomatoFullObject = (RottenTomatoFullObject*)_cachedData.cachedData;
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RottenTomatoMovieObject *movie = (RottenTomatoMovieObject *)[self.rottenTomatoFullObject.movies objectAtIndex:indexPath.row];
    RottenTomatoTableViewCell *sampleTableCell = [tableView dequeueReusableCellWithIdentifier:@"RottenTomatoTableViewCell"];
    if(sampleTableCell == nil) {
        sampleTableCell = (RottenTomatoTableViewCell *) [[RottenTomatoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RottenTomatoTableViewCell"];
    }
    [sampleTableCell setDataForNewsItem:movie];
    UIImage *_image = [[URLCache sharedInstance] getImageForURL:[NSURL URLWithString:movie.posters.thumbnail]];
    if (_image) {
        [sampleTableCell.movieThumbImage setImage:_image];
    }else{
        NSURLRequest *_urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:movie.posters.thumbnail]];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:_urlRequest success:^(UIImage *image) {
            //                        MainTableCell *sampleTableCell = [tableView dequeueReusableCellWithIdentifier:@"MainTableCell"];
            if (sampleTableCell!=nil) {
                [sampleTableCell.movieThumbImage setImage:image];
            }
            
            [[URLCache sharedInstance] addImageToCache:image forURL:[NSURL URLWithString:movie.posters.thumbnail]];
            
            //[self.imageDictionary setObject:image forKey:_newsItem.Photo];
        }];
        [operation start];
    }
    
    return sampleTableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RottenTomatoMovieObject *movie = (RottenTomatoMovieObject *)[self.rottenTomatoFullObject.movies objectAtIndex:indexPath.row];
    return [RottenTomatoTableViewCell getRowHeightForMovie:movie];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rottenTomatoFullObject.movies count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
   
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RottenTomatoMovieObject *movie = (RottenTomatoMovieObject *)[self.rottenTomatoFullObject.movies objectAtIndex:indexPath.row];
    EGYModalWebViewController *webview = [[EGYModalWebViewController alloc] initWithAddress:movie.links.alternate];
    [self presentViewController:webview animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
