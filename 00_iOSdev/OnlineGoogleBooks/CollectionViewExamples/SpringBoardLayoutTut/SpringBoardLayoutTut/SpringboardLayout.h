//  SpringboardLayout.h

#import <UIKit/UIKit.h>

// INSERT DELEGATE PROTOCOL SNIPPET HERE

@protocol SpringboardLayoutDelegate <UICollectionViewDelegateFlowLayout>

@required

- (BOOL) isDeletionModeActiveForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout;

@end


@interface SpringboardLayout : UICollectionViewFlowLayout

@end
