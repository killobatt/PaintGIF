//
//  DrawingGestureRecognizer.m
//  PaintGIF
//
//  Created by Vjacheslav Volodjko on 26.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "DrawingGestureRecognizer.h"
#import "Stroke.h"




@interface DrawingGestureRecognizer ()
@property (nonatomic, strong) NSMutableDictionary *touchTraces;
@end


@implementation DrawingGestureRecognizer

@dynamic delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.touchTraces = [@{} mutableCopy];
    }
    return self;
}

- (NSArray *)currentStrokes
{
    return self.touchTraces.allValues;
}

- (id<NSCopying>)keyForTouch:(UITouch *)touch
{
    return [NSValue valueWithPointer:(__bridge const void *)(touch)];
}

- (Stroke *)strokeForTouch:(UITouch *)touch
{
    return self.touchTraces[[self keyForTouch:touch]];
}

- (void)recordTouchBegan:(UITouch *)touch
{
    Stroke *stroke = [[Stroke alloc] initWithPoints:@[]];
    self.touchTraces[[self keyForTouch:touch]] = stroke;
    [self recordTouchMoved:touch];
}

- (void)recordTouchMoved:(UITouch *)touch
{
    CGPoint touchLocation = [touch locationInView:self.view];
    [[self strokeForTouch:touch] addPoint:touchLocation timeStamp:touch.timestamp];
    
    if ([self.delegate respondsToSelector:@selector(drawingGestureRecognizerMoved:)]) {
        [self.delegate drawingGestureRecognizerMoved:self];
    }
}

- (void)recordTouchEnded:(UITouch *)touch
{
    [self recordTouchMoved:touch];
    if ([self.delegate respondsToSelector:@selector(drawingGestureRecognizer:recognizedStroke:)]) {
        [self.delegate drawingGestureRecognizer:self recognizedStroke:[self strokeForTouch:touch]];
    }
    [self.touchTraces removeObjectForKey:[self keyForTouch:touch]];
}

- (void)recordTouchCanceled:(UITouch *)touch
{
    [self.touchTraces removeObjectForKey:[self keyForTouch:touch]];
}

#pragma mark - Overrides

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan: %@", touches);
    
    for (UITouch *touch in touches) {
        [self recordTouchBegan:touch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved: %@", touches);
    
    for (UITouch *touch in touches) {
        [self recordTouchMoved:touch];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded: %@", touches);
    
    for (UITouch *touch in touches) {
        [self recordTouchEnded:touch];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled: %@ ", touches);
    
    for (UITouch *touch in touches) {
        [self recordTouchCanceled:touch];
    }
}

@end
