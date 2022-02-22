#!/usr/bin/env python


import os
import re
import yaml

output = {}

environment = os.environ

for key in environment.keys():
    if not re.match("^BASH_FUNC", key):
        output[key] = environment[key]

print(yaml.safe_dump(output))
