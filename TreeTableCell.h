//
// TreeTableCell.h
//
// Katharina Winkler
//
// Zeilen der TreeTableView

#import <UIKit/UIKit.h>

@interface TreeTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *prepTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
