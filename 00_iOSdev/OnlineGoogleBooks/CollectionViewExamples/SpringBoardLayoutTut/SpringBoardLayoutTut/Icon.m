//  Icon.m


#define MARGIN 2

#import "Icon.h"
#import <QuartzCore/QuartzCore.h>
#import "SpringboardLayoutAttributes.h" // TO UNCOMMENT LATER

static UIImage *deleteButtonImg;

@implementation Icon

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        
        UIView *insetView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, self.bounds.size.width/8, self.bounds.size.height/8)];
        [self.contentView addSubview:insetView];
        
        self.layer.shouldRasterize = YES;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, insetView.frame.size.width, insetView.frame.size.height)];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.numberOfLines = 3;
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        float dim = MIN(self.label.bounds.size.width, self.label.bounds.size.height);
        self.label.clipsToBounds = YES;
        self.label.layer.cornerRadius = dim/8;
        self.label.layer.opacity = 0.7;
        self.label.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.label.layer.borderWidth = 1.0;
        self.label.font = [UIFont systemFontOfSize:dim/6];
        
        self.label.backgroundColor = [UIColor lightGrayColor];
        [insetView addSubview:self.label];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/16, frame.size.width/16, frame.size.width/4, frame.size.width/4)];
        
        
        if (!deleteButtonImg)
        {
            CGRect buttonFrame = self.deleteButton.frame;
            UIGraphicsBeginImageContext(buttonFrame.size);
            CGFloat sz = MIN(buttonFrame.size.width, buttonFrame.size.height);
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(buttonFrame.size.width/2, buttonFrame.size.height/2) radius:sz/2-MARGIN startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
            [path addLineToPoint:CGPointMake(sz-MARGIN, sz-MARGIN)];
            [path moveToPoint:CGPointMake(MARGIN, sz-MARGIN)];
            [path addLineToPoint:CGPointMake(sz-MARGIN, MARGIN)];
            [[UIColor redColor] setFill];
            [[UIColor whiteColor] setStroke];
            [path setLineWidth:3.0];
            [path fill];
            [path stroke];
            deleteButtonImg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        [self.deleteButton setImage:deleteButtonImg forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

// INSERT LAYOUT ATTRIBUTE APPLICATION SNIPPET HERE

- (void)applyLayoutAttributes:(SpringboardLayoutAttributes *)layoutAttributes
{
    if (layoutAttributes.isDeleteButtonHidden)
    {
        self.deleteButton.layer.opacity = 0.0;
        [self stopQuivering];
    }
    else
    {
        self.deleteButton.layer.opacity = 1.0;
        [self startQuivering];
        
    }
}

 

// INSERT CELL ANIMATION SNIPPET HERE

 
- (void)startQuivering
{
    CABasicAnimation *quiverAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    float startAngle = (-2) * M_PI/180.0;
    float stopAngle = -startAngle;
    quiverAnim.fromValue = [NSNumber numberWithFloat:startAngle];
    quiverAnim.toValue = [NSNumber numberWithFloat:3 * stopAngle];
    quiverAnim.autoreverses = YES;
    quiverAnim.duration = 0.2;
    quiverAnim.repeatCount = HUGE_VALF;
    float timeOffset = (float)(arc4random() % 100)/100 - 0.50;
    quiverAnim.timeOffset = timeOffset;
    CALayer *layer = self.layer;
    [layer addAnimation:quiverAnim forKey:@"quivering"];
}

- (void)stopQuivering
{
    CALayer *layer = self.layer;
    [layer removeAnimationForKey:@"quivering"];
}


@end
