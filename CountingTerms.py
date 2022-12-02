#!/usr/bin/env python3

import csv
import sys
from urllib.request import urlopen
import codecs

def main():
    if len(sys.argv) != 3:
        print("Please enter the url for the raw csv file and the file name containing the list of terms as a command line argument.")
        sys.exit("Incorrect number of command line arguments.")
    url = sys.argv[1]
    data = urlopen(url)
    cr = csv.reader(codecs.iterdecode(data, "utf-8"))
    billsData = urlopen('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/compiledNewAllBills.csv')
    allBills = csv.reader(codecs.iterdecode(billsData, "utf-8"))
    NumberFile = open("NewBillNumbers.csv", 'w')
    TERMSLIST_FILE = sys.argv[2]
    TERMSLIST = []
    for line in open(TERMSLIST_FILE, "r"):
        if '\n' in line:
            TERMSLIST.append(line[:-1])
        else:
            TERMSLIST.append(line)
    colnames = ['title','Congress', 'House', 'Sponsor', 'Sponsor.Party', 'LatestAction', 'LatestActionMonth', 'LatestActionDay', 'LatestActionYear', 'URL', 'term']
    outputFile = open("termsCountPipeSep.txt", "w")
    outputFile.write('|'.join(str(e) for e in colnames))
    outputFile.write('\n')
    #termDict: keeps list of all bills for each term, does not go into any output file
    termDict = createDictionary([], TERMSLIST)
    #countDict: keeps track of how many bills for each valid term
    countDict = createDictionary(0, TERMSLIST)
    #yesDict: keeps track of how many bills contain a term for each congress
    yesDict = {}
    #totalDict: keeps track of total number of bills for each congress
    totalDict = {}
    for line in cr:
        if line[1] in yesDict:
            yesDict[line[1]] = yesDict[line[1]] + 1
        else:
            yesDict[line[1]] = 1
        for term in TERMSLIST:
            if term in line[0].lower():
                line.append(term)
                termDict[term].append(line)
                countDict[term] = countDict[term] + 1
                outputFile.write('|'.join(str(e) for e in line))
                outputFile.write('\n')
                line = line[:-1]

    for line in allBills:
        if line[1] in totalDict:
            totalDict[line[1]] = totalDict[line[1]] + 1
        else:
            totalDict[line[1]] = 1
    print("countDict")
    print(yesDict)
    print("numDict")
    print(yesDict)
    frequencyFile = open('frequency.csv', 'w')
    frequencyFile.write("Term,Frequency\n")
    for key in countDict:
        frequencyFile.write(key + "," + str(countDict[key]) + "\n")
    NumberFile.write("Congress,YesBills,Total\n")
    for key in totalDict:
        if key != 'Congress':
            NumberFile.write(key + "," + str(yesDict[key]) + "," + str(totalDict[key])+ "\n")
def printOutput(termDict, TERMSLIST):
    for term in TERMSLIST:
        print(term)
        for item in termDict[term]:
            print(item)
        print("\n\n")
def createDictionary(initialValue, TERMSLIST):
    termDict = {}
    for term in TERMSLIST:
        termDict[term] = initialValue
    return termDict

#Execute Main:
if __name__ == '__main__':
    main()
