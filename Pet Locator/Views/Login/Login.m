//
//  Login.m
//  Pet Locator
//
//  Created by Angel Rivas on 6/24/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "Login.h"


extern NetworkStatus returnValue;
extern NSString* documentsDirectory;
extern NSString* GlobalString;
extern NSString* GlobalUsu;
extern NSString* Globalpass;
extern NSString* id_usr;
extern NSString* dispositivo;
extern NSString* url_webservice;
extern NSString* DeviceToken;
NSString*  mensaje_mascota;

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


@interface Login (){
    SYSoapTool *soapTool;
    NSMutableArray* MAUsuarios;
    NSString* fileName_Cookies;
    NSMutableArray* autocompletar_usuarios;
    BOOL check;
}

@end

@implementation Login


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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    txt_usuario.placeholder = @"Usuario";
    txt_usuario.keyboardType = UIKeyboardTypeEmailAddress;
    txt_usuario.autocorrectionType = UITextAutocorrectionTypeNo;
    txt_usuario.delegate = self;
    txt_usuario.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    txt_pass.placeholder = @"Contraseña";
    txt_pass.secureTextEntry = YES;
    txt_pass.autocorrectionType = UITextAutocorrectionTypeNo;
    txt_pass.delegate = self;
    txt_pass.clearButtonMode = UITextFieldViewModeWhileEditing;

    [btn_check addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    [btn_check setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    
    [btn_iniciar_sesion addTarget:self action:@selector(InIciarSesion:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_device_token addTarget:self action:@selector(ShowDeviceToken:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_usuario_nuevo addTarget:self action:@selector(Bienvenida:) forControlEvents:UIControlEventTouchUpInside];
    
    autocompletar_usuarios = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    [btn_device_token addTarget:self action:@selector(ShowDeviceToken:) forControlEvents:UIControlEventTouchUpInside];
    
    check = NO;
    if (![Globalpass isEqualToString:@""] && ![GlobalUsu isEqualToString:@""]) {
        txt_pass.text = Globalpass;
        txt_usuario.text = GlobalUsu;
        [btn_check setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        check = YES;
    }
   
    MAid_mascota            = [[NSMutableArray alloc]init];
    MAid_tracker               = [[NSMutableArray alloc]init];
    MAimei                        = [[NSMutableArray alloc]init];
    MAnombre_mascotas = [[NSMutableArray alloc]init];
    MAespecie_mascotas = [[NSMutableArray alloc]init];
    MAraza_mascotas      = [[NSMutableArray alloc]init];
    MAimagen_mascotas = [[NSMutableArray alloc]init];
    MAaniversario             = [[NSMutableArray alloc]init];
    MAedad                      = [[NSMutableArray alloc]init];
    MAalta                        = [[NSMutableArray alloc]init];
    MAestatus                  = [[NSMutableArray alloc]init];
    MAid_geocerca          = [[NSMutableArray alloc]init];
    MAgeocerca               = [[NSMutableArray alloc]init];
    MAicono_geocerca     = [[NSMutableArray alloc]init];
    MAfecha                     = [[NSMutableArray alloc]init];
    MAlatitud                    = [[NSMutableArray alloc]init];
    MAlongitud                 = [[NSMutableArray alloc]init];
    MAvelocidad               = [[NSMutableArray alloc]init];
    MAangulo                   = [[NSMutableArray alloc]init];
    MAmovimiento            = [[NSMutableArray alloc]init];
    MAradio                      = [[NSMutableArray alloc]init];
    MAubicacion               = [[NSMutableArray alloc]init];
    MAevento                   = [[NSMutableArray alloc]init];
    MAbateria                   = [[NSMutableArray alloc]init];
    MAcargando               = [[NSMutableArray alloc]init];
    
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    
    
 
    fileName_Cookies = [NSString stringWithFormat:@"%@/ConfigFile_Cookies.txt", documentsDirectory];
    MAUsuarios  = [[NSMutableArray alloc]initWithContentsOfFile:fileName_Cookies];
    if (MAUsuarios==nil || [MAUsuarios count]==0) {
        MAUsuarios = [[NSMutableArray alloc]init];
    }
    
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(txt_usuario.frame.origin.x, txt_usuario.frame.origin.y + 30, txt_usuario.frame.size.width, 120) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    [self.view addSubview:autocompleteTableView];
    
    
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
    
    // Do any additional setup after loading the view.
    
   /* self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
            }
        }
    }];*/
}

-(NSString*)ReadFileRecordar{
    NSString* fileName = [NSString stringWithFormat:@"%@/ConfigFile.txt", documentsDirectory];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contents == nil && [contents isEqualToString:@""]) {
        contents = @"Error";
    }
    
    return contents;
    
}

-(IBAction)InIciarSesion:(id)sender{
    
    admin_usr = NO;
    NSString* error_ = @"";
    if (returnValue == NotReachable)
        error_ = @"No existe conexión a internet";
    
    if ([txt_pass.text isEqualToString:[(@"") stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        error_ = @"Debe de insertar una contraseña";
        [txt_pass becomeFirstResponder];
    }
    if ([[txt_usuario.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:(@"")]){
        error_ = @"Debe de insertar un usuario";
        [txt_usuario becomeFirstResponder];
    }
    /*   else if ([txt_contrasenia text].length<4)
     msg_error = @"La contraseña debe tener entre 4 y 8 caracteres";*/
    
  /*  if ([error_ isEqualToString:@""]) {
        NSLog(@"%@",DeviceToken);
        
        DeviceToken = [[UAirship shared] deviceToken];
        
        if ([DeviceToken isKindOfClass:[NSNull class]] || DeviceToken==NULL || DeviceToken == nil) {
            DeviceToken = @"";
        }*/
    
    if ([error_ isEqualToString:@""]) {
        
        NSLog(@"%@",DeviceToken);
        
        if ([DeviceToken isKindOfClass:[NSNull class]] || DeviceToken==NULL || DeviceToken == nil) {
            DeviceToken = @"";
        }
    
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"usPushToken",@"usDevice",nil];
        
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:txt_usuario.text ,txt_pass.text, @"1234567890", DeviceToken,nil];
        
        [soapTool callSoapServiceWithParameters__functionName:@"Login" tags:tags vars:vars wsdlURL:url_webservice];
        contenedor_animacion.hidden = NO;
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"Pet Locator" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
        error_ = [NSString stringWithFormat:@"%@", @""];
    }
    
    
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
        contenedor_animacion.hidden = YES;
    }
    else{
        for (int i = 0; i<[MAimagen_mascotas count]; i++) {
            NSArray* words = [[MAimagen_mascotas objectAtIndex:i] componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString* nospacestring = [words componentsJoinedByString:@""];
            UIImage *pImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nospacestring]]];
            if (pImage==nil) {
                pImage = [UIImage imageNamed:@"sin_foto.png"];
            }
            NSData *webData = UIImagePNGRepresentation(pImage);
            NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString* foofile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[[MAid_mascota objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
            [webData writeToFile:foofile atomically:YES];
        }
        NSString* fileName = [NSString stringWithFormat:@"%@/ConfigFile.txt", documentsDirectory];
        //  if (check == YES) {
        NSString* DataMobileUser = [NSString stringWithFormat:@"%@%@%@", txt_usuario.text, @"|", txt_pass.text];
        GlobalUsu = txt_usuario.text;
        Globalpass = txt_pass.text;
        [DataMobileUser writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        //      }
        //    else{
        //      [@"Error" writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        // }
        [self MisMascotas:self];
    }
}

-(IBAction)ShowDeviceToken:(id)sender{
 /*   DeviceToken = [[UAirship shared] deviceToken];
    UIAlertView* alerta = [[UIAlertView alloc]initWithTitle:@"PetLocator" message:DeviceToken delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    [alerta show];*/
}

-(IBAction)MisMascotas:(id)sender{
    
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
    
    NSString* DataMobileUser = @"";
    DataMobileUser = [DataMobileUser stringByAppendingString:txt_usuario.text];
    DataMobileUser = [DataMobileUser stringByAppendingString:@"|"];
    DataMobileUser = [DataMobileUser stringByAppendingString:txt_pass.text];
    NSMutableArray* MAUsuariostem = [[NSMutableArray alloc]init];
    if (MAUsuarios ==nil || [MAUsuarios count] == 0) {
        MAUsuariostem = [[NSMutableArray alloc] initWithObjects:DataMobileUser, nil];
    }
    else{
        BOOL existe_usuario = false;
        NSString* string_ = [NSString stringWithFormat:@"%@|%@", txt_usuario.text, txt_pass.text];
        for (int i = 0; i<[MAUsuarios count]; i++) {
            NSArray *chunks2 = [[MAUsuarios objectAtIndex:i] componentsSeparatedByString: @"|"];
            if ([txt_usuario.text isEqualToString:[chunks2 objectAtIndex:0]]) {
                [MAUsuariostem addObject:string_];
                existe_usuario = true;
            }
            else{
                [MAUsuariostem addObject:[MAUsuarios objectAtIndex:i]];
            }
        }
        if (!existe_usuario) {
            [MAUsuariostem addObject:string_];
        }
    }
    [MAUsuariostem writeToFile:fileName_Cookies atomically:YES];
    contenedor_animacion.hidden = YES;
    MenuPrincipal *view = [[MenuPrincipal alloc] initWithNibName:[NSString stringWithFormat:@"MenuPrincipal_%@", dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}

-(IBAction)Olvidar:(id)sender{
 /*
    NSString* view_name = @"Olvidar";
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
    
    Olvidar *view = [[Olvidar alloc] initWithNibName:view_name bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];*/
    
}


- (IBAction)Ayuda:(id)sender {
 /*   form_Ayuda = @"Login";
    Ayuda *view = [[Ayuda alloc] initWithNibName:@"Ayuda" bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];*/
}

- (IBAction)Bienvenida:(id)sender {
     Bienvenida *view = [[Bienvenida alloc] initWithNibName:[NSString stringWithFormat:@"Bienvenida_%@",dispositivo] bundle:nil];
     view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
     [self presentViewController:view animated:YES completion:nil];
}

- (IBAction)check:(id)sender {
    if (!check) {
        [btn_check setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        check = YES;
    }
    else{
        [btn_check setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        check = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/*Method to hidden keyboard*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    autocompleteTableView.hidden = YES;
    [textField resignFirstResponder];
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    autocompleteTableView.hidden = YES;
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL) textFieldShouldClear:(UITextField *)textField{
    autocompleteTableView.hidden = YES;
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [autocompletar_usuarios removeAllObjects];
    for(NSString *curString in MAUsuarios) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [autocompletar_usuarios addObject:curString];
        }
    }
    if ([autocompletar_usuarios count]>0) {
        autocompleteTableView.hidden = NO;
    }
    else{
        autocompleteTableView.hidden = YES;
    }
    [autocompleteTableView reloadData];
}

/*Method to hidden keyboard*/



#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==txt_usuario) {
        NSString *substring = [NSString stringWithString:textField.text];
        substring = [substring stringByReplacingCharactersInRange:range withString:string];
        [self searchAutocompleteEntriesWithSubstring:substring];
    }
    return YES;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autocompletar_usuarios.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    NSArray *chunks2 = [[autocompletar_usuarios objectAtIndex:indexPath.row] componentsSeparatedByString: @"|"];
    
    cell.textLabel.text = [chunks2 objectAtIndex:0];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *chunks2 = [[autocompletar_usuarios objectAtIndex:indexPath.row] componentsSeparatedByString: @"|"];
    txt_usuario.text = [chunks2 objectAtIndex:0];
    txt_pass.text = [chunks2 objectAtIndex:1];
    autocompleteTableView.hidden = YES;
    [txt_usuario resignFirstResponder];
    //  [self goPressed];
    
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
