%Group Patches
function [verLinesGrp] = GroupPatchesV21(horImgCeil,verLines)
horImgNum = length(horImgCeil);
verLinesGrp{horImgNum} = [];
width = size(horImgCeil{1},2);
bin_num = 15;
lbp_bin_num = 20;
for i=1:horImgNum
    lines = [1 verLines{i} width];
    im = horImgCeil{i};
    hsv = rgb2hsv(im);
    im_gray = rgb2gray(im);
    col_begin = lines(1);
    for k=2:length(lines)-1
        col_mid = lines(k);
        col_end = lines(k+1);
        patch1 = hsv(:, col_begin:col_mid, :);
        patch2 = hsv(:, col_mid:col_end, :);

        fea1 = GetFeature(patch1, bin_num, lbp_bin_num);
        fea2 = GetFeature(patch2, bin_num, lbp_bin_num);

        sim = fea1'*fea2/(norm(fea1)*norm(fea2));
        if sim < 0.95
            verLinesGrp{i} = [verLinesGrp{i} lines(k)];
            col_begin = lines(k);
        end
    end
end
    function [fea] = GetFeature(patch, binNum, lbpBinNum)
        % the factor of color feature
        lamda = 0.6;

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
        
        % LBP feature in channel H and S
        edges = linspace(0, 256, lbpBinNum+1);
        edges = edges(1:lbpBinNum);
        num = size(patch, 1) * size(patch, 2);

        lbp_fea1 = EfficientLBP(patch(:,:,1), [3, 3]);
        n_patch = reshape(lbp_fea1, [num 1]);
        fe3 = histc(n_patch, edges);
        
        lbp_fea2 = EfficientLBP(patch(:,:,2), [3, 3]);
        n_patch = reshape(lbp_fea2, [num 1]);
        fe4 = histc(n_patch, edges);

        % normalize features
        norm1 = norm(fe1) + norm(fe2);
        fe1 = fe1./norm1;
        fe2 = fe2./norm1;
        norm2 = norm(fe3) + norm(fe4);
        fe3 = fe3./norm2;
        fe4 = fe4./norm2;
        
        fea = [lamda * fe1; lamda * fe2; (1-lamda) * fe3; (1-lamda) * fe4];
    end
end