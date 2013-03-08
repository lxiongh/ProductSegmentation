function [ edges_out ] = ImageErode( edges_in, len, deg_array )
%IAMGEERODE Summary of this function goes here
%   Detailed explanation goes here
edges_out = false(size(edges_in));
deg_num = length(deg_array);
for deg_idx=1:deg_num
    deg = deg_array(deg_idx);
    se = strel('line', len, deg);
    edges = imerode(edges_in, se);
    edges_out = edges_out | edges;
end
end

