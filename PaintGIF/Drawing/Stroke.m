
//
//  Stroke.m
//  PaintGIF
//
//  Created by Vjacheslav Volodjko on 26.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "DrawingEngine.h"

@interface Stroke ()
@property (nonatomic, strong) NSMutableArray *points;
@end


@implementation Stroke

- (instancetype)initWithPoints:(NSArray *)points
{
    self = [super init];
    if (self) {
        self.points = [points mutableCopy];
    }
    return self;
}

- (instancetype)initWithStartPoint:(CGPoint)point timestamp:(NSTimeInterval)timestamp
{
    self = [super init];
    if (self) {
        self.points = [@[] mutableCopy];
        [self addPoint:point timeStamp:timestamp];
    }
    return self;
}

- (void)addPoint:(CGPoint)point timeStamp:(NSTimeInterval)timestamp
{
    StrokePoint *strokePoint = [StrokePoint new];
    strokePoint.point = point;
    strokePoint.timestamp = timestamp;
    [self.points addObject:strokePoint];
}

- (NSArray *)strokePoints
{
    return self.points;
}

@end
