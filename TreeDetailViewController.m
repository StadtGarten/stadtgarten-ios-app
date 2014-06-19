//
// TreeDetailViewController.m
//
// Katharina Winkler
//
// zeigt Tree Details
// wird von TreeTableView aufgerufen


#import "TreeDetailViewController.h"

@interface TreeDetailViewController ()

@end

@implementation TreeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.title = self.tree.name;
    self.treeSubLabel.text = self.tree.description;
    self.treeImageView.image = [UIImage imageNamed:self.tree.image];
    
    NSMutableString *ingredientsText = [NSMutableString string];
    for (NSString* ingredient in self.tree.info) {
        [ingredientsText appendFormat:@"%@\n", ingredient];
    }
    self.descriptionTextView.text = ingredientsText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
