//
//  DetalleAlerta.h
//  Pet Locator
//
//  Created by Angel Rivas on 7/7/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SYSoapTool.h"
@import GoogleMaps;

@interface DetalleAlerta : UIViewController<GMSMapViewDelegate,SOAPToolDelegate, NSXMLParserDelegate>{
    GMSMapView *mapView_;
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    __weak IBOutlet UIView *panel_mapa;
    __weak IBOutlet UIView *panel_street;
    __weak IBOutlet UIButton* btn_atras;
    UISegmentedControl* sg_tipo_mapa;
    
}

-(IBAction)Alertas:(id)sender;
-(void)FillArray;
-(IBAction)setMap:(id)sender;

@end
