#!/usr/bin/env python3

import requests
import json
import sys

BASE_LINK = 'https://api.congress.gov/v3/'
#main:
def main():
#if the command line arguments contain a start and ending congressional session:
    if len(sys.argv) == 4:
        start = int(sys.argv[1])
        end = int(sys.argv[2])
        API_KEY_FILE = sys.argv[3]
#if the command line arguments only contains one congressional session:
    elif len(sys.argv) == 3:
        start = int(sys.argv[1])
        end = start
        API_KEY_FILE = sys.argv[2]
#if there are an incorrect number of command line arguments:
    else:
        print("\tCorrect Input Format Options:")
        print("\t\t./WomenInCongress startCongress endCongress APIKeyFile")
        print("\t\t./WomenInCongress onlyCongress APIKeyFile")
        sys.exit("Incorrect number of arguments")
#initialize an API_KEY_LIST
    API_KEY_LIST = []
#add keys to the list from the file provided as a command line argument:
    for line in open(API_KEY_FILE, "r"):
        if '\n' in line:
            API_KEY_LIST.append(line[:-1])
        else:
            API_KEY_LIST.append(line)
#write file contains the information for bills that contain one of the terms in test_title
    writeFile = open('output' + str(start) + '.csv', 'w')
#allBills is a file that contains the names of all bills that the program checks
    allBills = open("allBills" + str(start) +'.txt', 'w')
#CURR_INDEX is the index of the API_KEY_LIST being used
    CURR_INDEX = 0
#set the initial nexURL:
    nextURL = BASE_LINK + 'bill/' + str(start)
#current variable is the congressional session being evaluated:
    current = start
#while loop runs as long as check_for_next does not return False:
    while nextURL != False:
#name checkBills outputs
        (CURR_INDEX, data) = checkBills(start, end, nextURL, writeFile, CURR_INDEX, allBills, API_KEY_LIST)
#name check_for_next outputs
        newCurrent, current, nextURL = check_for_next(data, current, end, allBills)
        if newCurrent == True:
#if the program switched to testing a new congressional session, open new write files:
            writeFile = open('output' + str(current) + '.csv', 'w')
            allBills = open("allBills" + str(current) +'.txt', 'w')

def test_title(title):
    title = title.lower()
    termsList = ['woman', 'women', 'girl', 'transgender', 'nonbinary', 'pregnancy',
                'pregnant', 'menstrual', 'reproduction', 'reproductive', 'birth', 'mother',
                'female', 'feminine', ' lady ', 'ladies', 'widows', 'maternal', 'abortion',
                'sex', 'daughters', 'wives', 'mom', 'domestic violence', 'ultrasound', 'gender',
                'born', 'trans ', 'uterine', 'uterus', 'sisters']
#loops through the words in termsList and returns true if one of them is in the title
    for term in termsList:
        if term in title:
            return True
#if none of the terms is in the list, it returns False
    return False

def createList(billDict):
#takes in the input of a billDictionary
#returns a list of information about the bill
#FinalList : [title, congress, sponsors (as a string), latest action, date]
    finalList = []
    finalList.append(billDict['title'])
    finalList.append(billDict['congress'])
    if 'originChamber' in billDict:
        finalList.append(billDict['originChamber'])
    else:
        finalList.append('NA')
    sponsors = ""
    if 'sponsors' in billDict:
        for person in billDict['sponsors']:
            sponsors = sponsors + person['firstName'] + " " + person['lastName'] + '(' + person['party'] + ") "
    if sponsors == '':
        sponsors = 'NA'
    finalList.append(sponsors)
    if 'latestAction' in billDict:
        if 'text' in billDict['latestAction']:
            finalList.append(billDict['latestAction']['text'])
        else:
            finalList.append('NA')
        if 'actionDate' in billDict['latestAction']:
            finalList.append(billDict['latestAction']['actionDate'])
        else:
            finalList.append('NA')
    else:
        finalList.append('NA')
        finalList.append('NA')
    return finalList
#primary function that calls other functions:
def checkBills(current, end, url, file, CURR_INDEX, allBills, API_KEY_LIST):
    #make a request to get data from the url:
    response_format = 'json'
    header = {"x-api-key": API_KEY_LIST[CURR_INDEX]}
    params = {"format": response_format}
    data = requests.get(url, params=params, headers=header)
    print(data.status_code)
#while the status code is 429, get a new API_KEY from the list and make the request again
    while data.status_code == 429:
        CURR_INDEX+= 1
        print("new api key at index " + str(CURR_INDEX) + ": "+ API_KEY_LIST[CURR_INDEX])
        header = {"x-api-key": API_KEY_LIST[CURR_INDEX]}
        data = requests.get(url, params=params, headers=header)
        print(url)
        print("\n\n\n")
#200 indicates that the data was successfully retreived:
    if data.status_code == 200:
        data = data.json()
#sometimes when an API_KEY reaches maximum requests, it returns a dictionary containing the key ['error']:
        while 'error' in data:
            if CURR_INDEX < len(API_KEY_LIST):
                CURR_INDEX+= 1
                print("new api key at index " + str(CURR_INDEX) + ": "+ API_KEY_LIST[CURR_INDEX])
                header = {"x-api-key": API_KEY_LIST[CURR_INDEX]}
                data = requests.get(url, params=params, headers=header).json()
                print(url)
                print("\n\n\n")
            else:
                print("ran out of api keys, left off at url: " + url + "current congress: " + str(current))
                print("\n\n\n")
                break
#test each bill in ['bills'] using test_title:
        for bill in data['bills']:
            if test_title(bill['title']) == True:
                finalList = []
                print("*****" + bill['title'])
                allBills.write("Y" + "|" + str(bill['congress']) + "|" +  bill['title'] + "\n")
                tempURL = bill['url'].split("?")[0]
                newdata = requests.get(tempURL, params=params, headers=header)
                if newdata.status_code == 429:
                    CURR_INDEX+= 1
                    print("new api key at index " + str(CURR_INDEX) + ": "+ API_KEY_LIST[CURR_INDEX])
                    header = {"x-api-key": API_KEY_LIST[CURR_INDEX]}
                    newdata = requests.get(tempURL, params=params, headers=header)
                    print(tempURL)
                    print("\n\n\n")
                if newdata.status_code == 200:
                    newdata = newdata.json()
                    while 'error' in data:
                        if CURR_INDEX < len(API_KEY_LIST):
                            CURR_INDEX+= 1
                            print("new api key at index " + str(CURR_INDEX) + ": "+ API_KEY_LIST[CURR_INDEX])
                            header = {"x-api-key": API_KEY_LIST[CURR_INDEX]}
                            newdata = requests.get(tempURL, params=params, headers=header).json()
                            print(url)
                            print("\n\n\n")
                        else:
                            print("ran out of api keys, left off at url: " + url + "current congress: " + str(current))
                            print("\n\n\n")
                            break

                    if 'bill' in newdata:
                        billInfo = newdata['bill']
                        finalList = createList(billInfo)
                pdfdata = requests.get(tempURL + '/text', params=params, headers=header)
                if pdfdata.status_code == 429:
                    CURR_INDEX+= 1
                    print("new api key at index " + str(CURR_INDEX) + ": "+ API_KEY_LIST[CURR_INDEX])
                    header = {"x-api-key": API_KEY_LIST[CURR_INDEX]}
                    pdfdata = requests.get(tempURL, params=params, headers=header)
                    print(tempURL)
                    print("\n\n\n")
                if pdfdata.status_code == 200:
                    pdfdata = pdfdata.json()
                    while 'error' in pdfdata:
                        if CURR_INDEX < len(API_KEY_LIST):
                            CURR_INDEX+= 1
                            print("new api key at index " + str(CURR_INDEX) + ": "+ API_KEY_LIST[CURR_INDEX])
                            header = {"x-api-key": API_KEY_LIST[CURR_INDEX]}
                            pdfdata = requests.get(tempURL + '/text', params=params, headers=header).json()
                            print(url)
                            print("\n\n\n")
                        else:
                            print("ran out of api keys, left off at url: " + url + "current congress: " + str(current))
                            print("\n\n\n")
                            break
                    addedPDF = False
                    if 'textVersions' in pdfdata:
                        for formats in pdfdata['textVersions'][0]['formats']:
                            #if a pdf version of the bill exists, add it to the list
                            if formats['type'] == 'PDF':
                                finalList.append(formats['url'])
                                addedPDF = True
                    if not addedPDF:
                        finalList.append('NA')
                    file.write('|'.join(str(e) for e in finalList))
                    file.write("\n")
            else:
                allBills.write("N" + "|" + str(bill['congress']) + "|" + bill['title'] + "\n")
        return (CURR_INDEX, data)
    elif data.status_code == 403:
        print("Exiting program...")
        sys.exit("403: Invalid API key provided")
    else:
#if there is an issue accessing this URL, advance to the next URL
        print(url)
        offset = url.split("=")[1:]
        print("offset: ")
        offset = (''.join(str(e) for e in offset))
        print(offset)
        beginning = url.split("=")[0] + '='
        print("beginning")
        print(beginning)
        ending = offset.split("&")[1:]
        ending = '&' + (''.join(str(e) for e in ending))
        print("ending")
        print(ending)
        offset = offset.split("&")[0]
        print("offset: ")
        print(offset)
#adding 20 to the offset generates the next URL consistent with what is contained in data['pagination']['next']
        newoffset = int(offset) + 20
        print(offset)
        newURL = beginning + str(newoffset) + ending
        print(newURL)
        header = {"x-api-key": API_KEY_LIST[CURR_INDEX]}
        params = {"format": response_format}
        data = requests.get(newURL, params=params, headers=header).json()
        return (CURR_INDEX, data)


def check_for_next(data, current, end, allBills):
#if there is a next url in the pagination value then return that url
#the current congressional session value does not change
    if 'next' in data['pagination']:
        print(data['pagination']['next'])
        return (False, current, data['pagination']['next'])
#if there is not a next value in pagination
#if the current congressional session plus 1 is less than the ending congressional session:
#add one to current
#and return the initial URL for that congressional session
    elif current + 1 <= end:
            print("congress: " + str(current + 1))
            #allBills.write("SWITCHING TO NEW CONGRESS: " + str(current + 1))
            return (True, current+1, BASE_LINK + 'bill/' + str(current + 1))
#if both things are false, return False for all return values
#this will cause the while loop to be broken out of in main
    else:
        return False, False, False


#Execute Main:
if __name__ == '__main__':
    main()
