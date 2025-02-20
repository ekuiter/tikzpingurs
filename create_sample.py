import sys
import re
from bdd4va.bdd4va import BDD

def lreplace(string, pattern, sub):
    return string[len(pattern):] + sub if string.startswith(pattern) else string

def normalize_feature(feature):
    new_feature = feature.replace('_', ' ')
    if new_feature in features:
        return new_feature
    new_feature = feature.replace('_', '=')
    if new_feature in features:
        return new_feature
    return None

n = int(sys.argv[1])
file = 'penguin.xml'
my_bdd = BDD(file)

f = open(file, 'r')
features = f.readlines()
features = [lreplace(lreplace(feature.strip(), ':o', ''), ':', '').strip() for feature in features if ': ' in feature or ':o ' in feature and feature == feature.lower()]

configurations = my_bdd.sample(n)
for configuration in configurations:
    print(', '.join([normalize_feature(feature) for feature in configuration if not feature.startswith('not ') and normalize_feature(feature) is not None]))