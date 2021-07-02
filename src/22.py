import sys


FAIL = 1e10


def search(hp, mana, b_hp, b_d,
           is_player_turn=True, p_t=0, s_t=0, r_t=0, m=dict(),
           hard_mode=False):
    key = (hp, mana, b_hp, is_player_turn, p_t, s_t, r_t)
    memo = m.get(key)
    if memo is not None:
        return memo

    if is_player_turn:
        if hard_mode:
            hp -= 1
        if hp <= 0:
            return FAIL

        if p_t > 0:
            b_hp -= 3

        if b_hp <= 0:
            return 0

        if r_t > 0:
            mana += 101
        next_spells = possible_spells(mana)
        if [] == next_spells:
            return FAIL

        result = min([s[COST] + search(hp + s[HEAL], mana - s[COST],
                      b_hp-s[DAMAGE], b_d,
                      False, dec(p_t)+s[P_T], dec(s_t)+s[S_T], dec(r_t)+s[R_T],
                      m, hard_mode)
                      for s in next_spells])

    # Boss turn
    if not is_player_turn:
        if p_t > 0:
            b_hp -= 3
        if b_hp <= 0:
            return 0

        if r_t > 0:
            mana += 101

        armor = 0
        if s_t > 0:
            armor = 7
        hp -= max(1, b_d-armor)
        result = search(hp, mana, b_hp, b_d, True,
                        dec(p_t), dec(s_t), dec(r_t), m, hard_mode)

    m[key] = result
    return result


def dec(x):
    return max(0, x-1)


def possible_spells(mana):
    return [s for s in SPELLS if s[COST] <= mana]


COST = 1
NB_TURNS = 2
DAMAGE = 3
HEAL = 4
P_T = 5
R_T = 6
S_T = 7

SPELLS = [
        ["MAGIC_MISSILE", 53, 1, 4, 0, 0, 0, 0],
        ["DRAIN",         73, 1, 2, 2, 0, 0, 0],
        ["SHIELD",       113, 2, 0, 0, 0, 0, 6],
        ["POISON",       173, 6, 0, 0, 6, 0, 0],
        ["RECHARGE",     229, 5, 0, 0, 0, 5, 0],
]


def solve_1():
    # return search(hp=10, mana=250, b_hp=13, b_d=8)
    # return search(hp=10, mana=250, b_hp=14, b_d=8)
    return search(hp=50, mana=500, b_hp=58, b_d=9, m=dict())


def solve_2():
    return search(hp=50, mana=500, b_hp=58, b_d=9, m=dict(), hard_mode=True)


if __name__ == "__main__" and not sys.flags.interactive:
    print(solve_1())
    print(solve_2())
