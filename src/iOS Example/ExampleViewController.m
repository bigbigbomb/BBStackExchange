//
//  Created by Brian Romanko on 4/3/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "ExampleViewController.h"
#import "BBStackExchangeNetworkAPIClient.h"
#import "AFNetworking.h"
#import "QuestionTableViewCell.h"
#import "BBStackExchangeAPIClient.h"
#import "BBStackAPISite.h"
#import "BBStackAPICallData.h"


@interface ExampleViewController ()

@property(nonatomic, retain) BBStackExchangeNetworkAPIClient *networkAPIClient;
@property(nonatomic, retain) BBStackExchangeAPIClient *APIClient;
@property(nonatomic, retain) NSArray *questions;
@property(nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;


@end

@implementation ExampleViewController

@synthesize networkAPIClient = _networkAPIClient;
@synthesize questions = _questions;
@synthesize APIClient = _APIClient;
@synthesize activityIndicatorView = _activityIndicatorView;


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _networkAPIClient = [[BBStackExchangeNetworkAPIClient alloc] initWithAccessToken:nil];
    }

    return self;
}

- (void)dealloc {
    [_networkAPIClient release];
    [_questions release];
    [_APIClient release];
    [_activityIndicatorView release];
    [super dealloc];
}

- (void)loadView {
    [super loadView];

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView] autorelease];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)] autorelease];

    self.tableView.rowHeight = 70;

    // Get a site object to
    [self.networkAPIClient getSitesAtPage:nil pageSize:[NSNumber numberWithInt:100] filter:nil success:^(AFHTTPRequestOperation *operation, BBStackAPICallData *callData, NSArray *results) {
        NSPredicate *sitePredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", @"Bicycles"];
        BBStackAPISite *site = [[results filteredArrayUsingPredicate:sitePredicate] lastObject];

        _APIClient = [[BBStackExchangeAPIClient alloc] initWithSite:site accessToken:nil];
        self.title = [NSString stringWithFormat:@"%@ Questions", _APIClient.site.name];
        [self reload];
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)reload {
    [self.activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    [self.APIClient getQuestionsAtPage:nil pageSize:nil fromDate:nil toDate:nil order:BBStackAPISortOrderDescending min:nil
                                   max:nil sort:BBStackAPIQuestionSortCreation tagged:nil filter:@"!-q2R_6TI"
                               success:^(AFHTTPRequestOperation *operation, BBStackAPICallData *callData, NSArray *results) {
                                   self.questions = results;
                                   [self.tableView reloadData];

                                   [self.activityIndicatorView stopAnimating];
                                   self.navigationItem.rightBarButtonItem.enabled = YES;
                               } failure:^(NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.questions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.question = [self.questions objectAtIndex:(NSUInteger) indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end