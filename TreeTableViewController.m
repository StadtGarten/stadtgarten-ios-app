//
// TreeTableViewController.m
//
// Katharina Winkler
//
// erstellt die TableView der Bäume

#import "TreeTableViewController.h"
#import "TreeTableCell.h"
#import "TreeDetailViewController.h"
#import "Database.h"
#import "SGTree.h"

@interface TreeTableViewController ()

@end

@implementation TreeTableViewController
{
    NSArray *trees;
    NSArray *searchResults;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    Database *database = [[Database alloc] init];
    __block SGTree *sgTree;
    __block NSMutableArray *treeArray = [[NSMutableArray alloc] init];
    
    [database getTrees:^(NSArray *results, NSError *error) {

        for (int i = 0; i < [results count]; i++) {
            sgTree = [results objectAtIndex:i];
            /*Tree *tree = [Tree new];
            tree.name = sgTree.name;
            tree.description = sgTree.tag;
            UIImage *img = sgTree.picture;
            tree.image = img;
            tree.info = [NSArray arrayWithObjects:@"1 unsliced loaf (1 pound) French bread", @"4 tablespoons butter", @"2 tablespoons mayonnaise", @"8 thin slices deli ham", @"1 large tomato, sliced", @"1 small onion", @"8 eggs", @"8 slices cheddar cheese", nil];*/
            [treeArray addObject:sgTree];
        }
       trees = treeArray;
       [self.tableView reloadData];
       /*dispatch_async(dispatch_get_main_queue(), ^ {
            [self.tableView reloadData];
        });
        //[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    */
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [trees count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomTableCell";
    TreeTableCell *cell = (TreeTableCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[TreeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display tree in the table cell
    SGTree *tree;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tree = [searchResults objectAtIndex:indexPath.row];
    } else {
        tree = [trees objectAtIndex:indexPath.row];
    }
    
    cell.nameLabel.text = tree.name;
    cell.thumbnailImageView.image = tree.picture;
    cell.prepTimeLabel.text = tree.tag;
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTreeDetail"]) {
        NSIndexPath *indexPath = nil;
        SGTree *selectedTree = nil;
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            selectedTree = [searchResults objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            selectedTree = [trees objectAtIndex:indexPath.row];
        }
        
        TreeDetailViewController *destViewController = segue.destinationViewController;
        destViewController.treeObject = selectedTree;
        
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSLog(@"filterContentForSearchText");
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"tag contains[c] %@", searchText];
    searchResults = [trees filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    

    NSLog(@"searchDisplayController");
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


@end
