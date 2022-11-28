#!/usr/bin/env python3

import requests
import json
import sys

url = 'https://api.congress.gov/v3/bill/84'
API_KEY = sys.argv[1]
header = {"x-api-key": API_KEY}
params = {"format": 'json'}
data = requests.get(url, params=params, headers=header)
print(data.status_code)
print(data.json())
