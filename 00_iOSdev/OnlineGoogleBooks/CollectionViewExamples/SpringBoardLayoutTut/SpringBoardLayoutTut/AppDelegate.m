//  AppDelegate.m

#import "AppDelegate.h"
#import "ViewController.h"
#import "SpringboardLayout.h"


@implementation AppDelegate
{
    SpringboardLayout *springboardLayout;
    ViewController *viewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    springboardLayout = [[SpringboardLayout alloc] init];
    viewController = [[ViewController alloc] initWithCollectionViewLayout:springboardLayout];
    
    //springboardLayout.springBoardDelegate = viewController; // TO UNCOMMENT LATER
    
    
    self.window.rootViewController = viewController;
    viewController.collectionView.pagingEnabled = YES;
    viewController.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coolrobot.png"]];

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
