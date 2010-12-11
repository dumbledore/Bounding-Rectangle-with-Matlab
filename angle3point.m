function angle = angle3point(prevX, prevY, X, Y, nextX, nextY)
% ugul mejdu 3tochki s nachalo 2rata

a = sqrt( (X - prevX)^2 + (Y - prevY)^2 );
b = sqrt( (X - nextX)^2 + (Y - nextY)^2 );
c = sqrt( (nextX - prevX)^2 + (nextY - prevY)^2 );

angle = acosd( ( (a^2) + (b^2) - (c^2) ) / (2 * a * b) );                                                                                                                                                                                                                 