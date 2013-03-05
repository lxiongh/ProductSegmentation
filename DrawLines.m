function [Iout] = DrawLines(Iin,horLines,verLines)
%%
col = size(Iin,2); row = size(Iin,1);
Iout = Iin;
%% draw horLines
x0 = 1:1:col;
for i=1:size(horLines, 1)
    y0 = floor(horLines(i,1)*x0 + horLines(i,2));
    for k=1:length(x0)
        Iout(y0(k):y0(k)+3, x0(k), 1) = 0;
        Iout(y0(k):y0(k)+3, x0(k), 2) = 255;
        Iout(y0(k):y0(k)+3, x0(k), 3) = 0;
    end
end
%% draw verLines
horLines = [0 1; horLines; 0 row];
for i=1:size(horLines,1)-1
    for j=1:length(verLines{i})
        y0 = floor(horLines(i,1)*verLines{i}(j)+horLines(i,2)) ...
            :1:floor(horLines(i+1,1)*verLines{i}(j)+horLines(i+1,2));
        x0 = ones(1,length(y0))*verLines{i}(j);
        for k=1:length(x0)
            Iout(y0(k), x0(k), 1) = 0;
            Iout(y0(k), x0(k), 2) = 255;
            Iout(y0(k), x0(k), 3) = 0;
        end
    end
    %     end
end
end
