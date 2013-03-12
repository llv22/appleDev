//  ViewController.m


#import "ViewController.h"
#import "SimpleModel.h"
#import "Icon.h"
#import "SpringboardLayout.h"


@implementation ViewController
{
    SimpleModel *model;
    BOOL isDeletionModeActive; // TO UNCOMMENT LATER
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [[SimpleModel alloc] init];
	[self.collectionView registerClass:[Icon class] forCellWithReuseIdentifier:@"ICON"];
    //INSERT GESTURE RECOGNIZER CREATION SNIPPET HERE:

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(activateDeletionMode:)];
    longPress.delegate = self;
    [self.collectionView addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endDeletionMode:)];
    tap.delegate = self;
    [self.collectionView addGestureRecognizer:tap];


}

#pragma mark - data source methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return model.fontFamilies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Icon *icon = [collectionView dequeueReusableCellWithReuseIdentifier:@"ICON" forIndexPath:indexPath];
    icon.label.text = [model.fontFamilies objectAtIndex:indexPath.row];
    
    // INSERT DELETE BUTTON CONFIG SNIPPET HERE
    [icon.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];

    
    return icon;
}

// INSERT DELETE BUTTON ACTION SNIPPET HERE

#pragma mark - delete for button

- (void)delete:(UIButton *)sender
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(Icon *)sender.superview.superview];
    [model.fontFaces removeObjectForKey:[model.fontFamilies objectAtIndex:indexPath.row]];
    [model.fontFamilies removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    
}

// END DELETE BUTTON ACTION SNIPPET

#pragma mark - delegate methods


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.frame = [UIScreen mainScreen].bounds;
    NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] init];
    NSArray *faces = [model.fontFaces objectForKey:[model.fontFamilies objectAtIndex:indexPath.row]];
    for ( NSString *face in faces)
    {
        [attribString appendAttributedString:[[NSAttributedString alloc]
                                              initWithString:
                                              [NSString stringWithFormat:@"%@\n", face]
                                              attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:face size:30.0] forKey:NSFontAttributeName]]];
        
    }
    
    
    UITextView *content = [[UITextView alloc] initWithFrame:vc.view.bounds];
    content.attributedText = attribString;
    content.textAlignment = NSTextAlignmentCenter;
    content.editable = NO;
    [vc.view addSubview:content];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    b.frame = CGRectMake(vc.view.bounds.size.width/2 - 40, vc.view.bounds.size.height - 100, 80, 60);
    [b setTitle:@"Close" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [vc.view addSubview:b];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
}

// INSERT SHOULD SELECT SNIPPET HERE

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isDeletionModeActive) return NO;
    else return YES;
}


#pragma mark - dismiss modally presented view controller

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


// INSERT GESTURE RECOGNIZER ACTIONS HERE

#pragma mark - gesture-recognition action methods


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:touchPoint];
    if (indexPath && [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        return NO;
    }
    return YES;
}


- (void)activateDeletionMode:(UILongPressGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gr locationInView:self.collectionView]];
        if (indexPath)
        {
            isDeletionModeActive = YES;
            SpringboardLayout *layout = (SpringboardLayout *)self.collectionView.collectionViewLayout;
            [layout invalidateLayout];
        }
    }
}

- (void)endDeletionMode:(UITapGestureRecognizer *)gr
{
    if (isDeletionModeActive)
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gr locationInView:self.collectionView]];
        if (!indexPath)
        {
            isDeletionModeActive = NO;
            SpringboardLayout *layout = (SpringboardLayout *)self.collectionView.collectionViewLayout;
            [layout invalidateLayout];
        }
    }
}




// INSERT LAYOUT DELEGATE SNIPPET HERE:

#pragma mark - spring board layout delegate

 - (BOOL) isDeletionModeActiveForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
{
    return isDeletionModeActive;
}
 



@end
