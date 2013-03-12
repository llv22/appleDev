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
//  4, http://nshipster.com/uicollectionview/
//  5, http://www.skeuo.com/uicollectionview-custom-layout-tutorial
//
//  example of collection view under iOS 4.3-
//  1, https://github.com/steipete/PSTCollectionView
//  2, http://code4app.com/ios/类似NewsStand书架效果/4fdd40d66803fadf22000000
//

#import "DecorationViewCell.h"
#import "DecorationLayout.h"

// see http://stackoverflow.com/questions/6828831/sending-const-nsstring-to-parameter-of-type-nsstring-discards-qualifier
static NSString * const DECORID = @"DecorationViewForCell";

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
