using BenchmarkTools
using Distributed
using TimerOutputs
using Tullio
using LoopVectorization

X = rand(54, 581012)*100;

# function get_gains!(X, current_values, idxs, gains)
#     Threads.@threads for i in eachindex(idxs)
#         s = 0.0
#         for j in eachindex(current_values)
#             @inbounds s += @fastmath sqrt(current_values[j] + X[j, idxs[i]])
#         end
#         gains[i] = s
#     end
# end;
function get_gains!(X, current_values, idxs, gains)
    @tturbo for i in eachindex(idxs)
        s = 0.0
        for j in eachindex(current_values)
            s += sqrt(current_values[j] + X[j, idxs[i]])
        end
        gains[i] = s
    end
end;

function calculate_gains!(X, gains, current_values, idxs, current_concave_value_sum)
    get_gains!(X, current_values, idxs, gains)
    
    gains .-= current_concave_value_sum
    return gains
end;

@btime begin
    d, n = size(X);
    idxs = collect(1:n);

    current_values = zeros(Float64, d)
    current_concave_values = sqrt.(current_values)
    current_concave_values_sum = sum(current_concave_values)

    gains = zeros(Float64, n);
    calculate_gains!(X, gains, current_values, idxs, current_concave_values_sum);
end
