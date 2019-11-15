import sys,json;

print(json.load(sys.stdin)['processGroupRevision']['version'])
