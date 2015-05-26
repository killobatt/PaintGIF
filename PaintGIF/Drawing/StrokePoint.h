//
//  StrokePoint.h
//  PaintGIF
//
//  Created by Vjacheslav Volodjko on 26.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

@import Foundation;
@import CoreGraphics;



@interface StrokePoint : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) NSTimeInterval timestamp;

@end

