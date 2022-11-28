#!/usr/bin/env python3
import requests
def main():
    test_run()
    url = BASE_LINK = 'https://api.congress.gov/v3/bill/115/hr/4593'
    test_bill(url)

def test_run():
    print("hi")
def test_bill(url):
    API_KEY = '1n7NOqlRrdbSM1B2sPWj7f6VjYyVXweNk9hEftsW'
    response_format = 'json'
    header = {"x-api-key": API_KEY}
    params = {"format": response_format}
    data = requests.get(url, params=params, headers=header).json()
    #print(data)
    for key in data['bill']:
        print(key)
        print(data)
    sponsors = ''
    billDict = data['bill']
    if 'sponsors' in billDict:
        for person in billDict['sponsors']:
            sponsors = sponsors + person['firstName'] + " " + person['lastName'] + '(' + person['party'] + ") "
    if sponsors == '':
        sponsors = 'NA'
    print(sponsors)
    #print(data['bills'][0]['sponsors'])
    '''
    billDict = data['bills'][2]
    print(billDict['latestAction'])
    finalList = []
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
    print(billDict)
    sponsors = ""
    if 'sponsors' in billDict:
        for person in billDict['sponsors']:
            sponsors = sponsors + person['firstName'] + " " + person['lastName'] + '(' + person['party'] + ") "
    if sponsors == '':
        sponsors = 'NA'
    print(sponsors)
    print(finalList)
    '''
#Execute Main:
if __name__ == '__main__':
    main()
