%Group Patches
function [verLinesGrp] = GroupPatchesV21(horImgCeil,verLines)
horImgNum = length(horImgCeil);
verLinesGrp{horImgNum} = [];
width = size(horImgCeil{1},2);
bin_num = 15;
for i=1:horImgNum
    lines = [1 verLines{i} width];
    im = horImgCeil{i};
    hsv = rgb2hsv(im);
    col_begin = lines(1);
    for k=2:length(lines)-1
        col_mid = lines(k);
        col_end = lines(k+1);
        patch1 = hsv(:, col_begin:col_mid, :);
        patch2 = hsv(:, col_mid:col_end, :);
        fea1 = GetFeature(patch1, bin_num);
        fea2 = GetFeature(patch2, bin_num);
        sim = fea1'*fea2/(norm(fea1)*norm(fea2));
        if sim < 0.95
            verLinesGrp{i} = [verLinesGrp{i} lines(k)];
            col_begin = lines(k);
        end
    end
end
    function [fea] = GetFeature(patch, binNum)
        edges = linspace(0.01,1,binNum+1);
        edges = edges(1:binNum);
        num = size(patch, 1) * size(patch, 2);
        % H
        n_patch = reshape(patch(:, :, 1), [num 1]);
        fe1 = histc(n_patch, edges);
        % S
        n_patch = reshape(patch(:, :, 2), [num 1]);
        fe2 = histc(n_patch, edges);
%         % V
%         n_patch = reshape(patch(:, :, 3), [num 1]);
%         fe3 = histc(n_patch, edges);
        
        fea = [fe1; fe2];%; fe3];
    end
end