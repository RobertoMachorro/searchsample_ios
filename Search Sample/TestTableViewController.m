//
//  TestTableViewController.m
//  Search Sample
//
//  Created by Roberto Machorro on 12/25/17.
//  Copyright © 2017 Unplugged Ideas, LLC. All rights reserved.
//

#import "TestTableViewController.h"

@interface TestTableViewController ()

@property (strong, nonatomic) NSMutableArray<NSNumber *> *data;

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
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];

	// [indexPath section], [indexPath row], [indexPath item]

	NSNumber *item = [self.data objectAtIndex:indexPath.row];
	NSLog(@"Rendering: %d", [item intValue]);

	UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:1];
	descriptionLabel.text = [NSString stringWithFormat:@"Item %ld", (long)indexPath.row];

	UILabel *amountLabel = (UILabel *)[cell viewWithTag:2];
	amountLabel.text = [item stringValue];

	return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
}

@end
