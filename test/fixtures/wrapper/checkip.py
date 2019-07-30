#!/usr/bin/env python

import json
import requests

r = requests.get('https://checkip.amazonaws.com')
j = json.dumps({'ip': f'{r.text.strip()}/32'})
print(j)
