BBStackExchange is an Objective-C client API wrapper for the [StackExchange API].
This is the client wrapper that powers [StackTrace], the world's most awesome iPad Stack Overflow app.
It sits on top of [AFNetworking] and makes integrating your iOS app with Stack Exchange incredibly easy. Here's an example:

``` objective-c
[self.APIClient getQuestionsAtPage:nil pageSize:nil fromDate:nil toDate:nil order:BBStackAPISortOrderDescending min:nil
                               max:nil sort:BBStackAPIQuestionSortCreation tagged:nil filter:nil
                           success:^(AFHTTPRequestOperation *operation, BBStackAPICallData *callData, NSArray *results) {
                               NSLog(@"Grabbed %d questions!", results.count);
                           } failure:nil];
```

## Installation


## Overview

There are two main API clients for accessing the Stack Exchange API.

- **BBStackExchangeNetworkAPIClient**
  Provides access to Network Methods that do not require a specific site parameter
- **BBStackExchangeAPIClient**
  Provides access to Per-Site methods that require a specific site parameter


## Requirements

Due to usage of AFNetworking, BBStackExchange requires iOS 4.0 and higher. It will probably work on Mac OS as well although this hasn't been tested.


  [StackExchange API]: http://api.stackexchange.com
  [AFNetworking]: https://github.com/AFNetworking/AFNetworking
  [StackTrace]: http://stacktraceapp.com