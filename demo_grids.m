% draw grid
clear all; clc;
fl = dir('.\images\*.jpg');
for i=1:length(fl)
    dty = i/length(fl)*100;
    nm = fl(i).name;
    Im = imread(['.\images\' nm]);
    I = imresize(Im,0.3);
    [horLines, edges] = GetHorLinesV21(I);
    edges =uint8(edges*255 );
    edges = repmat(edges, [1 1 3]);
    
    horImgCeil = GetHorImgs(I,horLines);
    horImgCeilAdj = AdjHorImgsV11(horImgCeil);
    horImg1 = DrawImgCeil(horImgCeil);
    horImg2 = DrawImgCeil(horImgCeilAdj);
    horImg = [horImg1 zeros(size(horImg1,1), 20, 3) horImg2];
    
    verLines = GetVerLinesV30(horImgCeilAdj);
    verLinesGrp = GroupPatchesV21(horImgCeilAdj,verLines);
    img1 = DrawLines(I, horLines, verLines);
    img2 = DrawLines(I, horLines, verLinesGrp);
    grid = [img1 zeros(size(img1,1), 20, 3) img2];
    
    horImg = imresize(horImg, [size(grid,1) size(grid,2)]);
    imwrite([edges horImg grid], ['results\' nm], 'jpg');
    
    fprintf('%3.2f%%\n',dty);
end