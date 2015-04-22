//
//  ShareViewController.h
//  Test
//
//  Created by Azure Hu on 4/11/15.
//  Copyright (c) 2015 Labuser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *drawingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *drawingView;

- (IBAction)share:(id)sender;
- (IBAction)getImage:(id)sender;
@end
