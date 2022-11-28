#!/usr/bin/env python3

import requests
import json
import csv
import xml.etree.ElementTree as ET
import sys

#Add total counts for bills in a congress
API_KEY_LIST = [
    'x1e7PsMzG6cqcTaz1ZavxiCAlyDthVSBmadEMES6',
    'YtEKa6EUtKeooysinpJcRLQUso2kPTbO9upBlxov',
    '3TPRRsuvFiR5UVXAidCLBjCj3JzWyZyzlOemPfIL',
    'tgNC4Gjln20JyhPRUup2m3ekSnEpq3FEX27Bn7wf',
    'yFKgGVQJab7rz7iZrJaWtE8Lrut6cOlQAKuvWJic',
    'UbzzqfcsLX782CDNkUt8AEYorpjGgWgX77Hg4yAD',
    'Bx7yFlNO0tSfacOs9hUu1E4DHFkpGytGwKCvoXnM',
    'abSpEz6PaOoVnuyXU1IE6Z9D2BgkYtEce20AA3sZ',
    'vuokfptdCaDDPK0Xb7jmsVncnRjZI1Qb77HghfIT',
    'qblv4j7cOMkpfT9ZfnEy8JSBeR2dU0fW8KVLnP6T',
    'lwhASd4NCCUJC9vXRkOj3dolxKe6BS5aBAMR1HQa',
    'Ye0hINBTzFcltfCetoFWizltNUtMoFTqINRTtJf3',
    'KePvFvkTwnjdzN1zYFm9CoSCnmee72ENazV0CeHO',
    'zHBbJdUueEugv8OTinHrqVfwacH34rqPvec6m5Xf',
    '6HGzL96YQTnCPQJIwjYuyUlyZaniaTCso5L00Zfw',
    'ckwiPmGKRmiCeL9WgrpFoatFnyZJ7W0UJWHxQC8n',
    'Pkpuq4ZQH6VTm3Wrlo3rEOtev4hScOzZFcM8yFsS',
    'fLOTfTrnnJ2klZ9ZJVUzdCk0ZslUgd5LMctbPVBI',
    'PVVWY6nwei4s6aYcIqdMqdDH4lWSG2mqKQ4dbWOX',
    'Pchh2eKYyIZmv2gofjpP7KweDn8cr1fbI305IDbE',
    'Eaqd86cTvbiSU8AkEtJhM3mJ0iFTjOSlktUwkzwO',
    'ppTOwEZxevcv8oaAkvh8YRgA5NZZjs6Iv4sXrLSk',
    'rvZbmpuchl2F2MDvyKO1RJ1wnqSZzD14SrrboeIN',
    'Xap8SHIdhoRVJIXfTfY0evPKlfNcIpS35xpwYizG',
    '9puIFToGi1WPQcoALQCDWI1wBjYYPu330BbrB68x',
    'Ke4G6CbI1jTFBc5QsQF4JPXyKU8NaXYXBoJsDJdH',
    'KudwFal2jQsIh3eRDcI7YzOrES03ovdMmAAzRhSu',
    'tb1QAHiqbFYfDOFWIz0oHkCGU03F4Reb7Xzy4Kid',
    'eUjdD54oE9ahh0e1ZpYElGtYIT3F3P4puc4Truu3',
    'HgpfUS8hUmlNRwbet3Jzz7CxMNukcNWu5jbaRPmW',
    '1n7NOqlRrdbSM1B2sPWj7f6VjYyVXweNk9hEftsW']
BASE_LINK = 'https://api.congress.gov/v3/'

#main:
def main():
    #open write file as .csv file
    start = int(sys.argv[1])
    end = int(sys.argv[2])
    writeFile = open('output' + str(start) + "-" + str(end) +  '.csv', 'w')
    allBills = open("allBills" + str(start) + "-" + str(end) + '.txt', 'w')
    CURR_INDEX = 1
    nextURL = BASE_LINK + 'bill/' + str(start)
    current = start
    while nextURL != False:
        (CURR_INDEX, data) = checkBills(start, end, nextURL, writeFile, CURR_INDEX, allBills)
        current, nextURL = check_for_next(data, current, end, allBills)

def test_title(title):
    title = title.lower()
    termsList = ['woman', 'women', 'girl', 'transgender', 'nonbinary', 'pregnancy',
                'pregnant', 'menstrual', 'reproduction', 'reproductive', 'birth', 'mother',
                'female', 'feminine', 'lady', 'ladies', 'widow', 'maternal', 'abortion',
                'sex', 'daughters', 'wives', 'mom', 'domestic violence', 'ultrasound', 'gender',
                'born', 'trans ', 'uterine', 'uterus']
    for term in termsList:
        if term in title:
            return True
    else:
        return False

def createList(billDict):
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
#FinalList : [title, congress, sponsors (as a string), latest action, date]

def checkBills(current, end, url, file, CURR_INDEX, allBills):
    response_format = 'json'
    header = {"x-api-key": API_KEY_LIST[CURR_INDEX]}
    params = {"format": response_format}
    data = requests.get(url, params=params, headers=header).json()
    #print(data)
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

    for bill in data['bills']:
        if test_title(bill['title']) == True:
            print("*****" + bill['title'])
            allBills.write("*******" + bill['title'] + "\n")
            tempURL = bill['url'].split("?")[0]
            newdata = requests.get(tempURL, params=params, headers=header).json()
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
            finalList = []
            if 'bill' in newdata:
                billInfo = newdata['bill']
                finalList = createList(billInfo)
            pdfdata = requests.get(tempURL + '/text', params=params, headers=header).json()
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
            for formats in pdfdata['textVersions'][0]['formats']:
                #if a pdf version of the bill exists, add it to the list
                if formats['type'] == 'PDF':
                    finalList.append(formats['url'])
                    addedPDF = True
            if not addedPDF:
                finalList.append('NA')
            #print info to csv doc
            file.write('|'.join(str(e) for e in finalList))
            file.write("\n")
        else:
            allBills.write(bill['title'] + "\n")
    return (CURR_INDEX, data)


def check_for_next(data, current, end, allBills):
    if 'next' in data['pagination']:
        return (current, data['pagination']['next'])
    elif current + 1 < end + 1:
            print("congress: " + str(current + 1))
            allBills.write("SWITCHING TO NEW CONGRESS: " + str(current + 1))
            return (current+1, BASE_LINK + 'bill/' + str(current + 1))
    else:
        return False, False


#Execute Main:
if __name__ == '__main__':
    main()
