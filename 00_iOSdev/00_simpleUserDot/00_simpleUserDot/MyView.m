//
//  MyView.m
//  00_simpleUserDot
//
//  Created by Ding Orlando on 9/16/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "MyView.h"

@implementation MyView

//TODO : external bounds for MyView should be adjusted correctly, inside MyView, no explict screen size calculation.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /** -- manually change logic before --
         * UIScrollView* sv = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
         * CGRect _rect = [[UIScreen mainScreen]applicationFrame];
         * _rect.size.height -= 50;
         **/
        self->_sv = [[UIScrollView alloc]initWithFrame:self.bounds];
        self->_iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Floor.png"]];
        [self->_sv addSubview:self->_iv];
        /** -- manually change logic before --
         * CGSize sz = sv.bounds.size;
         **/
        self->_sv.contentSize = self->_iv.bounds.size;
        /** -- manually change logic before --
         * [self addSubview:self->_iv];//to full screen occupied
         **/
        self->_sv.delegate = self;
        [self addSubview:self->_sv];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //desc - gets called when user scrolls or drags
    self->_sv.alpha = 0.85f;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //desc - gets called only after scrolling
    self->_sv.alpha = 1.0f;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //desc - make sure that alpha is reset even if the user is dragging
    self->_sv.alpha = 1.0f;
}

@end
