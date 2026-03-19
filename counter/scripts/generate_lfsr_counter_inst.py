import math
import sys
import numpy as np

taps = {
    4: [4, 3],
    5: [5, 3],
    6: [6, 5],
    7: [7, 6],
    8: [8, 6, 5, 4],
    9: [9, 5],
    10: [10, 7],
    11: [11, 9],
    12: [12, 11, 8, 6],
    13: [13, 12, 10, 9],
    14: [14, 13, 11, 9],
    15: [15, 14],
    16: [16, 14, 13, 11],
    17: [17, 14],
    18: [18, 11],
    19: [19, 18, 17, 14],
    20: [20, 17],
    21: [21, 19],
    22: [22, 21],
    23: [23, 18],
    24: [24, 23, 21, 20],
    25: [25, 22],
    26: [26, 25, 24, 20],
    27: [27, 26, 25, 22],
    28: [28, 25],
    29: [29, 27],
    30: [30, 29, 26, 24],
    31: [31, 28],
    32: [32, 30, 26, 25],
    33: [33, 20],
    34: [34, 31, 30, 26],
    35: [35, 33],
    36: [36, 25],
    37: [37, 36, 33, 31],
    38: [38, 37, 33, 32],
    39: [39, 35],
    40: [40, 37, 36, 35],
    41: [41, 38],
    42: [42, 40, 37, 35],
    43: [43, 42, 38, 37],
    44: [44, 42, 39, 38],
    45: [45, 44, 42, 41],
    46: [46, 40, 39, 38],
    47: [47, 42],
    48: [48, 44, 41, 39],
    49: [49, 40],
    50: [50, 48, 47, 46],
    51: [51, 50, 48, 45],
    52: [52, 49],
    53: [53, 52, 51, 47],
    54: [54, 51, 48, 46],
    55: [55, 31],
    56: [56, 54, 52, 49],
    57: [57, 50],
    58: [58, 39],
    59: [59, 57, 55, 52],
    60: [60, 59],
    61: [61, 60, 59, 56],
    62: [62, 59, 57, 56],
    63: [63, 62],
    64: [64, 63, 61, 60],
}


def generate_galois_matrix(lfsr_len, taps):
    """
    Generates the transition matrix for a Galois LFSR.

    In a Galois configuration, the output bit is fed back into
    specific positions (taps) within the register.

    Parameters:
    lfsr_len (int): Number of bits in the register.
    taps (list): Indices of the bits where the feedback is applied.

    Returns:
    np.ndarray: An (n x n) transition matrix M.
    """
    # Initialize a square matrix with zeros (using int8 for memory efficiency)
    matrix = np.zeros((lfsr_len, lfsr_len), dtype=np.int8)

    # SHIFT OPERATION:
    # Bit at position 'i' moves to position 'i + 1'.
    # This creates a sub-diagonal of 1s.
    for i in range(lfsr_len - 1):
        matrix[i, i + 1] = 1

    # FEEDBACK OPERATION:
    # The last bit (the output bit) is XORed back into the positions
    # defined by the 'taps' list.
    for tap in taps:
        matrix[lfsr_len - 1, lfsr_len - tap - 1] = 1

    return matrix


def lfsr_fast_forward(matrix, state, steps):
    """
    Calculates the LFSR state after N steps using binary matrix exponentiation.

    The state at step N is calculated as: State_n = (M^n * State_0) mod 2.
    Using binary exponentiation reduces complexity from O(N) to O(log N).
    """

    def matrix_pow_mod2(base, p):
        """Efficiently raises a matrix to power 'p' in GF(2) field."""
        size = base.shape[0]
        # Identity matrix for GF(2)
        res = np.eye(size, dtype=np.int8)

        while p > 0:
            if p % 2 == 1:
                # Matrix multiplication followed by modulo 2 (XOR logic)
                res = (res @ base) % 2

            # Square the base matrix
            base = (base @ base) % 2
            p //= 2
        return res

    # 1. Compute the N-th power of the transition matrix
    matrix_n = matrix_pow_mod2(matrix, steps)

    # 2. Multiply the powered matrix by the initial state vector
    # Result must be modulo 2 to stay within the binary field
    final_state = np.dot(state, matrix_n) % 2

    return final_state


def state_to_int(state):
    return int("".join(str(b) for b in state), 2)


if len(sys.argv) != 2:
    print("Usage: python generate_lfsr_counter_inst.py <number>")
    sys.exit(1)
elif not sys.argv[1].isnumeric():
    print(f"Error: '{sys.argv[1]}' is not a valid integer.")

steps = int(sys.argv[1])
size = math.ceil(math.log(steps, 2) + 1)

tap = taps[size]
taps_list = list(i - 1 for i in tap)

result = np.ones(size, dtype=np.int8)

# Generate the Galois Matrix
M_galois = generate_galois_matrix(size, taps_list)

# Jump steps forward instantly
result = lfsr_fast_forward(M_galois, result, steps - 2)
output_int = state_to_int(result)
seed = hex(output_int)[2:].rjust(16, "0")
print(f"""-- LFSR counter to {steps}
lfsr_cnt : entity work.lfsr_counter
    generic map (
        g_size  => {size},
        g_state => x"{seed}"
    )
    port map (
        i_clk     => clk,
        i_rst_n   => rst_n,
        o_trigger => trigger_lfsr
    );)""")
