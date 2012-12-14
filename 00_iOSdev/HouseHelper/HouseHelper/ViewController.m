//
//  ViewController.m
//  HouseHelper
//
//  Created by Ding Orlando on 12/9/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "ViewController.h"
#import "MetroStop.h"
#import "MetroStopAnnotation.h"

@interface ViewController ()

- (void) resetToSquare;
- (void) drawHousing;
- (NSArray*) jsonToArray:(NSString*)fileName;
- (void) drawMetroLine:(NSArray*)line
             withTitle:(NSString*)title;

@end

@implementation ViewController

/**
 * not called
 *
- (id)init{
    self = [super init];
    if (self) {
    }
    return (self);
}*/

// TODO : initWithNibName delegate callback - http://stackoverflow.com/questions/5146791/instantiating-a-uiview-subclass-with-a-delegate-using-a-nib-file
- (void) awakeFromNib{
    [super awakeFromNib];
}

// TODO : http://stackoverflow.com/questions/1768937/how-do-i-convert-nsmutablearray-to-nsarray
// TODO : json metro parser - http://www.raywenderlich.com/5492/working-with-json-in-ios-5
// TODO : read json into NSData* - http://iphoneincubator.com/blog/data-management/how-to-read-a-file-from-your-application-bundle
- (NSArray*) jsonToArray:(NSString*)fileName{
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
        NSDecimalNumber* loc = (NSDecimalNumber*)item[@"loc"];
        NSDecimalNumber* lat = (NSDecimalNumber*)item[@"lat"];
        NSString* name = item[@"name"];
        MetroStop* _stop = [[MetroStop alloc]initWithLoc:[loc doubleValue]
                                                 withLat:[lat doubleValue]
                                            withStopName:name];
        [_tmpMetro addObject:_stop];
    }
    return ([_tmpMetro copy]);
}

- (void) initializeMetroLines{
    for (int i = 2; i < 5; i++) {
        NSArray* metroline = [self jsonToArray:[NSString stringWithFormat:@"m%d", i]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self drawMetroLine:metroline
                      withTitle:[NSString stringWithFormat:@"地铁%d号线", i]];
        });
    }
}

- (void) drawHousing{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(30.649875, 104.115973);
    id<MKAnnotation> obj = [[MetroStopAnnotation alloc]initWithLocation:coordinate
                                                           withStopName:@"华润二十四城"
                                                         withLineNumber:@"楼盘"];
    [self->map addAnnotation:obj];
    
    coordinate = CLLocationCoordinate2DMake(30.548144, 104.047866);
    obj = [[MetroStopAnnotation alloc]initWithLocation:coordinate
                                          withStopName:@"锦城南府"
                                        withLineNumber:@"楼盘"];
    [self->map addAnnotation:obj];
    
    coordinate = CLLocationCoordinate2DMake(30.543709, 104.067907);
    obj = [[MetroStopAnnotation alloc]initWithLocation:coordinate
                                          withStopName:@"利通.时代晶座"
                                        withLineNumber:@"楼盘"];
    [self->map addAnnotation:obj];
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
    if ([title isEqualToString:@"地铁2号线"]) {
        self->gLine2 = [MKPolyline polylineWithPoints:pointAddr count:i];
        self->gLine2.title = title;
        [self->map addOverlay:self->gLine2];
    }
    else if([title isEqualToString:@"地铁3号线"]) {
        self->gLine3 = [MKPolyline polylineWithPoints:pointAddr count:i];
        self->gLine3.title = title;
        [self->map addOverlay:self->gLine3];
    }
    else if([title isEqualToString:@"地铁4号线"]) {
        self->gLine4 = [MKPolyline polylineWithPoints:pointAddr count:i];
        self->gLine4.title = title;
        [self->map addOverlay:self->gLine4];
    }
    free(pointAddr);
}


//TODO : right-button view
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
//    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    view.rightCalloutAccessoryView = rightButton;
}

//TODO : Zoom-in & Out for deletion and other operations
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        MKUserLocation* _userAnnotation = (MKUserLocation*)annotation;
        _userAnnotation.title = @"I'm Here";
        return nil;
        
    }else{
        MKAnnotationView* annView = nil;
        if ([annotation isKindOfClass:[MetroStopAnnotation class]]){
            MetroStopAnnotation* _metroStop = (MetroStopAnnotation*)annotation;
            MKPinAnnotationView* _annView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
            if(!_annView){
                _annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"];
                if ([_metroStop.lineNumber isEqualToString:@"楼盘"]) {
                    // desc - display
                    _annView.pinColor = MKPinAnnotationColorGreen;
                }
                else{
                    // desc - display
                    _annView.pinColor = MKPinAnnotationColorPurple;
                }
                _annView.canShowCallout = YES;
            }
            else{
                _annView.annotation = annotation;
            }
            annView = _annView;
        }
        return annView;
    }
}

#pragma mark - adding MKPolyLine
- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id <MKOverlay>)overlay{
    MKOverlayView* overlayview = nil;
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline* _line = (MKPolyline*)overlay;
        
        if ([_line.title isEqualToString:@"地铁2号线"]) {
            // desc - for metro line 2
            if( nil == self->gLine2View){
                self->gLine2View = [[MKPolylineView alloc]initWithPolyline:self->gLine2];
                self->gLine2View.fillColor = [UIColor redColor];
                self->gLine2View.strokeColor = [UIColor redColor];
                self->gLine2View.lineWidth = 2;
            }
            overlayview = self->gLine2View;
        }
        else if ([_line.title isEqualToString:@"地铁3号线"]) {
            // desc - for metro line 3
            if( nil == self->gLine3View){
                self->gLine3View = [[MKPolylineView alloc]initWithPolyline:self->gLine3];
                self->gLine3View.fillColor = [UIColor redColor];
                self->gLine3View.strokeColor = [UIColor redColor];
                self->gLine3View.lineWidth = 2;
            }
            overlayview = self->gLine3View;
        }
        else if ([_line.title isEqualToString:@"地铁4号线"]) {
            // desc - for metro line 4
            if( nil == self->gLine4View){
                self->gLine4View = [[MKPolylineView alloc]initWithPolyline:self->gLine4];
                self->gLine4View.fillColor = [UIColor redColor];
                self->gLine4View.strokeColor = [UIColor redColor];
                self->gLine4View.lineWidth = 2;
            }
            overlayview = self->gLine4View;
        }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib
    self->distNorthToSouth = 8000;
    self->distEastToWest = 5000;
    [self initializeMetroLines];
    [self drawHousing];
    
    // desc - located into chengdu central
    [self resetToSquare];
}

- (void) resetToSquare{
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(30.657665, 104.065719);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, self->distNorthToSouth, self->distEastToWest);
    [self->map setRegion:region animated:YES];
}

- (IBAction)resetToCenter:(id)sender{
    [self resetToSquare];
}

// TODO : auto-rotate
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    // desc - if Portrait direction or landscape, return YES
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
