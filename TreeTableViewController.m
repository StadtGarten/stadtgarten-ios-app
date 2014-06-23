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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDataFromDatabase];
}


//gets the tree data from database
- (void)getDataFromDatabase
{
    Database *database = [[Database alloc] init];
    __block SGTree *sgTree;
    __block NSMutableArray *treeArray = [[NSMutableArray alloc] init];
    
    [database getTrees:^(NSArray *results, NSError *error) {
        
        for (int i = 0; i < [results count]; i++) {
            sgTree = [results objectAtIndex:i];
            [treeArray addObject:sgTree];
        }
        trees = treeArray;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//ruckgabe der anzahl der felder
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [trees count];
    }
}

//ruckgabe der hohe eines feldes
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomTableCell";
    TreeTableCell *cell = (TreeTableCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure
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
    
    //show labels and image
    cell.nameLabel.text = tree.name;
    cell.thumbnailImageView.image = tree.picture;
    cell.prepTimeLabel.text = tree.tag;
    
    return cell;
}


//Ausgewaehltes Item weiergeben und naechsten View aufrufen
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

//Filtern
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
