//
//  BlogDeFido.h
//  Pet Locator
//
//  Created by Angel Rivas on 7/6/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogDeFido : UIViewController<UIWebViewDelegate, UIAlertViewDelegate>{
    UIActivityIndicatorView *actividad;
    UIWebView *myWebView;
    __weak IBOutlet UIView* contenedor_webView;
    __weak IBOutlet UIButton* btn_atras;
    
}

-(IBAction)Atras:(id)sender;

@end
