//
//  Stroke.h
//  PaintGIF
//
//  Created by Vjacheslav Volodjko on 26.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

@import Foundation;
@import CoreGraphics;


@interface Stroke : NSObject

@property (nonatomic, strong, readonly) NSArray *strokePoints;

- (instancetype)initWithPoints:(NSArray *)points;
- (instancetype)initWithStartPoint:(CGPoint)point timestamp:(NSTimeInterval)timestamp;
- (void)addPoint:(CGPoint)point timeStamp:(NSTimeInterval)timestamp;

@end
