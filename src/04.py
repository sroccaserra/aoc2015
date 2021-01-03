import fileinput
import hashlib


[code] = [line.strip() for line in fileinput.input()]


def part_one(code):
    n = 0
    while not hashlib.md5((code+str(n)).encode('utf-8')).hexdigest().startswith('00000'):
        n += 1
    return n


print(part_one(code))
