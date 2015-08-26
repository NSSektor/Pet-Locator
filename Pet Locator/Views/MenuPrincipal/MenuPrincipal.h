//
//  MenuPrincipal.h
//  Pet Locator
//
//  Created by Angel Rivas on 6/30/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

@interface MenuPrincipal : UIViewController{
    
    __weak IBOutlet UIView* contenedor_menu_principal;
    __weak IBOutlet UIView* contenedor_mis_mascotas;
    __weak IBOutlet UIView* contenedor_regreso_a_casa;
    __weak IBOutlet UIView* contenedor_adoptame;
    __weak IBOutlet UIView* contenedor_blog_fido;
    __weak IBOutlet UIView* contenedor_vet_care;
    __weak IBOutlet UIView* contenedor_tienda;
    __weak IBOutlet UIView* panel;
    
    UIButton* btn_mis_mascotas;
    UIButton* btn_regreso_a_casa;
    UIButton* btn_adoptame;
    UIButton* btn_blog_fido;
    UIButton* btn_vet_care;
    UIButton* btn_tienda;
    
    __weak IBOutlet UILabel*   lbl_alerta_regreso_a_casa;
    __weak IBOutlet UILabel*   lbl_alerta_adoptame;
    
    __weak IBOutlet UIButton* btn_menu;
    __weak IBOutlet UIButton* btn_alertas;
    __weak IBOutlet UILabel*  lbl_perfil;
    __weak IBOutlet UIImageView* img_perfil;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
}

-(IBAction)MisMascotas:(id)sender;
-(IBAction)BlogDeFido:(id)sender;
-(IBAction)VetAndCare:(id)sender;
-(IBAction)Adoptame:(id)sender;

@end
