import fileinput


def area(xs):
    l, w, h = xs
    return min(l*w,w*h,h*l)+2*(l*w+w*h+h*l)


lines = [line.strip().split('x') for line in fileinput.input()]
ns = [[int(x) for x in l] for l in lines]
print(sum([area(x) for x in ns]))
