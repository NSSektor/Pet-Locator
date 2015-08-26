//
//  MisMascotas.h
//  Pet Locator
//
//  Created by Angel Rivas on 6/22/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SYSoapTool.h"
#import "Reachability.h"

#import <QuartzCore/QuartzCore.h>

@interface MisMascotas : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SOAPToolDelegate, NSXMLParserDelegate,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    
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
    
    __weak IBOutlet UISearchBar* searchBar_;
    __weak IBOutlet UILabel* lbl_actualizar;
    __weak IBOutlet UIImageView* img_actualizar;
  //  __weak IBOutlet UIButton* btn_actualizar;
    __weak IBOutlet UIButton* btn_atras;
    __weak IBOutlet UIView* contenedor_vista;
    __weak IBOutlet UIView* contenedor_menu;
    __weak IBOutlet UIButton* btn_menu;
    UIView* contenedor_invisible;
    __weak IBOutlet UITableView* tbl_menu;
    
    __weak IBOutlet UIView *blurContainerView;
    __weak IBOutlet UIView *transparentView;
    __weak IBOutlet UIButton*  btn_esconder;
    
    UIImage *blurrredImage;
    
}

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

-(void) checkNetworkStatus:(NSNotification *)notice;
-(void)FillArray;
-(void)Actualizar;
-(void)EscribeArchivos;
-(void)LeeArchivos;
-(void)LimpiaArreglosTemporales;
-(IBAction)ShowMenu:(id)sender;
-(NSString*)DameHoraActual;
-(void)LeeHoraGuardada;
-(void)EscribeHora;
-(IBAction)Atras:(id)sender;


@end
