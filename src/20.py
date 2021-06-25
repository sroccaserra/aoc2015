import sys
from collections import Counter


def solve_1(nb_presents):
    n = 1
    while nb_presents > presents(n):
        n += 1
        if n % 100000 == 0:
            print(n)
    return n


def presents(n):
    primes = prime_factors(n)
    c = Counter(primes)
    result = 10
    for k, v in c.items():
        result *= (k**(v+1)-1)/(k-1)
    return result


def prime_factors(n):
    i = 2
    factors = []
    while i * i <= n:
        if n % i:
            i += 1
        else:
            n //= i
            factors.append(i)
    if n > 1:
        factors.append(n)
    return factors


if __name__ == "__main__" and not sys.flags.interactive:
    for n in range(1, 11):
        print(presents(n))
    print(solve_1(29000000))
