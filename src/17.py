import fileinput
import sys


def parse(lines):
    return [int(line) for line in lines]


def solve(containers):
    n = 0
    for subset in powerset(containers):
        if sum(subset) == 150:
            n += 1
    return n


def powerset(ns):
    x = len(ns)
    masks = [1 << i for i in range(x)]
    for i in range(1 << x):
        yield [ss for mask, ss in zip(masks, ns) if i & mask]


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    containers = parse(lines)
    print(solve(containers))
