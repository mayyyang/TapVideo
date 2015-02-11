//
//  ViewController.m
//  Taplet
//
//  Created by May Yang on 2/6/15.
//  Copyright (c) 2015 May Yang. All rights reserved.
//

#import "RootViewController.h"
#import "ImageExtractionViewController.h"
#import "ImageDisplayViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface RootViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property NSString *moviePath;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)selectVideoButton:(UIButton *)sender
{
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}


#pragma mark - UIIMAGEPICKER METHODS

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays movies.
    mediaUI.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    
    // Hides the controls for trimming videos.  To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = delegate;
    
    [controller presentViewController:mediaUI animated:YES completion:nil];
    
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    // Handle a movied picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo)
    {
        self.moviePath = [info objectForKey:
                                UIImagePickerControllerMediaURL];
        
        // Do something with the picked movie available at moviePath
        
        NSLog(@"%@", info);
        NSLog(@"%@", self.moviePath);

    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"segue" sender:nil];

    }];
    
}


#pragma mark - SEGUES

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segue"])
    {
        ImageExtractionViewController *imageExtractionVC = segue.destinationViewController;
        imageExtractionVC.moviePath = self.moviePath;
    }
}

- (IBAction)unwindToRoot:(UIStoryboardSegue*)unwindSegue
{
    
}


@end
