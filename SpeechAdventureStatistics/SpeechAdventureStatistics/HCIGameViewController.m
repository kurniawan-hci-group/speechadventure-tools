//
//  HCIGameViewController.m
//  SpeechAdventureStatistics
//
//  Created by Jennifer on 3/8/14.
//  Copyright (c) 2014 Jennifer. All rights reserved.
//

#import "HCIGameViewController.h"
#import "HCIGame.h"


@interface HCIGameViewController ()

@end

@implementation HCIGameViewController

/*{
    NSMutableArray *_games;
}*/



- (void)loadInitialData
{
    HCIGame *game = [[HCIGame alloc] init];
    game.name = @"Game 1";
    game.score = @"95";
    game.totalTime = @"3.2";
    game.attemptsPerSentence = @"2.8";
    [_games addObject:game];
    
    game = [[HCIGame alloc] init];
    game.name = @"Game 2";
    game.score = @"70";
    game.totalTime = @"1.8";
    game.attemptsPerSentence = @"3.1";
    [_games addObject:game];
    
    game = [[HCIGame alloc] init];
    game.name = @"Game 3";
    game.score = @"55";
    game.totalTime = @".6";
    game.attemptsPerSentence = @"2.1";
    [_games addObject:game];
    
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
    
    _games = [NSMutableArray arrayWithCapacity:20];
    
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
        return [self.games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
    
    HCIGame *game = (self.games)[indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    nameLabel.text = game.name;
    
    UILabel *scoreLabel = (UILabel *)[cell viewWithTag:101];
    NSString *scorez= @"Score: ";
    scoreLabel.text = [NSString stringWithFormat:@"%@%@", scorez, game.score];
    
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:102];
    NSString *timez= @"Time: ";
    timeLabel.text = [NSString stringWithFormat:@"%@%@", timez, game.totalTime];
    
    UILabel *attemptsLabel = (UILabel *)[cell viewWithTag:103];
    NSString *attemptz= @"Average Attempts Per Sentence: ";
    attemptsLabel.text = [NSString stringWithFormat:@"%@%@", attemptz, game.attemptsPerSentence];
    
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
