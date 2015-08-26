//
//  VetAndCare.h
//  Pet Locator
//
//  Created by Angel Rivas on 8/20/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "SYSoapTool.h"
@import GoogleMaps;

@interface VetAndCare : UIViewController<CLLocationManagerDelegate,SOAPToolDelegate, NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate,GMSMapViewDelegate,UIAlertViewDelegate>{
    
    
    __weak IBOutlet UIView* vista_all;
    __weak IBOutlet UIButton* btn_atras;
    __weak IBOutlet UIButton* cambia_vista;
    __weak IBOutlet UIImageView* img_cambiar_vista;
    __weak IBOutlet UIButton* btn_SOS;
    __weak IBOutlet UIButton* btn_veterinarias;
    __weak IBOutlet UIButton* btn_care;
    
    
    __weak IBOutlet UIView* contenedor_lista;
    __weak IBOutlet UILabel* lbl_actualizar;
    __weak IBOutlet UIImageView* img_actualizar;
    __weak IBOutlet UITableView* tbl_vet;
    __weak IBOutlet UISearchBar* searBar;
    
    __weak IBOutlet UIView* contenedor_mapa;
    UILabel* lbl_sin_registros_mapa;
    GMSMapView* mapView_;
    
    
    __weak IBOutlet UIView* vista_detalle;
    __weak IBOutlet UILabel* lbl_detalle;
    __weak IBOutlet UIButton* btn_atras_detalle;
    __weak IBOutlet UIImageView* img_local;
    __weak IBOutlet UILabel* lbl_nombre;
    __weak IBOutlet UILabel* lbl_telefono;
    __weak IBOutlet UILabel* lbl_responsable;
    __weak IBOutlet UILabel* lbl_servicios;
    __weak IBOutlet UIView* contenedo_mapa_detalle;
    GMSMapView* mapView_detalle;
    __weak IBOutlet UIButton* btn_llamar;
    
    
    
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    
    UIRefreshControl* refreshControl;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    
    UIView* contenedor_animacion;
    UIActivityIndicatorView* actividad_global;

}

-(void)FillArray;
-(void)Actualizar;
-(void)LimpiaArreglosTemporales;
-(NSString*)DameHoraActual;
-(void)LeeHoraGuardada;
-(void)EscribeHora;

-(void) checkNetworkStatus:(NSNotification *)notice;
-(IBAction)Atras:(id)sender;
-(IBAction)AtrasDetalle:(id)sender;
-(IBAction)SOS:(id)sender;
-(IBAction)Veterinarias:(id)sender;
-(IBAction)Care:(id)sender;
-(void)FiltrarTablaXTipo:(NSString*)tipo;
- (UIImage *)grabImage: (UIView *) viewToGrab;
-(IBAction)CambiarVista:(id)sender;
-(IBAction)LLamar:(id)sender;
-(void)CargaDetalle;

-(void)DescargaImagenes;
@end
