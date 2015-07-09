//
//  Historico.m
//  Pet Locator
//
//  Created by Angel Rivas on 7/7/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

//
//  Historico.m
//  Pet Locator
//
//  Created by Angel Rivas on 5/30/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "Historico.h"
#import "UltimaPosicion.h"
#import "CustomTableViewCell.h"
#import "Annotation.h"
#import <QuartzCore/QuartzCore.h>

extern NSString* latitud_perro;
extern NSString* longitud_perro;
extern NSString* dispositivo;

extern NSString* GlobalString;
extern NSString* id_mascota;
extern NSString* id_usr;

extern NSString* url_webservice;

NSMutableArray* MAfechas;
NSMutableArray* MAeventos;
NSMutableArray* MAlatituds;
NSMutableArray* MAlongituds;
NSMutableArray* MAbaterias;
NSMutableArray* MAubicacions;
NSMutableArray* MAradios;
NSMutableArray* MAids;

NSString* latitud_perro_street;
NSString* longitud_perro_street;
GMSCoordinateBounds *bounds;
NSMutableArray * MAmarkers;

int id_;

@interface Historico (){
    SYSoapTool *soapTool;
    GMSPanoramaView *panoView_;
}

@end

@implementation Historico

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
    tbl_historico.dataSource = self;
    tbl_historico.delegate = self;
    
    [btn_atras addTarget:self action:@selector(Atras:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_ayer addTarget:self action:@selector(Ayer:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_hoy addTarget:self action:@selector(Hoy:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_mapa addTarget:self action:@selector(Mapa:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_tabular addTarget:self action:@selector(Tabular:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_mapa.layer setBorderWidth:1];
    [btn_mapa.layer setBorderColor:[UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/255.0 alpha:1].CGColor];
    [btn_mapa.layer setMasksToBounds:YES];
    
    [btn_tabular.layer setBorderWidth:1];
    [btn_tabular.layer setBorderColor:[UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/255.0 alpha:1].CGColor];
    [btn_tabular.layer setMasksToBounds:YES];
    
    [btn_hoy.layer setBorderWidth:1];
    [btn_hoy.layer setBorderColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1].CGColor];
    [btn_hoy.layer setMasksToBounds:YES];
    
    [btn_ayer.layer setBorderWidth:1];
    [btn_ayer.layer setBorderColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1].CGColor];
    [btn_ayer.layer setMasksToBounds:YES];
    
    CGRect frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frame = CGRectMake(280, 20, 30, 30);
    }
    else{
        frame = CGRectMake(700, 20, 50, 50);
    }
    UIImageView* img = [[UIImageView alloc]initWithFrame:frame];
    img.image = [UIImage imageNamed:@"petlocator_logo"];
    [self.view addSubview:img];
    /*StreetView*/
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        frame = CGRectMake(0, 20, 320, 40.0);
    else
        frame = CGRectMake(0.0, 20, 768, 60);
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
        if (screenSize.height > 480.0f)
            frame = CGRectMake(0, 60, 320, 528);
        else
            frame = CGRectMake(0, 60, 320, 440);
    }
    else
        frame = CGRectMake(0, 80, 768, 954);
    [panel_street addSubview:img];
    panoView_ = [[GMSPanoramaView alloc] initWithFrame:frame];
    [panel_street addSubview:panoView_];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        frame = CGRectMake(280, 60, 30, 30);
    else
        frame = CGRectMake(700, 80, 50, 50);
    UIButton *btn_cerrar = [ [UIButton alloc ] initWithFrame:frame];
    UIImage *btnImage = [UIImage imageNamed:@"cerrar.png"];
    [btn_cerrar setImage:btnImage forState:UIControlStateNormal];
    [btn_cerrar addTarget:self
                   action:@selector(Cerrar:)
         forControlEvents:UIControlEventTouchUpInside];
    [panel_street addSubview:btn_cerrar];
    
    //    [panoView_ moveNearCoordinate:CLLocationCoordinate2DMake([latitud_perro doubleValue], [longitud_perro doubleValue])];
    
    // Do any additional setup after loading the view from its nib.
    
    contenedor_animacion = [[UIView alloc]initWithFrame:self.view.frame];
    contenedor_animacion.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.5];
    contenedor_animacion.hidden = YES;
    [self.view addSubview:contenedor_animacion];
    
    UIActivityIndicatorView* actividad_global = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actividad_global.color = [UIColor darkGrayColor];
    actividad_global.hidesWhenStopped = TRUE;
    CGRect newFrames = actividad_global.frame;
    newFrames.origin.x = (contenedor_animacion.frame.size.width / 2) -13;
    newFrames.origin.y = (contenedor_animacion.frame.size.height / 2) - 13;
    actividad_global.frame = newFrames;
    actividad_global.backgroundColor = [UIColor clearColor];
    [actividad_global startAnimating];
    [contenedor_animacion addSubview:actividad_global];
    
    tbl_historico.layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
    
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    GMSCameraPosition *camera;
    camera = [GMSCameraPosition cameraWithLatitude:[latitud_perro doubleValue]
                                         longitude:[longitud_perro doubleValue]
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
    //  sg_tipo_mapa.segmentedControlStyle = UISegmentedControlStyleBar;
    [sg_tipo_mapa addTarget:self action:@selector(setMap:) forControlEvents: UIControlEventValueChanged];
    sg_tipo_mapa.selectedSegmentIndex = 0;
    sg_tipo_mapa.tintColor = [UIColor darkGrayColor];
    sg_tipo_mapa.backgroundColor = [UIColor whiteColor];
    sg_tipo_mapa.selectedSegmentIndex = 0;
    [panel_mapa addSubview:sg_tipo_mapa];
    
    contenedor_animacion.hidden = NO;
    contadorTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(actualizarTimer:) userInfo:nil repeats:NO];
    
    MAfechas = [[NSMutableArray alloc]init];
    MAeventos = [[NSMutableArray alloc]init];
    MAlatituds = [[NSMutableArray alloc]init];
    MAlongituds = [[NSMutableArray alloc]init];
    MAbaterias = [[NSMutableArray alloc]init];
    MAubicacions = [[NSMutableArray alloc]init];
    MAradios = [[NSMutableArray alloc]init];
    MAids = [[NSMutableArray alloc]init];
    
}

-(IBAction)actualizarTimer:(id)sender{
    
    MAfechas = [[NSMutableArray alloc]init];
    MAeventos = [[NSMutableArray alloc]init];
    MAlatituds = [[NSMutableArray alloc]init];
    MAlongituds = [[NSMutableArray alloc]init];
    MAbaterias = [[NSMutableArray alloc]init];
    MAubicacions = [[NSMutableArray alloc]init];
    MAradios = [[NSMutableArray alloc]init];
    MAids = [[NSMutableArray alloc]init];
    
    NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"idUsuario", @"idMascota", @"dia", nil];
    NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:id_usr ,id_mascota, @"0", nil];
    [soapTool callSoapServiceWithParameters__functionName:@"Historico" tags:tags vars:vars wsdlURL:url_webservice];
    contenedor_animacion.hidden = NO;
}

-(void)retriveFromSYSoapTool:(NSMutableArray *)_data{
    StringCode = @"";
    StringMsg = @"";
    StringCode = @"-10";
    StringMsg = @"Error en la conexión al servidor";
    NSLog(@"%@", GlobalString);
    MAfechas = [[NSMutableArray alloc]init];
    MAeventos = [[NSMutableArray alloc]init];
    MAlatituds = [[NSMutableArray alloc]init];
    MAlongituds = [[NSMutableArray alloc]init];
    MAbaterias = [[NSMutableArray alloc]init];
    MAubicacions = [[NSMutableArray alloc]init];
    MAradios = [[NSMutableArray alloc]init];
    MAids = [[NSMutableArray alloc]init];
    id_ = 0;
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

-(IBAction)Cerrar:(id)sender{
    panel_street.hidden = YES;
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
    if ([elementName isEqualToString:@"fecha"]){
        [MAfechas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [MAids addObject:[NSString stringWithFormat:@"%d", id_]];
        id_++;
    }
    if ([elementName isEqualToString:@"evento"])
        [MAeventos addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"latitud"])
        [MAlatituds addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"longitud"])
        [MAlongituds addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"bateria"])
        [MAbaterias addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"radio"])
        [MAradios addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"ubicacion"])
        [MAubicacions addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    [self FillArray];
}

-(void)FillArray{
    NSString* mensajeAlerta = StringMsg;
    NSInteger code = [StringCode intValue];
    if (code <0) {
        //  [message show];
        [MAfechas addObject:@""];
        [MAeventos addObject:mensajeAlerta];
        [MAlatituds addObject:@""];
        [MAlongituds addObject:@""];
        [MAbaterias addObject:@"-1"];
        [MAubicacions addObject:@""];
        [MAradios addObject:@""];
        [MAids addObject:@""];
    }
    contenedor_animacion.hidden = YES;
    [mapView_ clear];
    MAmarkers = [[NSMutableArray alloc]init];
    bounds = [[GMSCoordinateBounds alloc] init];
    for (int i = 0; i<[MAlatituds count]; i++) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([[MAlatituds objectAtIndex:i] doubleValue], [[MAlongituds objectAtIndex:i] doubleValue]);
        marker.icon = [UIImage imageNamed:@"marker_verde_60px.png"];
        marker.snippet = [MAids objectAtIndex:i];
        //  [MAmarkers addObject:marker];
        marker.map = mapView_;
        CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake([[MAlatituds objectAtIndex:i] doubleValue], [[MAlatituds objectAtIndex:i] doubleValue]);
        if (i==0) {
            bounds =
            [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake([[MAlatituds objectAtIndex:0] doubleValue], [[MAlongituds objectAtIndex:0] doubleValue]) coordinate:CLLocationCoordinate2DMake([[MAlatituds objectAtIndex:0] doubleValue], [[MAlongituds objectAtIndex:0] doubleValue])];
            
        }
        
        if (i==1) {
            bounds =
            [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake([[MAlatituds objectAtIndex:0] doubleValue], [[MAlongituds objectAtIndex:0] doubleValue]) coordinate:CLLocationCoordinate2DMake([[MAlatituds objectAtIndex:i] doubleValue], [[MAlongituds objectAtIndex:i] doubleValue])];
        }
        else if (i>1)
            [bounds includingCoordinate:circleCenter];
        if ([bounds includingCoordinate:circleCenter]) {
            NSLog(@" Latitud: %f, Longitud: %f ",circleCenter.latitude, circleCenter.longitude );
            NSLog(@"Si la incluyo %d", i);
        }
    }
    
    NSLog(@"final bounds: (%f,%f) - (%f,%f)",
          bounds.southWest.latitude, bounds.southWest.longitude,
          bounds.northEast.latitude, bounds.northEast.longitude);
    
    // [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds]];
    [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds]];
    //   GMSCameraPosition *camera = [mapView_ cameraForBounds:bounds insets:UIEdgeInsetsZero];
    //   mapView_.camera = camera;
    //   [mapView_ animateToZoom:Zoom];
    
    
    
    [tbl_historico reloadData];
    
}



-(IBAction)UltimaPosicion:(id)sender{

    
    UltimaPosicion *view = [[UltimaPosicion alloc] initWithNibName:[NSString stringWithFormat:@"UltimaPosicion_%@", dispositivo] bundle:nil];
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

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MAeventos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"TableCell";
    CustomTableViewCell *cell;
    cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSString* NibName = @"CustomTableViewCell";
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NibName owner:self options:nil];
        
        if ([dispositivo isEqualToString:@"iPhone6"])
            cell = [nib objectAtIndex:7];
        else if ([dispositivo isEqualToString:@"iPhone6plus"])
            cell = [nib objectAtIndex:8];
        else if ([dispositivo isEqualToString:@"iPad"])
            cell = [nib objectAtIndex:9];
        else
            cell = [nib objectAtIndex:6];
    }
    cell.lbl_error.hidden = YES;
    cell.lbl_fecha.text       = [MAfechas objectAtIndex:indexPath.row];
    cell.lbl_evento.text     = [MAeventos objectAtIndex:indexPath.row];
    if ([[MAeventos objectAtIndex:indexPath.row] isEqualToString:StringMsg]) {
        cell.lbl_error.hidden = NO;
        cell.lbl_error.text = StringMsg;
    }
    cell.lbl_ubicacion.text = [MAubicacions objectAtIndex:indexPath.row];
    cell.lbl_bateria.text     = [NSString stringWithFormat:@"%@%@%@", @"Batería: ", [MAbaterias objectAtIndex:indexPath.row], @"%"];
    if ([[MAbaterias objectAtIndex:indexPath.row] isEqualToString:@"-1"]) {
        cell.lbl_bateria.text = @"";
        cell.img_bateria.hidden = YES;
    }
    else{
        int level_ = [[MAbaterias objectAtIndex:indexPath.row] intValue];
        if (level_<=25)
            cell.img_bateria.image = [UIImage imageNamed:@"bateria_0.png"];
        else if (level_>25 && level_<=50)
            cell.img_bateria.image = [UIImage imageNamed:@"bateria_50.png"];
        else if (level_>50 && level_<=75)
            cell.img_bateria.image = [UIImage imageNamed:@"bateria_75.png"];
        else
            cell.img_bateria.image = [UIImage imageNamed:@"bateria_100.png"];
        
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //   [mapView_ clear];
    
    for (int i = 0; i<[MAids count]; i++) {
        
        if (![[MAids objectAtIndex:0] isEqualToString:@""]) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake([[MAlatituds objectAtIndex:i] doubleValue], [[MAlongituds objectAtIndex:i] doubleValue]);
            marker.icon = [UIImage imageNamed:@"marker_verde_60px.png"];
            marker.snippet = [MAids objectAtIndex:i];
            marker.map = mapView_;
            if (indexPath.row==i) {
                [mapView_ setSelectedMarker:marker];
            }
        }
        
        
    }
    [self Mapa:self];
    
    return indexPath;
}

-(UIView*)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    
    Annotation* annotation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        annotation = [[[NSBundle mainBundle]loadNibNamed:@"AnnotationView" owner:self options:nil ]objectAtIndex:0];
    } else {
        annotation = [[[NSBundle mainBundle]loadNibNamed:@"AnnotationView" owner:self options:nil ]objectAtIndex:1];
    }
    annotation.backgroundColor = [UIColor colorWithRed:.0001 green:.0001 blue:.0001 alpha:.0001];
    annotation.lbl_ubicacion.text = [MAubicacions objectAtIndex:[marker.snippet intValue]];
    annotation.lbl_evento.text = [MAeventos objectAtIndex:[marker.snippet intValue]];
    annotation.lbl_fecha.text = [MAfechas objectAtIndex:[marker.snippet intValue]];
    if ([[MAeventos objectAtIndex:[marker.snippet intValue]] isEqualToString:StringMsg]) {
        annotation.btn_street.hidden = YES;
    }
    annotation.lbl_bateria.text = [NSString stringWithFormat:@"%@%@%@", @"Batería: ",  [MAbaterias objectAtIndex:[marker.snippet intValue]], @"%"];
    if ([[MAbaterias objectAtIndex:[marker.snippet intValue]] isEqualToString:@"-1"]) {
        annotation.lbl_bateria.text = @"";
        annotation.img_bateria.hidden = YES;
    }
    else{
        int level_ = [[MAbaterias objectAtIndex:[marker.snippet intValue]] intValue];
        if (level_<=25)
            annotation.img_bateria.image = [UIImage imageNamed:@"bateria_0.png"];
        else if (level_>25 && level_<=50)
            annotation.img_bateria.image = [UIImage imageNamed:@"bateria_50.png"];
        else if (level_>50 && level_<=75)
            annotation.img_bateria.image = [UIImage imageNamed:@"bateria_75.png"];
        else
            annotation.img_bateria.image = [UIImage imageNamed:@"bateria_100.png"];
        
    }
    latitud_perro_street = [NSString stringWithFormat:@"%@",[[MAlatituds objectAtIndex:[marker.snippet intValue]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    longitud_perro_street = [NSString stringWithFormat:@"%@",[[MAlongituds objectAtIndex:[marker.snippet intValue]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return annotation;
}

- (void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker{
    if (![[MAeventos objectAtIndex:[marker.snippet intValue]] isEqualToString:StringMsg]) {
        [panoView_ moveNearCoordinate:CLLocationCoordinate2DMake([latitud_perro_street doubleValue], [longitud_perro_street doubleValue])];
        panel_street.hidden = NO;
    }
}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


-(IBAction)Hoy:(id)sender{
    
    [btn_ayer setTitleColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    [btn_ayer setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    
    [btn_hoy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_hoy setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1]] forState:UIControlStateNormal];
    
    
    contenedor_animacion.hidden = NO;
    NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"idUsuario", @"idMascota", @"dia", nil];
    NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:id_usr ,id_mascota, @"0", nil];
    [soapTool callSoapServiceWithParameters__functionName:@"Historico" tags:tags vars:vars wsdlURL:url_webservice];
    [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds]];
    
    
}

-(IBAction)Ayer:(id)sender{
    [btn_hoy setTitleColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    [btn_hoy setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    
    [btn_ayer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_ayer setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1]] forState:UIControlStateNormal];
    
    contenedor_animacion.hidden = NO;
    NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"idUsuario", @"idMascota", @"dia", nil];
    NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:id_usr ,id_mascota, @"1", nil];
    [soapTool callSoapServiceWithParameters__functionName:@"Historico" tags:tags vars:vars wsdlURL:url_webservice];
    [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds]];
}

-(IBAction)Tabular:(id)sender{
    
    [btn_mapa setTitleColor:[UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    [btn_mapa setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    
    [btn_tabular setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_tabular setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/255.0 alpha:1]] forState:UIControlStateNormal];
    
    
    panel_mapa.hidden = YES;
    panel_tabla.hidden = NO;
}

-(IBAction)Mapa:(id)sender{
    [btn_tabular setTitleColor:[UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    [btn_tabular setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    
    [btn_mapa setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_mapa setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/255.0 alpha:1]] forState:UIControlStateNormal];
    
    panel_mapa.hidden = NO;
    panel_tabla.hidden = YES;
}

@end
