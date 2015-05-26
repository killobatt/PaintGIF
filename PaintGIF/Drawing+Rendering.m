
//
//  Drawing+Drawing_Rendering.m
//  PaintGIF
//
//  Created by Vjacheslav Volodjko on 27.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "Drawing+Rendering.h"
#import "DrawingEngine.h"

@implementation Drawing (Drawing_Rendering)

#pragma mark - Stroke-by-stroke animation

- (UIImage *)animatedImage
{
    NSMutableArray *images = [@[] mutableCopy];
    for (NSUInteger i = 0; i < self.strokes.count + 1; i++) {
        NSArray *subStrokes = [self.strokes subarrayWithRange:NSMakeRange(0, i)];
        UIImage *image = [self renderStrokes:subStrokes byTimePoint:[[NSDate distantFuture] timeIntervalSince1970]];
        [images addObject:image];
    }
    return [UIImage animatedImageWithImages:images duration:0.5f * (self.strokes.count + 1)];
}

- (UIImage *)renderStrokes:(NSArray *)strokes byTimePoint:(NSTimeInterval)timePoint
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    [self.class drawStrokes:strokes byTimePoint:timePoint];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//+ (void)drawStrokes:(NSArray *)strokes
//{
//    for (Stroke *stroke in strokes) {
//        if (stroke.strokePoints.count > 0) {
//            UIBezierPath *strokePath = [UIBezierPath bezierPath];
//            StrokePoint *strokePoint = stroke.strokePoints.firstObject;
//            [strokePath moveToPoint:strokePoint.point];
//            
//            for (NSUInteger i = 1; i < stroke.strokePoints.count; i++) {
//                StrokePoint *strokePoint = stroke.strokePoints[i];
//                [strokePath addLineToPoint:strokePoint.point];
//            }
//            
//            strokePath.lineWidth = 10;
//            strokePath.lineCapStyle = kCGLineCapRound;
//            strokePath.lineJoinStyle = kCGLineJoinRound;
//            [strokePath stroke];
//        }
//    }
//}

#pragma mark - Smooth animation

- (UIImage *)smoothAnimatedImage
{
    NSTimeInterval duration = [self normalizeTimestamps];
    NSMutableArray *images = [@[] mutableCopy];

    for (NSTimeInterval timeCursor = 0; timeCursor <= duration; timeCursor += [self secondsPerFrame]) {
        UIImage *image = [self renderStrokes:self.strokes byTimePoint:timeCursor];
        [images addObject:image];
    }
    
    return [UIImage animatedImageWithImages:images duration:duration];
}

// returns duration
- (NSTimeInterval)normalizeTimestamps
{
    Stroke *firstStroke = self.strokes.firstObject;
    NSTimeInterval minTimestamp = [firstStroke.strokePoints.firstObject timestamp];
    NSTimeInterval maxTimestamp = [firstStroke.strokePoints.firstObject timestamp];
    for (Stroke *stroke in self.strokes) {
        for (StrokePoint *strokePoint in stroke.strokePoints) {
            if (minTimestamp > strokePoint.timestamp) {
                minTimestamp = strokePoint.timestamp;
            }
            if (maxTimestamp < strokePoint.timestamp) {
                maxTimestamp = strokePoint.timestamp;
            }
        }
    }

    for (Stroke *stroke in self.strokes) {
        for (StrokePoint *strokePoint in stroke.strokePoints) {
            strokePoint.timestamp -= minTimestamp;
        }
    }
    return maxTimestamp - minTimestamp;
}

- (NSTimeInterval)secondsPerFrame
{
    return 1.0f / [self fps];
}

- (NSTimeInterval)fps
{
    return 20.0f;
}

+ (void)drawStrokes:(NSArray *)strokes
{
    [self drawStrokes:strokes byTimePoint:[[NSDate distantFuture] timeIntervalSince1970]];
}

// TO DO: incremental drawing, based on previous image;
// TO DO: if nothing changed on increment, reduse time pause to fixed time;
+ (void)drawStrokes:(NSArray *)strokes byTimePoint:(NSTimeInterval)timePoint
{
    for (Stroke *stroke in strokes) {
        if (stroke.strokePoints.count > 0) {
            UIBezierPath *strokePath = [UIBezierPath bezierPath];
            StrokePoint *strokePoint = stroke.strokePoints.firstObject;
            [strokePath moveToPoint:strokePoint.point];
            
            for (NSUInteger i = 1; i < stroke.strokePoints.count; i++) {
                StrokePoint *strokePoint = stroke.strokePoints[i];
                if (strokePoint.timestamp > timePoint) {
                    break;
                }
                [strokePath addLineToPoint:strokePoint.point];
            }
            
            strokePath.lineWidth = 10;
            strokePath.lineCapStyle = kCGLineCapRound;
            strokePath.lineJoinStyle = kCGLineJoinRound;
            [strokePath stroke];
        }
    }
}


@end
