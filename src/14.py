import fileinput
import sys
from collections import namedtuple


Reindeer = namedtuple('Reindeer', ['name', 'speed', 'fly', 'rest'])


def parse(lines):
    return [parseLine(line) for line in lines]


def parseLine(line):
    words = line.split()
    result = Reindeer(
            name=words[0],
            speed=int(words[3]),
            fly=int(words[6]),
            rest=int(words[13]))
    return result


def distance(reindeer, time):
    period = reindeer.fly + reindeer.rest
    remaining = min(time % period, reindeer.fly)
    return (time // period)*(reindeer.speed*reindeer.fly) + \
        remaining*reindeer.speed


def race(reindeers, time):
    distances = sorted([distance(r, time) for r in reindeers])
    return distances[-1]


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    reindeers = parse(lines)
    print(race(reindeers, 2503))
