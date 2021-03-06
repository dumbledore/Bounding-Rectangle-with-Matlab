function [X, Y] = rotate_polygon(X, Y, cx, cy, a)
%zavurtane na polygon s tochki X, Y (vektori) na ugul a okolo tochka (cx,cy)

    %translirame
    Xt = X - cx;
    Yt = Y - cy;
    
    %vurtim
    Xr = Xt * cos(a) - Yt * sin(a);
    Yr = Xt * sin(a) + Yt * cos(a);
    
    %translirame obratno
    X = Xr + cx;
    Y = Yr + cy;                                                                                                                                                                        