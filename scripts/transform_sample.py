import random

def lreplace(string, pattern, sub):
    return string[len(pattern):] + sub if string.startswith(pattern) else string

def look_up_feature(c, i):
    if i not in features:
        return None
    if c == '*':
        c = random.choice(['0', '1'])
    if c == '1':
        return features[i]
    if c == '0':
        return None

dimacs = 'scripts/penguin.dimacs'
spur = 'scripts/penguin.spur'

f = open(dimacs, 'r')
lines = [' '.join(feature.strip().split(' ')[2:]) for feature in f.readlines() if feature.startswith('c ')]
features = {}
for i, line in enumerate(lines):
    if line == line.lower():
        features[i + 1] = line

f = open(spur, 'r')
configurations = []
lines = f.readlines()
reading = False
for line in lines:
    if line.startswith('#END_SAMPLES'):
        reading = False
    if reading:
        amount, configuration = line.split(",")
        for i in range(int(amount)):
            configurations.append([look_up_feature(c, i + 1) for i, c in enumerate(configuration)])
    if line.startswith('#START_SAMPLES'):
        reading = True

for configuration in configurations:
    print('\\tikz{\\pingu[', end='')
    print(', '.join([feature for feature in configuration if feature is not None]), end='')
    print(']}')