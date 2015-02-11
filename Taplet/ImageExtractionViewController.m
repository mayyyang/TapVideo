//
//  ImageExtractionViewController.m
//  Taplet
//
//  Created by May Yang on 2/6/15.
//  Copyright (c) 2015 May Yang. All rights reserved.
//

#import "ImageExtractionViewController.h"
#import "ImageDisplayViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ImageExtractionViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property UIImage *image;
@property NSMutableArray *timesMutableArray;
@property NSArray *timesArrayToPass;
@property NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@end

@implementation ImageExtractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self playMovie];
    [self setupTap];
    
    self.timesMutableArray = [NSMutableArray new];
    self.images = [NSMutableArray new];

    [self.continueButton setHidden:YES];
    
}


#pragma mark - GESTURE RECOGNIZER METHODS

- (void)setupTap
{
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRollTap:)];
    singleFingerTap.delegate = self;
    singleFingerTap.numberOfTapsRequired = 1;
    [self.movieController.view addGestureRecognizer:singleFingerTap];
}

- (void)handleRollTap:(UITapGestureRecognizer *)sender
{
    float time = [self.movieController currentPlaybackTime];
    [self.timesMutableArray addObject:[NSNumber numberWithFloat:time]];
    
    // Grab currentPlaybackTime and pass it into requestImages.
    
    [self requestImages];
    
    // Add preview image to images array.
    if (self.image !=nil)
    {
        [self.images addObject:self.image];
    }
    
    NSLog(@"%@", self.images);
    
    [self.continueButton setHidden:NO];
   
   
}

// GESTURE RECOGNIZER DELEGATE METHODS: necessary for taps to work.

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // This allows you to dispatch touches
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    // This enables you to handle multiple recognizers on single view
    return YES;
}


#pragma mark - MPMOVIECONTROLELR METHODS

- (void)playMovie
{
    NSString *string = [NSString stringWithFormat:@"%@",self.moviePath];
    NSURL *assetURL = [NSURL URLWithString:string];
    [self.movieController prepareToPlay];
    self.movieController = [[MPMoviePlayerController alloc] initWithContentURL:assetURL];
    [self.movieController.view setFrame:CGRectMake(0, 60, self.view.frame.size.width, 320)];
    [self.movieController setControlStyle:MPMovieControlStyleNone];
    [self.view addSubview:self.movieController.view];
    [self.movieController play];
}

- (void)requestImages
{
    NSArray *time = [[NSArray alloc] initWithArray:self.timesMutableArray]; //Need to convert from NSMutableArray to NSArray to use requestThumbnailImagesAtTimes
    [self.movieController requestThumbnailImagesAtTimes:time timeOption:MPMovieTimeOptionExact];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerThumbnailImageRequestDidFinishNotification:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.movieController];
}


-(void)MPMoviePlayerThumbnailImageRequestDidFinishNotification: (NSNotification*)note
{
    
    NSDictionary * userInfo = [note userInfo];
    self.image = (UIImage *)[userInfo objectForKey:MPMoviePlayerThumbnailImageKey];
    
    // Display preview image.
    if (self.image !=nil)
    {
        [self.imageView setImage:self.image];
    }
  
}


#pragma mark - UIBUTTONS
- (IBAction)continueButton:(UIButton *)sender
{
//    [self.movieController stop];
//    [self dismissMoviePlayerViewControllerAnimated];
    
}

#pragma mark - SEGUE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"display"])
    {
        ImageDisplayViewController *vc = segue.destinationViewController;
        vc.images = self.images;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (self.images.count < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nope!"
                                                        message:@"Please tap more frames."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    [self.movieController stop];
    return YES;
}


@end
