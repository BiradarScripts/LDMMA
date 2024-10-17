#include <iostream>
#include <deque>
#include <vector>
#include <cmath>
#include <bits/stdc++.h>


using namespace std;

typedef long long ll;

// Function to split the input for Karatsuba algorithm
vector<ll> karatsuba_split_inputs(ll multiplicand, ll multiplier) {
    int m = max(to_string(multiplicand).length(), to_string(multiplier).length()) / 2;

    ll high1 = multiplicand / pow(10, m);
    ll low1 = multiplicand % (ll)pow(10, m);
    ll high2 = multiplier / pow(10, m);
    ll low2 = multiplier % (ll)pow(10, m);

    return {m, 2 * m, high1, low1, high2, low2};
}

ll karatsuba_multiply_iterative(ll multiplicand, ll multiplier) {
    deque<vector<ll>> node_stack = {{multiplicand, multiplier, 0}};
    deque<int> branch_path;
    deque<vector<ll>> m_stack;
    deque<ll> z_stack[3];
    int leaf_count = 0;

    while (!node_stack.empty()) {
        vector<ll> current_node = node_stack.back();
        node_stack.pop_back();

        ll multiplicand_temp = current_node[0];
        ll multiplier_temp = current_node[1];
        int branch = current_node[2];

        if (multiplicand_temp >= 10 && multiplier_temp >= 10) {
            vector<ll> intermediate_results = karatsuba_split_inputs(multiplicand_temp, multiplier_temp);
            ll m_digit_shift_temp = intermediate_results[0];
            ll m2_digit_shift_temp = intermediate_results[1];
            ll high1 = intermediate_results[2];
            ll low1 = intermediate_results[3];
            ll high2 = intermediate_results[4];
            ll low2 = intermediate_results[5];

            node_stack.push_back({high1, high2, 2}); // z2 - right
            node_stack.push_back({low1 + high1, low2 + high2, 1}); // z1 - center
            node_stack.push_back({low1, low2, 0}); // z0 - left

            branch_path.push_back(branch);
            m_stack.push_back({m_digit_shift_temp, m2_digit_shift_temp});
            leaf_count = 0;
        } else {
            z_stack[leaf_count].push_back(multiplicand_temp * multiplier_temp);
            if (leaf_count != 2) {
                leaf_count++;
            }
        }

        while (!z_stack[2].empty()) {
            int last_branch = branch_path.back();
            branch_path.pop_back();

            vector<ll> m_pair = m_stack.back();
            m_stack.pop_back();

            ll m_digit_shift_bits = m_pair[0];
            ll m2_digit_shift_bits = m_pair[1];

            ll z0 = z_stack[0].back();
            z_stack[0].pop_back();
            ll z1 = z_stack[1].back();
            z_stack[1].pop_back();
            ll z2 = z_stack[2].back();
            z_stack[2].pop_back();

            ll result = (z2 << m_digit_shift_bits) + ((z1 - z2 - z0) << m2_digit_shift_bits) + z0;
            z_stack[last_branch].push_back(result);
        }
    }

    return z_stack[0][0];
}

int main() {
    ll multiplicand = 12345678;
    ll multiplier = 87654321;

    ll result = karatsuba_multiply_iterative(multiplicand, multiplier);
    cout << "Result: " << result << endl;

    return 0;
}
