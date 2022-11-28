#!/usr/bin/env python3

#Name: api-demo.py
#Creator: Makenna Gall
import requests
import json
#You need to import the requests and json packages in order to utilize their commands
#Use requests to retreive data from the site. Use json to help the computer interpret data from the site.
API_KEY = #your api-key here
#this will create a global variable containing your api key
#if you don't have a congress.gov api key, visit https://api.congress.gov/sign-up/ to get one.
BASE_LINK = 'https://api.congress.gov/v3/'
#this will create a global variable containing the base link
#you can append to this link to retreive data about specific sessions of congress and bills.
