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

@end
