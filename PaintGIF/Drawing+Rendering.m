
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

- (UIImage *)animatedImage
{
    NSMutableArray *images = [@[] mutableCopy];
    for (NSUInteger i = 0; i < self.strokes.count + 1; i++) {
        NSArray *subStrokes = [self.strokes subarrayWithRange:NSMakeRange(0, i)];
        UIImage *image = [self renderStrokes:subStrokes];
        [images addObject:image];
    }
    return [UIImage animatedImageWithImages:images duration:0.5f * (self.strokes.count + 1)];
}

- (UIImage *)renderStrokes:(NSArray *)strokes
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    [self.class drawStrokes:strokes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)drawStrokes:(NSArray *)strokes
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

@end
