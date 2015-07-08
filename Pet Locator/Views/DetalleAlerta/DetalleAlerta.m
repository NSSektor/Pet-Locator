//
//  DetalleAlerta.m
//  Pet Locator
//
//  Created by Angel Rivas on 7/7/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//


#import "DetalleAlerta.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Alertas.h"
#import "CustomTableViewCell.h"
#import "Annotation.h"

extern NSString* GlobalString;
extern NSString* Sid_alerta;
extern NSString* Saviso;
extern NSString* Sfecha_alerta;
extern NSString* Sevento_alerta;
extern NSString* Slatitud_alerta;
extern NSString* Slongitud_alerta;
extern NSString* Svisto_alerta;
extern NSString* Sradio_alerta;
extern NSString* Subicacion_alerta;
extern NSString* dispositivo;
extern NSString* url_webservice;


@interface DetalleAlerta (){
    SYSoapTool *soapTool;
    GMSPanoramaView *panoView_;
}

@end

@implementation DetalleAlerta

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect frame;
        soapTool = [[SYSoapTool alloc]init];
    
    soapTool.delegate = self;
    GMSCameraPosition *camera;
    camera = [GMSCameraPosition cameraWithLatitude:[Slatitud_alerta doubleValue]
                                         longitude:[Slongitud_alerta doubleValue]
                                              zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, panel_mapa.frame.size.width, panel_mapa.frame.size.height) camera:camera];
    mapView_.delegate = self;
    [panel_mapa addSubview:mapView_];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Normal", @"Híbrido", nil];
    sg_tipo_mapa = [[UISegmentedControl alloc] initWithItems:itemArray];
    sg_tipo_mapa.frame = CGRectMake(10, panel_mapa.frame.size.height - 39 , 100, 30);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        sg_tipo_mapa.frame = CGRectMake(10, panel_mapa.frame.size.height - 39 , 150, 30);
    }
    [sg_tipo_mapa addTarget:self action:@selector(setMap:) forControlEvents: UIControlEventValueChanged];
    sg_tipo_mapa.selectedSegmentIndex = 0;
    sg_tipo_mapa.tintColor = [UIColor darkGrayColor];
    sg_tipo_mapa.backgroundColor = [UIColor whiteColor];
    sg_tipo_mapa.selectedSegmentIndex = 0;
    [panel_mapa addSubview:sg_tipo_mapa];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([Slatitud_alerta doubleValue], [Slongitud_alerta doubleValue]);
    marker.icon = [UIImage imageNamed:@"marker_rojo_60px.png"];
    marker.map = mapView_;
    NSString* newStr = [NSString stringWithFormat:@"%@", [Sradio_alerta stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    newStr = [newStr stringByReplacingOccurrencesOfString:@" metros" withString:@""];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:newStr];
    if (myNumber>0) {
        CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake([Slatitud_alerta doubleValue], [Slongitud_alerta doubleValue]);
        GMSCircle *circ = [GMSCircle circleWithPosition:circleCenter
                                                 radius:[myNumber floatValue]];
        circ.fillColor = [UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/255.0 alpha:0.05];
        circ.strokeColor = [UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/255.0 alpha:1];
        circ.strokeWidth = 5;
        
    }
    
    //    circ.map = mapView_;
    
    [mapView_ setSelectedMarker:marker];
    
    /*StreetView*/
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([dispositivo isEqualToString:@"iPhone6"]) {
            frame = CGRectMake(0, 20, 575, 40.0);
        }
        else if ([dispositivo isEqualToString:@"iPhone6plus"])
            frame = CGRectMake(0, 20, 414, 40.0);
        else
            frame = CGRectMake(0, 20, 320, 40.0);
        
    }
    else{
        frame = CGRectMake(0.0, 20, 768, 60);
    }
    
    UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:frame];
    
    scoreLabel.textAlignment =  NSTextAlignmentCenter;
    
    scoreLabel.textColor = [UIColor whiteColor];
    
    scoreLabel.numberOfLines = 2;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        
        [scoreLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13.0]];
    
    else
        
        [scoreLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:22.0]];
    
    scoreLabel.text = @"StreetView";
    
    [panel_street addSubview:scoreLabel];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([dispositivo isEqualToString:@"iPhone6"]) {
            frame = CGRectMake(0, 20, 575, 40.0);
        }
        else if ([dispositivo isEqualToString:@"iPhone6plus"])
            frame = CGRectMake(0, 20, 414, 40.0);
        else
            if (screenSize.height > 480.0f)
                frame = CGRectMake(0, 60, 320, 528);
            else
                frame = CGRectMake(0, 60, 320, 440);
        
    }
    else{
        frame = CGRectMake(0, 80, 768, 954);
    }
    
    panoView_ = [[GMSPanoramaView alloc] initWithFrame:frame];
    
    [panel_street addSubview:panoView_];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        frame = CGRectMake(10, 60, 30, 30);
    else
        frame = CGRectMake(10, 80, 50, 50);
    
    UIButton *btn_cerrar = [ [UIButton alloc ] initWithFrame:frame];
    
    UIImage *btnImage = [UIImage imageNamed:@"btn_back.png"];
    
    [btn_cerrar setImage:btnImage forState:UIControlStateNormal];
    
    [btn_cerrar addTarget:self
     
                   action:@selector(Cerrar:)
     
         forControlEvents:UIControlEventTouchUpInside];
    
    [btn_atras addTarget:self
     
                   action:@selector(Alertas:)
     
         forControlEvents:UIControlEventTouchUpInside];
    
    [panel_street addSubview:btn_cerrar];
    
    
    
    //    [panoView_ moveNearCoordinate:CLLocationCoordinate2DMake([latitud_perro doubleValue], [longitud_perro doubleValue])];
   
    
    
    
    NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"idAlerta", nil];
    NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:Sid_alerta, nil];
    [soapTool callSoapServiceWithParameters__functionName:@"AlertaRevisada" tags:tags vars:vars wsdlURL:url_webservice];
}

-(IBAction)Cerrar:(id)sender{
    panel_street.hidden = YES;
}

-(void)retriveFromSYSoapTool:(NSMutableArray *)_data{
    
    StringCode = @"";
    StringMsg = @"";
    StringCode = @"-10";
    StringMsg = @"Error en la conexión al servidor";
    NSLog(@"%@", GlobalString);
    NSData* data = [GlobalString dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    if(![parser parse]){
        NSLog(@"Error al parsear");
    }
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
}

//xml

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    
    NSLog(@"The XML document is now being parsed.");
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"Parse error: %ld", (long)[parseError code]);
    [self FillArray];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //Store the name of the element currently being parsed.
    currentElement = [elementName copy];
    //Create an empty mutable string to hold the contents of elements
    currentElementString = [NSMutableString stringWithString:@""];
    //Empty the dictionary if we're parsing a new status element
    if ([elementName isEqualToString:@"response"]) {
        [currentElementData removeAllObjects];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Take the string inside an element (e.g. <tag>string</tag>) and save it in a property
    [currentElementString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"id"])
        StringCode = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"msg"])
        StringMsg = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    [self FillArray];
}

-(void)FillArray{
    NSLog(@"Algo debo de hacer");
}

-(IBAction)Alertas:(id)sender{
    Alertas *view = [[Alertas alloc] initWithNibName:[NSString stringWithFormat:@"Alertas_%@", dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}



-(IBAction)setMap:(id)sender{
    switch(((UISegmentedControl*)sender).selectedSegmentIndex)
    {
        case 0:{
            mapView_.mapType = kGMSTypeNormal;
        }
            break;
        case 1:{
            mapView_.mapType = kGMSTypeHybrid;
        }
            break;
        default:
            break;
    }
    
}

-(UIView*)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    Annotation* annotation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        annotation = [[[NSBundle mainBundle]loadNibNamed:@"AnnotationView" owner:self options:nil ]objectAtIndex:2];
    } else {
        annotation = [[[NSBundle mainBundle]loadNibNamed:@"AnnotationView" owner:self options:nil ]objectAtIndex:3];
    }
    annotation.backgroundColor = [UIColor colorWithRed:.0001 green:.0001 blue:.0001 alpha:.0001];
    annotation.lbl_evento_alerta.text = Sevento_alerta;
    annotation.lbl_fecha_alerta.text = Sfecha_alerta;
    annotation.lbl_ubicacion_alerta.text = Subicacion_alerta;
    annotation.img_alerta.image = [UIImage imageNamed:@"icono_alerta_leida.png"];
    return annotation;
}

- (void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker{
    panel_street.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

