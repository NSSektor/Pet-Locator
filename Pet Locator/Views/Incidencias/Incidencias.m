//
//  Incidencias.m
//  Pet Locator
//
//  Created by Angel Rivas on 8/17/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "Incidencias.h"

#import "MisMascotas.h"
#import "UltimaPosicion.h"

extern NSMutableArray* MAincidencias;
extern NetworkStatus returnValue;
BOOL ajustar;
NSString* incidencia;
extern NSString* GlobalUsu;
extern NSString* Globalpass;
extern NSString* GlobalString;
extern NSString* id_mascota;
extern NSString* url_webservice;
extern NSString* dispositivo;

@interface Incidencias (){
    SYSoapTool *soapTool;
}

@end

@implementation Incidencias

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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
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
    if(![parser parse]){
        NSLog(@"Error al parsear");
    }
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pc_view.delegate = self;
    pc_view.dataSource = self;
    
    txt_incidencia = [[UITextField alloc]initWithFrame:CGRectMake(lbl_incidencia.frame.origin.x, lbl_incidencia.frame.origin.y, lbl_incidencia.frame.size.width, lbl_incidencia.frame.size.height)];
    
    txt_sub_incidencia = [[UITextField alloc] init];
    txt_sub_incidencia.backgroundColor = [UIColor whiteColor];
    txt_sub_incidencia.placeholder = @"Incidencia";
    txt_sub_incidencia.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    
    UIButton* btn_codigo = [[UIButton alloc] init];
    [btn_codigo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_codigo.backgroundColor = [UIColor colorWithRed:132.0/255.0 green:189.0/255.0 blue:0.0 / 255.0 alpha:1];
    btn_codigo.layer.borderColor = [UIColor blackColor].CGColor;
    btn_codigo.layer.borderWidth = 0.5f;
    btn_codigo.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    [btn_codigo setTitle:@"Aceptar" forState:UIControlStateNormal];
    [btn_codigo addTarget:self action:@selector(doneWithToolBar) forControlEvents:UIControlEventTouchUpInside];
    UIToolbar* Toolbar_codigo = [[UIToolbar alloc]init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        txt_sub_incidencia.frame = CGRectMake(5, 0, 200, 30);
        btn_codigo.frame = CGRectMake(5, 200, 90, 30);
        Toolbar_codigo.frame = CGRectMake(0, 0, 320, 60);
    }
    else{
        txt_sub_incidencia.frame = CGRectMake(5, 0, 600, 30);
        btn_codigo.frame = CGRectMake(5, 600, 120, 30);
        Toolbar_codigo.frame = CGRectMake(0, 0, 768, 60);
    }
    
    Toolbar_codigo.barStyle = UIBarStyleBlackTranslucent;
    Toolbar_codigo.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:txt_sub_incidencia], [[UIBarButtonItem alloc] initWithCustomView:btn_codigo],
                            nil];
    [Toolbar_codigo sizeToFit];
    txt_incidencia.inputAccessoryView = Toolbar_codigo;
    txt_incidencia.delegate = self;
    txt_sub_incidencia.delegate = self;
    lbl_incidencia.text = @"Proporcione más información sobre su incidencia";
    lbl_incidencia.textColor = [UIColor lightGrayColor];
    // [txt_incidencia addTarget:self action:@selector(Fin_codigo:) forControlEvents:UIControlEventEditingDidEnd];
    // [txt_incidencia addTarget:self action:@selector(Inicio_codigo:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:txt_incidencia];
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
    ajustar = YES;
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    incidencia = [MAincidencias objectAtIndex:0];
    
    [btn_enviar addTarget:self action:@selector(Enviar:) forControlEvents:UIControlEventTouchUpInside];
    [btn_atras addTarget:self action:@selector(Atras:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)Atras:(id)sender{
    UltimaPosicion *view = [[UltimaPosicion alloc] initWithNibName:[NSString stringWithFormat:@"UltimaPosicion_%@", dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}

-(void)Inicio_codigo{
    [txt_sub_incidencia becomeFirstResponder];
    if ([lbl_incidencia.text isEqualToString:@"Proporcione más información sobre su incidencia"]) {
        lbl_incidencia.text = @"";
        lbl_incidencia.textColor = [UIColor blackColor]; //optional
    }
    txt_sub_incidencia.text = [NSString stringWithFormat:@"%@", lbl_incidencia.text];
    txt_incidencia.enabled = NO;
}
-(void)Fin_codigo{
    lbl_incidencia.text = [NSString stringWithFormat:@"%@", txt_sub_incidencia.text];
    if ([lbl_incidencia.text isEqualToString:@"Proporcione más información sobre su incidencia"]) {
        lbl_incidencia.text = @"";
        lbl_incidencia.textColor = [UIColor blackColor]; //optional
    }
    [txt_sub_incidencia resignFirstResponder];
    [txt_incidencia resignFirstResponder];
    txt_incidencia.enabled = YES;
}

-(void)doneWithToolBar{
    [self Fin_codigo];
}

- (void)keyboardDidShow: (NSNotification *) notif{
    [self Inicio_codigo];
}

- (void)keyboardDidHide: (NSNotification *) notif{
    [self Fin_codigo];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self Fin_codigo];
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self Fin_codigo];
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    incidencia = [MAincidencias objectAtIndex:row];
    
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return MAincidencias.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    incidencia = [MAincidencias objectAtIndex:row];
    incidencia = [incidencia stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceCharacterSet]];
    incidencia = [incidencia stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return MAincidencias[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        
        CGRect frame;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frame = CGRectMake(0.0, 0.0, 299, 30);
        }
        else{
            frame = CGRectMake(0.0, 0.0, 650, 60);
        }
        
        //label size
        
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        //here you can play with fonts
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [pickerLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
        }
        else{
            [pickerLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:17.0]];
        }
        
    }
    //picker view array is the datasource
    NSString *trimmedString = [[MAincidencias objectAtIndex:row] stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    trimmedString = [[MAincidencias objectAtIndex:row] stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [pickerLabel setText:trimmedString];
    return pickerLabel;
}




-(IBAction)Enviar:(id)sender{
    NSString* error = @"";
    if(returnValue==NotReachable)
        error = @"No existe conexión a internet";
    else if ([[lbl_incidencia.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
        error = @"Debe escribir el detalle de la incidencia";
    
    if([error isEqualToString:@""]){
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"id_mascota", @"Tipo",@"Comentarios",nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu, Globalpass,id_mascota, incidencia, txt_incidencia.text,nil];
        
        [soapTool callSoapServiceWithParameters__functionName:@"Incidencia" tags:tags vars:vars wsdlURL:url_webservice];
        contenedor_animacion.hidden = NO;
    }else
        [[[UIAlertView alloc]initWithTitle:@"PerLocator" message:error delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
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
    if ([elementName isEqualToString:@"Response"]) {
        [currentElementData removeAllObjects];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Take the string inside an element (e.g. <tag>string</tag>) and save it in a property
    [currentElementString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //If we've hit the </status> tag, store the data in the statuses array
    if ([elementName isEqualToString:@"code"]) {
        StringCode = currentElementString;
    }
    if ([elementName isEqualToString:@"msg"]) {
        StringMsg = currentElementString;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    //Document has been parsed. It's time to fire some new methods off!
    [self FillArray];
}

-(void)FillArray{
    contenedor_animacion.hidden = YES;
    NSString* mensajeAlerta = StringMsg;
    NSInteger code = [StringCode intValue];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"PetLocator"
                                                      message:mensajeAlerta
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    if (code <0) {
        contenedor_animacion.hidden = YES;
        [message show];
    }
    else{
        [self Atras:self];
    }
    
}


@end
