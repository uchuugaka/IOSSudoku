//
//  sudokuPuzzleView.m
//  Sudoku
//
//  Created by Sean Fitzgerald on 2/26/13.
//  Copyright (c) 2013 ND. All rights reserved.
//

#import "sudokuPuzzleView.h"

@implementation sudokuPuzzleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

 - (void)drawRect:(CGRect)rect {
	 [super drawRect:rect];
 
	 CGContextRef context = UIGraphicsGetCurrentContext();
	 CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
 
	 // Draw them with a 2.0 stroke width so they are a bit more visible.
	 CGContextSetLineWidth(context, 3.0);
 
	 CGContextMoveToPoint(context, 112, 20); //start at this point
 
	 CGContextAddLineToPoint(context, 112, 354); //draw to this point
 
	 // and now draw the Path!
	 CGContextStrokePath(context);
	 
	 CGContextMoveToPoint(context, 208, 20); //start at this point
	 
	 CGContextAddLineToPoint(context, 208, 354); //draw to this point
	 
	 // and now draw the Path!
	 CGContextStrokePath(context);

	 
	 CGContextMoveToPoint(context, 20, 130); //start at this point
	 
	 CGContextAddLineToPoint(context, 300, 130); //draw to this point
	 
	 // and now draw the Path!
	 CGContextStrokePath(context);

	 
	 CGContextMoveToPoint(context, 20, 244); //start at this point
	 
	 CGContextAddLineToPoint(context, 300, 244); //draw to this point
	 
	 // and now draw the Path!
	 CGContextStrokePath(context);

 }

@end
