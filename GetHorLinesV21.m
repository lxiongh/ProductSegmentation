function [ lines, edges2] = GetHorLinesV21( Iin )
im_gray = rgb2gray(Iin);
edges = edge(im_gray,'canny');

% 腐蚀
se = strel('rectangle', [1 20]);
edges1 = imerode(edges, se);

% 膨胀
se = strel('rectangle', [1 1]);
edges2 = imdilate(edges1, se);

% ===========2012-11-18===================
% 将检测直线的范围缩小为+-2度间
thetastep = 0.5;
[R xp] = radon(edges2,89:thetastep:91);
% ---------------------------------------------------------------

[R_pi IDX] = sort(R,'descend');
theta_set = [];
rho_set = [];

ROW = size(edges, 1);
COL = size(edges,2);
% 只取前20条直线
for i=1:20
    [max_R, max_idx] = max(R_pi(i,:));
    theta = 89 + (max_idx-1)*thetastep;
    xp_pi = xp(IDX(i,max_idx));
    y_pi = size(edges2,1)/2 - (xp_pi)*sin(theta*pi/180);
    % 加入了至顶及至底直线的检测，并将其剔除
    if (y_pi > 0.05*ROW )  &&  ( y_pi < 0.95*ROW) && max_R > COL/20
        y1 = y_pi;
        for j=1:length(rho_set)
            y2 = size(edges2,1)/2 - (rho_set(j))*sin(theta*pi/180);
            % 修改为判断条件，之前代码的判断条件有误
            % 此处为剔除靠得太近的两直直线
            if abs(y2-y1) < ROW/12
                break;
            end
            if j==length(rho_set)
                rho_set = [rho_set; xp_pi];
                theta_set = [theta_set; theta];
            end
        end
        % 将初始化工作放进了for循环里头
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
lines = sortrows(lines,2);

end