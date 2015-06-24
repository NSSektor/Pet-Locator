//
//  Bienvenida.h
//  Pet Locator
//
//  Created by Angel Rivas on 6/23/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bienvenida : UIViewController{
    
    IBOutlet UIView* perro;
    IBOutlet UIImageView* img_presentation1;
    UIButton* btn_yasoyusuario;
    UIButton* btn_nuevousuario;
    UIActivityIndicatorView *actividad;
    NSTimer *contadorTimer;
}

-(IBAction)actualizarimagen:(id)sender;

-(IBAction)Login:(id)sender;

@end
