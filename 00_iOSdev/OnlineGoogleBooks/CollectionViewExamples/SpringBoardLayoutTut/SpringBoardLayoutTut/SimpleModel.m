
// SimpleModel.m

#import "SimpleModel.h"

@implementation SimpleModel

- (id)init
{
    if (self = [super init])
    {
        self.fontFamilies = [NSMutableArray arrayWithArray:[UIFont familyNames]];
        self.fontFaces = [NSMutableDictionary dictionaryWithCapacity:self.fontFamilies.count];
        for ( NSString *familyName in self.fontFamilies)
        {
            NSArray *fontsList = [UIFont fontNamesForFamilyName:familyName];
            [self.fontFaces setObject:fontsList forKey:familyName];
        }
        
    }
    return self;
}

@end