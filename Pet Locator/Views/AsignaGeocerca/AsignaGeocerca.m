//
//  AsignaGeocerca.m
//  Pet Locator
//
//  Created by Angel Rivas on 8/13/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "AsignaGeocerca.h"

//
//  AsignaGeocerca.m
//  Pet Locator
//
//  Created by Angel Rivas on 6/14/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "AsignaGeocerca.h"
#import "UltimaPosicion.h"

extern NSString* GlobalUsu;
extern NSString* Globalpass;
extern NSString* GlobalString;
extern NSString* id_mascota;
extern NSString* id_geocerca_asignada;
extern BOOL actualizar_tabla;
extern NSString* dispositivo;
extern NetworkStatus returnValue;

extern NSString* url_webservice;

NSString* funcion;
NSString* id_geocerca_mascota;
NSString* latitud_geocerca_mascota;
NSString* longitud_geocerca_mascota;

NSMutableArray* MAid_mascota_geocerca;
NSMutableArray* MAnombre_mascota_geocerca;
NSMutableArray* MAid_geocerca_mascota;
NSMutableArray* MAnombre_geo_mascota;
NSMutableArray* MAlatitud_geocerca;
NSMutableArray* MAlongitud_geocerca;
NSMutableArray* MAradio_geocerca;
NSMutableArray* MAactiva_geocerca;
NSMutableArray* MAdireccion_geocerca;



NSInteger index_seleccionado;


@interface AsignaGeocerca (){
    SYSoapTool *soapTool;
}

@end

@implementation AsignaGeocerca

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
    
    
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            break;
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)retriveFromSYSoapTool:(NSMutableArray *)_data{
    StringCode = @"";
    StringMsg = @"";
    StringCode = @"-10";
    StringMsg = @"Error en la conexión al servidor";
    NSData* data = [GlobalString dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    if ([funcion isEqualToString:@"DameGeocerca"]) {
        MAid_mascota_geocerca = [[NSMutableArray alloc]init];
        MAnombre_mascota_geocerca = [[NSMutableArray alloc]init];
        MAid_geocerca_mascota = [[NSMutableArray alloc]init];
        MAnombre_geo_mascota = [[NSMutableArray alloc]init];
        MAlatitud_geocerca = [[NSMutableArray alloc]init];
        MAlongitud_geocerca = [[NSMutableArray alloc]init];
        MAradio_geocerca = [[NSMutableArray alloc]init];
        MAactiva_geocerca = [[NSMutableArray alloc]init];
        MAdireccion_geocerca = [[NSMutableArray alloc]init];
    }
    
    if(![parser parse]){
        NSLog(@"Error al parsear");
        [MAid_mascota_geocerca addObject:@""];
        [MAnombre_mascota_geocerca addObject:@""];
        [MAid_geocerca_mascota addObject:@""];
        [MAnombre_geo_mascota addObject:@"Error en la conexión al servidor"];
        [MAlatitud_geocerca addObject:@""];
        [MAlongitud_geocerca addObject:@""];
        [MAradio_geocerca addObject:@""];
        [MAactiva_geocerca addObject:@""];
        [MAdireccion_geocerca addObject:@""];
    }
    
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tbl_geocercas.dataSource = self;
    tbl_geocercas.delegate = self;
    index_seleccionado = -1;
    id_geocerca_mascota = @"";
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    MAid_mascota_geocerca = [[NSMutableArray alloc]init];
    MAnombre_mascota_geocerca = [[NSMutableArray alloc]init];
    MAid_geocerca_mascota = [[NSMutableArray alloc]init];
    MAnombre_geo_mascota = [[NSMutableArray alloc]init];
    MAlatitud_geocerca = [[NSMutableArray alloc]init];
    MAlongitud_geocerca = [[NSMutableArray alloc]init];
    MAradio_geocerca = [[NSMutableArray alloc]init];
    MAactiva_geocerca = [[NSMutableArray alloc]init];
    MAdireccion_geocerca = [[NSMutableArray alloc]init];
   
    // [tbl_geocercas addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    funcion = @"DameGeocerca";
    
    
    GMSCameraPosition *camera;
    camera = [GMSCameraPosition cameraWithLatitude:19.4290041
                                         longitude:-99.1425485
                                              zoom:15];
    latitud_geocerca_mascota = @"19.4290041";
    longitud_geocerca_mascota = @"-99.1425485";
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, contenedor_mapa.frame.size.width, contenedor_mapa.frame.size.height) camera:camera];
    mapView_.delegate = self;
    [contenedor_mapa  addSubview:mapView_];
    
    [btn_atras addTarget:self action:@selector(Atras:) forControlEvents:UIControlEventTouchUpInside];
    [btn_asignar addTarget:self action:@selector(Asignar:) forControlEvents:UIControlEventTouchUpInside];
    
    contenedor_animacion = [[UIView alloc]initWithFrame:self.view.frame];
    contenedor_animacion.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.5];
    contenedor_animacion.hidden = YES;
    [self.view addSubview:contenedor_animacion];
    
    UIActivityIndicatorView* actividad_global = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actividad_global.color = [UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/255.0 alpha:1];
    actividad_global.hidesWhenStopped = TRUE;
    CGRect newFrames = actividad_global.frame;
    newFrames.origin.x = (contenedor_animacion.frame.size.width / 2) -13;
    newFrames.origin.y = (contenedor_animacion.frame.size.height / 2) - 13;
    actividad_global.frame = newFrames;
    actividad_global.backgroundColor = [UIColor clearColor];
    actividad_global.hidden = NO;
    [actividad_global startAnimating];
    [contenedor_animacion addSubview:actividad_global];
    
    contenedor_animacion.hidden = YES;
    
    [self refreshTable];
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
    currentElement = [elementName copy];
    currentElementString = [NSMutableString stringWithString:@""];
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
    if ([elementName isEqualToString:@"id_mascota"])
        [MAid_mascota_geocerca addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"nombre_mascota"])
        [MAnombre_mascota_geocerca addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"id_geocerca"])
        [MAid_geocerca_mascota addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"nombre_geo"])
        [MAnombre_geo_mascota addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"latitud"])
        [MAlatitud_geocerca addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"longitud"])
        [MAlongitud_geocerca addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"radio"])
        [MAradio_geocerca addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"activa"])
        [MAactiva_geocerca addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"direccion"])
        [MAdireccion_geocerca addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    [self FillArray];
}

-(void)FillArray{
    contenedor_animacion.hidden = YES;
    NSString* mensajeAlerta = StringMsg;
    NSInteger code = [StringCode intValue];
    
    if ([funcion isEqualToString:@"DameGeocerca"]) {
        if (code <0){
            
            [MAid_mascota_geocerca addObject:@""];
            [MAnombre_mascota_geocerca addObject:@""];
            [MAid_geocerca_mascota addObject:@""];
            [MAnombre_geo_mascota addObject:mensajeAlerta];
            [MAlatitud_geocerca addObject:@""];
            [MAlongitud_geocerca addObject:@""];
            [MAradio_geocerca addObject:@""];
            [MAactiva_geocerca addObject:@""];
            [MAdireccion_geocerca addObject:@""];
            btn_asignar.hidden = YES;
            contenedor_mapa.hidden = YES;
            [tbl_geocercas reloadData];
            [refreshControl endRefreshing];
            
        }
        else{
            btn_asignar.hidden = NO;
            contenedor_mapa.hidden = NO;
        }
        
        for (int i = 0; i<[MAid_geocerca_mascota count]; i++) {
            if ([id_geocerca_asignada isEqualToString:[MAid_geocerca_mascota objectAtIndex:i]]) {
                index_seleccionado = i;
            }
        }
        
        [tbl_geocercas reloadData];
        [refreshControl endRefreshing];
    }
    else  if ([funcion isEqualToString:@"RevisaGeocerca"]) {
        if (code<0) {
            mensajeAlerta = [mensajeAlerta stringByAppendingString:@" ¿Desea continuar?"];
            UIAlertView* alerta = [[UIAlertView alloc] initWithTitle:@"PetLocator" message:mensajeAlerta delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:@"Cancelar", nil];
            [alerta show];
        }
        else{
            funcion = @"AsociaGeocerca";
            [self refreshTable];
        }
    }
    else{
        if (code<0) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"PetLocator" message:mensajeAlerta delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            for (int i = 0; i<[MAid_geocerca_mascota count]; i++) {
                if (index_seleccionado==i) {
                    id_geocerca_asignada = [MAid_geocerca_mascota objectAtIndex:i];
                }
            }
            
            actualizar_tabla = YES;
            [self Atras:self];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        funcion = @"AsociaGeocerca";
        [self refreshTable];
    }
    
}


-(IBAction)Asignar:(id)sender{
    if (index_seleccionado == -1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"PetLocator" message:@"Debe escoger alguna geocerca" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        funcion = @"RevisaGeocerca";
        [self refreshTable];
    }
}



- (void)refreshTable {
    
    NSString* error = @"";
    if(returnValue==NotReachable)
        error = @"No existe conexión a internet";

    if([error isEqualToString:@""]){
        contenedor_animacion.hidden = NO;
        NSMutableArray *tags;
        NSMutableArray *vars;
        if ([funcion isEqualToString:@"DameGeocerca"]) {
            tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", nil];
            vars   = [[NSMutableArray alloc]initWithObjects:GlobalUsu, Globalpass, nil];
        }
        else{
            
            tags = [[NSMutableArray alloc]initWithObjects:@"id_geocerca", @"id_mascota", nil];
            vars   = [[NSMutableArray alloc]initWithObjects:id_geocerca_mascota, id_mascota, nil];
        }
        [soapTool callSoapServiceWithParameters__functionName:funcion tags:tags vars:vars wsdlURL:url_webservice];
    }else
        [[[UIAlertView alloc]initWithTitle:@"PerLocator" message:error delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
    
    
    
}

//TABLEVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MAnombre_geo_mascota count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell  = nil;
    cell  = [tableView dequeueReusableCellWithIdentifier:@"celda"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"celda"];
    }
    
    cell.textLabel.text = [MAnombre_geo_mascota objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [MAdireccion_geocerca objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    }
    cell.detailTextLabel.numberOfLines = 2;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    if (![[MAnombre_geo_mascota objectAtIndex:indexPath.row] isEqualToString:StringMsg]) {
        if (index_seleccionado==indexPath.row) {
            [mapView_ clear];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            
            NSString* newStr = [NSString stringWithFormat:@"%@", [MAradio_geocerca objectAtIndex:indexPath.row]];
            if ([newStr isEqualToString:@"0"]) {
                newStr = @"1";
            }
            latitud_geocerca_mascota = [MAlatitud_geocerca objectAtIndex:indexPath.row] ;
            longitud_geocerca_mascota = [MAlongitud_geocerca objectAtIndex:indexPath.row] ;
            NSNumber * myNumber = [f numberFromString:newStr];
            CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake([latitud_geocerca_mascota doubleValue], [longitud_geocerca_mascota doubleValue]);
            GMSCircle *circ = [GMSCircle circleWithPosition:circleCenter
                                                     radius:[myNumber floatValue]];
            circ.fillColor = [UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/0.0 alpha:0.25];
            circ.strokeColor = [UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/0.0 alpha:1];
            circ.strokeWidth = 5;
            circ.map = mapView_;
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake([latitud_geocerca_mascota doubleValue], [longitud_geocerca_mascota doubleValue]);
            marker.icon = [UIImage imageNamed:@"marker_verde_60px.png"];
            marker.map = mapView_;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitud_geocerca_mascota doubleValue], [longitud_geocerca_mascota doubleValue]);
            [mapView_ animateToLocation:coordinate];
            cell.accessoryType =  UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType =  UITableViewCellAccessoryNone;
            
        }
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id_geocerca_mascota = [MAid_geocerca_mascota objectAtIndex:indexPath.row];
    index_seleccionado = indexPath.row;
    [tbl_geocercas reloadData];
    return indexPath;
}

-(IBAction)Atras:(id)sender{
    
    UltimaPosicion *view = [[UltimaPosicion alloc] initWithNibName:[NSString stringWithFormat:@"UltimaPosicion_%@", dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
