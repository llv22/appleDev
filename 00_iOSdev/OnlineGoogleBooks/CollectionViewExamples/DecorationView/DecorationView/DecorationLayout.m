//
//  DecorationLayout.m
//  DecorationView
//
//  Created by Ding Orlando on 3/10/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//
//  see sample of
//  1, http://blogs.captechconsulting.com/blog/paul-dakessian/ios-6-tutorial-getting-started-collection-views
//  2, http://stackoverflow.com/questions/12810628/uicollectionview-decoration-view
//  3, http://www.appcoda.com/ios-programming-uicollectionview-tutorial/
//

#import "DecorationViewCell.h"
#import "DecorationLayout.h"

@implementation DecorationLayout

-(void)prepareLayout{
    // desc - dummy register
    [self registerClass:[DecorationViewCell class] forDecorationViewOfKind:DECORID];
}

// desc - dummy decoration
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return  NULL;
}

#pragma mark - decoration layout delegate
// desc - dummy decoration
-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                                                 atIndexPath:(NSIndexPath *)indexPath{
    return NULL;
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind
                                                                                    atIndexPath:(NSIndexPath *)decorationIndexPath{
    return NULL;
}

-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingDecorationElementOfKind:(NSString *)elementKind
                                                                                     atIndexPath:(NSIndexPath *)decorationIndexPath{
    return NULL;
}

@end
