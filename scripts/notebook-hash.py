# adapted from https://github.com/jupyter/notebook/blob/master/notebook/auth/security.py

import getpass
import hashlib
import random
from sys import argv

# Length of the salt in nr of hex chars, which implies salt_len * 4
# bits of randomness.
salt_len = 12

def passwd(passphrase):
    h = hashlib.new('sha1')
    salt = ('%0' + str(salt_len) + 'x') % random.getrandbits(4 * salt_len)
    h.update(passphrase + salt)
    return ':'.join(("sha1", salt, h.hexdigest()))

text="""
c.NotebookApp.ip = '*'
c.NotebookApp.password = u'{password}'
c.NotebookApp.open_browser = False
c.NotebookApp.port = {port}
"""

print(text.format(password=passwd(argv[1]), port='9999'))
