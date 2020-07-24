//
//  APIManager.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 23/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "APIManager.h"

@interface APIManager()
	
@end

@implementation APIManager

@synthesize accessToken;

- (instancetype)initWithToken:(NSString *)token {
    self = [super init];
    self.accessToken = token;
    return self;
}

- (void)getUserPlaylists: (void (^)(NSDictionary *responseData, NSError *error)) completion {
    // Define base url
    NSURL *URL = [NSURL URLWithString:@"https://api.spotify.com/v1/me/playlists"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // Headers
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:self.accessToken] forHTTPHeaderField:@"Authorization"];

    // Make API request
    [manager GET:[URL absoluteString]
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
             NSLog(@"Reply POST JSON: %@", responseObject);

             completion(responseObject, nil);
         }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error: %@", error);
    
             completion(nil, error);
         }
     ];
}


@end
