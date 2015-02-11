//
//  ImageDisplayViewController.h
//  Taplet
//
//  Created by May Yang on 2/8/15.
//  Copyright (c) 2015 May Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ImageDisplayViewController : UIViewController
@property MPMoviePlayerController *movieController;
@property NSMutableArray *receivedTimesArray;
@property NSMutableArray *images;

@end
