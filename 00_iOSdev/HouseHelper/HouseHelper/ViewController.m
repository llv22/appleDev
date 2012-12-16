//
//  ViewController.m
//  HouseHelper
//
//  Created by Ding Orlando on 12/9/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "MetroStop.h"
#import "MetroStopAnnotation.h"
#import "HouseBase.h"
#import "HouseBaseAnnotation.h"
#import "LinePairs.h"
#import <objc/runtime.h>

const int iLineNumberTotal = 6;

@interface ViewController (PrivateMethods)

- (void) resetToSquare;
- (void) initializeMetroLines;
- (void) initializeHousing;
- (NSArray*) jsonToArray:(NSString*)fileName
                 forType:(enum EntityType)type;
- (void) drawMetroLine:(NSArray*)line
             withTitle:(NSString*)title;
- (void) drawHousings:(NSArray*)line
            withTitle:(NSString*)title;
- (MetroStop*) jsonToMetroStop:(NSDictionary*)item;
- (HouseBase*) jsonToHouseBase:(NSDictionary*)item;

@end

@implementation ViewController

#pragma mark - JSON to module mapping
// TODO : http://stackoverflow.com/questions/1768937/how-do-i-convert-nsmutablearray-to-nsarray
// 1, json metro parser - http://www.raywenderlich.com/5492/working-with-json-in-ios-5
// 2, read json into NSData* - http://iphoneincubator.com/blog/data-management/how-to-read-a-file-from-your-application-bundle
- (NSArray*) jsonToArray:(NSString*)fileName
                 forType:(enum EntityType)type{
    NSError* error =nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    assert(filePath!=nil);
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    assert(jsonData!=nil);
    id result = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:kNilOptions
                                                  error:&error];
    NSArray* _jsonRawArray = (NSArray*)result;
    assert(_jsonRawArray!=nil);
    
    // desc - convert to entity array
    NSMutableArray* _tmpMetro = [NSMutableArray new];
    for (NSDictionary* item in _jsonRawArray) {
        if (type == MetroStopType) {
            [_tmpMetro addObject:[self jsonToMetroStop:item]];
        }
        else if(type == HousingType){
            [_tmpMetro addObject:[self jsonToHouseBase:item]];
        }
    }
    return ([_tmpMetro copy]);
}

- (MetroStop*) jsonToMetroStop:(NSDictionary*)item{
    NSDecimalNumber* loc = (NSDecimalNumber*)item[@"loc"];
    NSDecimalNumber* lat = (NSDecimalNumber*)item[@"lat"];
    NSString* name = item[@"name"];
    MetroStop* _stop = [[MetroStop alloc]initWithLoc:[loc doubleValue]
                                             withLat:[lat doubleValue]
                                        withStopName:name];
    return (_stop);
}

- (HouseBase*) jsonToHouseBase:(NSDictionary*)item{
    NSDecimalNumber* loc = (NSDecimalNumber*)item[@"loc"];
    NSDecimalNumber* lat = (NSDecimalNumber*)item[@"lat"];
    NSString* name = item[@"name"];
    HouseBase* _house = [[HouseBase alloc]initWithLoc:[loc doubleValue]
                                             withLat:[lat doubleValue]
                                        withHouseName:name];
    return (_house);
}

#pragma mark - initialization of metroline and housing
//TODO : async load metroline from m<Number>.json
- (void) initializeMetroLines{
    // desc - perhaps dynamically add fields for   ||| MKPolyline* gLine%d; MKPolylineView* gLine%dView; |||
    // desc - allocation of @"地铁%d号线" -> <gLine%d, gLine%dView> NSMutableDictionary
    for (int i = 2; i < iLineNumberTotal; i++) {
        self->gLines[[NSString stringWithFormat:@"地铁%d号线", i]] =
        [[LinePairs alloc]initWithLine:[NSString stringWithFormat:@"gLine%d", i]
                          withLineView:[NSString stringWithFormat:@"gLine%dView", i]
                          withColorInt:i
                         withTotalLine:iLineNumberTotal
         ];
    }
    
    for (int i = 2; i < iLineNumberTotal; i++) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSArray* metroline = [self jsonToArray:[NSString stringWithFormat:@"m%d", i]
                                           forType:MetroStopType];
            [self drawMetroLine:metroline
                      withTitle:[NSString stringWithFormat:@"地铁%d号线", i]];
        });
    }
}

- (void) initializeHousing{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSArray* housing = [self jsonToArray:@"housing"
                                     forType:HousingType];
        [self drawHousings:housing
                 withTitle:@"楼盘"];
    });
}

- (void) drawHousings:(NSArray*)line
            withTitle:(NSString*)title{
    for (HouseBase* item in line) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(item.lat, item.loc);
        id<MKAnnotation> obj = [[HouseBaseAnnotation alloc]initWithLocation:coordinate
                                                               withHouseName:item.houseName
                                                           withHouseBuilder:title];
        [self->map addAnnotation:obj];
    }
}

// TODO : draw metro line with points and connection line in gcd main thread
- (void) drawMetroLine:(NSArray*)line
             withTitle:(NSString*)title{
    MKMapPoint* pointAddr = malloc(sizeof(CLLocationCoordinate2D) * line.count);
    int i = 0;
    for (MetroStop* _stop in line) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_stop.lat, _stop.loc);
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        pointAddr[i] = point;
        
        id<MKAnnotation> obj = [[MetroStopAnnotation alloc]initWithLocation:coordinate
                                                               withStopName:_stop.stopName
                                                             withLineNumber:title];
        [self->map addAnnotation:obj];
        i++;
    }
    
    // desc - new array allocation
    LinePairs* _linePair = (LinePairs*)self->gLines[title];
    MKPolyline* _line = [MKPolyline polylineWithPoints:pointAddr count:i];
    
    // desc - with objective-c runtime integration, [_linePair.gLine UTF8String] with runtime exception, then returned _gline is null
    // as returned <const char*> pointer, just convert force will be OK
    // desc - MUST use [NSString defaultCStringEncoding] for cString Encoding system
    // AND MUST convert <const char*> to <char*> for allowing runtime modification
    char* charKey = (char*)[_linePair.gLine cStringUsingEncoding:[NSString defaultCStringEncoding]];
    objc_setAssociatedObject(self, charKey, _line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    MKPolyline* _gline = objc_getAssociatedObject(self, charKey);
    _gline.title = title;
    [self->map addOverlay:_gline];
    
    free(pointAddr);
}

#pragma mark - MapAnnotationView, overlayView and tapping events
// TODO : Tapped event - for displaying the detailed information with pop-up on ipad/navigation on iphone
- (void)                mapView:(MKMapView *)mapView
                 annotationView:(MKAnnotationView *)view
  calloutAccessoryControlTapped:(UIControl *)control{
    HouseBaseAnnotation* _houseAnnotation = (HouseBaseAnnotation*)[view annotation];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // desc - iphone
        DetailViewController *_detailController = [[DetailViewController alloc]initWithNibName:@"DetailViewController_iPhone" bundle:nil];
        _detailController.title = _houseAnnotation.title;
        // desc - only valid before pushing item into callback item
        UIBarButtonItem* back = [[UIBarButtonItem alloc]initWithTitle:@"返回"
                                                                style:UIBarButtonItemStylePlain
                                                               target:nil
                                                               action:nil];
        self.navigationItem.backBarButtonItem = back;
        [self.navigationController pushViewController:_detailController animated:YES];
    }
    else{
        // desc - ipad
        // desc - close annotation, http://stackoverflow.com/questions/1193928/how-to-close-a-callout-for-mkannotation-in-a-mkmapview
        [self->map deselectAnnotation:_houseAnnotation animated:YES];
        // desc - show popover
        DetailViewController* vc = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
        vc.contentSizeForViewInPopover = CGSizeMake(320, 380);
        vc.title = _houseAnnotation.title;
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:nav];
        
        // desc - rotation and dismisal control
        self.currentPopover = pop;
        self.currentpopoverAnnotationView = view;

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [pop presentPopoverFromRect:CGRectMake(0, 0, 15, 15)
                             inView:view
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:YES];
        [UIView commitAnimations];
        
        // desc - comment out next line and you'll see that Bad Things can happen can summmon same popover twice, also note that this line must come *after* we present the popover or it is ineffectual
        // [iOS 5] all of that is still true, except that instead of summoning same popover twice, we now crash if next line is commented out when tapping button with popover showing this is because as we assign a new popover controller to
        // currentPop......the previous popover controller is dealloced while its popover is showing, which is illegal (sort of nice, really)
        pop.passthroughViews = nil;
        // desc - make ourselves delegate so we learn when popover is dismissed
        pop.delegate = self;
    }
}

// TODO : rotation handling for popover controller - http://developer.apple.com/library/ios/#qa/qa1694/_index.html
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (self.currentPopover && self.currentpopoverAnnotationView) {
            [self.currentPopover presentPopoverFromRect:CGRectMake(0, 0, 15, 15)
                                                 inView:self.currentpopoverAnnotationView
                               permittedArrowDirections:UIPopoverArrowDirectionAny
                                               animated:YES];
        }
    }
}

// TODO : dismisal the popover controller view
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)pc {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (self.currentPopover) {
            [self.currentPopover dismissPopoverAnimated:YES];
            self.currentPopover = nil;
            self.currentpopoverAnnotationView = nil;
        }
    }
}

// TODO : Zoom-in & Out for deletion and other operations
// 1, right-button view - http://stackoverflow.com/questions/2607431/how-to-tell-a-rightcalloutaccessoryview-has-been-touched-for-mapkit
// 2, popver-controller - http://stackoverflow.com/questions/2763284/placing-arrow-of-uipopovercontroller-at-annotation-point-on-mapkit
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        MKUserLocation* _userAnnotation = (MKUserLocation*)annotation;
        _userAnnotation.title = @"I'm Here";
        return nil;
    }else{
        MKAnnotationView* annView = nil;
        if ([annotation isKindOfClass:[MetroStopAnnotation class]]){
            MKPinAnnotationView* _annView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"metrostop"];
            if(!_annView){
                _annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"metrostop"];
                // desc - display
                _annView.pinColor = MKPinAnnotationColorPurple;
                _annView.canShowCallout = YES;
                _annView.draggable = YES;
            }
            
            _annView.annotation = annotation;
            annView = _annView;
        }
        else if([annotation isKindOfClass:[HouseBaseAnnotation class]]){
            MKPinAnnotationView* _annView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"housing"];
            if(!_annView){
                _annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"housing"];
                // desc - display
                _annView.pinColor = MKPinAnnotationColorGreen;
                UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                _annView.rightCalloutAccessoryView = rightButton;
                _annView.canShowCallout = YES;
            }
            
            _annView.annotation = annotation;
            annView = _annView;
        }
        return annView;
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id <MKOverlay>)overlay{
    MKOverlayView* overlayview = nil;
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline* _line = (MKPolyline*)overlay;
        LinePairs* _linePair = (LinePairs*)self->gLines[_line.title];
        
        // desc - dynamic add field for runtime - Must use [NSString defaultCStringEncoding] for cString Encoding system
        // AND MUST convert <const char*> to <char*> for allowing runtime modification
        char* charKeyOfgLine = (char*)[_linePair.gLine cStringUsingEncoding:[NSString defaultCStringEncoding]];
        char* charKeyOfgLineView = (char*)[_linePair.gLineView cStringUsingEncoding:[NSString defaultCStringEncoding]];
        id _lineView = objc_getAssociatedObject(self, charKeyOfgLineView);
        if (nil == _lineView){
            assert(objc_getAssociatedObject(self, charKeyOfgLine));
            MKPolylineView* _lineNewView = [[MKPolylineView alloc]initWithPolyline:objc_getAssociatedObject(self, charKeyOfgLine)];
            // desc - only read once
            UIColor* _colorLine = _linePair.colorLine;
            _lineNewView.fillColor = _colorLine;
            _lineNewView.strokeColor = _colorLine;
            _lineNewView.lineWidth = 2.3;
            _lineView = _lineNewView;
            objc_setAssociatedObject(self, charKeyOfgLineView, _lineNewView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        overlayview = (MKPolylineView*)_lineView;
    }
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleView* circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 3.0;
        overlayview = circleView;
    }
    return overlayview;
}

#pragma mark - View and click event on UIControl
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib
    // desc - right navigation button
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                             target:self
                                                                             action:@selector(resetToCenter:)];
    [self.navigationItem setRightBarButtonItem:refreshBtn animated:YES];
    // desc - http://stackoverflow.com/questions/1449339/how-do-i-change-the-title-of-the-back-button-on-a-navigation-bar
    // how-to reset navigation back button title
    self.title = nil;
    
    // desc - initialization of ui and center size
    self->gLines = [[NSMutableDictionary alloc]init];
    self->distNorthToSouth = 8000;
    self->distEastToWest = 5000;
    [self initializeMetroLines];
    [self initializeHousing];
    // desc - located into chengdu central
    [self resetToSquare];
}

- (IBAction)resetToCenter:(id)sender{
    [self resetToSquare];
}

- (void) resetToSquare{
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(30.657665, 104.065719);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, self->distNorthToSouth, self->distEastToWest);
    [self->map setRegion:region animated:YES];
}

// TODO : auto-rotate
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    // desc - if Portrait direction or landscape, return YES [in order to rotate all]
    return YES;
//    return (toInterfaceOrientation == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
