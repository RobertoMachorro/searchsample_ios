# searchsample_ios

Sample for Proper use of UISearchController+Toolbar with UITableViewController within a Single View App on iOS.

It's a mouthful, but for most of my iOS projects, this has become a basic template, however, I wanted to build a clear startup code that had all platform kinks resolved and blessed by the Apple Support staff.
The code is self explanatory, however, it is recommended you review the commit history or the steps below in order to reproduce the desired results.

## Steps

1. This sample code starts from an Xcode iOS new project template for a *Single View App*.
2. The code is cleaned up and standardized.
3. The basic view is swapped for a Table View Controller.
4. A custom Cell is setup with labels for output.
5. A custom Table View Controller class is created for the prior view, with randomized data.
6. Data is formatted and presented on the table view.
7. Search controller functionality is implemented via delegation and UISearchController.
