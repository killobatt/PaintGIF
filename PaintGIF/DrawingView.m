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
    
    self.gestureRecognizer = [[DrawingGestureRecognizer alloc] init];
    self.gestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.gestureRecognizer];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    [self drawStrokes:self.drawing.strokes];
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    [self drawStrokes:self.gestureRecognizer.currentStrokes];
}

- (void)drawStrokes:(NSArray *)strokes
{
    for (Stroke *stroke in strokes) {
        if (stroke.strokePoints.count > 0) {
            UIBezierPath *strokePath = [UIBezierPath bezierPath];
            StrokePoint *strokePoint = stroke.strokePoints.firstObject;
            [strokePath moveToPoint:strokePoint.point];
            
            for (NSUInteger i = 1; i < stroke.strokePoints.count; i++) {
                StrokePoint *strokePoint = stroke.strokePoints[i];
                [strokePath addLineToPoint:strokePoint.point];
            }
            
            strokePath.lineWidth = 10;
            strokePath.lineCapStyle = kCGLineCapRound;
            strokePath.lineJoinStyle = kCGLineJoinRound;
            [strokePath stroke];
        }
    }
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
