//
//  MisMascotas.m
//  Pet Locator
//
//  Created by Angel Rivas on 6/22/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "MisMascotas.h"
#import "CustomCollectionViewCell.h"

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


@interface MisMascotas (){
    SYSoapTool *soapTool;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    label_array = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<23; i++){
        [label_array addObject:[NSString stringWithFormat:@"%d", i]];
    }
                   
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //CollectionCell
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
  //  [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell_iPhone6" bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:@"CollectionCell"];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.collectionView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    
    contenedor_animacion = [[UIView alloc]initWithFrame:self.view.frame];
    contenedor_animacion.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.5];
    contenedor_animacion.hidden = YES;
    [self.view addSubview:contenedor_animacion];
    
    actividad_global = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
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
    
    if (actualizar_tabla==YES) {
        contenedor_animacion.hidden = YES;
        [self Actualizar];
    }
    
}

-(void)Actualizar{
    contenedor_animacion.hidden = NO;
    NSString* error_ = @"";
    if (returnValue == NotReachable)
        error_ = @"No existe conexión a internet";
    
    if ([error_ isEqualToString:@""]) {
        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"usPushToken",@"usDevice",nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu ,Globalpass, @"1234567890", @"I",nil];
        
        [soapTool callSoapServiceWithParameters__functionName:@"Login" tags:tags vars:vars wsdlURL:url_webservice];
        //  contenedor_animacion.hidden = NO;
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"Pet Locator" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
        error_ = [NSString stringWithFormat:@"%@", @""];
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
    }
    contenedor_animacion.hidden = YES;
    if (actividad_global.isHidden)
        actividad_global.hidden = NO;
    [refreshControl endRefreshing];
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [label_array count];
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

    cell.collectionLabel.text = [NSString stringWithFormat:@"%@", [label_array objectAtIndex:indexPath.row]];
    return cell;
    
  /*
    static NSString *simpleTableIdentifier = @"CollectionCell";
    
    
    
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    cell.collectionLabel.text = [label_array objectAtIndex:indexPath.row];
    return cell;*/
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSLog(@"Clicked %d", indexPath.row);
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(150, 150);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.sdsadsdsad
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
