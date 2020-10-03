# docs
* https://docs.godotengine.org/en/stable/tutorials/math/beziers_and_curves.html
* https://spencermortensen.com/articles/bezier-circle/

# bezier circle
P0=(0,1),P1=(c,1),P2=(1,c),P3=(1,0)
P0=(1,0),P1=(1,−c),P2=(c,−1),P3=(0,−1)
P0=(0,−1),P1=(−c,−1),P2=(−1,−c),P3=(−1,0)
P0=(−1,0),P1=(−1,c),P2=(−c,1),P3=(0,1)
with c=0.551915024494

Point0   = P0
Control0 =  P1-P0
Control1 = P3-P2
Point1 = P3