reeks = 1:461;
woopx = Ix' - reeks;
[a bx] = min(abs(woopx))

woopy = Iy - reeks;
[a by] = min(abs(woopy))



[xi,yi] = polyxpoly(round(Ix'),reeks,round(Iy),reeks)
