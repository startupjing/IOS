//
//  battle_smoothedBIView.m
//  ChineseMinusMinus
//
//  Created by Azure Hu on 4/17/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import "battle_smoothedBIView.h"

@implementation battle_smoothedBIView


{
    UIBezierPath *path;
    UIImage *incrementalImage;
    CGPoint pts[5]; // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    uint ctr;
    
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        
        path = [UIBezierPath bezierPath];
        [path setLineWidth:25.5];
        
        
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMultipleTouchEnabled:NO];
        path = [UIBezierPath bezierPath];
        [path setLineWidth:25.5];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect

{
    
    [incrementalImage drawInRect:rect];
    [path stroke];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    /*
     NSString * curChar = [[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"];
     NSMutableString * curChar_pic = [NSMutableString stringWithString:curChar];
     [curChar_pic appendString:@"_mizige"];
     //NSString *currCharacter = @"ri";
     
     UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", curChar_pic]]];
     [background setFill];
     
     
     UIGraphicsBeginImageContext(self.frame.size);
     [[UIImage imageNamed:@"yue_mizige.png"] drawInRect:self.bounds];
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     self.backgroundColor = [UIColor colorWithPatternImage:image];
     
     
     
     */
    
    NSLog(@"begin touch");
    ctr = 0;
    UITouch *touch = [touches anyObject];
    pts[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSString *currCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"currChar"];
    //
    //    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", currCharacter]]];
    //    [background setFill];
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    ctr++;
    pts[ctr] = p;
    if (ctr == 4)
    {
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
        
        [path moveToPoint:pts[0]];
        [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
        
        [self setNeedsDisplay];
        // replace points and get ready to handle the next segment
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSString *currCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"currChar"];
    //
    //    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", currCharacter]]];
    //    [background setFill];
    [self drawBitmap];
    NSLog(@"touch end");
    [self setNeedsDisplay];
    [path removeAllPoints];
    ctr = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //    NSString *currCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"currChar"];
    //
    //    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", currCharacter]]];
    //    [background setFill];
    [self touchesEnded:touches withEvent:event];
}



- (void)drawBitmap
{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    if (!incrementalImage) // first time; paint background white
    {
        NSLog(@"inside if");
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        
        
        
        /*
         
         NSString * curChar = [[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"];
         NSMutableString * curChar_pic = [NSMutableString stringWithString:curChar];
         [curChar_pic appendString:@"_mizige"];
         //NSString *currCharacter = @"ri";
         
         
         
         UIImage* back_image = [UIImage imageNamed:curChar_pic];
         
         
         UIColor *background = [[UIColor alloc] initWithPatternImage:back_image];
         
         
         
         
         
         //UIColor *background = [UIColor whiteColor];
         [background setFill];
         
         */
        
        
        NSString * currCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"battle_curChar"];
        
        NSMutableString * curChar = [[NSMutableString alloc] initWithString: currCharacter];
        [curChar appendString:@"_mizige.jpg"];
        
        
        UIGraphicsBeginImageContext(self.frame.size);
        [[UIImage imageNamed:curChar] drawInRect:self.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIColor *c = [UIColor colorWithPatternImage:image];
        [c setFill];
        
        
        [rectpath fill];
        
    }
    
    
    
    /*
     
     NSString *currCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"];
     
     //NSString *currCharacter = @"ri";
     NSLog(@"haha: %@", currCharacter);
     UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", currCharacter]]];
     
     //UIColor *background = [UIColor whiteColor];
     [background setFill];
     */
    
    
    
    NSString * currCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"battle_curChar"];
    NSMutableString * curChar = [[NSMutableString alloc] initWithString: currCharacter];
    [curChar appendString:@"_mizige.jpg"];
    
    UIGraphicsBeginImageContext(self.frame.size);
    [[UIImage imageNamed:curChar] drawInRect:self.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UIColor *c = [UIColor colorWithPatternImage:image];
    [c setFill];
    
    //self.backgroundColor = [UIColor colorWithPatternImage:image];
    
    [incrementalImage drawAtPoint:CGPointZero];
    [[UIColor blackColor] setStroke];
    [path stroke];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
}

@end