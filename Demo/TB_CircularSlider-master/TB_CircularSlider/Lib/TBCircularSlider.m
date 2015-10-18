//
//  TBCircularSlider.m
//  TB_CircularSlider
//
//  Created by Yari Dareglia on 1/12/13.
//  Copyright (c) 2013 Yari Dareglia. All rights reserved.
//

#import "TBCircularSlider.h"
#import "Commons.h"

/** Helper Functions **/
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

/** Parameters **/
#define TB_SAFEAREA_PADDING 60


#pragma mark - Private -

@interface TBCircularSlider(){
    UITextField *_textField;
    int radius;
    
    UIImageView *pan;
    
    
}
@end


#pragma mark - Implementation -

@implementation TBCircularSlider

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        self.opaque = NO;
        
        //Define the circle radius taking into account the safe area
        radius = self.frame.size.width/2 - TB_SAFEAREA_PADDING;
        
        //Initialize the Angle at 0
        self.angle = 0;
        self.steps = 7;
        
        //Define the Font
        UIFont *font = [UIFont fontWithName:TB_FONTFAMILY size:TB_FONTSIZE];
        //Calculate font size needed to display 3 numbers
        NSString *str = @"000";
        CGSize fontSize = [str sizeWithFont:font];
        
        


        
        
        [self addPanzi];
        
        
        //Using a TextField area we can easily modify the control to get user input from this field
        _textField = [[UITextField alloc]initWithFrame:CGRectMake((frame.size.width  - fontSize.width) /2,
                                                                  (frame.size.height - fontSize.height) /2,
                                                                  fontSize.width,
                                                                  fontSize.height)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = appMainColor;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = font;
        _textField.text = [NSString stringWithFormat:@"%d",self.angle];
        _textField.enabled = NO;
        
        [self addSubview:_textField];
        

        _textField.transform = CGAffineTransformMakeRotation(90 * (M_PI /180.0f));

        
    }
    
    return self;
}


#pragma mark - 盘子 -


-(void)addPanzi{
    
    
    //带三角的盘
    int pansizeWidth = radius*2;
    
    pan = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"box"]];
    [pan setBackgroundColor:[UIColor clearColor]];
    [pan setContentMode:UIViewContentModeScaleAspectFit];
    [pan setUserInteractionEnabled:NO];
    [pan setFrame:CGRectMake((self.frame.size.width-pansizeWidth)/2,(self.frame.size.height-pansizeWidth)/2 , pansizeWidth, pansizeWidth)];
    [self addSubview:pan];

    
    
}




#pragma mark - UIControl Override -

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    //We need to track continuously
    return YES;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];

    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];

    //Use the location to design the Handle
    [self movehandle:lastPoint];
    
    //Control value has changed, let's notify that   
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
}


#pragma mark - Drawing Functions - 

//Use the draw rect to draw the Background, the Circle and the Handle 
-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
/** Draw the Background **/
    
    //Create the path
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, 0, M_PI *2, 0);
    
    //Set the stroke color to black
    
    [[UIColor colorWithRed:233/255.f green:233/255.f blue:233/255.f alpha:1.0] setStroke];
    
    //Define line width and cap
    CGContextSetLineWidth(ctx, TB_BACKGROUND_WIDTH);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    
    //draw it!
    CGContextDrawPath(ctx, kCGPathStroke);
    
   
//** Draw the circle (using a clipped gradient) **/
    
    
    /** Create THE MASK Image **/
    UIGraphicsBeginImageContext(CGSizeMake(TB_SLIDER_SIZE,TB_SLIDER_SIZE));
    CGContextRef imageCtx = UIGraphicsGetCurrentContext();
    int transferangle = 0 ;
    if (self.angle == 0) {
        transferangle = 0;
    }
    else if (self.angle == 360){
        transferangle = 360;
    }
    else{
        transferangle = 360-self.angle;
        
    }
    
    CGContextAddArc(imageCtx, self.frame.size.width/2  , self.frame.size.height/2, radius, 0, ToRad(transferangle), 1);
    [[UIColor blackColor]set];
    
    
    
    //投影光效果
    //Use shadow to create the Blur effect
//    CGContextSetShadowWithColor(imageCtx, CGSizeMake(0, 0), self.angle/20, [UIColor blackColor].CGColor);
    
    //define the path
    CGContextSetLineWidth(imageCtx, TB_LINE_WIDTH);
    CGContextDrawPath(imageCtx, kCGPathStroke);
    
    //save the context content into the image mask
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    

    /** Clip Context to the mask **/
    CGContextSaveGState(ctx);
    
    CGContextClipToMask(ctx, self.bounds, mask);
    CGImageRelease(mask);
    
    
    
    /** THE GRADIENT **/
  
    
    //list of components
    CGFloat components[4] = {
        128/255.f, 196/255.f, 62/255.f, 1.0};   // End color - Violet

//    CGFloat components[8] = {
//        1.0, 0.0, 0.0, 1.0,     // Start color - Blue
//        1.0, 0.0, 0.0, 1.0 };   // End color - Violet
    CGFloat locations[3]={0,0,0};
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, 1);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    
    //Gradient direction
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    //Draw the gradient
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    CGContextRestoreGState(ctx);

    
    
/** Add some light reflection effects on the background circle**/
    
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
//    //Draw the outside light
//    CGContextBeginPath(ctx);
//    CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, radius+TB_BACKGROUND_WIDTH/2, 0, ToRad(-self.angle), 1);
//    [[UIColor colorWithWhite:1.0 alpha:0.05]set];
//    CGContextDrawPath(ctx, kCGPathStroke);
//    
//    //draw the inner light
//    CGContextBeginPath(ctx);
//    CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, radius-TB_BACKGROUND_WIDTH/2, 0, ToRad(-self.angle), 1);
//    [[UIColor colorWithWhite:1.0 alpha:0.05]set];
//    CGContextDrawPath(ctx, kCGPathStroke);
    
    
/** Draw the handle **/
//    [self drawTheHandle:ctx];
    
    
    [self drawSteps:ctx];
    
    self.transform = CGAffineTransformMakeRotation(-90 * (M_PI /180.0f));

    
}

/** Draw a white knob over the circle **/
-(void) drawTheHandle:(CGContextRef)ctx{
    
    CGContextSaveGState(ctx);
    
    //I Love shadows
//    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3, [UIColor blackColor].CGColor);
    
    //Get the handle position
    CGPoint handleCenter =  [self pointFromAngle: self.angle];
    
    //Draw It! hander
//    [[UIColor colorWithRed:128/255.f green:196/255.f blue:62/255.f alpha:1.f]set];
//    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, TB_LINE_WIDTH, TB_LINE_WIDTH));
//    
//    CGContextRestoreGState(ctx);
    
    
    
    
    
    /*图片*/
    UIImage *image = [UIImage imageNamed:@"round_button"];
    [image drawInRect:CGRectMake(handleCenter.x, handleCenter.y, TB_LINE_WIDTH, TB_LINE_WIDTH)];//在坐标中画出图片
//    CGContextDrawImage(ctx, CGRectMake(handleCenter.x, handleCenter.y, TB_LINE_WIDTH, TB_LINE_WIDTH), image.CGImage);
}





-(void) drawSteps:(CGContextRef)ctx{
    float everangle = 360.0 /self.steps;
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

    for (int i = 0; i < self.steps ; i++) {
        float currentangle = everangle * (i +1 );
        
//        float angleInt = floor(currentangle);
        float angleInt = currentangle;
        NSLog(@"%f step",currentangle);
       float acturalRad = radius + TB_LINE_WIDTH/2 -2;
        
        float inner = 18.0;
        float innerrad = acturalRad - inner;
 
        float X =  0.0;
        float Y =  0.0;
        float innerX = 0.0;
        float innerY = 0.0;

       X  = round(centerPoint.x + acturalRad * cos(ToRad(-angleInt))) ;
       Y = round(centerPoint.y + acturalRad * sin(ToRad(-angleInt))) ;

        innerX = round(centerPoint.x + innerrad * cos(ToRad(-angleInt)));
        innerY = round(centerPoint.y + innerrad * sin(ToRad(-angleInt))) ;

        CGPoint aPoints[2];//坐标点
        aPoints[0] =CGPointMake(X, Y);//坐标1
        aPoints[1] =CGPointMake(innerX, innerY);//坐标2
        //CGContextAddLines(CGContextRef c, const CGPoint points[],size_t count)
        //points[]坐标数组，和count大小
        CGContextSetRGBStrokeColor(ctx,
                                   1.0, 1.0, 1.0, 1.0);
         CGContextSetShadowWithColor(ctx, CGSizeMake(0,0), 2, RGB(174,174,174).CGColor);
        CGContextAddLines(ctx, aPoints, 2);//添加线
        CGContextDrawPath(ctx, kCGPathStroke); //根据坐标绘制路径
        
        
    }
    
    
    
    
    
    
}




#pragma mark - Math -

/** Move the Handle **/
-(void)movehandle:(CGPoint)lastPoint{
    
    //Get the center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    int angleInt = floor(currentAngle);
    
    
    
    //Store the new angle
    self.angle =  angleInt;//本来是360-angleInt
    //Update the textfield 
    _textField.text =  [NSString stringWithFormat:@"%d", self.angle];
    
    //Redraw
    [self setNeedsDisplay];
    
    
    //旋转盘子
    pan.transform = CGAffineTransformMakeRotation(angleInt * (M_PI /180.0f));
    

    
}

/** Given the angle, get the point position on circumference **/
-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - TB_LINE_WIDTH/2, self.frame.size.height/2 - TB_LINE_WIDTH/2);
    //The point position on the circumference
    CGPoint result;
    // hander的半径控制
    int smallradius = radius - 30;
    
    result.y = round(centerPoint.y + smallradius * sin(ToRad(-angleInt))) ;
    result.x = round(centerPoint.x + smallradius * cos(ToRad(-angleInt))) ;
    return result;
}

//Sourcecode from Apple example clockControl 
//Calculate the direction in degrees from a center point to an arbitrary position.
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}
@end


