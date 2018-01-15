function [] = plotStauwellen(highway_array,mode)

% Christoph Sokal

hold on
for i=1:length(highway_array)
    for j=1:size(highway_array{1},1)
        for k=1:size(highway_array{1},2)
            if(mode==false)
                if(~isempty(highway_array{i}{j,k}))
                    if(size(highway_array{1},1)>1)
                        if(mod(j,2)~=0)
                            plot(k,-i*2+1,'.r')
                        else
                           plot(k,-(2*i-1)+1,'.b') 
                        end
                    else
                        plot(k,-i+1,'.r')
                    end
                    
                end
            elseif(mode==true)
                if(~isempty(highway_array{i}{j,k}))
                    if(size(highway_array{1},1)>1)
                        if(mod(j,2)~=0)
                            plot(k,-i-length(highway_array)+1,'.r')
                        else
                            plot(k,-i+1,'.b') 
                        end
                    else
                        plot(k,-i+1,'.r')
                    end
                    
                end
                
            end
        end
        
    end
    
    
end

