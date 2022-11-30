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
