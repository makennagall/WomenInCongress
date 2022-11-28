README for WomenInCongress

WomenInCongress.py executes a program that takes in two or three command line inputs: The starting congressional session, the ending congressional session and the file containing API keys (one listed on each line). If only one congressional session is being tested, then the program can take in only one input. The program creates two output files for each congressional session it tests. One output file contains information about bills that contain the key terms (terms can be found in the test_title function). The other output file contains the names of all bills that the program tested, the congressional session the bill was introduced in, and whether or not that bill is contained in the other output file.

requestTest.py takes in one command line input: a valid API key. It prints the html status code that it receives after making a get request. It also prints the data in json format. If the status code is 200, then it will print the data in json format.

The Outputs and allBills folders contains the files outputed by WomenInCongress.py for each congressional session. Outputs contains bills that have one of the key terms in their title. AllBills contains the title of all bills for that congressional session. All files are delimited with the | character.
