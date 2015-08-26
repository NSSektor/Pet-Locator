//
//  MenuPrincipal.m
//  Pet Locator
//
//  Created by Angel Rivas on 6/30/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "MenuPrincipal.h"
#import "MisMascotas.h"
#import "BlogDeFido.h"
#import "VetAndCare.h"
#import "Adoptame.h"

extern NSString* dispositivo;
extern NetworkStatus returnValue;

@interface MenuPrincipal ()

@end

@implementation MenuPrincipal


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
    
    
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [lbl_alerta_adoptame.layer setCornerRadius:5];
    [lbl_alerta_adoptame.layer setMasksToBounds:YES];
    [lbl_alerta_adoptame.layer setCornerRadius:lbl_alerta_adoptame.frame.size.width/2];
    [lbl_alerta_adoptame.layer setMasksToBounds:YES];
    
    [lbl_alerta_regreso_a_casa.layer setCornerRadius:5];
    [lbl_alerta_regreso_a_casa.layer setMasksToBounds:YES];
    [lbl_alerta_regreso_a_casa.layer setCornerRadius:lbl_alerta_regreso_a_casa.frame.size.width/2];
    [lbl_alerta_regreso_a_casa.layer setMasksToBounds:YES];
    
    btn_mis_mascotas = [[UIButton alloc] initWithFrame:contenedor_mis_mascotas.frame];
    [panel addSubview:btn_mis_mascotas];
    [btn_mis_mascotas addTarget:self action:@selector(MisMascotas:) forControlEvents:UIControlEventTouchUpInside];
    
    btn_blog_fido = [[UIButton alloc] initWithFrame:contenedor_blog_fido.frame];
    [panel addSubview:btn_blog_fido];
    [btn_blog_fido addTarget:self action:@selector(BlogDeFido:) forControlEvents:UIControlEventTouchUpInside];
    
    btn_vet_care = [[UIButton alloc] initWithFrame:contenedor_vet_care.frame];
    [panel addSubview:btn_vet_care];
    [btn_vet_care addTarget:self action:@selector(VetAndCare:) forControlEvents:UIControlEventTouchUpInside];
    
    btn_adoptame = [[UIButton alloc] initWithFrame:contenedor_adoptame.frame];
    [panel addSubview:btn_adoptame];
    [btn_adoptame addTarget:self action:@selector(Adoptame:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)MisMascotas:(id)sender{
    
    NSString* error_ = @"";
    
    if (returnValue == NotReachable)
        error_ = @"No existe conexión a internet para realizar la petición, intente más tarde";
    
    if ([error_ isEqualToString:@""]) {
        MisMascotas *view = [[MisMascotas alloc] initWithNibName:[NSString stringWithFormat:@"MisMascotas_%@",dispositivo] bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
    }else
        [[[UIAlertView alloc] initWithTitle:@"PetLocator" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
    
    
}

-(IBAction)BlogDeFido:(id)sender{
    
    NSString* error_ = @"";
    
    if (returnValue == NotReachable)
        error_ = @"No existe conexión a internet para realizar la petición, intente más tarde";
    
    if ([error_ isEqualToString:@""]) {
        BlogDeFido *view = [[BlogDeFido alloc] initWithNibName:[NSString stringWithFormat:@"BlogDeFido_%@",dispositivo] bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
    }else
        [[[UIAlertView alloc] initWithTitle:@"PetLocator" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
    
}

-(IBAction)VetAndCare:(id)sender{
    NSString* error_ = @"";
    
    if (returnValue == NotReachable)
        error_ = @"No existe conexión a internet para realizar la petición, intente más tarde";
    
    if ([error_ isEqualToString:@""]) {
        VetAndCare *view = [[VetAndCare alloc] initWithNibName:[NSString stringWithFormat:@"VetAndCare_%@",dispositivo] bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
    }else
        [[[UIAlertView alloc] initWithTitle:@"PetLocator" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];

}

-(IBAction)Adoptame:(id)sender{
    NSString* error_ = @"";
    
    if (returnValue == NotReachable)
        error_ = @"No existe conexión a internet para realizar la petición, intente más tarde";
    
    if ([error_ isEqualToString:@""]) {
        Adoptame *view = [[Adoptame alloc] initWithNibName:[NSString stringWithFormat:@"Adoptame_%@",dispositivo] bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
    }else
        [[[UIAlertView alloc] initWithTitle:@"PetLocator" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil] show];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
