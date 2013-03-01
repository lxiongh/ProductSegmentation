function [adjImgCeils] = AdjHorImgsV11( imgCeils )
horImgNum = length(imgCeils);
adjImgCeils = {};
for imnum=1:horImgNum
    im_gray = rgb2gray(imgCeils{imnum});
    % extra hor-edges
    edges = edge(im_gray,'canny');
   % ∏Ø ¥
    se = strel('rectangle', [1 20]);
    edges1 = imerode(edges, se);

    % ≈Ú’Õ
    se = strel('rectangle', [1 1]);
    edges2 = imdilate(edges1, se);
    
    row = size(edges2,1);
    col = size(edges2,2);
    
    horLines = [0 1; HorLines(edges2); 0 row];
    up_cursor = 1; down_cursor = size(horLines,1);
    for lnum=1:size(horLines,1)-2
        if horLines(up_cursor+1,2) - horLines(up_cursor,2) ...
                < horLines(down_cursor,2) - horLines(up_cursor+1,2)
            up_cursor = up_cursor + 1;
        else
            down_cursor = down_cursor - 1;
        end
    end
    im = uint8(zeros(size(imgCeils{imnum})));
    for ii=1:col
        y_s = max([1, floor(horLines(up_cursor,1)*ii + horLines(up_cursor,2))]);
        y_e = min([row, floor(horLines(down_cursor,1)*ii + horLines(down_cursor,2))]);
        im(y_s:y_e,ii,:) = imgCeils{imnum}(y_s:y_e,ii,:);
    end
    adjImgCeils{imnum} = im;
end

    function [horLines] = HorLines(edges)
        % use randon algm. which is like to GetHorLines.m
        ROW = size(edges,1);
        thetastep = 0.5;
        [R xp] = radon(edges,89:thetastep:91);
        [R_pi, IDX] = sort(R,'descend');
        theta_set = [];
        rho_set = [];
        for i=1:10
            [~, max_idx] = max(R_pi(i,:));
            theta = 89 + (max_idx-1)*thetastep;
            xp_pi = xp(IDX(i,max_idx));
            y_pi = size(edges,1)/2 - (xp_pi)*sin(theta*pi/180);
            if (y_pi > 0.05*ROW )  &&  ( y_pi < 0.95*ROW)
                y1 = y_pi;
                for j=1:length(rho_set)
                    y2 = size(edges,1)/2 - (rho_set(j))*sin(theta*pi/180);
                    if abs(y2-y1) < ROW/12
                        break;
                    end
                    if j==length(rho_set)
                        rho_set = [rho_set; xp_pi];
                        theta_set = [theta_set; theta];
                    end
                end
                if isempty(rho_set)
                    theta_set = theta;
                    rho_set = xp_pi;
                end
            end
        end
        x_origin = size(edges,2) / 2 + (rho_set) .* cos(theta_set * pi / 180);
        y_origin = size(edges,1) / 2 - (rho_set) .* sin(theta_set * pi / 180);
        b = (y_origin - (0 - x_origin) .* tan(((theta_set) - 90) * pi / 180));
        k = -tan(((theta_set) - 90) * pi / 180);
        lines = [k b];
        if ~isempty(lines)
            horLines = sortrows(lines,2);
        else
            horLines = [];
        end
    end
end