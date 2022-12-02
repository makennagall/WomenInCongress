<b>Code Files: </b>
<br><em>WomenInCongress.py</em> executes a program that distinguishes bills that have key terms contained in their titles.
<br>Inputs: The starting congressional session, the ending congressional session, the file containing API keys (one listed on each line), and the file containing the list of terms to be tested for (one listed on each line). If only one congressional session is being tested, then the program takes only three inputs: the congressional session, the file containing API keys, and the terms file.
<br>Outputs:The program creates two output files for each congressional session it tests. One output file contains information about bills that contain the key terms. The other output file contains the names of all bills that the program tested, the congressional session the bill was introduced in, and whether or not that bill is contained in the other output file.

<em>WomenInCongress.R</em> contains code that creates graphs using the plotly package.

<em>CompileData.py</em> is a program that compiles the data from different files into one file. It is used to create one file containing data from all the congressional sessions from the separate files generated by WomenInCongress.py.

<em>CountingTerms.py</em> is a program that creates files concerning how many bills contain specific terms in the termList document.

<em>requestTest.py</em> takes in one command line input: a valid API key. It prints the html status code that it receives after making a get request. It also prints the data in json format. If the status code is 200, then it will print the data in json format.

<b>Data Files: </b>
<br><em>termList.txt</em> is a text file containing the terms that were selected in the most recent program execution. All data files that are not in OldData were created using these terms.

<em>compiledNewAllBills.csv</em> and compiledNewAllBills.txt contains the content of all newAllBills files (compiled using CompileData.py)

<em>compiledNewOutputs.csv</em> and compiledNewOutputs.txt contains the content of all newOutputs files (compiled using CompileData.py)

<em>frequency.csv</em> contains data on the frequency that each term appears in the bills

<em>termsCountNew.csv</em> contains allOutputs bills with the term that appears in the bill appended to the end of the csv row. If more than one term appears in the bill, then the bill is listed more than once.

<em>WomenPerSession.csv</em> contains tidied data from https://cawp.rutgers.edu/facts/levels-office/congress/history-women-us-congress

<em>dictionary_comments</em> contains notes on what dictionary keys different request responses contained

<b>Folders: </b>
<br><em>OldData</em> folder contains data processed with the key terms listed in OldTermList.txt. The Outputs and allBills folders contains the files outputed by WomenInCongress.py for each congressional session. Outputs contains bills that have one of the key terms in their title. AllBills contains the title of all bills for that congressional session. All files are delimited with the | character. <br>AllBillsNumbers.csv and AllBillsNumbers.xlsx contains how many bills with the key terms and how many total bills were accessed for each congressional session.
<br><em>AllOutputs.csv</em> and AllOutput.xlsx contains the output for the bills that contained the key terms for all available congressional session in the form:
    title|congress|sponsors|sponsor's party|latest action| date (maybe separated into m, d, y)| pdfURL

<em>newAllBills</em> and <em>newOutputs</em> contains data from the most recent execution separated by congressional session.

<em>ShinyAppWiC</em> is a folder that contains a very very rough draft of a shiny app
