//
//  Incidencias.h
//  Pet Locator
//
//  Created by Angel Rivas on 8/17/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SYSoapTool.h"
#import "Reachability.h"
@interface Incidencias : UIViewController<UITextFieldDelegate, UIPickerViewDataSource, SOAPToolDelegate, NSXMLParserDelegate,UIPickerViewDelegate>{
    UITextField* txt_sub_incidencia;
    UITextField* txt_incidencia;
    __weak IBOutlet UILabel      *lbl_incidencia;
    __weak IBOutlet UIButton     *btn_enviar;
    __weak IBOutlet UIButton     *btn_atras;
    __weak IBOutlet UIPickerView *pc_view;
    UIView*      contenedor_animacion;
    
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
}

-(IBAction)Atras:(id)sender;
-(IBAction)Enviar:(id)sender;
-(void)doneWithToolBar;


-(void)Inicio_codigo;
-(void)Fin_codigo;

@end
