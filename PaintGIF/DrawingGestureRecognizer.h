//
//  DrawingGestureRecognizer.h
//  PaintGIF
//
//  Created by Vjacheslav Volodjko on 26.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

@import UIKit;



@class DrawingGestureRecognizer;
@class Stroke;



@protocol DrawingGestureRecognizerDelegate <UIGestureRecognizerDelegate>
@optional
- (void)drawingGestureRecognizerMoved:(DrawingGestureRecognizer *)recognizer;
- (void)drawingGestureRecognizer:(DrawingGestureRecognizer *)recognizer recognizedStroke:(Stroke *)stroke;
@end




@interface DrawingGestureRecognizer : UIPanGestureRecognizer
@property (weak, nonatomic) id<DrawingGestureRecognizerDelegate> delegate;
@property (strong, readonly, nonatomic) NSArray *currentStrokes;
@end
