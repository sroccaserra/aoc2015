import fileinput


[commands] = [line.strip() for line in fileinput.input()]


D = {'^': (0,1), '>': (1,0), 'v': (0,-1), '<': (-1,0)}

(x, y) = (0,0)
visits = {(x, y): 1}
for c in commands:
    (dx, dy) = D[c]
    (x, y) = (x+dx, y+dy)
    if (x, y) in visits:
        visits[(x, y)] += 1
    else:
        visits[(x, y)] = 1


print(len(visits))
