#!/usr/bin/env python3

import requests
import json
import sys

url = 'https://api.congress.gov/v3/bill/84'
header = {"x-api-key": 'YtEKa6EUtKeooysinpJcRLQUso2kPTbO9upBlxov'}
params = {"format": 'json'}
data = requests.get(url, params=params, headers=header)
print(data.status_code)
print(data)
