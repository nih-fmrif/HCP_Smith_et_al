#!/usr/bin/python3

# usage: python3 gen_matrixN1.py <path to .txt files with partial parcellations>
# Note, the output file will go same location as the original .txt files with the specified name

import numpy as np
from numpy import genfromtxt
import os
import sys


file_path = sys.argv[1] #path to the folder containing the .txt files w/ matrices
ICA = int(sys.argv[2]) #number of ICA components (ex. 200)
num_subs = int(sys.argv[3])

expected_cols = int((ICA * (ICA-1))/2)

print('Expected matrix shape: ({}, {})'.format(num_subs, expected_cols))

myList = []
for filename in os.listdir(file_path):
	if filename.endswith(".txt"): 
		#print(os.path.join(file_path, filename))
		arr = genfromtxt(os.path.join(file_path, filename), delimiter=',')

		if(arr.shape[0]==ICA & arr.shape[1]==ICA):
			#print("okay file", filename)
			flat_lower_tri = arr[np.tril(arr, -1) !=0]
			myList.append(flat_lower_tri)
		else:
			print("ERROR: Incorrect array dimensions in file ", filename)
			continue
	else:
		continue

matrix = np.array(myList)
if( (matrix.shape[0]==num_subs) & (matrix.shape[1]==expected_cols) ):
	print("NET Successfully generated! Resulting matrix shape:", matrix.shape)
	np.savetxt(fname="NET500.txt", X=matrix, delimiter=',')
else:
	print('Error occured, resulting matrix shape is: {}, but expected ({},{})'.format(matrix.shape, num_subs, expected_cols))
	print("NET not generated!")