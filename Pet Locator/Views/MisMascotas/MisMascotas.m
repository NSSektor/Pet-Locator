//
//  MisMascotas.m
//  Pet Locator
//
//  Created by Angel Rivas on 6/22/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "MisMascotas.h"
#import "CustomCollectionViewCell.h"
#import "CustomTableViewCell.h"
#import "UltimaPosicion.h"

extern NetworkStatus returnValue;
extern NSString* documentsDirectory;
extern NSString* GlobalString;
extern NSString* GlobalUsu;
extern NSString* Globalpass;
extern NSString* id_usr;
extern NSString* dispositivo;
extern NSString* url_webservice;
extern BOOL actualizar_tabla;
extern NSString*  mensaje_mascota;

extern BOOL admin_usr;

extern NSMutableArray* MAid_mascota;
extern NSMutableArray* MAid_tracker;
extern NSMutableArray* MAimei;
extern NSMutableArray* MAnombre_mascotas;
extern NSMutableArray* MAespecie_mascotas;
extern NSMutableArray* MAraza_mascotas;
extern NSMutableArray* MAimagen_mascotas;
extern NSMutableArray* MAaniversario;
extern NSMutableArray* MAedad;
extern NSMutableArray* MAalta;
extern NSMutableArray* MAestatus;
extern NSMutableArray* MAid_geocerca;
extern NSMutableArray* MAgeocerca;
extern NSMutableArray* MAicono_geocerca;
extern NSMutableArray* MAfecha;
extern NSMutableArray* MAlatitud;
extern NSMutableArray* MAlongitud;
extern NSMutableArray* MAvelocidad;
extern NSMutableArray* MAangulo;
extern NSMutableArray* MAmovimiento;
extern NSMutableArray* MAradio;
extern NSMutableArray* MAubicacion;
extern NSMutableArray* MAevento;
extern NSMutableArray* MAbateria;
extern NSMutableArray* MAcargando;

NSString* nombre_perro;
NSString* raza_perro;
NSString* aniversario_perro;
NSString* fotografia_perro;
NSString* latitud_perro;
NSString* longitud_perro;
NSString* edad_perro;
NSString* id_mascota;
NSString* bateria;
NSString* fecha_gps;
NSString* ubicacion;
NSString* id_geocerca_asignada;
NSString* evento;


@interface MisMascotas (){
    SYSoapTool *soapTool;
    NSMutableArray* MAid_mascota_tem;
    NSMutableArray* MAid_tracker_tem;
    NSMutableArray* MAimei_tem;
    NSMutableArray* MAnombre_mascotas_tem;
    NSMutableArray* MAespecie_mascotas_tem;
    NSMutableArray* MAraza_mascotas_tem;
    NSMutableArray* MAimagen_mascotas_tem;
    NSMutableArray* MAaniversario_tem;
    NSMutableArray* MAedad_tem;
    NSMutableArray* MAalta_tem;
    NSMutableArray* MAestatus_tem;
    NSMutableArray* MAid_geocerca_tem;
    NSMutableArray* MAgeocerca_tem;
    NSMutableArray* MAicono_geocerca_tem;
    NSMutableArray* MAfecha_tem;
    NSMutableArray* MAlatitud_tem;
    NSMutableArray* MAlongitud_tem;
    NSMutableArray* MAvelocidad_tem;
    NSMutableArray* MAangulo_tem;
    NSMutableArray* MAmovimiento_tem;
    NSMutableArray* MAradio_tem;
    NSMutableArray* MAubicacion_tem;
    NSMutableArray* MAevento_tem;
    NSMutableArray* MAbateria_tem;
    NSMutableArray* MAcargando_tem;
    NSString* texto_busqueda;
    BOOL actualiza_imagenes;
    CGSize size_collection_cell;
    BOOL Show;
    NSArray* array_menu;
    NSArray* array_menu_img;
}

@end

@implementation MisMascotas

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
    
    if (actualizar_tabla==YES) {
        contenedor_animacion.hidden = YES;
        [self Actualizar];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    tbl_menu.dataSource = self;
    tbl_menu.delegate = self;
    
    Show = NO;
    
    //CollectionCell
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
  //  [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    if([dispositivo isEqualToString:@"iPhone"] || [dispositivo isEqualToString:@"iPhone5"]){
        [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:[NSBundle mainBundle]]
              forCellWithReuseIdentifier:@"CollectionCell"];
        size_collection_cell = CGSizeMake(150, 150);
    }
    else if([dispositivo isEqualToString:@"iPhone6"]){
        [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell_iPhone6" bundle:[NSBundle mainBundle]]
              forCellWithReuseIdentifier:@"CollectionCell"];
        size_collection_cell = CGSizeMake(180, 180);
    }
    else if([dispositivo isEqualToString:@"iPhone6plus"]){
        [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell_iPhone6plus" bundle:[NSBundle mainBundle]]
              forCellWithReuseIdentifier:@"CollectionCell"];
        size_collection_cell = CGSizeMake(196, 196);
    }
    else if([dispositivo isEqualToString:@"iPad"]){
        [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell_iPad" bundle:[NSBundle mainBundle]]
              forCellWithReuseIdentifier:@"CollectionCell"];
        size_collection_cell = CGSizeMake(370, 370);
    }
    
    if (admin_usr==YES) {
        array_menu = [[NSArray alloc]initWithObjects:@"Mis mascotas", @"Alertas", @"Geocercas", @"Resumen", @"Ayuda", @"Cerrar sesión", nil ];
        array_menu_img = [[NSArray alloc]initWithObjects:@"mis_mascotas.png", @"alertas.png", @"geocercas.png",@"icono_reporte.png", @"ayuda.png", @"cerrar_sesion.png", nil ];
    }else{
        array_menu = [[NSArray alloc]initWithObjects:@"Mis mascotas", @"Alertas", @"Geocercas", @"Ayuda", @"Cerrar sesión", nil ];
        array_menu_img = [[NSArray alloc]initWithObjects:@"mis_mascotas.png", @"alertas.png", @"geocercas.png",@"ayuda.png", @"cerrar_sesion.png", nil ];
    }

    
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    
    [btn_actualizar addTarget:self action:@selector(Actualizar) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_menu addTarget:self action:@selector(ShowMenu:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    searchBar_.delegate = self;
    
    texto_busqueda = @"";
    
    [self LeeArchivos];
    
    actualiza_imagenes = NO;
    
    contenedor_invisible = [[UIView alloc] initWithFrame:contenedor_vista.frame];
    contenedor_invisible.backgroundColor = [UIColor clearColor];
    contenedor_invisible.hidden = YES;
    
    [contenedor_vista addSubview:contenedor_invisible];
    
}

-(IBAction)ShowMenu:(id)sender{
    CGRect frame_panel_menu = contenedor_menu.frame;
    CGRect frame_panel_vista = contenedor_vista.frame;
    if (Show) {
        contenedor_invisible.hidden = YES;
        Show = NO;
        frame_panel_menu.origin.x = - (contenedor_menu.frame.size.width);
        frame_panel_vista.origin.x = 0;
    }
    else{
        Show = YES;
        contenedor_invisible.hidden = NO;
        frame_panel_menu.origin.x = 0;
        frame_panel_vista.origin.x = (contenedor_menu.frame.size.width);
    }
    
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.9];
    contenedor_vista.frame = frame_panel_vista;
    contenedor_menu.frame = frame_panel_menu;
    [UIView commitAnimations];
}

-(void)EscribeArchivos{
    NSString* FileName = [NSString stringWithFormat:@"%@/MAid_mascota.txt", documentsDirectory];
    [MAid_mascota writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAid_tracker.txt", documentsDirectory];
    [MAid_tracker writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAimei.txt", documentsDirectory];
    [MAimei writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAnombre_mascotas.txt", documentsDirectory];
    [MAnombre_mascotas writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAespecie_mascotas.txt", documentsDirectory];
    [MAespecie_mascotas writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAraza_mascotas.txt", documentsDirectory];
    [MAraza_mascotas writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAimagen_mascotas.txt", documentsDirectory];
    [MAimagen_mascotas writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAaniversario.txt", documentsDirectory];
    [MAaniversario writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAedad.txt", documentsDirectory];
    [MAedad writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAalta.txt", documentsDirectory];
    [MAalta writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAestatus.txt", documentsDirectory];
    [MAestatus writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAid_geocerca.txt", documentsDirectory];
    [MAid_geocerca writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAgeocerca.txt", documentsDirectory];
    [MAgeocerca writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAicono_geocerca.txt", documentsDirectory];
    [MAicono_geocerca writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAfecha.txt", documentsDirectory];
    [MAfecha writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAlatitud.txt", documentsDirectory];
    [MAlatitud writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAlongitud.txt", documentsDirectory];
    [MAlongitud writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAvelocidad.txt", documentsDirectory];
    [MAvelocidad writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAangulo.txt", documentsDirectory];
    [MAangulo writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAmovimiento.txt", documentsDirectory];
    [MAmovimiento writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAradio.txt", documentsDirectory];
    [MAradio writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAubicacion.txt", documentsDirectory];
    [MAubicacion writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAevento.txt", documentsDirectory];
    [MAevento writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAbateria.txt", documentsDirectory];
    [MAbateria writeToFile:FileName atomically:YES];
    
    FileName = [NSString stringWithFormat:@"%@/MAcargando.txt", documentsDirectory];
    [MAcargando writeToFile:FileName atomically:YES];
    
    [self LeeArchivos];
}

-(void)LimpiaArreglosTemporales{
    MAid_mascota_tem = [[NSMutableArray alloc]init];
    MAid_tracker_tem = [[NSMutableArray alloc]init];
    MAimei_tem = [[NSMutableArray alloc]init];
    MAnombre_mascotas_tem = [[NSMutableArray alloc]init];
    MAespecie_mascotas_tem = [[NSMutableArray alloc]init];
    MAraza_mascotas_tem = [[NSMutableArray alloc]init];
    MAimagen_mascotas_tem = [[NSMutableArray alloc]init];
    MAaniversario_tem = [[NSMutableArray alloc]init];
    MAedad_tem = [[NSMutableArray alloc]init];
    MAalta_tem = [[NSMutableArray alloc]init];
    MAestatus_tem = [[NSMutableArray alloc]init];
    MAid_geocerca_tem = [[NSMutableArray alloc]init];
    MAgeocerca_tem = [[NSMutableArray alloc]init];
    MAicono_geocerca_tem = [[NSMutableArray alloc]init];
    MAfecha_tem = [[NSMutableArray alloc]init];
    MAlatitud_tem = [[NSMutableArray alloc]init];
    MAlongitud_tem = [[NSMutableArray alloc]init];
    MAvelocidad_tem = [[NSMutableArray alloc]init];
    MAangulo_tem = [[NSMutableArray alloc]init];
    MAmovimiento_tem = [[NSMutableArray alloc]init];
    MAradio_tem = [[NSMutableArray alloc]init];
    MAubicacion_tem = [[NSMutableArray alloc]init];
    MAevento_tem = [[NSMutableArray alloc]init];
    MAbateria_tem = [[NSMutableArray alloc]init];
    MAcargando_tem = [[NSMutableArray alloc]init];
}

-(void)LeeArchivos{
    [self LimpiaArreglosTemporales];
    NSString* FileName = [NSString stringWithFormat:@"%@/MAid_mascota.txt", documentsDirectory];
    MAid_mascota = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAid_mascota_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAid_tracker.txt", documentsDirectory];
    MAid_tracker = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAid_tracker_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAimei.txt", documentsDirectory];
    MAimei = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAimei_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAnombre_mascotas.txt", documentsDirectory];
    MAnombre_mascotas = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAnombre_mascotas_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAespecie_mascotas.txt", documentsDirectory];
    MAespecie_mascotas = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAespecie_mascotas_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAraza_mascotas.txt", documentsDirectory];
    MAraza_mascotas = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAraza_mascotas_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAimagen_mascotas.txt", documentsDirectory];
    MAimagen_mascotas = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAimagen_mascotas_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAaniversario.txt", documentsDirectory];
    MAaniversario = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAaniversario_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAedad.txt", documentsDirectory];
    MAedad = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAedad_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAalta.txt", documentsDirectory];
    MAalta = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAalta_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAestatus.txt", documentsDirectory];
    MAestatus = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAestatus_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAid_geocerca.txt", documentsDirectory];
    MAid_geocerca = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAid_geocerca_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAgeocerca.txt", documentsDirectory];
    MAgeocerca = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAgeocerca_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAicono_geocerca.txt", documentsDirectory];
    MAicono_geocerca = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAicono_geocerca_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAfecha.txt", documentsDirectory];
    MAfecha = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAfecha_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAlatitud.txt", documentsDirectory];
    MAlatitud = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAlatitud_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAlongitud.txt", documentsDirectory];
    MAlongitud = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAlongitud_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAvelocidad.txt", documentsDirectory];
    MAvelocidad = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAvelocidad_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAangulo.txt", documentsDirectory];
    MAangulo = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAangulo_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAmovimiento.txt", documentsDirectory];
    MAmovimiento = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAmovimiento_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAradio.txt", documentsDirectory];
    MAradio = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAradio_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAubicacion.txt", documentsDirectory];
    MAubicacion = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAubicacion_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAevento.txt", documentsDirectory];
    MAevento = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAevento_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAbateria.txt", documentsDirectory];
    MAbateria = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAbateria_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    
    FileName = [NSString stringWithFormat:@"%@/MAcargando.txt", documentsDirectory];
    MAcargando = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
    MAcargando_tem = [[NSMutableArray alloc]initWithContentsOfFile:FileName];
}

-(void)Actualizar{
    contenedor_animacion.hidden = NO;
    NSString* error_ = @"";
    if (returnValue == NotReachable)
        error_ = @"No existe conexión a internet para realizar la petición, intente más tarde";
    
    if ([error_ isEqualToString:@""]) {
        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"usPushToken",@"usDevice",nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu ,Globalpass, @"1234567890", @"I",nil];
        
        [soapTool callSoapServiceWithParameters__functionName:@"Login" tags:tags vars:vars wsdlURL:url_webservice];
        //  contenedor_animacion.hidden = NO;
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
    MAid_mascota       = [[NSMutableArray alloc]init];
    MAid_tracker       = [[NSMutableArray alloc]init];
    MAimei             = [[NSMutableArray alloc]init];
    MAnombre_mascotas  = [[NSMutableArray alloc]init];
    MAespecie_mascotas = [[NSMutableArray alloc]init];
    MAraza_mascotas    = [[NSMutableArray alloc]init];
    MAimagen_mascotas  = [[NSMutableArray alloc]init];
    MAaniversario      = [[NSMutableArray alloc]init];
    MAedad             = [[NSMutableArray alloc]init];
    MAalta             = [[NSMutableArray alloc]init];
    MAestatus          = [[NSMutableArray alloc]init];
    MAid_geocerca      = [[NSMutableArray alloc]init];
    MAgeocerca         = [[NSMutableArray alloc]init];
    MAicono_geocerca   = [[NSMutableArray alloc]init];
    MAfecha            = [[NSMutableArray alloc]init];
    MAlatitud          = [[NSMutableArray alloc]init];
    MAlongitud         = [[NSMutableArray alloc]init];
    MAvelocidad        = [[NSMutableArray alloc]init];
    MAangulo           = [[NSMutableArray alloc]init];
    MAmovimiento       = [[NSMutableArray alloc]init];
    MAradio            = [[NSMutableArray alloc]init];
    MAubicacion        = [[NSMutableArray alloc]init];
    MAevento           = [[NSMutableArray alloc]init];
    MAbateria          = [[NSMutableArray alloc]init];
    MAcargando         = [[NSMutableArray alloc]init];
    actualiza_imagenes = YES;
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
    if ([elementName isEqualToString:@"msg_st_masc"])
        mensaje_mascota = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"email_usr"])
        GlobalUsu = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"pass_usr"])
        Globalpass = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"admin_usr"] && ![[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
        admin_usr = YES;
    if ([elementName isEqualToString:@"id_mascota"])
        [MAid_mascota addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"id_tracker"])
        [MAid_tracker addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"imei"])
        [MAimei addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"nombre"])
        [MAnombre_mascotas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"especie"])
        [MAespecie_mascotas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"raza"])
        [MAraza_mascotas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"foto"])
        [MAimagen_mascotas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"aniversario"])
        [MAaniversario addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"edad"])
        [MAedad addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"alta"])
        [MAalta addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"estatus"])
        [MAestatus addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"id_geocerca"])
        [MAid_geocerca addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"geocerca"])
        [MAgeocerca addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"icono_geocerca"])
        [MAicono_geocerca addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"fecha_gps"])
        [MAfecha addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"latitud"])
        [MAlatitud addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"longitud"])
        [MAlongitud addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"velocidad"])
        [MAvelocidad addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"angulo"])
        [MAangulo addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"movimiento"])
        [MAmovimiento addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"radio"])
        [MAradio addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"ubicacion"])
        [MAubicacion addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"evento"])
        [MAevento addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"bateria"])
        [MAbateria addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"cargando"])
        [MAcargando addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"id_usr"]){
        id_usr = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* fileName = [NSString stringWithFormat:@"%@/id_usr.txt", documentsDirectory];
        [id_usr writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
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
    if (code <0) {
        [message show];
    }
    else{
        if (actualiza_imagenes == YES ) {
            for (int i = 0; i<[MAimagen_mascotas count]; i++) {
                
                NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString* foofile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[[MAid_mascota objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
                
                
                NSArray* words = [[MAimagen_mascotas objectAtIndex:i] componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString* nospacestring = [words componentsJoinedByString:@""];
                UIImage *pImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nospacestring]]];
                if (pImage==nil) {
                    pImage = [UIImage imageNamed:@"sin_foto.png"];
                }
                NSData *webData = UIImagePNGRepresentation(pImage);
                
                [webData writeToFile:foofile atomically:YES];
            }
            actualiza_imagenes = NO;
        }
        
        [self EscribeArchivos];
    }
    
    [self.collectionView reloadData];
    
    
   /* MisMascotas *view = [[MisMascotas alloc] initWithNibName:[NSString stringWithFormat:@"MisMascotas_%@", dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];*/
    
    contenedor_animacion.hidden = YES;
    if (actividad_global.isHidden)
        actividad_global.hidden = NO;
    [refreshControl endRefreshing];
    actualizar_tabla = NO;
    
    
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [MAid_mascota_tem count] + 1;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CollectionCell";
    CustomCollectionViewCell* cell;
    
    cell = (CustomCollectionViewCell *)[cv dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    if(indexPath.row == [MAid_mascota_tem count]){
        cell.mascota.hidden = YES;
        cell.agregar.hidden = NO;
    }else{
        cell.agregar.hidden = YES;
        cell.mascota.hidden = NO;
        NSString* valor = [[MAimagen_mascotas_tem objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@""];
        valor = [valor stringByReplacingOccurrencesOfString:@"/n" withString:@""];
        valor = [valor stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* foofile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[[MAid_mascota_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
        UIImage *pImage = [UIImage imageWithContentsOfFile:foofile];
        [cell.img_mascota setImage:pImage];
        
        NSString* nivel_bateria = [NSString stringWithFormat:@"%@", [MAbateria_tem objectAtIndex:indexPath.row]];
        int nivel_ = [nivel_bateria intValue];
        if (nivel_<=25){
            [cell.battery_1 setImage:[UIImage imageNamed:@"bateria_rojo_2.png"]];
            [cell.battery_2 setImage:[UIImage imageNamed:@"bateria_blanco_2.png"]];
            [cell.battery_3 setImage:[UIImage imageNamed:@"bateria_blanco_2.png"]];
            [cell.battery_4 setImage:[UIImage imageNamed:@"bateria_blanco_2.png"]];
        }
        else if (nivel_>=25  && nivel_ <=50){
            [cell.battery_1 setImage:[UIImage imageNamed:@"bateria_naranja_2.png"]];
            [cell.battery_2 setImage:[UIImage imageNamed:@"bateria_naranja_2.png"]];
            [cell.battery_3 setImage:[UIImage imageNamed:@"bateria_blanco_2.png"]];
            [cell.battery_4 setImage:[UIImage imageNamed:@"bateria_blanco_2.png"]];
        }
        else if (nivel_>50  && nivel_ <=75){
            [cell.battery_1 setImage:[UIImage imageNamed:@"bateria_verde_1.png"]];
            [cell.battery_2 setImage:[UIImage imageNamed:@"bateria_verde_1.png"]];
            [cell.battery_3 setImage:[UIImage imageNamed:@"bateria_verde_1.png"]];
            [cell.battery_4 setImage:[UIImage imageNamed:@"bateria_blanco_2.png"]];
        }
        cell.lbl_fecha.text = [NSString stringWithFormat:@"%@",[MAfecha_tem objectAtIndex:indexPath.row]];
        cell.lbl_geocerca_asignada.text = [NSString stringWithFormat:@"%@",[[MAgeocerca_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        [cell.img_geocerca setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[MAicono_geocerca_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]]];
        cell.lbl_bateria.text = [NSString stringWithFormat:@"%@%@ %@",@"Bateria:",[[MAbateria_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], @"%"];
        cell.lbl_nombre.text = [NSString stringWithFormat:@"%@", [[MAnombre_mascotas_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [MAid_mascota_tem count]){
        //Agregar Perro
    }
    
    nombre_perro = [NSString stringWithFormat:@"%@", [[MAnombre_mascotas_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    raza_perro = [NSString stringWithFormat:@"%@", [[MAraza_mascotas_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    aniversario_perro = [NSString stringWithFormat:@"%@", [[MAaniversario_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    fotografia_perro  = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[[MAid_mascota_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
    latitud_perro = [NSString stringWithFormat:@"%@", [[MAlatitud_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    longitud_perro = [NSString stringWithFormat:@"%@", [[MAlongitud_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    edad_perro = [NSString stringWithFormat:@"%@", [[MAedad_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    id_mascota = [NSString stringWithFormat:@"%@", [[MAid_mascota_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    bateria = [NSString stringWithFormat:@"%@", [[MAbateria_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    fecha_gps = [NSString stringWithFormat:@"%@", [[MAfecha_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    ubicacion = [NSString stringWithFormat:@"%@", [[MAubicacion_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    evento = [NSString stringWithFormat:@"%@", [[MAevento_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    id_geocerca_asignada = [NSString stringWithFormat:@"%@", [[MAid_geocerca_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    
    UltimaPosicion *view = [[UltimaPosicion alloc] initWithNibName:[NSString stringWithFormat:@"UltimaPosicion_%@",dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return size_collection_cell;
}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array_menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"TableCell";
    CustomTableViewCell *cell;
    
    cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSString* NibName = @"CustomTableViewCell";

        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NibName owner:self options:nil];
        if ([dispositivo isEqualToString:@"iPhone"] || [dispositivo isEqualToString:@"iPhone5"])
            cell = [nib objectAtIndex:10];
        else if ([dispositivo isEqualToString:@"iPhone6"] || [dispositivo isEqualToString:@"iPhone6plus"])
            cell = [nib objectAtIndex:11];
        else
            cell = [nib objectAtIndex:12];
        
    }
    cell.lbl_menu.text = [array_menu objectAtIndex:indexPath.row];
    cell.img_menu.image = [UIImage imageNamed:[array_menu_img objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   /* if (indexPath.row == 0) {
        [self ShowMenu:self];
    }
    if (indexPath.row == 1) {
        NSString* view_name = @"Alertas";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height == 568.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone5"];
            else if (screenSize.height == 667.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone6"];
            else if (screenSize.height == 736.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone6plus"];
        }
        else
            view_name = [view_name stringByAppendingString:@"_iPad"];
        
        
        Alertas *view = [[Alertas alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
        
    }
    if (indexPath.row == 2) {
        NSString* view_name = @"Geocercas";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height == 568.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone5"];
            else if (screenSize.height == 667.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone6"];
            else if (screenSize.height == 736.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone6plus"];
        }
        else
            view_name = [view_name stringByAppendingString:@"_iPad"];
        
        
        Geocercas *view = [[Geocercas alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
        
    }
    if (indexPath.row == 3 && admin_usr==NO) {
        form_Ayuda = @"MisMascotas";
        Ayuda *view = [[Ayuda alloc] initWithNibName:@"Ayuda" bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
    }
    if (indexPath.row==3 && admin_usr == YES) {
        NSString* view_name = @"Reporte";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height == 568.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone5"];
            else if (screenSize.height == 667.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone6"];
            else if (screenSize.height == 736.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone6plus"];
        }
        else
            view_name = [view_name stringByAppendingString:@"_iPad"];
        
        
        Reporte *view = [[Reporte alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
    }
    
    if (indexPath.row == 4 && admin_usr==NO) {
        metodo = @"Cerrar sesión";
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"usPushToken",@"usDevice",nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu ,Globalpass, DeviceToken, @"I",nil];
        NSLog(@"%@%@",GlobalUsu, Globalpass);
        [soapTool callSoapServiceWithParameters__functionName:@"Login" tags:tags vars:vars wsdlURL:@"http://201.131.96.39/wbs/wbs_pet3.php?wsdl"];
    }
    if (indexPath.row == 4 && admin_usr ==YES) {
        form_Ayuda = @"MisMascotas";
        Ayuda *view = [[Ayuda alloc] initWithNibName:@"Ayuda" bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
        
    }
    if (indexPath.row==5) {
        metodo = @"Cerrar sesión";
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"id_usuario", @"push_token", nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:id_usr, DeviceToken, nil];
        [soapTool callSoapServiceWithParameters__functionName:@"CierraSesion" tags:tags vars:vars wsdlURL:@"http://201.131.96.39/wbs/wbs_pet3.php?wsdl"];
    }
    */
    
    return indexPath;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.sdsadsdsad
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    if (Show) {
        [self ShowMenu:self];
    }

    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self->searchBar_ setShowsCancelButton:YES animated:YES];
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
  [self->searchBar_ setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSString* texto = self->searchBar_.text;
    if([searchText isEqualToString:@""] || searchText==nil) {
//        ArrayNombreFlotasSearch = [ArrayNombreFlotas copy];
        [self LeeArchivos];
        texto_busqueda = @"";
        // [self.searchBar resignFirstResponder];
    }
    else {
        [self LimpiaArreglosTemporales];
        for (int i = 0; i<[MAid_mascota count]; i++) {
            NSRange r = [[MAnombre_mascotas objectAtIndex:i] rangeOfString: texto options:NSCaseInsensitiveSearch];
            if (r.length>0){
                [MAid_mascota_tem addObject:[MAid_mascota objectAtIndex:i]];
                [MAid_tracker_tem addObject:[MAid_tracker objectAtIndex:i]];
                [MAimei_tem addObject:[MAimei objectAtIndex:i]];
                [MAnombre_mascotas_tem addObject:[MAnombre_mascotas objectAtIndex:i]];
                [MAespecie_mascotas_tem addObject:[MAespecie_mascotas objectAtIndex:i]];
                [MAraza_mascotas_tem addObject:[MAraza_mascotas objectAtIndex:i]];
                [MAimagen_mascotas_tem addObject:[MAimagen_mascotas objectAtIndex:i]];
                [MAaniversario_tem addObject:[MAaniversario objectAtIndex:i]];
                [MAedad_tem addObject:[MAedad objectAtIndex:i]];
                [MAalta_tem addObject:[MAalta objectAtIndex:i]];
                [MAestatus_tem addObject:[MAestatus objectAtIndex:i]];
                [MAid_geocerca_tem addObject:[MAid_geocerca objectAtIndex:i]];
                [MAgeocerca_tem addObject:[MAid_mascota objectAtIndex:i]];
                [MAicono_geocerca_tem addObject:[MAicono_geocerca objectAtIndex:i]];
                [MAfecha_tem addObject:[MAfecha objectAtIndex:i]];
                [MAlatitud_tem addObject:[MAlatitud objectAtIndex:i]];
                [MAlongitud_tem addObject:[MAlongitud objectAtIndex:i]];
                [MAvelocidad_tem addObject:[MAvelocidad objectAtIndex:i]];
                [MAangulo_tem addObject:[MAangulo objectAtIndex:i]];
                [MAmovimiento_tem addObject:[MAmovimiento objectAtIndex:i]];
                [MAradio_tem addObject:[MAradio objectAtIndex:i]];
                [MAubicacion_tem addObject:[MAubicacion objectAtIndex:i]];
                [MAevento_tem addObject:[MAevento objectAtIndex:i]];
                [MAbateria_tem addObject:[MAbateria objectAtIndex:i]];
                [MAcargando_tem addObject:[MAcargando objectAtIndex:i]];
                
                texto_busqueda = self->searchBar_.text;
            }
            
        }
    }
    
    [self.collectionView reloadData];
}



-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self->searchBar_.text = @"";
    texto_busqueda = @"";
    [self LeeArchivos];
    [self.collectionView reloadData];
    [self->searchBar_ resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self LimpiaArreglosTemporales];
    for (int i = 0; i<[MAid_mascota count]; i++) {
        NSRange r = [[MAnombre_mascotas objectAtIndex:i] rangeOfString: texto_busqueda options:NSCaseInsensitiveSearch];
        if (r.length>0){
            [MAid_mascota_tem addObject:[MAid_mascota objectAtIndex:i]];
            [MAid_tracker_tem addObject:[MAid_tracker objectAtIndex:i]];
            [MAimei_tem addObject:[MAimei objectAtIndex:i]];
            [MAnombre_mascotas_tem addObject:[MAnombre_mascotas objectAtIndex:i]];
            [MAespecie_mascotas_tem addObject:[MAespecie_mascotas objectAtIndex:i]];
            [MAraza_mascotas_tem addObject:[MAraza_mascotas objectAtIndex:i]];
            [MAimagen_mascotas_tem addObject:[MAimagen_mascotas objectAtIndex:i]];
            [MAaniversario_tem addObject:[MAaniversario objectAtIndex:i]];
            [MAedad_tem addObject:[MAedad objectAtIndex:i]];
            [MAalta_tem addObject:[MAalta objectAtIndex:i]];
            [MAestatus_tem addObject:[MAestatus objectAtIndex:i]];
            [MAid_geocerca_tem addObject:[MAid_geocerca objectAtIndex:i]];
            [MAgeocerca_tem addObject:[MAid_mascota objectAtIndex:i]];
            [MAicono_geocerca_tem addObject:[MAicono_geocerca objectAtIndex:i]];
            [MAfecha_tem addObject:[MAfecha objectAtIndex:i]];
            [MAlatitud_tem addObject:[MAlatitud objectAtIndex:i]];
            [MAlongitud_tem addObject:[MAlongitud objectAtIndex:i]];
            [MAvelocidad_tem addObject:[MAvelocidad objectAtIndex:i]];
            [MAangulo_tem addObject:[MAangulo objectAtIndex:i]];
            [MAmovimiento_tem addObject:[MAmovimiento objectAtIndex:i]];
            [MAradio_tem addObject:[MAradio objectAtIndex:i]];
            [MAubicacion_tem addObject:[MAubicacion objectAtIndex:i]];
            [MAevento_tem addObject:[MAevento objectAtIndex:i]];
            [MAbateria_tem addObject:[MAbateria objectAtIndex:i]];
            [MAcargando_tem addObject:[MAcargando objectAtIndex:i]];
            
            texto_busqueda = self->searchBar_.text;
        }
        
    }
    [self.collectionView reloadData];
    
    [self->searchBar_ resignFirstResponder];
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
