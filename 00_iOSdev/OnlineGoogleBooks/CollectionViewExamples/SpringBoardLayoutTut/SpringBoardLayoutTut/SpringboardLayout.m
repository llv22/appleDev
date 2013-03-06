//  SpringboardLayout.m

#import "SpringboardLayout.h"
#import "SpringboardLayoutAttributes.h" // TO UNCOMMENT LATER

@implementation SpringboardLayout

- (id)init
{
    if (self = [super init])
    {
        self.itemSize = CGSizeMake(144, 144);
        self.minimumInteritemSpacing = 48;
        self.minimumLineSpacing = 48;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(32, 32, 32, 32);
    }
    return self;
}

// INSERT DELETION MODE SNIPPET HERE

- (BOOL)isDeletionModeOn
{
    if ([[self.collectionView.delegate class] conformsToProtocol:@protocol(SpringboardLayoutDelegate)])
    {
        return [(id)self.collectionView.delegate isDeletionModeActiveForCollectionView:self.collectionView layout:self];
        
    }
    return NO;
    
}

// INSERT ATTRIBUTES SNIPPET HERE

+ (Class)layoutAttributesClass
{
    return [SpringboardLayoutAttributes class];
}

- (SpringboardLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SpringboardLayoutAttributes *attributes = (SpringboardLayoutAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
    if ([self isDeletionModeOn])
        attributes.deleteButtonHidden = NO;
    else
        attributes.deleteButtonHidden = YES;
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributesArrayInRect = [super layoutAttributesForElementsInRect:rect];
    
    for (SpringboardLayoutAttributes *attribs in attributesArrayInRect)
    {
        if ([self isDeletionModeOn]) attribs.deleteButtonHidden = NO;
        else attribs.deleteButtonHidden = YES;
    }
    return attributesArrayInRect;
}



@end
