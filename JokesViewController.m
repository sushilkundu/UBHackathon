//
//  JokesViewController.m
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "JokesViewController.h"
#import "CacheData.h"
#import "NSObject+DataFetch.h"
#import "AFNetworking.h"
#import "ObjectMapperContainer.h"
#import "ObjectMapper.h"
#import "MBProgressHUD.h"
#import "IIViewDeckController.h"
#import "JokesCompleteObject.h"
#import "JokesTableViewCell.h"
#import "JokeStringObject.h"

@interface JokesViewController ()

@end

@implementation JokesViewController

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
    URLObject *_urlObject = [URLObject defaultGETForURLPath:@"http://api.icndb.com/jokes/random/20" forcedFecth:YES internalClass:@"JokesCompleteObject"];
    ObjectMapperContainer *_objMapperContainer = [ObjectMapperContainer objectMapperContainer];
    [_objMapperContainer addClassNameMapping:[ObjectMapper objectMapperForJsonClass:@"value" toInternalClass:@"JokeStringObject"]];
    [_urlObject setObjectMapperContainer:_objMapperContainer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestDataFromURLObject:_urlObject  completionBlock:^(id aObject, NSError *error) {
        CacheData *_cachedData = (CacheData*)aObject;
        self.jokeObject = (JokesCompleteObject*)_cachedData.cachedData;
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self.jokesTable reloadData];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JokeStringObject *joke = (JokeStringObject *)[self.jokeObject.value objectAtIndex:indexPath.row];
    joke.joke = [joke.joke stringByReplacingOccurrencesOfString:@"&quot" withString:@""];
    JokesTableViewCell *sampleTableCell = [tableView dequeueReusableCellWithIdentifier:@"JokesTableViewCell"];
    if(sampleTableCell == nil) {
        sampleTableCell = (JokesTableViewCell *) [[JokesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RightViewTableCellTableViewCell"];
    }
    [sampleTableCell setData:joke.joke];
    return sampleTableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JokeStringObject *joke = (JokeStringObject *)[self.jokeObject.value objectAtIndex:indexPath.row];
    return [JokesTableViewCell getRowHeightForJokes:joke.joke];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
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
