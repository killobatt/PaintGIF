//
//  Drawing.m
//  PaintGIF
//
//  Created by Vjacheslav Volodjko on 26.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "DrawingEngine.h"



@interface Drawing ()
@property (nonatomic, strong) NSMutableArray *mutableStrokes;
@end



@implementation Drawing

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mutableStrokes = [@[] mutableCopy];
    }
    return self;
}

- (NSArray *)strokes
{
    return self.mutableStrokes;
}

- (void)addStroke:(Stroke *)stroke
{
    [self.mutableStrokes addObject:stroke];
}

- (void)render
{
    
}

@end
