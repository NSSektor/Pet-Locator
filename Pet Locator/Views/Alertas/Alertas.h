//
//  Alertas.h
//  Pet Locator
//
//  Created by Angel Rivas on 7/7/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSoapTool.h"
@interface Alertas : UIViewController<SOAPToolDelegate, NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate>{
    __weak IBOutlet UITableView *tbl_alertas;
    __weak IBOutlet UIButton   *btn_atras;
    UIView* contenedor_animacion;
    __weak IBOutlet UIButton* btn_marcar_leidas;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
}

-(IBAction)MisMascotas:(id)sender;
-(void)FillArray;
-(IBAction)MarcarLeidas:(id)sender;


@end
