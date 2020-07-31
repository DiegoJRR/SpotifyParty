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

-(void)getPlaylistTracks: (NSString * _Nullable) playlistID withCompletion: (void (^)(NSDictionary *responseData, NSError *error)) completion {
    
    NSString *baseURL = [@"https://api.spotify.com/v1/playlists/" stringByAppendingString:playlistID];
    
    // Define base url
    NSURL *URL = [NSURL URLWithString:[baseURL stringByAppendingString:@"/tracks"]];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // Headers
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:self.accessToken] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:[@"application/json" stringByAppendingString:self.accessToken] forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[@"application/json" stringByAppendingString:self.accessToken] forHTTPHeaderField:@"Accept"];

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

- (void) getTrack: (NSString * _Nullable) trackURI withCompletion: (void (^)(NSDictionary *responseData, NSError *error)) completion {

    NSString *baseURL = [@"https://api.spotify.com/v1/tracks/" stringByAppendingString:trackURI];

    // Define base url
    NSURL *URL = [NSURL URLWithString:baseURL];

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

-(void) postTracksToPlaylist: (NSArray * _Nullable) songsURIS toPlaylist: (NSString * _Nullable) playlistURI withCompletion: (void (^)(NSDictionary *responseData, NSError *error)) completion {

    NSString *baseURL = [[@"https://api.spotify.com/v1/playlists/" stringByAppendingString:playlistURI] stringByAppendingString:@"/tracks?uris="];
    
    NSString *tracksString = @"";
    
    for (NSString *songURI in songsURIS) {
        NSString *queryParam = [@"spotify:track:" stringByAppendingString:songURI];
        tracksString = [tracksString stringByAppendingString:queryParam];
        tracksString = [tracksString stringByAppendingString:@","];
    }
    
    // Removes the last added comma to the parameters
    tracksString = [tracksString substringToIndex:[tracksString length] - 1];
    baseURL = [baseURL stringByAppendingString:tracksString];
    

    // Define base url
    NSURL *URL = [NSURL URLWithString:baseURL];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    // Headers
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:self.accessToken] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    // Make API request
    [manager POST:[URL absoluteString]
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
