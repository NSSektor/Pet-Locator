//
//  CustomTableViewCell.h
//  Pet Locator
//
//  Created by Angel Rivas on 7/6/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

/**Menu**/

@property (nonatomic, weak) IBOutlet UIImageView *img_menu;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_menu;

/**Menu**/

/**Alertas**/

@property (nonatomic, weak) IBOutlet UILabel     *lbl_evento_alerta;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_fecha_alerta;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_ubicacion_alerta;
@property (nonatomic, weak) IBOutlet UIImageView *img_alerta;

/**Alertas**/

/**Histórico**/

@property (nonatomic, weak) IBOutlet UILabel     *lbl_fecha;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_evento;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_ubicacion;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_bateria;
@property (nonatomic, weak) IBOutlet UIImageView *img_bateria;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_error;

@property (nonatomic, weak) NSString* id_celda;

/**Histórico**/

@end
