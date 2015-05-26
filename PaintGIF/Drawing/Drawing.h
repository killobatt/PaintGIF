//
//  Drawing.h
//  PaintGIF
//
//  Created by Vjacheslav Volodjko on 26.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

@import Foundation;


@class Stroke;



@interface Drawing : NSObject

@property (nonatomic, strong, readonly) NSArray *strokes;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (void)addStroke:(Stroke *)stroke;

@end
