//
//  Puzzle.h
//  Sudoku
//
//  Created by Sean Fitzgerald on 2/26/13.
//  Copyright (c) 2013 ND. All rights reserved.
//

#ifndef __Sudoku__Puzzle__
#define __Sudoku__Puzzle__

#include <iostream>
#include <vector>

using namespace std;

class Puzzle
{
private:
	vector<vector<int>> _puzzleVector; //stores the puzzle
	vector<vector<vector<int>>> _possibilitiesVector;//stores the possibilities for each cell
	vector<int> checkRow(int, int); //checks the row of the cell and modifies its possibilities
	vector<int> checkColumn(int, int); //checks the column of the cell and modifies its possibilities
	vector<int> checkMiniGrid(int, int); //checks the minigrid of the cell and modifies its possibilities
	int checkForSingleton(int,int); //checks the row, column, and minigrid for the current cell's singletons, returns what it finds. else zero
	void getPossibilities(); //fills in all cells' possibilities
	bool checkPuzzle(vector<vector<int>>); //checks to see if the puzzle is correct
	void removeIntFromVector(int, vector<int> *); //removes the specified int from the specified vector
	bool vectorContainsInt(int, vector<int>); //returns true or false based on whther or not a vector contains the in parameter
	void printVector(vector<int>);

	
public:
	Puzzle();//constructor
	void setPuzzleVector(vector<vector<int>>);
	vector<vector<int>> getPuzzleVector();
	vector<vector<int>> solve();
	
};



#endif /* defined(__Sudoku__Puzzle__) */
