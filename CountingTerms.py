#!/usr/bin/env python3

import csv
import sys
from urllib.request import urlopen
import codecs
TERMSLIST = ['woman', 'women', 'girl', 'transgender', 'nonbinary', 'pregnancy',
            'pregnant', 'menstrual', 'reproduction', 'reproductive', 'birth', 'mother',
            'female', 'feminine', ' lady ', 'ladies', 'widows', 'maternal', 'abortion',
            'sex', 'daughters', 'wives', 'mom', 'domestic violence', 'ultrasound', 'gender',
            'born', 'trans ', 'uterine', 'uterus', 'sisters']
def main():
    url = 'https://raw.githubusercontent.com/makennagall/WomenInCongress/main/AllOutputs.csv'
    data = urlopen(url)
    cr = csv.reader(codecs.iterdecode(data, "utf-8"))
    colnames = ['title','Congress', 'House', 'Sponsor', 'Sponsor.Party', 'LatestAction', 'LatestActionMonth', 'LatestActionDay', 'LatestActionYear', 'URL', 'term']
    outputFile = open("termsCount.csv", "w")
    outputFile.write(','.join(str(e) for e in colnames))
    outputFile.write('\n')
    termDict = createDictionary()
    for line in cr:
        for term in TERMSLIST:
            if term in line[0]:
                line.append(term)
                termDict[term].append(line)
                outputFile.write("\"" + line[0] + "\"")
                outputFile.write(','.join(str(e) for e in line[1:]))
                outputFile.write('\n')
                line = line[:-1]

    #print(termDict)
    printOutput(termDict)

def printOutput(termDict):
    for term in TERMSLIST:
        print(term)
        for item in termDict[term]:
            print(item)
        print("\n\n")
def createDictionary():
    termDict = {}
    for term in TERMSLIST:
        termDict[term] = []
    return termDict

#Execute Main:
if __name__ == '__main__':
    main()
