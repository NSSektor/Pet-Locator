//
//  AppDelegate.m
//  Pet Locator
//
//  Created by Angel Rivas on 6/22/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "AppDelegate.h"

#import "Bienvenida.h"

NSString* dispositivo;
NSString* documentsDirectory;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];

    NSString *contents = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/ConfigFile.txt", documentsDirectory] usedEncoding:nil error:nil];
    NSString* mensaje = [NSString stringWithFormat:@"%@", @"Error"];

    if (contents != nil && ![contents isEqualToString:@"Error"]) {
        NSArray *chunks2 = [contents componentsSeparatedByString: @"|"];
        if ([chunks2 count]==2){
     /*       GlobalUsu = [NSString stringWithFormat:@"%@", [chunks2 objectAtIndex:0]];
            Globalpass = [NSString stringWithFormat:@"%@", [chunks2 objectAtIndex:1]];
            ViewName = @"MisMascotas";
            mensaje = @"OK";*/
        }
    }
    
    contents = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/url_paypal.txt", documentsDirectory] usedEncoding:nil error:nil];
    if (contents != nil && ![contents isEqualToString:@""]) {
       /* ViewName = @"PagoPaypal";
        url_paypal = contents;
        mensaje = @"PayPal";*/
    }
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    dispositivo = @"iPhone";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height == 568.0f)
            dispositivo = @"iPhone5";
        else if (screenSize.height == 667.0f)
            dispositivo = @"iPhone6";
        else if (screenSize.height == 736.0f)
            dispositivo = @"iPhone6plus";
    } else
        dispositivo = @"iPad";
        
    if ([mensaje isEqualToString:@"Error"]) {
        Bienvenida*  viewController = [[Bienvenida alloc] initWithNibName:[NSString stringWithFormat:@"Bienvenida_%@", dispositivo] bundle:nil];
        self.window.rootViewController = viewController;
        
    }
    else if ([mensaje isEqualToString:@"PayPal"]){
    /*    PagoPaypal*  viewController = [[PagoPaypal alloc] initWithNibName:@"PagoPaypal" bundle:nil];
        self.window.rootViewController = viewController;*/
    }
    else{
  /*      actualizar_tabla = YES;
        MisMascotas *viewController = [[MisMascotas alloc] initWithNibName:ViewName bundle:nil];
        self.window.rootViewController = viewController;*/
    }
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end