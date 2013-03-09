function [ lines, edges2] = GetHorLinesV21( Iin )
im_gray = rgb2gray(Iin);
edges = edge(im_gray,'canny');

% ¸¯Ê´
se = strel('line', 10, 0);
edges1 = imerode(edges, se);
% edges1 = ImageErode(edges, 10, -2:0.5:2);

% ÅòÕÍ
% se = strel('line', 1, 0);
% edges2 = imdilate(edges1, se);
edges2 = edges1;

% ===========2012-11-18===================
% ½«¼ì²âÖ±ÏßµÄ·¶Î§ËõÐ¡Îª+-2¶È¼ä
thetastep = 0.5;
[R xp] = radon(edges2,88:thetastep:92);
% ---------------------------------------------------------------

[R_pi IDX] = sort(R,'descend');
theta_set = [];
rho_set = [];

ROW = size(edges, 1);
COL = size(edges,2);

if COL > ROW
    threshold = COL/8;
else
    threshold = COL/10;
end

max_max = max(R_pi(:));
for i=1:40
    [max_R, max_idx] = max(R_pi(i,:));
    theta = 88 + (max_idx-1)*thetastep;
    xp_pi = xp(IDX(i,max_idx));
    y_pi = size(edges2,1)/2 - (xp_pi)*sin(theta*pi/180);
    % ¼ÓÈëÁËÖÁ¶¥¼°ÖÁµ×Ö±ÏßµÄ¼ì²â£¬²¢½«ÆäÌÞ³ý
    if (y_pi > 0.05*ROW )  &&  ( y_pi < 0.95*ROW) && max_R > COL/20
        y1 = y_pi;
        for j=1:length(rho_set)
            y2 = size(edges2,1)/2 - (rho_set(j))*sin(theta*pi/180);
            % ÐÞ¸ÄÎªÅÐ¶ÏÌõ¼þ£¬Ö®Ç°´úÂëµÄÅÐ¶ÏÌõ¼þÓÐÎó
            % ´Ë´¦ÎªÌÞ³ý¿¿µÃÌ«½üµÄÁ½Ö±Ö±Ïß
            if abs(y2-y1) < threshold
                break;
            end
            if j==length(rho_set)
                rho_set = [rho_set; xp_pi];
                theta_set = [theta_set; theta];
            end
        end
        % ½«³õÊ¼»¯¹¤×÷·Å½øÁËforÑ­»·ÀïÍ·
        if isempty(rho_set)
            theta_set = theta;
            rho_set = xp_pi;
        end
    end
end
% ---------------------------------------------------------------
x_origin = size(edges2,2) / 2 + (rho_set) .* cos(theta_set * pi / 180);
y_origin = size(edges2,1) / 2 - (rho_set) .* sin(theta_set * pi / 180);
b = (y_origin - (0 - x_origin) .* tan(((theta_set) - 90) * pi / 180));
k = -tan(((theta_set) - 90) * pi / 180);
lines = [k b];
if ~isempty(lines)
    lines = sortrows(lines,2);
end
end