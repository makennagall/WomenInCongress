README for WomenInCongress

WomenInCongress.py executes a program that takes in two or three command line inputs: The starting congressional session, the ending congressional session and the file containing API keys (one listed on each line). If only one congressional session is being tested, then the program can take in only one input. The program creates two output files for each congressional session it tests. One output file contains information about bills that contain the key terms (terms can be found in the test_title function). The other output file contains the names of all bills that the program tested, the congressional session the bill was introduced in, and whether or not that bill is contained in the other output file.

requestTest.py takes in one command line input: a valid API key. It prints the html status code that it receives after making a get request. It also prints the data in json format. If the status code is 200, then it will print the data in json format.

WomenInCongress.R contains code that creates graphs using the plotly package. 

The Outputs and allBills folders contains the files outputed by WomenInCongress.py for each congressional session. Outputs contains bills that have one of the key terms in their title. AllBills contains the title of all bills for that congressional session. All files are delimited with the | character.

WomenPerSession.csv contains tidied data from https://cawp.rutgers.edu/facts/levels-office/congress/history-women-us-congress

AllBillsNumbers.csv and AllBillsNumbers.xlsx contains how many bills with the key terms and how many total bills were accessed for each congressional session.

AllOutputs.csv and AllOutput.xlsx contains the output for the bills that contained the key terms for all available congressional session in the form:
  title|congress|sponsors|sponsor's party|latest action| date (maybe separated into m, d, y)| pdfURL
  
dictionary_comments contains notes on what dictionary keys different request responses contained

