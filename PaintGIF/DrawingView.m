//
//  DrawingView.m
//  PaintGIF
//
//  Created by Vjacheslav Volodjko on 26.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "DrawingView.h"
#import "DrawingEngine.h"
#import "DrawingGestureRecognizer.h"

@interface DrawingView ()< DrawingGestureRecognizerDelegate >
@property (nonatomic, strong) DrawingGestureRecognizer *gestureRecognizer;
@end

@implementation DrawingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.drawing = [[Drawing alloc] init];
    self.drawing.size = self.bounds.size;
    
    self.gestureRecognizer = [[DrawingGestureRecognizer alloc] init];
    self.gestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.gestureRecognizer];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    self.drawing.size = self.bounds.size;
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    [Drawing drawStrokes:self.drawing.strokes];
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    [Drawing drawStrokes:self.gestureRecognizer.currentStrokes];
}

#pragma mark - DrawingGestureRecognizer Delegate

- (void)drawingGestureRecognizerMoved:(DrawingGestureRecognizer *)recognizer
{
    [self setNeedsDisplay];
}

- (void)drawingGestureRecognizer:(DrawingGestureRecognizer *)recognizer recognizedStroke:(Stroke *)stroke
{
    if (recognizer == self.gestureRecognizer) {
        [self.drawing addStroke:stroke];
        [self setNeedsDisplay];
    }
}

@end
