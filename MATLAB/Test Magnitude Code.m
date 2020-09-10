h = 0.2;
a = 2;

e = [h: a];
sv = e.*e;

dp = sum(sv);
mag = sqrt(dp);
disp (mag);
