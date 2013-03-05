//
//  Puzzle.cpp
//  Sudoku
//
//  Created by Sean Fitzgerald on 2/26/13.
//  Copyright (c) 2013 ND. All rights reserved.
//

#include "Puzzle.h"

Puzzle::Puzzle()
{
	for (int column = 0; column < 9; column++)
	{
		vector<vector<int>> columnOfPossibilities;
		_possibilitiesVector.push_back(columnOfPossibilities);
		for (int row = 0; row < 9; row++)
		{
			vector<int> cellOfPossibilities;
			_possibilitiesVector[column].push_back(cellOfPossibilities);
		}
	}
	
	//set up the vector fo possibilities with the required number of coluns and rows for a sudoku puzzle
}

void Puzzle::setPuzzleVector(vector<vector<int>> puzzleVector)
{
	_puzzleVector = puzzleVector;
}

vector<vector<int>> Puzzle::getPuzzleVector(void)
{
	return _puzzleVector;
}

vector<vector<int>> Puzzle::solve()
{
	bool finishedSolving = true;
	bool noSolution = true;
	getPossibilities();
	for (int row = 0; row < 9; row++)
	{
		for (int column = 0; column < 9; column++)
		{
			if (_puzzleVector[column][row] == 0 && _possibilitiesVector[column][row].size() == 1)
			{
				noSolution = false;
				_puzzleVector[column][row] = _possibilitiesVector[column][row][0];
			}
		}
	}
	
	for (int row = 0; row < 9; row++)
	{
		for (int column = 0; column < 9; column++)
		{
			if (_puzzleVector[column][row] == 0)
			{
				finishedSolving = false;
			}
		}
	}
	
	if (finishedSolving == false && noSolution == false)
	{
		solve();
	}
	return _puzzleVector;
}

vector<int> Puzzle::checkRow(int x, int y)
{
	vector<int> oneToNineVector;
	for (int i = 1; i < 10; i++)
		oneToNineVector.push_back(i);
	
	for (int row = 0; row < 9; row++)
		if (_puzzleVector[x][row] != 0 && row != y)
			removeIntFromVector(_puzzleVector[x][row], &oneToNineVector);
	

	return oneToNineVector;
}

vector<int> Puzzle::checkColumn(int x, int y)
{
	vector<int> oneToNineVector;
	for (int i = 1; i < 10; i++)
		oneToNineVector.push_back(i);
	
	for (int column = 0; column < 9; column++)
		if (_puzzleVector[column][y] != 0 && column != x)
			removeIntFromVector(_puzzleVector[column][y], &oneToNineVector);
	

	return oneToNineVector;
}

vector<int> Puzzle::checkMiniGrid(int x, int y)
{
	vector<int> oneToNineVector;
	for (int i = 1; i < 10; i++)
		oneToNineVector.push_back(i);
	
	int	columnMiniGrid = x / 3;
	int rowMiniGrid = y / 3;
	
	for (int column = (columnMiniGrid * 3); column < (columnMiniGrid * 3 + 3); column++)
		for (int row = (rowMiniGrid * 3); row < (rowMiniGrid * 3 + 3); row++) {
			if (_puzzleVector[column][row] != 0 && (column != x || row != y))
				removeIntFromVector(_puzzleVector[column][row], &oneToNineVector);
		}

	return oneToNineVector;
	
}


int Puzzle::checkForSingleton(int x, int y)
{
	
}

void Puzzle::getPossibilities()
{
	vector<int> possibilities;
	vector<int> finalPossibilities;
	for (int row = 0; row < 9; row++)
	{
		for (int column = 0; column < 9; column++)
		{
			if (!_puzzleVector[column][row])
			{
				finalPossibilities = checkRow(column, row);
				
				
				possibilities = checkColumn(column, row);
				
				
				vector<int> tempFinalPossibilities = finalPossibilities;
				for (int i = 0; i < finalPossibilities.size(); i++)
				{
					if (!vectorContainsInt(finalPossibilities[i], possibilities))
					{
						removeIntFromVector(finalPossibilities[i], &tempFinalPossibilities);
						//tempFinalPossibilities.erase(tempFinalPossibilities.begin() + i);
					}
				}
				finalPossibilities = tempFinalPossibilities;
				
				
				possibilities = checkMiniGrid(column, row);
				
				
				tempFinalPossibilities = finalPossibilities;
				for (int i = 0; i < finalPossibilities.size(); i++)
				{
					if (!vectorContainsInt(finalPossibilities[i], possibilities))
					{
						removeIntFromVector(finalPossibilities[i], &tempFinalPossibilities);
						//tempFinalPossibilities.erase(tempFinalPossibilities.begin() + i);
					}
				}
				finalPossibilities = tempFinalPossibilities;
				
				_possibilitiesVector[column][row] = finalPossibilities;

			}			
		}
	}
	
}

bool Puzzle::checkPuzzle(vector<vector<int>>)
{
	
}

void Puzzle::removeIntFromVector(int searchForInt, vector<int>* vectorPointer)
{
	for (int i = 0; i < (*vectorPointer).size(); i++)
	{
		if (searchForInt == (*vectorPointer)[i])
		{
			(*vectorPointer).erase((*vectorPointer).begin() + i);
		}
	}
}
//removes the specified int from the specified vector

//add the vector parameter to the vector of puzzle possibilities

bool Puzzle::vectorContainsInt(int searchForInt, vector<int> vectorParameter)
{
	int i;
	
	for (i = 0; i < vectorParameter.size(); i++)
	{
		if (vectorParameter[i] == searchForInt)
		{
			return true;
		}
	}
	
	return false;
}
//returns true or false based on whether or not a vector contains the in parameter


void Puzzle::printVector(vector<int> vectorToPrint)
{
	cout << endl;
	for (int i = 0; i < vectorToPrint.size(); i++)
	{
		cout << vectorToPrint[i] << endl;
	}
	cout << endl;
}




