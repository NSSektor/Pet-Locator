//
//  Adoptame.h
//  Pet Locator
//
//  Created by Angel Rivas on 8/24/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "SYSoapTool.h"
#import <MessageUI/MessageUI.h>

@interface Adoptame : UIViewController<CLLocationManagerDelegate,SOAPToolDelegate, NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate>{
    
    
    __weak IBOutlet UIView* view_all;
    
    __weak IBOutlet UIView* vista_particulares;
    __weak IBOutlet UIButton* btn_atras;
    __weak IBOutlet UIButton* btn_nuevo;
    __weak IBOutlet UIButton* btn_particulares;
    __weak IBOutlet UIButton* btn_fundaciones;
    
    
    __weak IBOutlet UIView* vista_fundaciones;
    __weak IBOutlet UITableView* tbl_fundaciones;
    __weak IBOutlet UISearchBar* searBar_fundaciones;
    
    __weak IBOutlet UIView* vista_detalle_fundaciones;
    __weak IBOutlet UIButton* btn_atras_detalle_fundaciones;
    __weak IBOutlet UIImageView* img_fundacion;
    __weak IBOutlet UILabel* lbl_nombre_fundacion;
    __weak IBOutlet UILabel* lbl_email_fundacion;
    __weak IBOutlet UILabel* lbl_mensaje_fundacion;
    
    __weak IBOutlet UIButton* btn_paypal;
    __weak IBOutlet UIButton* btn_face;
    __weak IBOutlet UIButton* btn_twitter;
    __weak IBOutlet UIButton* btn_mail;
    __weak IBOutlet UIButton* btn_www;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    
    UIRefreshControl* refreshControl_fundaciones;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    
    UIView* contenedor_animacion;
    UIActivityIndicatorView* actividad_global;
    
    UIView* contenedor_web_view;
    UIWebView* webview_;
    
    
}

-(void)FillArray;
-(void)ActualizarFundaciones;
-(void)LimpiaArreglosTemporales;
-(void) checkNetworkStatus:(NSNotification *)notice;
-(IBAction)Atras:(id)sender;
-(IBAction)Particulares:(id)sender;
-(IBAction)Fundaciones:(id)sender;
-(void)refreshTableFundaciones;
-(IBAction)AtrasDetalleFundaciones:(id)sender;
-(IBAction)Facebook:(id)sender;
-(IBAction)Twitter:(id)sender;
-(IBAction)Escribenos:(id)sender;
-(IBAction)VisitaPagina:(id)sender;

//-(void)DescargaImagenes;


@end
