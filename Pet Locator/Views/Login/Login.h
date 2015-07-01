//
//  Login.h
//  Pet Locator
//
//  Created by Angel Rivas on 6/24/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SYSoapTool.h"
#import "Reachability.h"

#import "Bienvenida.h"
#import "MenuPrincipal.h"


@interface Login : UIViewController<UITextFieldDelegate,SOAPToolDelegate, NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource>{
    Reachability* internetReachable;
    Reachability* hostReachable;
    UIView* contenedor_animacion;
    
    __weak IBOutlet UITextField *txt_usuario;
    __weak IBOutlet UITextField *txt_pass;
    __weak IBOutlet UIButton *btn_check;
    __weak IBOutlet UIButton *btn_iniciar_sesion;
    __weak IBOutlet UIButton *btn_usuario_nuevo;
    __weak IBOutlet UIButton *btn_olvidar;
    __weak IBOutlet UIButton *btn_ayuda;
    __weak IBOutlet UIButton* btn_device_token;
    IBOutlet UITableView* autocompleteTableView;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    
}

-(void) checkNetworkStatus:(NSNotification *)notice;
- (IBAction)InIciarSesion:(id)sender;
- (IBAction)Olvidar:(id)sender;
- (IBAction)Ayuda:(id)sender;
- (IBAction)check:(id)sender;
-(IBAction)Bienvenida:(id)sender;
-(IBAction)MisMascotas:(id)sender;
-(void)FillArray;
-(IBAction)ShowDeviceToken:(id)sender;
-(NSString*)ReadFileRecordar;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;


@end
