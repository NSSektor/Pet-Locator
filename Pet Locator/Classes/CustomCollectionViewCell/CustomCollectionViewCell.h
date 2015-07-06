//
//  CustomCollectionViewCell.h
//  Pet Locator
//
//  Created by Angel Rivas on 6/25/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) IBOutlet UIView  *agregar;
@property (nonatomic, strong) IBOutlet UIView  *mascota;
@property (nonatomic, strong) IBOutlet UIView  *datos_mascota;
@property (nonatomic, strong) IBOutlet UILabel     *lbl_nombre;
@property (nonatomic, strong) IBOutlet UIImageView *img_mascota;
@property (nonatomic, strong) IBOutlet UIImageView *battery_1;
@property (nonatomic, strong) IBOutlet UIImageView *battery_2;
@property (nonatomic, strong) IBOutlet UIImageView *battery_3;
@property (nonatomic, strong) IBOutlet UIImageView *battery_4;
@property (nonatomic, strong) IBOutlet UILabel     *lbl_fecha;
@property (nonatomic, strong) IBOutlet UILabel     *lbl_geocerca_asignada;
@property (nonatomic, strong) IBOutlet UIImageView *img_geocerca;
@property (nonatomic, strong) IBOutlet UILabel     *lbl_bateria;
@end
