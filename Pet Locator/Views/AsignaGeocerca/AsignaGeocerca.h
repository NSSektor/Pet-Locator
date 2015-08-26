//
//  AsignaGeocerca.h
//  Pet Locator
//
//  Created by Angel Rivas on 8/13/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SYSoapTool.h"
#import "Reachability.h"
@import GoogleMaps;


@interface AsignaGeocerca : UIViewController<GMSMapViewDelegate,SOAPToolDelegate, NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet UITableView* tbl_geocercas;
    __weak IBOutlet UIButton*    btn_asignar;
    __weak IBOutlet UIButton*    btn_atras;
    __weak IBOutlet UIView*      contenedor_mapa;
    UIView*      contenedor_animacion;
    GMSMapView *mapView_;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    
    UIRefreshControl* refreshControl;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
}

-(IBAction)Atras:(id)sender;
-(void)FillArray;
-(IBAction)Asignar:(id)sender;

@end