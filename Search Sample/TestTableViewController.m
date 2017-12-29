//
//  TestTableViewController.m
//  Search Sample
//
//  Created by Roberto Machorro on 12/25/17.
//  Copyright © 2017 Unplugged Ideas, LLC. All rights reserved.
//

#import "TestTableViewController.h"

@interface TestTableViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray<NSNumber *> *data;
@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;

@property (strong, nonatomic) NSArray<NSNumber *> *searchResults;
@property (strong, nonatomic) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarTotalsButton;

@end

@implementation TestTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Generate data
	NSUInteger length = 100;
	self.data = [NSMutableArray arrayWithCapacity:length];
	for (int i=0; i<length; i++) {
		float dollars = arc4random_uniform(99);
		float cents = arc4random_uniform(99)/100.0;
		[self.data addObject:[NSNumber numberWithFloat:(dollars+cents)]];
	}

	NSString *above = NSLocalizedString(@"above", nil);
	NSString *exact = NSLocalizedString(@"Exact", nil);
	NSString *below = NSLocalizedString(@"below", nil);

	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchResultsUpdater = self;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.searchController.searchBar.scopeButtonTitles = @[above, exact, below];
	self.searchController.searchBar.delegate = self;

	self.tableView.tableHeaderView = self.searchController.searchBar;
	self.toolbarTotalsButton.title = @"";
	self.definesPresentationContext = YES;
}

- (void)didReceiveMemoryWarning {
	self.searchResults = nil;
	[super didReceiveMemoryWarning];
}

#pragma mark - Properties

- (NSNumberFormatter *)currencyFormatter
{
	if (_currencyFormatter != nil) {
		return _currencyFormatter;
	}
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	_currencyFormatter = formatter;
	
	return _currencyFormatter;
}

#pragma mark - Table View Data Stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.searchController.active) // Search Mode
		return 1;
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.searchController.active) { // Search Mode
		return self.searchResults.count;
	}
	return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Ref: [indexPath section], [indexPath row], [indexPath item]
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];

	NSNumber *item = nil;
	if (self.searchController.active) { // Search Mode
		item = [self.searchResults objectAtIndex:indexPath.row];
	} else {
		item = [self.data objectAtIndex:indexPath.row];
	}

	UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:1];
	UILabel *amountLabel = (UILabel *)[cell viewWithTag:2];

	if (item != nil) {
		descriptionLabel.text = [item stringValue]; //[NSString stringWithFormat:@"Random Item %ld", (long)indexPath.row];
		amountLabel.text = [self.currencyFormatter stringFromNumber:item];
	} else {
		descriptionLabel.text = @"-";
		amountLabel.text = [self.currencyFormatter stringFromNumber:[NSNumber numberWithInt:0]];
	}

	return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
}

#pragma mark - Search Delegation

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	float amount = [searchController.searchBar.text floatValue]; // Normally normalize
	NSMutableArray *results = [NSMutableArray<NSNumber *> array];
	NSInteger buttonIndex = searchController.searchBar.selectedScopeButtonIndex;

	for (int i=0; i<self.data.count; i++) {
		if (amount == 0) {
			[results addObject:self.data[i]]; // No filter
		} else {
			switch (buttonIndex) {
				case 0:
					if ([self.data[i] floatValue] > amount)
						[results addObject:self.data[i]];
					break;
				case 1:
					if ([self.data[i] floatValue] == amount)
						[results addObject:self.data[i]];
					break;
				case 2:
					if ([self.data[i] floatValue] < amount)
						[results addObject:self.data[i]];
					break;
				default:
					break;
			}
		}
	}
	self.searchResults = results;

	if (self.searchResults.count > 0) {
		[self.navigationController setToolbarHidden:NO animated:YES];
		self.toolbarTotalsButton.title = [NSString stringWithFormat:NSLocalizedString(@"%d items", nil), self.searchResults.count];
	}
	[self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
	[self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - What I may be missing...

/*
- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
	<#code#>
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
	<#code#>
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
	<#code#>
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
	<#code#>
}
*/

@end
