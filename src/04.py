import fileinput
import hashlib


[code] = [line.strip() for line in fileinput.input()]


def part_one(code):
    n = 0
    while not hashlib.md5((code+str(n)).encode('utf-8')).hexdigest().startswith('00000'):
        n += 1
    return n


def part_two(code):
    n = 0
    while not hashlib.md5((code+str(n)).encode('utf-8')).hexdigest().startswith('000000'):
        n += 1
        if (n % 1000000 == 0):
            print(n)
    return n

print(part_one(code))
print(part_two(code))
