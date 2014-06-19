//
// TreeTableViewController.m
//
// Katharina Winkler
//
// erstellt die TableView der Bäume

#import "TreeTableViewController.h"
#import "TreeTableCell.h"
#import "Tree.h"
#import "TreeDetailViewController.h"

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
	
    // Initialize the recipes array
    Tree *recipe1 = [Tree new];
    recipe1.name = @"Egg Benedict";
    recipe1.description = @"30 min";
    recipe1.image = @"apple_pin.png";
    recipe1.info = [NSArray arrayWithObjects:@"2 fresh English muffins", @"4 eggs", @"4 rashers of back bacon", @"2 egg yolks", @"1 tbsp of lemon juice", @"125 g of butter", @"salt and pepper", nil];
    
    
    Tree *recipe2 = [Tree new];
    recipe2.name = @"Mushroom Risotto";
    recipe2.description = @"30 min";
    recipe2.image = @"apple_pin.png";
    recipe2.info = [NSArray arrayWithObjects:@"1 tbsp dried porcini mushrooms", @"2 tbsp olive oil", @"1 onion, chopped", @"2 garlic cloves", @"350g/12oz arborio rice", @"1.2 litres/2 pints hot vegetable stock", @"salt and pepper", @"25g/1oz butter", nil];
    
    Tree *recipe3 = [Tree new];
    recipe3.name = @"Full Breakfast";
    recipe3.description = @"20 min";
    recipe3.image = @"apple_pin.png";
    recipe3.info = [NSArray arrayWithObjects:@"2 sausages", @"100 grams of mushrooms", @"2 rashers of bacon", @"2 eggs", @"150 grams of baked beans", @"Vegetable oil", nil];
    
    Tree *recipe4 = [Tree new];
    recipe4.name = @"Hamburger";
    recipe4.description = @"30 min";
    recipe4.image = @"apple_pin.png";
    recipe4.info = [NSArray arrayWithObjects:@"400g of ground beef", @"1/4 onion (minced)", @"1 tbsp butter", @"hamburger bun", @"1 teaspoon dry mustard", @"Salt and pepper", nil];
    
    Tree *recipe5 = [Tree new];
    recipe5.name = @"Ham and Egg Sandwich";
    recipe5.description = @"10 min";
    recipe5.image = @"apple_pin.png";
    recipe5.info = [NSArray arrayWithObjects:@"1 unsliced loaf (1 pound) French bread", @"4 tablespoons butter", @"2 tablespoons mayonnaise", @"8 thin slices deli ham", @"1 large tomato, sliced", @"1 small onion", @"8 eggs", @"8 slices cheddar cheese", nil];
    
    
    trees = [NSArray arrayWithObjects:recipe1, recipe2, recipe3, recipe4, recipe5, nil];
    
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
    
    // Display recipe in the table cell
    Tree *tree = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tree = [searchResults objectAtIndex:indexPath.row];
    } else {
        tree = [trees objectAtIndex:indexPath.row];
    }
    
    cell.nameLabel.text = tree.name;
    cell.thumbnailImageView.image = [UIImage imageNamed:tree.image];
    cell.prepTimeLabel.text = tree.description;
    
    return cell;
}


/*
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
 NSIndexPath *indexPath = nil;
 Recipe *recipe = nil;
 
 if (self.searchDisplayController.active) {
 indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
 recipe = [searchResults objectAtIndex:indexPath.row];
 } else {
 indexPath = [self.tableView indexPathForSelectedRow];
 recipe = [recipes objectAtIndex:indexPath.row];
 }
 
 RecipeDetailViewController *destViewController = segue.destinationViewController;
 destViewController.recipe = recipe;
 }
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        NSIndexPath *indexPath = nil;
        Tree *selectedTree = nil;
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            selectedTree = [searchResults objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            selectedTree = [trees objectAtIndex:indexPath.row];
        }
        
        TreeDetailViewController *destViewController = segue.destinationViewController;
        destViewController.treeName = selectedTree;
        
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSLog(@"filterContentForSearchText");
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
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
