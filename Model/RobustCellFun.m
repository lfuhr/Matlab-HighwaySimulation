function cellArray = RobustCellFun(f,cellArray)
        cellArray = cellfun(@(c)doifnotempty(f, c),cellArray, 'un', false);
        function cell = doifnotempty(f, cell)
            if ~ isempty(cell)
                cell = f(cell);
            end
        end
end