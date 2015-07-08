//
//  BlogDeFido.m
//  Pet Locator
//
//  Created by Angel Rivas on 7/6/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "BlogDeFido.h"
#import "MenuPrincipal.h"

extern NSString* dispositivo;

@interface BlogDeFido ()

@end

@implementation BlogDeFido

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [btn_atras addTarget:self action:@selector(Atras:) forControlEvents:UIControlEventTouchUpInside];
    
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, contenedor_webView.frame.size.width, contenedor_webView.frame.size.height)];
    [contenedor_webView addSubview:myWebView];
    myWebView.delegate = self;
    
    actividad = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [actividad setCenter:self.view.center];
    [actividad setColor:[UIColor darkGrayColor]];
    actividad.hidesWhenStopped = TRUE;
    [actividad startAnimating];
    [self.view addSubview:actividad];
    [self Animacion:1];
    NSString *urlString = @"https://elblogdefido.wordpress.com/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) [myWebView loadRequest:request];
         else if (error != nil) {
             NSLog(@"Error: %@", error);
             UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"PetLocator" message:@"No esta conectado a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
             [Notpermitted show];
             [self Animacion:2];
         }}];
    
    
}


-(IBAction)Atras:(id)sender{
    MenuPrincipal *view = [[MenuPrincipal alloc] initWithNibName:[NSString stringWithFormat:@"MenuPrincipal_%@", dispositivo] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}

-(void)Animacion:(int)Code{
    
    if (Code==1) {
        actividad.hidesWhenStopped = TRUE;
        [actividad startAnimating];
        
    }
    else {
        [actividad stopAnimating];
        [actividad hidesWhenStopped];
        
    }
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self Animacion:1];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self Animacion:2];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self Animacion:2];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end