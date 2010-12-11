function [min_rect, min_area] = brect(points)
% Obrimchvasht pravougulnik s nai-malko lice (bounding rectangle).

    points_ok = true;
    % proverka dali e vuveden spisuk s tochki

    if (~exist('points', 'var') || isempty(points) || ~isnumeric(points))
        %proverka:
        %1. dali funkciata e izvikana s argument
        %2. dali ne e vuveden prazen spisuk
        %3. dali spisuka ne e s nekorektna informacia
        points_ok = false;
    end

    if (points_ok) %ako vsichko zasega e nared, oshte proverki
        psize = size(points); %razmernostta na spisuka

        if (psize(1) ~= 2 && psize(2) ~= 2) %dali spisuka e ot greshna razmernost
            points_ok = false;
        else
            % razmernostta e pravilna. dali ne trqbva da transponirame?
            if (psize(2) ~= 2)
                points = points';
            end
        end
    end

    if (~points_ok) %izbirame tochki ot ekrana
        %vuvejdame broi tochki
        point_num = '';
        while(isempty(point_num) || point_num < 3) % ne e vavedeno chislo (a naprimer bukvichki)
            point_num = str2num(input('vuvedete broq na tochkite (pone 3 tochki) samo s cifri: ', 's'));
            %vtoriqt argument zadava inputa da se priema za string.
            %taka ne moje da se izpulni nepredviden kod.
        end
        point_num = ceil(point_num); %ako sa vuveli ne-cqlo chisllo

        %izbirame metod za vuvejdane
        point_method = '';
        while(~strcmpi(point_method, 't') && ~strcmpi(point_method, 'g') && ~strcmpi(point_method, 'r'))
            point_method = input('vuvedete `t` za vuvejdane s klaviaturata, `g` za s mishkata, `r` za sluchaino izbrani: ','s');
        end

        switch(point_method)
            case 't'
                %klaviatura

                %neka zadelim mqsto
                points = zeros(point_num, 2);

                %pulnim
                for i = 1:point_num
                    crr_point_x = '';
                    while (isempty(crr_point_x))
                        crr_point_x = str2num(input(['tochka ' num2str(i) ', koordinata X: '], 's'));
                    end
                    crr_point_y = '';
                    while (isempty(crr_point_y))
                        crr_point_y = str2num(input(['tochka ' num2str(i) ', koordinata Y: '], 's'));
                    end
                    points(i, 1) = crr_point_x;
                    points(i, 2) = crr_point_y;
                end
                
            case 'g'
            %mishka
                figure; %otvarqme nova grafika. Nujno e da se napravi tuk, tai kato se izpolzva ot ginput i inache moje da se vijda neshto ot predishni kartinki
                points = ginput(point_num);
                
            case 'r'
                points = rand(point_num, 2);
        end
    end %krai na: ~points_ok
    
    % tochkite sa vuvedeni, vsichko e OK.
    
    % Namerime izpuknalia poligon, obrimchvasht mnojestvoto ot tochkite
    % Za tazi cel polzvame vgradeniq v Matlab `convhull`, osnovavasht
    % se na QuickHull algorituma, realiziran v `qhull` (qhull.org)
    
    %shte izpolzvame try, zashtoto moje tochkite da ne sa dobre podbrani
    %i convhull shte se surdi
    try
        points_ind = convhull(points(:,1), points(:,2));
        %vrushta indexite samo na tochkite, koito obrazuvat polygon-a
    catch
        error('Losho izbrani tochki: vsicjkite lejat na edna prava!');
    end
    
    %da opravim indexite. tai kato convhull vrashta purvata tochka 2puti (i
    %kato posledna), neka q mahnem
    
    points_ind(length(points_ind), :) = []; %iztrivame posledniq index.
    %obichainia nachin e poslednata tochka na polygon-a da se povtarq
    %za da bude toi zatvoren. Naprimer, ako imame tochki
    %1,2,3,4,5,6,7,8 i se okaje che 2, 3, 5, 7, 8 obrazuvat polygon-a
    %convhull vrushta 2, 3, 5, 7, 8, 2.
    
    valid_points = points(points_ind, :); %polzvaiki indexite,
    %ostavqme samo tochkite, koito ni trqbvat.
    
    %prilagame algorituma na Dennis S. Arnon---------------

    n = length(valid_points); %broi tochki
    
    %centura na mnogougulnika (za da vartim okolo nego)
    cx = sum(valid_points(:,1)) / n;
    cy = sum(valid_points(:,2)) / n;

    %inicializirame
    min_area = inf;
    min_rect = zeros(4,2);
    
    for i=1:n
        next = i + 1;
        if (i == n) %tai kato polzvame purvata tochka pri smetkite na poslednata
            next = 1;
        end
        
        if (valid_points(i,1) == valid_points(next,1))
            current_angle = 0.5 * pi;
        else
            current_angle = atan((valid_points(next, 2) - valid_points(i,2)) / (valid_points(next,1) - valid_points(i,1)));
        end

        %da poluchim koordinatite na zavurtqnite tochki okolo centara na
        %mnogougulnika
        [points_rotated_x, points_rotated_y] = rotate_polygon(valid_points(:,1), valid_points(:,2), cx, cy, -current_angle);

        %vzimame krainite tochki
        left = min(points_rotated_x);
        right = max(points_rotated_x);
        bottom = min(points_rotated_y);
        top = max(points_rotated_y);
        current_area = abs(left-right) * abs(top-bottom);

        %zapisvame tochkite vav vid na pravougulnik
        rect = [left bottom; right bottom; right top; left top];
        
        %zavurtame pravougulnika obratno no okolo centara na MNOGOUGULNIKA,
        %ne okolo negovia si center.
        
        [rect_x rect_y] = rotate_polygon(rect(:,1), rect(:,2), cx, cy, +current_angle);

        if (current_area < min_area)
            min_area = current_area;
            min_rect = [rect_x rect_y];
        end

        clf; %iztrivame predishniq obraz (figura)
        draw_polygon(valid_points, 'k');
        draw_polygon([rect_x rect_y], 'r');
        title(['Pravougulnik ' num2str(i) ' s lice ' num2str(current_area)]);
        axis equal; %za da ne razpune Matlab proporciite

        pause
    end    

    %da narisuvame pravougulnika otnovo
    clf; %iztrivame predishniq obraz (figura)
    draw_polygon(valid_points, 'k');
    draw_polygon([min_rect(:,1) min_rect(:,2)], 'g');
    title(['Nai-malkiq pravougulnik pravougulnik ima lice ' num2str(min_area)]);
    axis equal; %za da ne razpune Matlab proporciite   draw_polygon([rect_x rect_y], 'r');
        title(['Pravougulnik ' num2str(i) ' s lice ' num2str(current_area)]);
        axis equal; %za da ne razpune Matlab proporciite

        pause
    end    

    %da narisuvame pravougulnika otnovo
    clf; %iztrivame predishniq obraz (figura)
    draw_polygon(valid_points, 'k');
    draw_polygon([min_rect(:,1) min_rect(:,2)], 'g');
    title(['Nai-malkiq pravou