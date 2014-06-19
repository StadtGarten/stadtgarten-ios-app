//
//  TreeDetailViewController.h
//
//
//  Katharina Winkler


#import <UIKit/UIKit.h>
#import "Tree.h"

@interface TreeDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *treeImageView;
@property (weak, nonatomic) IBOutlet UILabel *treeSubLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (nonatomic, strong) Tree *tree;

@end
