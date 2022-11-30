#!/usr/bin/env python3

import csv
import sys
from urllib.request import urlopen
import codecs

def main():
    if length(sys.argv) != 3:
        print("Please enter the url for the raw csv file and the file name containing the list of terms as a command line argument.")
        sys.exit("Incorrect number of command line arguments.")
    url = sys.argv[1]
    data = urlopen(url)
    cr = csv.reader(codecs.iterdecode(data, "utf-8"))
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
    termDict = createDictionary([])
    countDict = createDictionary(0)
    for line in cr:
        for term in TERMSLIST:
            if term in line[0]:
                line.append(term)
                termDict[term].append(line)
                countDict[term] = countDict[term] + 1
                outputFile.write('|'.join(str(e) for e in line))
                outputFile.write('\n')
                line = line[:-1]
    print("countDict")
    print(countDict)
    print("birth control bills:")
    #printOutput(termDict)
    for line in cr:
        if 'birth control' in line[0]:
            print(line)
def printOutput(termDict):
    for term in TERMSLIST:
        print(term)
        for item in termDict[term]:
            print(item)
        print("\n\n")
def createDictionary(initialValue):
    termDict = {}
    for term in TERMSLIST:
        termDict[term] = initialValue
    return termDict

#Execute Main:
if __name__ == '__main__':
    main()
