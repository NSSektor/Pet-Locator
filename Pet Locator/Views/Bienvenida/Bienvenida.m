//
//  Bienvenida.m
//  Pet Locator
//
//  Created by Angel Rivas on 6/23/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "Bienvenida.h"
#import <QuartzCore/QuartzCore.h>
#import "Login.h"

extern NSString* dispositivo;
NSString* img_1;
NSString* img_2;
NSString* img_3;
NSString* img_4;
int contador_bienvenida;

@interface Bienvenida ()

@end

@implementation Bienvenida

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:132.0/255.0 green: 189.0/255.0 blue:0.0/255.0 alpha:1.0];
    perro.backgroundColor = [UIColor colorWithRed:132.0/255.0 green: 189.0/255.0 blue:0.0/255.0 alpha:1.0];
    
    [perro.layer setCornerRadius:5];
    [perro.layer setMasksToBounds:YES];
    [perro.layer setCornerRadius:perro.frame.size.width/2];
    [perro.layer setMasksToBounds:YES];
    
    
    img_1 = @"fondo_1_iPhone";
    img_2 = @"fondo_2_iPhone";
    img_3 = @"fondo_3_iPhone";
    img_4 = @"fondo_4_iPhone";
    
    if ([dispositivo isEqualToString:@"iPhone5"]) {
        img_1 = @"fondo_1_iPhone5";
        img_2 = @"fondo_2_iPhone5";
        img_3 = @"fondo_3_iPhone5";
        img_4 = @"fondo_4_iPhone5";
    }
    if ([dispositivo isEqualToString:@"iPhone6"]) {
        img_1 = @"fondo_1_iPhone6";
        img_2 = @"fondo_2_iPhone6";
        img_3 = @"fondo_3_iPhone6";
        img_4 = @"fondo_4_iPhone6";
    }
    if ([dispositivo isEqualToString:@"iPhone6plus"]) {
        img_1 = @"fondo_1_iPhone6plus";
        img_2 = @"fondo_2_iPhone6plus";
        img_3 = @"fondo_3_iPhone6plus";
        img_4 = @"fondo_4_iPhone6plus";
    }
    if ([dispositivo isEqualToString:@"iPad"]) {
        img_1 = @"fondo_1_iPad";
        img_2 = @"fondo_2_iPad";
        img_3 = @"fondo_3_iPad";
        img_4 = @"fondo_4_iPad";
    }
    
    img_presentation1.image = [UIImage imageNamed:img_1];
    contador_bienvenida++;
    
    UIView* contenedor_botones = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - ((self.view.frame.size.width - 60) / 2) , (self.view.frame.size.height / 3) *2, (self.view.frame.size.width - 60), 80)];
    contenedor_botones.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contenedor_botones];
    
    btn_yasoyusuario = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, contenedor_botones.frame.size.width, 30)];
    [btn_yasoyusuario setTitle:@"Ya soy usuario" forState:UIControlStateNormal];
    [btn_yasoyusuario setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal ];
    btn_yasoyusuario.backgroundColor = [UIColor colorWithRed:132.0/255.0 green: 189.0/255.0 blue:0.0/255.0 alpha:1.0];
    btn_yasoyusuario.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [btn_yasoyusuario addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_botones addSubview:btn_yasoyusuario];
    
    [btn_yasoyusuario.layer setCornerRadius:5];
    [btn_yasoyusuario.layer setMasksToBounds:YES];
    
    btn_nuevousuario = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, contenedor_botones.frame.size.width, 30)];
    [btn_nuevousuario setTitle:@"Nuevo usuario" forState:UIControlStateNormal];
    [btn_nuevousuario setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal ];
    btn_nuevousuario.backgroundColor = [UIColor darkGrayColor];
    btn_nuevousuario.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
//    [btn_nuevousuario addTarget:self action:@selector(Registro:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_botones addSubview:btn_nuevousuario];
    
    [btn_nuevousuario.layer setCornerRadius:5];
    [btn_nuevousuario.layer setMasksToBounds:YES];
    
    contadorTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(actualizarimagen:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)actualizarimagen:(id)sender{
    contador_bienvenida++;
    UIImage* newImage = [UIImage imageNamed:img_1];
    switch(contador_bienvenida) {
        case 1:
            newImage = [UIImage imageNamed:img_1];
            break;
        case 2:
            newImage = [UIImage imageNamed:img_2];
            break;
        case 3:
            newImage = [UIImage imageNamed:img_3];
            break;
        case 4:{
            newImage = [UIImage imageNamed:img_4];
            contador_bienvenida = 0;
        }
            break;
        default:
            break;
            
            // do something by default;
    }
    // set up an animation for the transition the content
    img_presentation1.image = newImage;
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.1f;
    //  animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFilterLinear;
    animation.removedOnCompletion = YES;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [[img_presentation1 layer] addAnimation:animation forKey:@"SwitchToView1"];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.9f];
    
    
    
    [UIView commitAnimations];
}

-(IBAction)Login:(id)sender{
    
    Login *view = [[Login alloc] initWithNibName:[NSString stringWithFormat:@"Login_%@",dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
    
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
