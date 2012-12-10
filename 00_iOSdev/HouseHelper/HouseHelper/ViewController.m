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
- (void) initializeMetroLine2;
- (NSArray*) jsonToArray:(NSString*)fileName;
- (void) drawMetroLine: (NSArray*)line
             withTitle: (NSString*)title;

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
//    NSLog(@"%@", [[NSBundle mainBundle] resourcePath]);
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

- (void) initializeMetroLine2{
    self->metroLine2 = [self jsonToArray:@"m2"];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self drawMetroLine:self->metroLine2 withTitle:@"mline 2"];
    });
}

// TODO : draw metro line with points and connection line in gcd main thread
- (void) drawMetroLine: (NSArray*)line
             withTitle: (NSString*)title{
    MKMapPoint* pointAddr = malloc(sizeof(CLLocationCoordinate2D) * line.count);
    int i = 0;
    for (MetroStop* _stop in line) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_stop.lat, _stop.loc);
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        pointAddr[i] = point;
        
        id<MKAnnotation> obj = [[MetroStopAnnotation alloc]initWithLocation:coordinate withStopName:_stop.stopName];
        [self->map addAnnotation:obj];
        
//        MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:30];
//        [circle setTitle:_stop.stopName];
//        [self->map addOverlay:circle];
        i++;
    }
    self->gLine2 = [MKPolyline polylineWithPoints:pointAddr count:i];
    self->gLine2.title = title;
    [self->map addOverlay:self->gLine2];
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
            MKPinAnnotationView* _annView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
            if(!_annView){
                _annView=(MKPinAnnotationView*)[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"];
                // desc - display
                _annView.pinColor = MKPinAnnotationColorPurple;
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
    if (overlay == self->gLine2) {
        // desc - for metro line 2
        if( nil == self->gLine2View){
            self->gLine2View = [[MKPolylineView alloc]initWithPolyline:self->gLine2];
            self->gLine2View.fillColor = [UIColor redColor];
            self->gLine2View.strokeColor = [UIColor redColor];
            self->gLine2View.lineWidth = 2;
        }
        overlayview = self->gLine2View;
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
    [self initializeMetroLine2];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
