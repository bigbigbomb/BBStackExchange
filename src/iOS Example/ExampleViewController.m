//
//  Created by Brian Romanko on 4/3/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "ExampleViewController.h"
#import "BBStackExchangeNetworkAPIClient.h"
#import "AFNetworking.h"
#import "QuestionTableViewCell.h"


@interface ExampleViewController ()

@property(nonatomic, retain) BBStackExchangeNetworkAPIClient *APIClient;
@property(nonatomic, retain) NSArray *questions;


@end

@implementation ExampleViewController

@synthesize APIClient = _APIClient;
@synthesize questions = _questions;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _APIClient = [[BBStackExchangeNetworkAPIClient alloc] initWithAccessToken:nil];
    }

    return self;
}

- (void)dealloc {
    [_APIClient release];
    [_questions release];
    [super dealloc];
}

- (void)loadView {
    [super loadView];

    self.tableView.rowHeight = 70;
    self.title = @"Newest Questions";

    [self reload];
}

- (void)reload {
    [self.APIClient getSitesAtPage:nil pageSize:nil filter:nil success:^(AFHTTPRequestOperation *operation, BBStackAPICallData *callData, NSArray *results) {
        self.questions = results;
        [self.tableView reloadData];
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

//    cell.tweet = [_tweets objectAtIndex:indexPath.row];
//
    return cell;
}

#pragma mark - UITableViewDelegate


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [TweetTableViewCell heightForCellWithTweet:[_tweets objectAtIndex:indexPath.row]];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end