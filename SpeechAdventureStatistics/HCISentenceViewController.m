//
//  HCISentenceViewController.m
//  SpeechAdventureStatistics
//
//  Created by Jennifer on 3/9/14.
//  Copyright (c) 2014 Jennifer. All rights reserved.
//

#import "HCISentenceViewController.h"
#import "HCISentence.h"

@interface HCISentenceViewController ()

@end

@implementation HCISentenceViewController

- (void)loadInitialData
{
    HCISentence *sentence = [[HCISentence alloc] init];
    sentence.name = @"Sentence 1";
    sentence.numAttempts = @"3";
    sentence.numUtterances = 3;
    [_sentences addObject:sentence];
    
    sentence = [[HCISentence alloc] init];
    sentence.name = @"Sentence 2";
    sentence.numAttempts = @"2";
    sentence.numUtterances = 2;
    [_sentences addObject:sentence];
    
    sentence = [[HCISentence alloc] init];
    sentence.name = @"Sentence 3";
    sentence.numAttempts = @"4";
    sentence.numUtterances = 4;
    [_sentences addObject:sentence];
    
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sentences = [NSMutableArray arrayWithCapacity:20];
    
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.sentences count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SentenceCell"];
    
    HCISentence *sentence = (self.sentences)[indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    nameLabel.text = sentence.name;
    
    UILabel *attemptLabel = (UILabel *)[cell viewWithTag:101];
    NSString *attemptz= @"Number of Attempts: ";
    attemptLabel.text = [NSString stringWithFormat:@"%@%@", attemptz, sentence.numAttempts];
    

    
    UIButton *utteranceButton1 = (UIButton *)[cell viewWithTag:102];
    UIButton *utteranceButton2 = (UIButton *)[cell viewWithTag:103];
    UIButton *utteranceButton3 = (UIButton *)[cell viewWithTag:104];
    UIButton *utteranceButton4 = (UIButton *)[cell viewWithTag:105];
    
    switch (sentence.numUtterances) {
        case 1:
            utteranceButton2.hidden = YES;
            utteranceButton3.hidden = YES;
            utteranceButton4.hidden = YES;
            break;
        case 2:
            utteranceButton3.hidden = YES;
            utteranceButton4.hidden = YES;
            break;
        case 3:
            utteranceButton4.hidden = YES;
            break;
            
    }
    
    return cell;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
