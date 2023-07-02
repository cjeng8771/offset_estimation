%% Generating Pseudonoise Bit Sequences

%% In Phase

% Parameters
num_stages = 9; % N
code_length = 511; % L
% start_states = [1, 1, 0, 0, 0, 1, 0, 0, 1];
start_states = [0, 0, 0, 0, 0, 0, 0, 0, 1]; % Not all zeros
taps = [9, 5];

pn_i = lfsr(num_stages, start_states, code_length, taps);

string_i = sprintf('%d,', pn_i);
disp('in-phase')
disp(string_i)

%% Quadrature

% Parameters
num_stages = 9; % N
code_length = 511; % L
% start_states = [1, 1, 0, 0, 0, 1, 0, 0, 1];
start_states = [0, 0, 0, 0, 0, 0, 0, 0, 1]; % Not all zeros
taps = [9, 6, 4, 3];

pn_q = lfsr(num_stages, start_states, code_length, taps);

string_q = sprintf('%d,', pn_q);
disp('quadrature')
disp(string_q)

%% Functions

function [output] = lfsr(N, states, L, taps)
    n = N;
    state = states;
    output = zeros(1,L);
    for i = 1:(2^n-1)
        output(i) = state(end);
        state_sum = 0;
        for t = taps
            state_sum = state_sum + state(t);
        end
        input = mod(state_sum,2);
        state = [input, state(1:end-1)];
    end
end

% Patwari Reference Function
function [output] = lfsr_p()
    n = 5;
    state = [1, 1, 0, 0, 0];
    output = zeros(1,31);
    for i = 1:(2^n-1)
        output(i) = state(end);
        input = mod(state(3)+state(5),2);
        state = [input, state(1:end-1)];
    end
end