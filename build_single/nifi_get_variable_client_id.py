import sys,json;

print(json.load(sys.stdin)['processGroupRevision']['clientId'])
