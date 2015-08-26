//
//  Adoptame.m
//  Pet Locator
//
//  Created by Angel Rivas on 8/24/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "Adoptame.h"
#import <QuartzCore/QuartzCore.h>
#import "MenuPrincipal.h"
#import "Bienvenida.h"
#import "CustomTableViewCell.h"

extern NSString* dispositivo;
extern NetworkStatus returnValue;
extern NSString* url_webservice;
extern NSString* documentsDirectory;
extern NSString* GlobalString;

@interface Adoptame (){
    CLLocation *LocacionSeleccionada;
    CLLocationManager *locationManager;
    CLLocation *mi_ubicacion;
    SYSoapTool *soapTool;
    NSString* metodo;
    
    NSMutableArray* Maid_fundacion;
    NSMutableArray* Manombre_fundacion;
    NSMutableArray* MaMensaje_fundacion;
    NSMutableArray* MaEmail_fundacion;
    NSMutableArray* MaWeb_fundacion;
    NSMutableArray* MaFacebook_fundacion;
    NSMutableArray* MaTwitter_fundacion;
    NSMutableArray* MaPayPal_fundacion;
    NSMutableArray* MaFotografia_fundacion;
    
    NSMutableArray* Maid_fundacion_tem;
    NSMutableArray* Manombre_fundacion_tem;
    NSMutableArray* MaMensaje_fundacion_tem;
    NSMutableArray* MaEmail_fundacion_tem;
    NSMutableArray* MaWeb_fundacion_tem;
    NSMutableArray* MaFacebook_fundacion_tem;
    NSMutableArray* MaTwitter_fundacion_tem;
    NSMutableArray* MaPayPal_fundacion_tem;
    NSMutableArray* MaFotografia_fundacion_tem;
    
    NSString* nombre_fundacion;
    NSString* Mensaje_fundacion;
    NSString* Email_fundacion;
    NSString* Web_fundacion;
    NSString* Facebook_fundacion;
    NSString* Twitter_fundacion;
    NSString* PayPal_fundacion;
    NSString* Fotografia_fundacion;
    
    
}

@end

@implementation Adoptame

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
    [self ActualizarFundaciones];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tbl_fundaciones.dataSource = self;
    tbl_fundaciones.delegate = self;
    
    vista_fundaciones.hidden = YES;
    
    refreshControl_fundaciones = [[UIRefreshControl alloc]init];
    [refreshControl_fundaciones addTarget:self action:@selector(refreshTableFundaciones) forControlEvents:UIControlEventValueChanged];
    [tbl_fundaciones addSubview:refreshControl_fundaciones];
    
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    
    
    contenedor_web_view = [[UIView alloc]initWithFrame:CGRectMake(0, img_fundacion.frame.origin.y, vista_detalle_fundaciones.frame.size.width, vista_detalle_fundaciones.frame.size.height - img_fundacion.frame.origin.y)];
    contenedor_web_view.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.5];
    contenedor_web_view.hidden = YES;
    [vista_detalle_fundaciones addSubview:contenedor_web_view];
    
    webview_ = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, contenedor_web_view.frame.size.width, contenedor_web_view.frame.size.height)];
    [contenedor_web_view addSubview:webview_];
    webview_.delegate = self;
    
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

    
    [btn_atras_detalle_fundaciones addTarget:self action:@selector(AtrasDetalleFundaciones:) forControlEvents:UIControlEventTouchUpInside];

    [btn_face addTarget:self action:@selector(Facebook:) forControlEvents:UIControlEventTouchUpInside];

    [btn_twitter addTarget:self action:@selector(Twitter:) forControlEvents:UIControlEventTouchUpInside];

    [btn_mail addTarget:self action:@selector(Escribenos:) forControlEvents:UIControlEventTouchUpInside];

    [btn_www addTarget:self action:@selector(VisitaPagina:) forControlEvents:UIControlEventTouchUpInside];

    [btn_fundaciones addTarget:self action:@selector(Fundaciones:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_particulares addTarget:self action:@selector(Particulares:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_fundaciones.layer setBorderWidth:1];
    [btn_fundaciones.layer setBorderColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1].CGColor];
    [btn_fundaciones.layer setMasksToBounds:YES];
    
    [btn_particulares.layer setBorderWidth:1];
    [btn_particulares.layer setBorderColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1].CGColor];
    [btn_particulares.layer setMasksToBounds:YES];
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
}

-(void)LimpiaArreglosTemporales{
    if ([metodo isEqualToString:@"DameFundaciones"]) {
        Maid_fundacion_tem = [[NSMutableArray alloc]init];
        Manombre_fundacion_tem = [[NSMutableArray alloc]init];
        MaMensaje_fundacion_tem = [[NSMutableArray alloc]init];
        MaEmail_fundacion_tem = [[NSMutableArray alloc]init];
        MaWeb_fundacion_tem = [[NSMutableArray alloc]init];
        MaFacebook_fundacion_tem = [[NSMutableArray alloc]init];
        MaTwitter_fundacion_tem = [[NSMutableArray alloc]init];
        MaPayPal_fundacion_tem = [[NSMutableArray alloc]init];
        MaFotografia_fundacion_tem = [[NSMutableArray alloc]init];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    mi_ubicacion = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                              longitude:newLocation.coordinate.longitude];
}

-(IBAction)Atras:(id)sender{
    MenuPrincipal *view = [[MenuPrincipal alloc] initWithNibName:[NSString stringWithFormat:@"MenuPrincipal_%@", dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}

-(IBAction)Fundaciones:(id)sender{
    
    [btn_particulares setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_particulares setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    
    [btn_fundaciones setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_fundaciones setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1]] forState:UIControlStateNormal];
    
    vista_fundaciones.hidden = NO;
    vista_particulares.hidden = YES;
    
}

-(IBAction)Particulares:(id)sender{
    
    [btn_fundaciones setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_fundaciones setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    
    [btn_particulares setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_particulares setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:80.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1]] forState:UIControlStateNormal];
    
    vista_particulares.hidden = NO;
    vista_fundaciones.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ActualizarFundaciones{
    contenedor_animacion.hidden = NO;
    NSString* error_ = @"";
    if (returnValue == NotReachable)
        error_ = @"No existe conexión a internet para realizar la petición, intente más tarde";
    
    if ([error_ isEqualToString:@""]) {
        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"lat", @"lon",nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%f", mi_ubicacion.coordinate.latitude] ,[NSString stringWithFormat:@"%f", mi_ubicacion.coordinate.longitude], nil];
        [soapTool callSoapServiceWithParameters__functionName:@"DameFundaciones" tags:tags vars:vars wsdlURL:url_webservice];
        
        metodo = @"DameFundaciones";
        
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"Pet Locator" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
        error_ = [NSString stringWithFormat:@"%@", @""];
        contenedor_animacion.hidden = YES;
        [refreshControl_fundaciones endRefreshing];
    }
}




-(void)refreshTableFundaciones{
    actividad_global.hidden = YES;
    [self ActualizarFundaciones];
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
    if([metodo isEqualToString:@"DameFundaciones"]){
        
        Maid_fundacion = [[NSMutableArray alloc] init];
        Manombre_fundacion = [[NSMutableArray alloc] init];
        MaMensaje_fundacion = [[NSMutableArray alloc] init];
        MaEmail_fundacion = [[NSMutableArray alloc] init];
        MaWeb_fundacion = [[NSMutableArray alloc] init];
        MaFacebook_fundacion= [[NSMutableArray alloc] init];
        MaTwitter_fundacion = [[NSMutableArray alloc] init];
        MaPayPal_fundacion = [[NSMutableArray alloc] init];
        MaFotografia_fundacion = [[NSMutableArray alloc] init];
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
    
    if ([metodo isEqualToString:@"DameFundaciones"]) {
        if ([elementName isEqualToString:@"id_veterinaria"])
            [Maid_fundacion addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"nombre"])
            [Manombre_fundacion addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"mensaje"])
            [MaMensaje_fundacion addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"email"])
            [MaEmail_fundacion addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"web"])
            [MaWeb_fundacion addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"tw"])
            [MaTwitter_fundacion addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"fb"])
            [MaFacebook_fundacion addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"paypal"])
            [MaPayPal_fundacion addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"fotografia"])
            [MaFotografia_fundacion addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
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
        if([metodo isEqualToString:@"DameFundaciones"]){
        //llena la tabla
            
            for (int i = 0; i<[MaFotografia_fundacion count]; i++) {
                UIImage* pImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[MaFotografia_fundacion objectAtIndex:i] componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""]]]];
                NSData *webData = UIImagePNGRepresentation(pImage);
                NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString* foofile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[[Maid_fundacion objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
                    [webData writeToFile:foofile atomically:YES];
 
            }
            
            [self LimpiaArreglosTemporales];
            for (int i = 0; i<[Maid_fundacion count]; i++) {
                
                [Maid_fundacion_tem addObject:[Maid_fundacion objectAtIndex:i]];
                [Manombre_fundacion_tem addObject:[Manombre_fundacion objectAtIndex:i]];
                [MaMensaje_fundacion_tem addObject:[MaMensaje_fundacion objectAtIndex:i]];
                [MaEmail_fundacion_tem addObject:[MaEmail_fundacion objectAtIndex:i]];
                [MaWeb_fundacion_tem addObject:[MaWeb_fundacion objectAtIndex:i]];
                [MaFacebook_fundacion_tem addObject:[MaFacebook_fundacion objectAtIndex:i]];
                [MaTwitter_fundacion_tem addObject:[MaTwitter_fundacion objectAtIndex:i]];
                [MaPayPal_fundacion_tem addObject:[MaPayPal_fundacion objectAtIndex:i]];
                [MaFotografia_fundacion_tem addObject:[MaFotografia_fundacion objectAtIndex:i]];
            }
            
            if ([Maid_fundacion_tem count]==0) {
                [Maid_fundacion_tem addObject:@""];
                [Manombre_fundacion_tem addObject:@"Sin registros"];
                [MaMensaje_fundacion_tem addObject:@""];
                [MaEmail_fundacion_tem addObject:@""];
                [MaWeb_fundacion_tem addObject:@""];
                [MaFacebook_fundacion_tem addObject:@""];
                [MaTwitter_fundacion_tem addObject:@""];
                [MaPayPal_fundacion_tem addObject:@""];
                [MaFotografia_fundacion_tem addObject:@""];
            }else{
              //  [self DescargaImagenes];
            }
            [tbl_fundaciones reloadData];
        }else{
            Bienvenida *view = [[Bienvenida alloc] initWithNibName:[NSString stringWithFormat:@"Bienvenida_%@",dispositivo]bundle:nil];
            view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:view animated:YES completion:nil];
        }
        
    }
    if([metodo isEqualToString:@"DameFundaciones"]){
        contenedor_animacion.hidden = YES;
        if (actividad_global.isHidden)
            actividad_global.hidden = NO;
        [refreshControl_fundaciones endRefreshing];
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
    return [Maid_fundacion_tem count];
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
    
    cell.lbl_nombre_vet.text = [Manombre_fundacion_tem objectAtIndex:indexPath.row];
    cell.lbl_telefono_vet.text = @"";
    cell.lbl_responsable_vet.text = @"";
    cell.lbl_servicios_vet.text = @"";
    if([[Manombre_fundacion_tem objectAtIndex:indexPath.row] isEqualToString:@"Sin registros"]){
        cell.img_vet.hidden = YES;
        cell.img_flecha_verde.hidden = YES;
        cell.lbl_separacion_vet.hidden = YES;
    }else{
        cell.img_vet.hidden = NO;
        cell.img_vet.image = [UIImage imageNamed:@"img_vet"];
        cell.img_flecha_verde.hidden = YES;
        cell.lbl_separacion_vet.hidden = NO;
        cell.lbl_separacion_vet.backgroundColor = [UIColor lightGrayColor];
        cell.lbl_servicios_vet.text = [MaMensaje_fundacion_tem objectAtIndex:indexPath.row];
        cell.lbl_telefono_vet = [MaEmail_fundacion_tem objectAtIndex:indexPath.row];
       // cell.lbl_telefono_vet.text     = [NSString stringWithFormat:@"Teléfono: %@",[ma objectAtIndex:indexPath.row]];
      //  cell.lbl_responsable_vet.text = [ma objectAtIndex:indexPath.row];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![[Manombre_fundacion_tem objectAtIndex:indexPath.row] isEqualToString:@"Sin registros"]){
        
        
        Fotografia_fundacion = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[[Maid_fundacion_tem objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
        
        img_fundacion.image = [UIImage imageNamed:Fotografia_fundacion];
        
        nombre_fundacion = [Manombre_fundacion_tem objectAtIndex:indexPath.row];
        lbl_nombre_fundacion.text = nombre_fundacion;
        
        Email_fundacion = [MaEmail_fundacion_tem objectAtIndex:indexPath.row];
        lbl_email_fundacion.text = Email_fundacion;
        
        Mensaje_fundacion = [MaMensaje_fundacion_tem objectAtIndex:indexPath.row];
        lbl_mensaje_fundacion.text = Mensaje_fundacion;
        
        PayPal_fundacion = [MaPayPal_fundacion_tem objectAtIndex:indexPath.row];
        
        Facebook_fundacion = [MaFacebook_fundacion_tem objectAtIndex:indexPath.row];
        
        Twitter_fundacion = [MaTwitter_fundacion_tem objectAtIndex:indexPath.row];
        
        Web_fundacion = [MaWeb_fundacion_tem objectAtIndex:indexPath.row];
        
        view_all.hidden = YES;
        vista_detalle_fundaciones.hidden = NO;
        
    }
    
    return indexPath;
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

-(IBAction)AtrasDetalleFundaciones:(id)sender{
    if (!contenedor_web_view.isHidden) {
        contenedor_web_view.hidden = YES;
    }else{
        view_all.hidden = NO;
        vista_detalle_fundaciones.hidden = YES;
    }
    
}

-(IBAction)Facebook:(id)sender{
    contenedor_web_view.hidden = NO;
    contenedor_animacion.hidden = NO;
    NSURL *url = [NSURL URLWithString:Facebook_fundacion];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil){
             [webview_ loadRequest:request];
             
         }
         else if (error != nil) {
             NSLog(@"Error: %@", error);
             [[[UIAlertView alloc] initWithTitle:@"PetLocator" message:@"No esta conectado a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil]show];
             contenedor_animacion.hidden = YES;
             contenedor_web_view.hidden = YES;
         }}];
}
-(IBAction)Twitter:(id)sender{
    contenedor_web_view.hidden = NO;
    contenedor_animacion.hidden = NO;
    NSURL *url = [NSURL URLWithString:Twitter_fundacion];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil){
             [webview_ loadRequest:request];
             
         }
         else if (error != nil) {
             NSLog(@"Error: %@", error);
             [[[UIAlertView alloc] initWithTitle:@"PetLocator" message:@"No esta conectado a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil]show];
             contenedor_animacion.hidden = YES;
             contenedor_web_view.hidden = YES;
         }}];
}
-(IBAction)Escribenos:(id)sender{

    NSArray *toRecipents = [NSArray arrayWithObject:Email_fundacion];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        mc.mailComposeDelegate = self;
        [mc setSubject:@"Contacto"];
        [mc setMessageBody:@"Hola :)" isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"PetLocator" message:@"No existe una cuenta de correo configurada en el dispositivo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
    }
   
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}




-(IBAction)VisitaPagina:(id)sender{
    contenedor_web_view.hidden = NO;
    contenedor_animacion.hidden = NO;
    NSURL *url = [NSURL URLWithString:Web_fundacion];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil){
            [webview_ loadRequest:request];
             
         }
         else if (error != nil) {
             NSLog(@"Error: %@", error);
             [[[UIAlertView alloc] initWithTitle:@"PetLocator" message:@"No esta conectado a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil]show];
             contenedor_animacion.hidden = YES;
             contenedor_web_view.hidden = YES;
         }}];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    contenedor_animacion.hidden = NO;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    contenedor_animacion.hidden = YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    contenedor_animacion.hidden = YES;
}


/*
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
}*/


@end
