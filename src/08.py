import fileinput
import sys


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    transformed = [eval(line) for line in lines]
    print(sum([len(x) for x in lines]) - sum([len(x) for x in transformed]))
