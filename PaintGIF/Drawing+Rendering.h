//
//  Drawing+Drawing_Rendering.h
//  PaintGIF
//
//  Created by Vjacheslav Volodjko on 27.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "Drawing.h"
@import UIKit;

@interface Drawing (Drawing_Rendering)

- (UIImage *)animatedImage;
- (UIImage *)smoothAnimatedImage;

+ (void)drawStrokes:(NSArray *)strokes;

@end
