//
//  Song.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 27/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Song : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *explicit;
@property (nonatomic, strong) NSString *spotifyID;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *authorName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
