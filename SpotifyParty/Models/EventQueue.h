//
//  EventQueue.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 31/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <Parse/Parse.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventQueue : PFObject <PFSubclassing>

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *songURI;


- (instancetype) initLike: (NSString * _Nullable) songURI inEvent: (Event * _Nullable) event;
    
@end

NS_ASSUME_NONNULL_END
