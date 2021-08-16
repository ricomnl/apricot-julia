import numpy as np
import timeit
from numba import njit, prange

def get_gains(parallel, fastmath, cache):
    @njit(parallel=parallel, fastmath=fastmath, cache=cache)
    def get_gains_(x, y, idxs, gains):
        for i in prange(idxs.shape[0]):
            idx = idxs[i]
            gains[i] = np.sqrt(y + x[idx, :]).sum()

        return gains

    return get_gains_


if __name__ == "__main__":
    d = 54
    n = 581012
    x = np.abs(np.random.randn(n, d))*100
    y = np.zeros(d, dtype="float64")
    idxs = np.arange(n)
    gains = np.zeros(n, dtype="float64")

    get_gains_ = get_gains(True, True, False)
    
    t = timeit.timeit("get_gains_(x, y, idxs, gains)", number=1, globals=globals())
    print("Elapsed time: ", round(t, 7)*1000, "ms.")