from google.appengine.ext import vendor
import os
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'libs'))
try:
    vendor.add('src/libs')
except:
    pass

try:
    vendor.add('libs')
except:
    pass


if os.name == 'nt':
    os.name = None
    sys.platform = ''