function RobustCellFun(f,cellArray)
        cellfun(@(c)doifnotempty(f, c),cellArray, 'un', false);
        function doifnotempty(f, cell)
            if ~ isempty(cell)
                f(cell);
            end
        end
end