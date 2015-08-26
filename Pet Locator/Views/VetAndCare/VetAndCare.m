//
//  VetAndCare.m
//  Pet Locator
//
//  Created by Angel Rivas on 8/20/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "VetAndCare.h"
#import <QuartzCore/QuartzCore.h>
#import "MenuPrincipal.h"
#import "Bienvenida.h"
#import "CustomTableViewCell.h"
#import "Annotation.h"

extern NSString* dispositivo;
extern NetworkStatus returnValue;
extern NSString* url_webservice;
extern NSString* documentsDirectory;
extern NSString* GlobalString;

@interface VetAndCare (){
    CLLocation *LocacionSeleccionada;
    CLLocationManager *locationManager;
    CLLocation *mi_ubicacion;
    SYSoapTool *soapTool;
    NSString* metodo;
    NSString* filtro;
    
    NSMutableArray* MAid_vet;
    NSMutableArray* MAtipo;
    NSMutableArray* MAnombre;
    NSMutableArray* MAresponsable;
    NSMutableArray* Macalle;
    NSMutableArray* MAcolonia;
    NSMutableArray* MAciudad;
    NSMutableArray* MAmunicipio;
    NSMutableArray* MAestado;
    NSMutableArray* MAcp;
    NSMutableArray* MAtelefono1;
    NSMutableArray* MAtelefono2;
    NSMutableArray* MAhr_inicio;
    NSMutableArray* MAhr_fin;
    NSMutableArray* MAfotografia;
    NSMutableArray* MAlatitud;
    NSMutableArray* MAlongitud;
    NSMutableArray* MAid_servicio_vet;
    NSMutableArray* Maservicio;
    
    
    NSMutableArray* MAid_vet_tem;
    NSMutableArray* MAtipo_tem;
    NSMutableArray* MAnombre_tem;
    NSMutableArray* MAresponsable_tem;
    NSMutableArray* Macalle_tem;
    NSMutableArray* MAcolonia_tem;
    NSMutableArray* MAciudad_tem;
    NSMutableArray* MAmunicipio_tem;
    NSMutableArray* MAestado_tem;
    NSMutableArray* MAcp_tem;
    NSMutableArray* MAtelefono1_tem;
    NSMutableArray* MAtelefono2_tem;
    NSMutableArray* MAhr_inicio_tem;
    NSMutableArray* MAhr_fin_tem;
    NSMutableArray* MAfotografia_tem;
    NSMutableArray* MAlatitud_tem;
    NSMutableArray* MAlongitud_tem;
    NSMutableArray* MAid_servicio_vet_tem;
    NSMutableArray* Maservicio_tem;
    
    
    NSString* nombre_vet;
    NSString* ruta_imagen_vet;
    NSString* responsable_vet;
    NSString* servicios_vet;
    NSString* telefono_1_vet;
    NSString* telefono_2_vet;
    NSString* latitud_vet;
    NSString* longitud_vet;
    NSString* direccion_vet;
    
}

@end

@implementation VetAndCare

-(NSString*)DameHoraActual{
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    
    NSString *hora_actual = [dateFormatter stringFromDate: currentTime];
    
    return hora_actual;
}

-(void)LeeHoraGuardada{
    NSString* fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"Hora.txt"];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contents == nil || [contents isEqualToString:@""]) {
        
        lbl_actualizar.text = [NSString stringWithFormat:@"Deslize para actualizar...\nUltima actualización: %@", [self DameHoraActual]];
        [[self DameHoraActual] writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
    else{
        lbl_actualizar.text = [NSString stringWithFormat:@"Deslize para actualizar...\nUltima actualización: %@", contents];
    }
}

-(void)EscribeHora{
    lbl_actualizar.text = [NSString stringWithFormat:@"Deslize para actualizar...\nUltima actualización: %@", [self DameHoraActual]];
    NSString* fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"Hora.txt"];
    [[self DameHoraActual] writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}


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
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [locationManager stopUpdatingLocation];
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
   [self Actualizar]; 
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tbl_vet.dataSource = self;
    tbl_vet.delegate = self;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [tbl_vet addSubview:refreshControl];
    
    filtro = @"SOS";
    
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    
    contenedor_animacion = [[UIView alloc]initWithFrame:self.view.frame];
    contenedor_animacion.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.5];
    contenedor_animacion.hidden = YES;
    [self.view addSubview:contenedor_animacion];
    
    actividad_global = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // actividad_global.color = [UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0/255.0 alpha:1];
    actividad_global.color = [UIColor darkGrayColor];
    actividad_global.hidesWhenStopped = TRUE;
    CGRect newFrames = actividad_global.frame;
    newFrames.origin.x = (contenedor_animacion.frame.size.width / 2) -13;
    newFrames.origin.y = (contenedor_animacion.frame.size.height / 2) - 13;
    actividad_global.frame = newFrames;
    actividad_global.backgroundColor = [UIColor clearColor];
    actividad_global.hidden = NO;
    [actividad_global startAnimating];
    [contenedor_animacion addSubview:actividad_global];

    
    
    [btn_atras addTarget:self action:@selector(Atras:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_llamar addTarget:self action:@selector(LLamar:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_atras_detalle addTarget:self action:@selector(AtrasDetalle:) forControlEvents:UIControlEventTouchUpInside];
    
    [cambia_vista addTarget:self action:@selector(CambiarVista:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_veterinarias addTarget:self action:@selector(Veterinarias:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_SOS addTarget:self action:@selector(SOS:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_care addTarget:self action:@selector(Care:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_veterinarias.layer setBorderWidth:1];
    [btn_veterinarias.layer setBorderColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1].CGColor];
    [btn_veterinarias.layer setMasksToBounds:YES];
    
    [btn_SOS.layer setBorderWidth:1];
    [btn_SOS.layer setBorderColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1].CGColor];
    [btn_SOS.layer setMasksToBounds:YES];
    
    [btn_care.layer setBorderWidth:1];
    [btn_care.layer setBorderColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1].CGColor];
    [btn_care.layer setMasksToBounds:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:19.99
                                                            longitude:-99.99
                                                                 zoom:10];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, contenedor_mapa.frame.size.width, contenedor_mapa.frame.size.height) camera:camera];
    mapView_.delegate = self;
    [contenedor_mapa addSubview:mapView_];
    
    lbl_sin_registros_mapa = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contenedor_mapa.frame.size.width, 25)];
    lbl_sin_registros_mapa.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:0.5];
    lbl_sin_registros_mapa.textColor = [UIColor whiteColor];
    lbl_sin_registros_mapa.text = @"Sin registros";
    
    [contenedor_mapa addSubview:lbl_sin_registros_mapa];
    
    contenedor_mapa.hidden = YES;
    
    mapView_detalle = [GMSMapView mapWithFrame:CGRectMake(0, 0, contenedo_mapa_detalle.frame.size.width, contenedo_mapa_detalle.frame.size.height) camera:camera];
    mapView_detalle.delegate = self;
    [contenedo_mapa_detalle addSubview:mapView_detalle];
    
    
   // [self Actualizar];
}

-(void)LimpiaArreglosTemporales{
    
    MAid_vet_tem = [[NSMutableArray alloc]init];
    MAtipo_tem = [[NSMutableArray alloc]init];
    MAnombre_tem = [[NSMutableArray alloc]init];
    MAresponsable_tem = [[NSMutableArray alloc]init];
    Macalle_tem = [[NSMutableArray alloc]init];
    MAcolonia_tem = [[NSMutableArray alloc]init];
    MAciudad_tem = [[NSMutableArray alloc]init];
    MAmunicipio_tem = [[NSMutableArray alloc]init];
    MAestado_tem = [[NSMutableArray alloc]init];
    MAcp_tem = [[NSMutableArray alloc]init];
    MAtelefono1_tem = [[NSMutableArray alloc]init];
    MAtelefono2_tem = [[NSMutableArray alloc]init];
    MAhr_inicio_tem = [[NSMutableArray alloc]init];
    MAhr_fin_tem = [[NSMutableArray alloc]init];
    MAfotografia_tem = [[NSMutableArray alloc]init];
    MAlatitud_tem = [[NSMutableArray alloc]init];
    MAlongitud_tem = [[NSMutableArray alloc]init];
    MAid_servicio_vet_tem = [[NSMutableArray alloc]init];
    Maservicio_tem = [[NSMutableArray alloc]init];
    
}

-(void)FiltrarTablaXTipo:(NSString*)tipo{
    [self LimpiaArreglosTemporales];
    
    for (int i = 0; i<[MAid_vet count]; i++) {
        if ([[MAtipo objectAtIndex:i] isEqualToString:tipo]) {
            [MAid_vet_tem addObject:[MAid_vet objectAtIndex:i]];
            [MAtipo_tem addObject:[MAtipo objectAtIndex:i]];
            [MAnombre_tem addObject:[MAnombre objectAtIndex:i]];
            [MAresponsable_tem addObject:[MAresponsable objectAtIndex:i]];
            [Macalle_tem addObject:[Macalle objectAtIndex:i]];
            [MAcolonia_tem addObject:[MAcolonia objectAtIndex:i]];
            [MAciudad_tem addObject:[MAciudad objectAtIndex:i]];
            [MAmunicipio_tem addObject:[MAmunicipio objectAtIndex:i]];
            [MAestado_tem addObject:[MAestado objectAtIndex:i]];
            [MAcp_tem addObject:[MAcp objectAtIndex:i]];
            [MAtelefono1_tem addObject:[MAtelefono1 objectAtIndex:i]];
            [MAtelefono2_tem addObject:[MAtelefono2 objectAtIndex:i]];
            [MAhr_inicio_tem addObject:[MAhr_inicio objectAtIndex:i]];
            [MAhr_fin_tem addObject:[MAhr_fin objectAtIndex:i]];
            [MAfotografia_tem addObject:[MAfotografia objectAtIndex:i]];
            [MAlatitud_tem addObject:[MAlatitud objectAtIndex:i]];
            [MAlongitud_tem addObject:[MAlongitud objectAtIndex:i]];
        }
    }
    
    if ([MAid_vet_tem count]==0) {
        [MAid_vet_tem addObject:@""];
        [MAtipo_tem addObject:@""];
        [MAnombre_tem addObject:@"Sin registros"];
        [MAresponsable_tem addObject:@""];
        [Macalle_tem addObject:@""];
        [MAresponsable_tem addObject:@""];
        [MAcolonia_tem addObject:@""];
        [MAciudad_tem addObject:@""];
        [MAmunicipio_tem addObject:@""];
        [MAestado_tem addObject:@""];
        [MAcp_tem addObject:@""];
        [MAtelefono1_tem addObject:@""];
        [MAtelefono2_tem addObject:@""];
        [MAhr_inicio_tem addObject:@""];
        [MAhr_fin_tem addObject:@""];
        [MAfotografia_tem addObject:@""];
        [MAlatitud_tem addObject:@""];
        [MAlongitud_tem addObject:@""];
        [MAid_servicio_vet_tem addObject:@""];
        [Maservicio_tem addObject:@""];
        [mapView_ clear];
        lbl_sin_registros_mapa.hidden = NO;
    }else{
        [self DescargaImagenes];
        for (int i = 0; i<[MAid_servicio_vet count]; i++) {
            [MAid_servicio_vet_tem addObject:[MAid_servicio_vet objectAtIndex:i]];
            [Maservicio_tem addObject:[Maservicio objectAtIndex:i]];
        }
        lbl_sin_registros_mapa.hidden = YES;
        GMSMutablePath *path = [GMSMutablePath path];
        
        for (int i = 0; i < [MAid_vet_tem count]; i++) {
            CLLocationCoordinate2D position_marker = CLLocationCoordinate2DMake([[[MAlatitud_tem objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]doubleValue], [[[MAlongitud_tem objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]doubleValue]);
            GMSMarker* marker_ = [GMSMarker markerWithPosition:position_marker];
            marker_.snippet = [NSString stringWithFormat:@"%d", i];
            UIView* view_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 72)];
            view_.backgroundColor = [UIColor clearColor];
            UIImageView* img_view = [[UIImageView alloc] initWithFrame:CGRectMake((view_.frame.size.width / 2) - 20, 0, 40, 40)];
            img_view.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @"img_vet"]];
            [view_ addSubview:img_view];
            
            UILabel* lbl_direc = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 260, 30)];
            lbl_direc.numberOfLines = 2;
            lbl_direc.backgroundColor = [UIColor whiteColor];
            
            [lbl_direc.layer setBorderWidth:1];
            [lbl_direc.layer setBorderColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1].CGColor];
            [lbl_direc.layer setMasksToBounds:YES];
            
            lbl_direc.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
            lbl_direc.text = [MAnombre_tem objectAtIndex:i];
            lbl_direc.textAlignment = NSTextAlignmentCenter;
            [view_ addSubview:lbl_direc];
            
            UIImage* img_ = [self grabImage:view_];
            
            marker_.icon = img_;
            
            marker_.map = mapView_;
            [path addCoordinate: marker_.position];
        }
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
        [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds withPadding:50.0]];
        
    }
    
   
    
    [tbl_vet reloadData];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    mi_ubicacion = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                              longitude:newLocation.coordinate.longitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Atras:(id)sender{
    MenuPrincipal *view = [[MenuPrincipal alloc] initWithNibName:[NSString stringWithFormat:@"MenuPrincipal_%@", dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}

-(IBAction)AtrasDetalle:(id)sender{
    vista_detalle.hidden = YES;
    vista_all.hidden = NO;
}


-(IBAction)CambiarVista:(id)sender{
    if (contenedor_mapa.isHidden) {
        contenedor_mapa.hidden = NO;
        contenedor_lista.hidden = YES;
        img_cambiar_vista.image = [UIImage imageNamed:@"vista_mapa"];

    }else{
        contenedor_mapa.hidden = YES;
        contenedor_lista.hidden = NO;
        img_cambiar_vista.image = [UIImage imageNamed:@"vista_lista"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:+52%@", telefono_1_vet]]];
        }
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:+52%@", telefono_1_vet]]];
        }
        else if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:+52%@", telefono_2_vet]]];
        }
    }
}

-(IBAction)LLamar:(id)sender{
    if (![telefono_1_vet isEqualToString:@""] && telefono_1_vet) {
        if (![telefono_2_vet isEqualToString:@""] && telefono_2_vet) {
            
            UIAlertView *telefonos_2 = [[UIAlertView alloc] initWithTitle:@"Esto puede generar un costo extra"
                                                                  message:@"Llamar a :"
                                                           delegate:self
                                                  cancelButtonTitle:telefono_1_vet
                                                  otherButtonTitles:telefono_2_vet, @"Cancelar", nil];
            [telefonos_2 setTag:2];
            [telefonos_2 show];
            
        }else{
            UIAlertView *telefonos_1 = [[UIAlertView alloc] initWithTitle:@"Esto puede generar un costo extra"
                                                                  message:@"Llamar a :"
                                                                 delegate:self
                                                        cancelButtonTitle:telefono_1_vet
                                                        otherButtonTitles:@"Cancelar", nil];
            [telefonos_1 setTag:1];
            [telefonos_1 show];
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:@"PetLocator" message:@"No hay teléfonos disponibles" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
    }
}

-(void)CargaDetalle{

    lbl_detalle.text = [NSString stringWithFormat:@"%@", filtro];
    lbl_nombre.text = [NSString stringWithFormat:@"%@", nombre_vet];
    //NSString* ruta_imagen_vet;
    
    img_local.image = [UIImage imageNamed:ruta_imagen_vet];
    
        
    
    
    lbl_responsable.text = [NSString stringWithFormat:@"%@", responsable_vet];
    lbl_servicios.text = [NSString stringWithFormat:@"%@", servicios_vet];
    lbl_telefono.text = [NSString stringWithFormat:@"Teléfono(s): %@, %@", telefono_1_vet, telefono_2_vet];
    
    
    GMSMutablePath *path = [GMSMutablePath path];
    CLLocationCoordinate2D position_marker = CLLocationCoordinate2DMake([latitud_vet doubleValue], [longitud_vet doubleValue]);
    GMSMarker* marker_ = [GMSMarker markerWithPosition:position_marker];
    
    UIView* view_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 92)];
    view_.backgroundColor = [UIColor clearColor];
    
    UIImageView* img_globo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    img_globo.image = [UIImage imageNamed:@"GLOBO1"];
    [view_ addSubview:img_globo];
    
    UILabel* lbl_direc = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 40)];
    lbl_direc.numberOfLines = 2;
    lbl_direc.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
    lbl_direc.text = direccion_vet;
    [view_ addSubview:lbl_direc];
    
    UIImageView* img_view = [[UIImageView alloc] initWithFrame:CGRectMake(145, 51, 40, 40)];
    img_view.image = [UIImage imageNamed:@"img_vet"];
    [view_ addSubview:img_view];
    UIImage* img_ = [self grabImage:view_];
    marker_.icon = img_;
    marker_.map = mapView_detalle;
    [path addCoordinate: marker_.position];
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    
    [mapView_detalle moveCamera:[GMSCameraUpdate fitBounds:bounds withPadding:50.0]];
    
    vista_all.hidden = YES;
    vista_detalle.hidden = NO;
    
    //NSString* direccion_vet;
}

-(IBAction)SOS:(id)sender{
    
    [btn_care setTitleColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btn_care setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [btn_veterinarias setTitleColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btn_veterinarias setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [btn_SOS setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_SOS setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1]] forState:UIControlStateNormal];
    
    [self FiltrarTablaXTipo:@"SOS"];
    
    filtro = @"SOS";
    
}
-(IBAction)Veterinarias:(id)sender{
    
    [btn_care setTitleColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btn_care setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [btn_SOS setTitleColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btn_SOS setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [btn_veterinarias setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_veterinarias setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1]] forState:UIControlStateNormal];
    
    [self FiltrarTablaXTipo:@"VETERINARIA"];
    
    filtro = @"VETERINARIA";
    
}
-(IBAction)Care:(id)sender{
    
    [btn_veterinarias setTitleColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btn_veterinarias setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [btn_SOS setTitleColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btn_SOS setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [btn_care setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_care setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1]] forState:UIControlStateNormal];
    
    [self FiltrarTablaXTipo:@"CARE"];
    
    filtro = @"CARE";
}

-(void)Actualizar{
    contenedor_animacion.hidden = NO;
    NSString* error_ = @"";
    if (returnValue == NotReachable)
        error_ = @"No existe conexión a internet para realizar la petición, intente más tarde";
    
    if ([error_ isEqualToString:@""]) {
        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"lat", @"lon",nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%f", mi_ubicacion.coordinate.latitude] ,[NSString stringWithFormat:@"%f", mi_ubicacion.coordinate.longitude], nil];
        
        [soapTool callSoapServiceWithParameters__functionName:@"DameVeterinarias" tags:tags vars:vars wsdlURL:url_webservice];
        
        metodo = @"DameVeterinarias";
        
        lbl_actualizar.text = @"Actualizando...";
        img_actualizar.hidden = YES;
        
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"Pet Locator" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
        error_ = [NSString stringWithFormat:@"%@", @""];
        contenedor_animacion.hidden = YES;
        [refreshControl endRefreshing];
    }
}




-(void)refreshTable{
    actividad_global.hidden = YES;
    [self Actualizar];
}

-(void)retriveFromSYSoapTool:(NSMutableArray *)_data{
    StringCode = @"";
    StringMsg = @"";
    StringCode = @"-10";
    StringMsg = @"Error en la conexión al servidor";
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
    if([metodo isEqualToString:@"DameVeterinarias"]){
        
        MAid_vet = [[NSMutableArray alloc] init];
        MAtipo = [[NSMutableArray alloc] init];
        MAnombre = [[NSMutableArray alloc] init];
        MAresponsable = [[NSMutableArray alloc] init];
        Macalle = [[NSMutableArray alloc] init];
        MAcolonia = [[NSMutableArray alloc] init];
        MAciudad = [[NSMutableArray alloc] init];
        MAmunicipio = [[NSMutableArray alloc] init];
        MAestado = [[NSMutableArray alloc] init];
        MAcp = [[NSMutableArray alloc] init];
        MAtelefono1 = [[NSMutableArray alloc] init];
        MAtelefono2 = [[NSMutableArray alloc] init];
        MAhr_inicio = [[NSMutableArray alloc] init];
        MAhr_fin = [[NSMutableArray alloc] init];
        MAfotografia = [[NSMutableArray alloc] init];
        MAid_servicio_vet = [[NSMutableArray alloc] init];
        Maservicio = [[NSMutableArray alloc] init];
        MAlatitud = [[NSMutableArray alloc] init];
        MAlongitud = [[NSMutableArray alloc] init];
      //  actualiza_imagenes = YES;
    }
    
    
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
    
    if ([elementName isEqualToString:@"id_veterinaria"])
        [MAid_vet addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"tipo"])
        [MAtipo addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"nombre"])
        [MAnombre addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"contacto"])
        [MAresponsable addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"calle"])
        [Macalle addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"colonia"])
        [MAcolonia addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"ciudad"])
        [MAciudad addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"municipio"])
        [MAmunicipio addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"estado"])
        [MAestado addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"cp"])
        [MAcp addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"telefono1"])
        [MAtelefono1 addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"telefono2"])
        [MAtelefono2 addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"hr_inicio"])
        [MAhr_inicio addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"hr_fin"])
        [MAhr_fin addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"fotografia"])
        [MAfotografia addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"latitud"])
        [MAlatitud addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"longitiud"])
        [MAlongitud addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"id_vet"])
        [MAid_servicio_vet addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"descripcion"])
        [Maservicio addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    [self FillArray];
}

-(void)FillArray{
    NSString* mensajeAlerta = StringMsg;
    NSInteger code = [StringCode intValue];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"PetLocator"
                                                      message:mensajeAlerta
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    img_actualizar.hidden = NO;
    
    if (code <0) {
        [message show];
        [self LeeHoraGuardada];
    }
    else{
        if([metodo isEqualToString:@"DameVeterinarias"]){
            
            [self FiltrarTablaXTipo:filtro];
            [self EscribeHora];
       
        }else{
            [@"Error" writeToFile:[NSString stringWithFormat:@"%@/ConfigFile.txt", documentsDirectory] atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
            
            Bienvenida *view = [[Bienvenida alloc] initWithNibName:[NSString stringWithFormat:@"Bienvenida_%@",dispositivo]bundle:nil];
            view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:view animated:YES completion:nil];
        }
        
    }
    if([metodo isEqualToString:@"DameVeterinarias"]){
        contenedor_animacion.hidden = YES;
        if (actividad_global.isHidden)
            actividad_global.hidden = NO;
        [refreshControl endRefreshing];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MAid_vet_tem count];
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
            cell = [nib objectAtIndex:15];
        else if ([dispositivo isEqualToString:@"iPhone6plus"])
            cell = [nib objectAtIndex:16];
        else if ([dispositivo isEqualToString:@"iPad"])
            cell = [nib objectAtIndex:17];
        else
            cell = [nib objectAtIndex:13];
    }
    
    cell.lbl_nombre_vet.text = [MAnombre_tem objectAtIndex:indexPath.row];
    if([[MAnombre_tem objectAtIndex:indexPath.row] isEqualToString:@"Sin registros"]){
        cell.img_vet.hidden = YES;
        cell.img_flecha_verde.hidden = YES;
        cell.lbl_separacion_vet.hidden = YES;
        cell.lbl_telefono_vet.text = @"";
        cell.lbl_responsable_vet.text = @"";
        cell.lbl_servicios_vet.text = @"";
    }else{
        cell.img_vet.hidden = NO;
        cell.img_flecha_verde.hidden = YES;
        cell.lbl_separacion_vet.hidden = NO;
        cell.lbl_separacion_vet.backgroundColor = [UIColor lightGrayColor];
        NSString* servicios_ = @"Servicios: ";
        for (int i = 0; i<[MAid_servicio_vet_tem count]; i++) {
            if ([[MAid_servicio_vet_tem objectAtIndex:i] isEqualToString:[MAid_vet_tem objectAtIndex:indexPath.row]]) {
                if ([servicios_ isEqualToString:@"Servicios: "]) {
                    servicios_ = [NSString stringWithFormat:@"%@%@", servicios_, [Maservicio_tem objectAtIndex:i]];
                }else{
                   servicios_ = [NSString stringWithFormat:@"%@, %@", servicios_, [Maservicio_tem objectAtIndex:i]];
                }
            }
        }
        cell.lbl_telefono_vet.text     = [NSString stringWithFormat:@"Teléfono: %@",[MAtelefono1_tem objectAtIndex:indexPath.row]];
        cell.lbl_responsable_vet.text = [MAresponsable_tem objectAtIndex:indexPath.row];
        cell.lbl_servicios_vet.text     = [[NSString stringWithFormat:@"%@", servicios_] stringByReplacingOccurrencesOfString:@" ," withString:@""];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(![[MAnombre_tem objectAtIndex:indexPath.row] isEqualToString:@"Sin registros"]){
        
        nombre_vet = [MAnombre_tem objectAtIndex:indexPath.row];
       ruta_imagen_vet = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[[MAid_vet_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
        
        
        
        responsable_vet = [MAresponsable_tem objectAtIndex:indexPath.row];
        telefono_1_vet = [MAtelefono1_tem objectAtIndex:indexPath.row];
        telefono_2_vet = [MAtelefono2_tem objectAtIndex:indexPath.row];
        latitud_vet = [MAlatitud_tem objectAtIndex:indexPath.row];
        longitud_vet  = [MAlongitud_tem objectAtIndex:indexPath.row];
        direccion_vet = [NSString stringWithFormat:@"%@ %@. %@, %@, %@. C.P. %@", [Macalle_tem objectAtIndex:indexPath.row], [MAcolonia_tem objectAtIndex:indexPath.row], [MAciudad_tem objectAtIndex:indexPath.row],[MAmunicipio_tem objectAtIndex:indexPath.row], [MAestado_tem objectAtIndex:indexPath.row], [MAcp_tem objectAtIndex:indexPath.row]];
        
        servicios_vet = @"Servicios: ";
        
        for (int i = 0; i<[MAid_servicio_vet_tem count]; i++) {
            if ([[MAid_servicio_vet_tem objectAtIndex:i] isEqualToString:[MAid_vet_tem objectAtIndex:indexPath.row]]) {
                
                if ([servicios_vet isEqualToString:@"Servicios: "])
                    servicios_vet = [NSString stringWithFormat:@"%@%@", servicios_vet, [Maservicio_tem objectAtIndex:i]];
                else
                    servicios_vet = [NSString stringWithFormat:@"%@, %@", servicios_vet, [Maservicio_tem objectAtIndex:i]];
            }
        }
        servicios_vet = [[NSString stringWithFormat:@"%@", servicios_vet] stringByReplacingOccurrencesOfString:@";," withString:@""];
        
    }
    [self CargaDetalle];
    

    
    
    return indexPath;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    if(mapView==mapView_){
        nombre_vet = [MAnombre_tem objectAtIndex:[marker.snippet integerValue]];
        ruta_imagen_vet = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[[MAid_vet_tem objectAtIndex:[marker.snippet integerValue]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
        responsable_vet = [MAresponsable_tem objectAtIndex:[marker.snippet integerValue]];
        telefono_1_vet = [MAtelefono1_tem objectAtIndex:[marker.snippet integerValue]];
        telefono_2_vet = [MAtelefono2_tem objectAtIndex:[marker.snippet integerValue]];
        latitud_vet = [MAlatitud_tem objectAtIndex:[marker.snippet integerValue]];
        longitud_vet  = [MAlongitud_tem objectAtIndex:[marker.snippet integerValue]];
        direccion_vet = [NSString stringWithFormat:@"%@ %@. %@, %@, %@. C.P. %@", [Macalle_tem objectAtIndex:[marker.snippet integerValue]], [MAcolonia_tem objectAtIndex:[marker.snippet integerValue]], [MAciudad_tem objectAtIndex:[marker.snippet integerValue]],[MAmunicipio_tem objectAtIndex:[marker.snippet integerValue]], [MAestado_tem objectAtIndex:[marker.snippet integerValue]], [MAcp_tem objectAtIndex:[marker.snippet integerValue]]];
        
        servicios_vet = @"Servicios: ";
        
        for (int i = 0; i<[MAid_servicio_vet_tem count]; i++) {
            if ([[MAid_servicio_vet_tem objectAtIndex:i] isEqualToString:[MAid_vet_tem objectAtIndex:[marker.snippet integerValue]]]) {
                
                if ([servicios_vet isEqualToString:@"Servicios: "])
                    servicios_vet = [NSString stringWithFormat:@"%@%@", servicios_vet, [Maservicio_tem objectAtIndex:[marker.snippet integerValue]]];
                else
                    servicios_vet = [NSString stringWithFormat:@"%@, %@", servicios_vet, [Maservicio_tem objectAtIndex:[marker.snippet integerValue]]];
            }
        }
        servicios_vet = [[NSString stringWithFormat:@"%@", servicios_vet] stringByReplacingOccurrencesOfString:@";," withString:@""];
        servicios_vet = [[NSString stringWithFormat:@"%@", servicios_vet] stringByReplacingOccurrencesOfString:@";," withString:@""];
        [self CargaDetalle];
    }
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIImage *)grabImage: (UIView *) viewToGrab{
    UIGraphicsBeginImageContext(viewToGrab.bounds.size);
    
    [[viewToGrab layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}


-(void)DescargaImagenes{
    if (returnValue !=NotReachable ) {
        NSMutableArray* MAUbicacionImagenes = [[NSMutableArray alloc] init];
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        for (int i = 0; i<[MAfotografia count]; i++) {
            NSString* foofile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[[MAid_vet objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
            [MAUbicacionImagenes addObject:foofile];
        }
        if ([MAfotografia count]>0 && [MAfotografia count] == [MAfotografia count]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                for (int i = 0; i<[MAfotografia count]; i++) {
                    NSArray* words = [[MAfotografia objectAtIndex:i] componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString* nospacestring = [words componentsJoinedByString:@""];
                    UIImage* pImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nospacestring]]];
                    NSData *webData = UIImagePNGRepresentation(pImage);
                    if ([MAUbicacionImagenes count]>0) {
                        [webData writeToFile:[MAUbicacionImagenes objectAtIndex:i] atomically:YES];
                    }
                    
                }
                
                
                
            });
        }
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
