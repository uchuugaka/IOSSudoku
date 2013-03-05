//
//  SudokuViewController.m
//  Sudoku
//
//  Created by Sean Fitzgerald on 2/26/13.
//  Copyright (c) 2013 ND. All rights reserved.
//

#import "SudokuViewController.h"
#import "Puzzle.h"
#import "sudokuPuzzleView.h"


#import <vector>

using namespace std;

@interface SudokuViewController ()

@property (nonatomic, strong) NSArray * sudokuCellTextFieldsAndLabels;
@property (nonatomic, strong) NSArray * puzzleArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *activeField;

//@property (nonatomic) Puzzle  cPlusPlusSudokuPuzzle;
@property (nonatomic) vector<vector<int>> puzzleVector;

@end

@implementation SudokuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
		
	[self updateSudokuPuzzleArrayandVectorFromFile];
		
	self.sudokuCellTextFieldsAndLabels = [self setupAndReturnSudokuCellTextFieldsAndLabels];
	//create and save the textFields
	
	for(NSArray * sudokuCellColumn in self.sudokuCellTextFieldsAndLabels)
		for(id sudokuCell in sudokuCellColumn)
			[self.scrollView addSubview:sudokuCell];
	//add the sudoku cells as subviews
	
	[self registerForKeyboardNotifications];
				
}

- (void)registerForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(keyboardWasShown:)
																							 name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(keyboardWillBeHidden:)
																							 name:UIKeyboardWillHideNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyPressed:) name: UITextFieldTextDidChangeNotification object: nil];
	//add a notification if the text is changed. Should resign first responder status if the correct text is present

}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
	NSDictionary* info = [aNotification userInfo];
	CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	/*UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
	self.scrollView.contentInset = contentInsets;
	self.scrollView.scrollIndicatorInsets = contentInsets;
	*/
	// If active text field is hidden by keyboard, scroll it so it's visible
	// Your application might not need or want this behavior.
	CGRect aRect = self.view.frame;
	aRect.size.height -= keyboardSize.height;
	
	CGPoint lowerOrigin = CGPointMake(self.activeField.frame.origin.x, self.activeField.frame.origin.y + self.activeField.frame.size.height);
	
	if (!CGRectContainsPoint(aRect, lowerOrigin) ) {
		CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-keyboardSize.height + 8);
		[self.scrollView setContentOffset:scrollPoint animated:YES];
	}
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
	CGPoint scrollPoint = CGPointZero;
	[self.scrollView setContentOffset:scrollPoint animated:YES];
	UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	self.scrollView.contentInset = contentInsets;
	self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	self.activeField = nil;
}


-(NSArray *) setupAndReturnSudokuCellTextFieldsAndLabels // 9 x 9 NSArray of UITextfields
{

	NSMutableArray * tempSudokuCellTextFields = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < 9; i++) //for each column
	{
		[tempSudokuCellTextFields addObject: [[NSMutableArray alloc] init]];
		for (int j = 0; j < 9; j++) //for each row
		{
			
			if ([self.puzzleArray[i][j] intValue] == 0)
			{
				[tempSudokuCellTextFields[i] addObject:[[UITextField alloc] initWithFrame:CGRectMake(20.0 + 32.0 * i, 20.0 + 38.0 * j, 24.0, 30.0)]];
				//create a text field for each of the empty sudoku cells
			
				((UITextField *)tempSudokuCellTextFields[i][j]).borderStyle = UITextBorderStyleRoundedRect;
				//set the correct border style so that the text fields are visible
			
				((UITextField *)tempSudokuCellTextFields[i][j]).keyboardType = UIKeyboardTypeNumberPad;
				//set the keyboard to be only numbers
			
				((UITextField *)tempSudokuCellTextFields[i][j]).delegate = self;
				//set the delegate to this class so we can manage the keyboard
				
				((UITextField *)tempSudokuCellTextFields[i][j]).textAlignment = NSTextAlignmentCenter;
								
			}
			else
			{
				[tempSudokuCellTextFields[i] addObject:[[UILabel alloc] initWithFrame:CGRectMake(20.0 + 32.0 * i, 20.0 + 38.0 * j, 24.0, 30.0)]];
				//create a label for each sudoku cell already described
								
				((UILabel *)tempSudokuCellTextFields[i][j]).text= [NSString stringWithFormat:@"%@", self.puzzleArray[i][j]];
				//put the correct sudoku number in the cell
				
				((UILabel *)tempSudokuCellTextFields[i][j]).textAlignment = NSTextAlignmentCenter;

			}
		}
		
		tempSudokuCellTextFields[i] = [tempSudokuCellTextFields[i] copy];
		//make the mutable array into an immutable array
		
	}
	
	return [tempSudokuCellTextFields copy];

}


-(void) keyPressed: (NSNotification*) notification //resigns first responder status, updates the puzzle vector in the program
{
	
	if (((UITextField*)[notification object]).text.length > 0)
	{
		((UITextField*)[notification object]).text = [((UITextField*)[notification object]).text substringFromIndex:((UITextField*)[notification object]).text.length - 1];

	}
	
	[[notification object] resignFirstResponder];

	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)solveButtonPressed
{
	Puzzle cPlusPlusSudokuPuzzle;
	cPlusPlusSudokuPuzzle.setPuzzleVector(self.puzzleVector);
	self.puzzleVector = cPlusPlusSudokuPuzzle.solve();
	[self updateBoardWithPuzzleFromCPlusPlus];
}

- (IBAction)clearButtonPressed
{
	for (NSArray * sudokuColumn in self.sudokuCellTextFieldsAndLabels) {
    for (id sudokuCell in sudokuColumn) {
			if ([sudokuCell isKindOfClass:[UITextField class]])
			{
				((UITextField *)sudokuCell).text = @"";
			}
		}
	}
}

-(void)updateSudokuPuzzleArrayandVectorFromFile
{
	__block NSMutableArray * columnArray = [[NSMutableArray alloc] init];
	
	__block vector<vector<int>> tempSudokuNumbers;
	
	for (int i = 0; i < 9; i++)
	{
		__block NSMutableArray * nextRowArray = [[NSMutableArray alloc] init];
		[columnArray addObject:nextRowArray];
		
		__block vector<int> nextRowVector;
		tempSudokuNumbers.push_back(nextRowVector);
	}
	
	__block int counterColumns = 0;
	
	NSString* path = [[NSBundle mainBundle] pathForResource:@"sudokuPuzzles"
																									 ofType:@"txt"];
	
	NSString* content = [NSString stringWithContentsOfFile:path
																								encoding:NSUTF8StringEncoding
																									 error:NULL];
	
	[content enumerateSubstringsInRange:NSMakeRange(0, [content length])
															options:NSStringEnumerationByWords
													 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
														 
														 int cellNumber = [substring intValue];
														 [columnArray[counterColumns] addObject:[NSNumber numberWithInt:cellNumber]];
															
														 tempSudokuNumbers[counterColumns].push_back(cellNumber);
															
														 counterColumns++;
														 if (counterColumns >= 9)
															 counterColumns = 0;
														 
													 }];
	
	self.puzzleArray = [columnArray copy];
	
	self.puzzleVector = tempSudokuNumbers;
		
}

-(void) updateBoardWithPuzzleFromCPlusPlus
{
	for (int column = 0; column < 9; column++)
	{
		for (int row = 0; row < 9; row++)
		{
			if ([self.sudokuCellTextFieldsAndLabels[column][row] isKindOfClass:[UITextField class]]) {
				
				((UITextField *)self.sudokuCellTextFieldsAndLabels[column][row]).text = [NSString stringWithFormat:@"%d", self.puzzleVector.at(column).at(row)];

			}
			if ([self.sudokuCellTextFieldsAndLabels[column][row] isKindOfClass:[UILabel class]]) {
				
				((UILabel *)self.sudokuCellTextFieldsAndLabels[column][row]).text = [NSString stringWithFormat:@"%d", self.puzzleVector.at(column).at(row)];
				
			}
		}
	}
}

@end
