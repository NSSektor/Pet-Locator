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

@interface MisMascotas : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SOAPToolDelegate, NSXMLParserDelegate,UISearchBarDelegate>{
    
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
    
}

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

-(void) checkNetworkStatus:(NSNotification *)notice;
-(void)FillArray;
-(void)Actualizar;
-(void)EscribeArchivos;
-(void)LeeArchivos;
-(void)LimpiaArreglosTemporales;

@end
