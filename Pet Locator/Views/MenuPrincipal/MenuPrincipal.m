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

extern NSString* dispositivo;

@interface MenuPrincipal ()

@end

@implementation MenuPrincipal

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)MisMascotas:(id)sender{
    MisMascotas *view = [[MisMascotas alloc] initWithNibName:[NSString stringWithFormat:@"MisMascotas_%@",dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}

-(IBAction)BlogDeFido:(id)sender{
    BlogDeFido *view = [[BlogDeFido alloc] initWithNibName:[NSString stringWithFormat:@"BlogDeFido_%@",dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
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
