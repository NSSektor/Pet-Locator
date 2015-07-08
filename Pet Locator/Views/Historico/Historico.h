//
//  Historico.h
//  Pet Locator
//
//  Created by Angel Rivas on 7/7/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "SYSoapTool.h"
@import GoogleMaps;


@interface Historico : UIViewController<GMSMapViewDelegate,SOAPToolDelegate, NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate>{
    
    __weak IBOutlet UILabel     *lbl_hoy;
    __weak IBOutlet UILabel     *lbl_ayer;
    __weak IBOutlet UILabel     *lbl_tabular;
    __weak IBOutlet UILabel     *lbl_mapa;
    __weak IBOutlet UIButton   *btn_hoy;
    __weak IBOutlet UIButton   *btn_ayer;
    __weak IBOutlet UIButton   *btn_tabular;
    __weak IBOutlet UIButton   *btn_mapa;
    __weak IBOutlet UIButton   *btn_atras;
    
    __weak IBOutlet UITableView *tbl_historico;
    __weak IBOutlet UIView *panel_mapa;
    __weak IBOutlet UIView *panel_tabla;
    __weak IBOutlet UIView *panel_street;
    GMSMapView *mapView_;
    
    UIView*      contenedor_animacion;
    
    UISegmentedControl* sg_tipo_mapa;
    NSTimer *contadorTimer;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
}

-(IBAction)Hoy:(id)sender;
-(IBAction)Ayer:(id)sender;
-(IBAction)Tabular:(id)sender;
-(IBAction)Mapa:(id)sender;

-(IBAction)UltimaPosicion:(id)sender;
-(void)FillArray;
-(IBAction)Cerrar:(id)sender;
-(IBAction)setMap:(id)sender;

-(IBAction)actualizarTimer:(id)sender;

@end
