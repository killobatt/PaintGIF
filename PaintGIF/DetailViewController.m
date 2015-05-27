//
//  DetailViewController.m
//  PaintGIF
//
//  Created by Vjacheslav Volodjko on 26.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "DetailViewController.h"
#import "DrawingView.h"
#import "DrawingEngine.h"
#import "AnimatedGIFImageSerialization.h"
@import AssetsLibrary;
@import ImageIO;
@import MobileCoreServices;

@interface DetailViewController ()

@property (assign, nonatomic) BOOL previewState;
@property (weak, nonatomic) IBOutlet DrawingView *drawingView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIButton *previewDrawingButton;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        self.previewState = NO;
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
    
    self.drawingView.hidden = self.previewState;
    self.previewImageView.hidden = !self.previewState;
    self.previewDrawingButton.selected = self.previewState;
    
    self.previewImageView.image = [self.drawingView.drawing smoothAnimatedImage];
    [self.previewImageView startAnimating];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previewToggled:(id)sender
{
    self.previewState = !self.previewState;
    [self configureView];
}

- (IBAction)savePressed:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = self.previewImageView.image;
        NSLog(@"packing image of size: %@ with %lu frames", NSStringFromCGSize(image.size), (unsigned long)image.images.count);
        
        NSError *error = nil;
//        NSData *data = UIImageAnimatedGIFRepresentation(self.previewImageView.image, self.previewImageView.image.duration, 0, &error);
        NSString *filePath = [self UIImageAnimatedGIF:image saveToFile:@"temp.gif" duration:image.duration loopCount:0 error:&error];
        
        if (filePath) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                NSLog(@"Success at %@, error: %@", [assetURL path], error);
            }];
        }
    });
}

- (NSString *)UIImageAnimatedGIF:(UIImage *)image saveToFile:(NSString *)fileName duration:(NSTimeInterval)duration loopCount:(NSUInteger)loopCount error:(NSError * __autoreleasing *)error {
    if (!image.images) {
        return nil;
    }
    
    NSString *directory = NSTemporaryDirectory(); // [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    NSURL *fileURL = [NSURL URLWithString:filePath];
    CFURLRef fileURLRef = (__bridge CFURLRef)fileURL;
    
    NSDictionary *userInfo = nil;
    {
        size_t frameCount = image.images.count;
        NSTimeInterval frameDuration = (duration <= 0.0 ? image.duration / frameCount : duration / frameCount);
        NSDictionary *frameProperties = @{
                                          (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
                                                  (__bridge NSString *)kCGImagePropertyGIFDelayTime: @(frameDuration)
                                                  }
                                          };
        
//        NSMutableData *mutableData = [NSMutableData data];
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL(fileURLRef, kUTTypeGIF, frameCount, NULL);
//        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)mutableData, kUTTypeGIF, frameCount, NULL);
        
        NSDictionary *imageProperties = @{ (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
                                                   (__bridge NSString *)kCGImagePropertyGIFLoopCount: @(loopCount)
                                                   }
                                           };
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)imageProperties);
        
        for (size_t idx = 0; idx < image.images.count; idx++) {
            @autoreleasepool {
                CGImageDestinationAddImage(destination, [[image.images objectAtIndex:idx] CGImage], (__bridge CFDictionaryRef)frameProperties);
            }
        }
        
        BOOL success = CGImageDestinationFinalize(destination);
        CFRelease(destination);
        
        if (!success) {
            userInfo = @{
                         NSLocalizedDescriptionKey: NSLocalizedString(@"Could not finalize image destination", nil)
                         };
            
            goto _error;
        }
        
        return filePath;
//        return [NSData dataWithData:mutableData];
    }
_error: {
    if (error) {
        *error = [[NSError alloc] initWithDomain:AnimatedGIFImageErrorDomain code:-1 userInfo:userInfo];
    }
    return nil;
}
}

@end
