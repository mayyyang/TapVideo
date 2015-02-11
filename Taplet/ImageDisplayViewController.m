//
//  ImageDisplayViewController.m
//  Taplet
//
//  Created by May Yang on 2/8/15.
//  Copyright (c) 2015 May Yang. All rights reserved.
//

#import "ImageDisplayViewController.h"
#import "ImageCollectionViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ImageDisplayViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property NSArray *timesArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ImageDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

#pragma mark - UIBUTTONS
- (IBAction)startOverButton:(UIButton *)sender
{
    [self.images removeAllObjects];
    [self.movieController stop];
    [self performSegueWithIdentifier:@"unwindToRoot" sender:self];

}

- (IBAction)previousButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICOLLECTIONVIEW METHODS

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = (UIImage *)[self.images objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *imageToSave = [cell.imageView image];
    UIImageWriteToSavedPhotosAlbum(imageToSave,
                                   self, // send the message to 'self' when calling the callback
                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                   NULL); // you generally won't need a contextInfo here
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry."
                                                        message:@"Error saving photo"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"Photo saved to camera roll"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
