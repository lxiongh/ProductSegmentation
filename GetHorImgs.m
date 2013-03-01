function [horImgCeil] = GetHorImgs (Iin,lines)
% 得到行分割后的区域
% Iin: 输入RGB图片
% lins: 当前图片Iin的行分割参数 {y = ax + b}
row = size(Iin,1);
col = size(Iin,2);
% 补足首尾两条直线
segLines = [0 0; lines; 0 row];
linesNum = size(segLines,1);
clear horImgCeil; horImgCeil{linesNum-1} = [];
for i=2:linesNum
    y0L = segLines(i-1,2); y0R = segLines(i-1,1)*col + segLines(i-1,2);
    y1L = segLines(i,2); y1R = segLines(i,1)*col + segLines(i,2);
    yMin = floor(min([y0L y0R])); yMax = floor(max([y1L y1R]));
    horImgCeil{i-1} = uint8(zeros(yMax-yMin+1,col,3));
    for j=1:col
        py1 = floor(segLines(i-1,1)*j + segLines(i-1,2));
        py2 = min([floor(segLines(i,1)*j + segLines(i,2)) size(Iin,1)]);
        horImgCeil{i-1}(py1-yMin+1:py2-yMin,j,:) = Iin(py1+1:py2,j,:);
    end
end
end