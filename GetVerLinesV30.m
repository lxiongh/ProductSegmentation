function [ verLines ] = GetVerLinesV30 ( imgCeils )

verLines = { };
%figure(2);  clf;
for i=1:length(imgCeils)
    % 将rgb空间转换为hsv空间
    im = imgCeils{i};
	im_seg_gray = rgb2gray(im);
	edges = edge(im_seg_gray, 'canny');
	% 腐蚀
	se = strel('rectangle', [3 1]);
	edges1 = imerode(edges, se);
	% 膨胀
	se = strel('rectangle', [6 2]);
	edges2 = imdilate(edges1, se);
	% radon
	[R idx] = radon(edges2, 0);
	% sort
	[R ix] = sort(R, 'descend');
	idx = idx(ix);
	% scale R and idx
	idx_max = max(idx);
	center = floor((size(edges2, 2) + 1) / 2);
	R = floor(R/max(R)*(size(im,1)-1));
	idx =  floor((1+idx/idx_max)*center)+1;
	xp1 = idx(1);
	R1 = R(1);
	COL = size(edges2, 2);
	for j=2:50
		xp2 = idx(j);
		R2 = R(j);
		for jj=1:length(xp1)
			if abs(xp1(jj) - xp2) < COL/30
				break;
			end
			if jj==length(xp1)
				xp1 = [xp1 xp2];
				R1 = [R1 R2];
			end
		end
	end
	verLines{i} = sort(xp1);
end

end


