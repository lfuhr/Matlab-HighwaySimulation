% Simple pseudo random number generator% Marsaglia's theorem is not affecting the modelclassdef LCG < handle    	properties (Constant)        m = 2^31;        a = 65539;        c = 0;    end        properties (Access = private)        lastNumber    end        methods        function obj = LCG(seed)            obj.lastNumber = seed;        end        function number = random(obj)            obj.lastNumber = mod( (LCG.a * obj.lastNumber + LCG.c), LCG.m );            number = (obj.lastNumber + 1) / (LCG.m + 1);        end   endend