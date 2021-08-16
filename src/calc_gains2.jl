using BenchmarkTools
using LoopVectorization

function get_gains!(x, y, idxs, gains)
    @tturbo for i in eachindex(idxs)
        s = 0.0
        for j in eachindex(y)
            s += sqrt(y[j] + x[j, idxs[i]])
        end
        gains[i] = s
    end
end;

d = 54
n = 581012
x = rand(d, n)*100;
y = zeros(Float64, d)
idxs = collect(1:n);
gains = zeros(Float64, n);

bench_jl = @benchmark get_gains!($x, $y, $idxs, $gains)
print(bench_jl)