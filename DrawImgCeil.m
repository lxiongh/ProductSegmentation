function [ img ] = DrawImgCeil( imgCeil )
%DRAWIMGCEIL Summary of this function goes here
%   Detailed explanation goes here
img = [];
for i=1:length(imgCeil)
    img = [img; imgCeil{i}];
end
end

