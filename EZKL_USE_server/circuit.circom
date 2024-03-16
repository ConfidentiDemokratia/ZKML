pragma circom 2.0.0;

include "../node_modules/circomlib-ml/circuits/ReLU.circom";
include "../node_modules/circomlib-ml/circuits/Dense.circom";

template Model() {
signal input in[768];
signal input dense_weights[768][128];
signal input dense_bias[128];
signal input dense_out[128];
signal input dense_remainder[128];
signal input dense_re_lu_out[128];
signal input dense_1_weights[128][2];
signal input dense_1_bias[2];
signal input dense_1_out[2];
signal input dense_1_remainder[2];
signal input dense_1_re_lu_out[2];
signal output out[2];

component dense = Dense(768, 128, 10**18);
component dense_re_lu[128];
for (var i0 = 0; i0 < 128; i0++) {
    dense_re_lu[i0] = ReLU();
}
component dense_1 = Dense(128, 2, 10**18);
component dense_1_re_lu[2];
for (var i0 = 0; i0 < 2; i0++) {
    dense_1_re_lu[i0] = ReLU();
}

for (var i0 = 0; i0 < 768; i0++) {
    dense.in[i0] <== in[i0];
}
for (var i0 = 0; i0 < 768; i0++) {
    for (var i1 = 0; i1 < 128; i1++) {
        dense.weights[i0][i1] <== dense_weights[i0][i1];
}}
for (var i0 = 0; i0 < 128; i0++) {
    dense.bias[i0] <== dense_bias[i0];
}
for (var i0 = 0; i0 < 128; i0++) {
    dense.out[i0] <== dense_out[i0];
}
for (var i0 = 0; i0 < 128; i0++) {
    dense.remainder[i0] <== dense_remainder[i0];
}
for (var i0 = 0; i0 < 128; i0++) {
    dense_re_lu[i0].in <== dense.out[i0];
}
for (var i0 = 0; i0 < 128; i0++) {
    dense_re_lu[i0].out <== dense_re_lu_out[i0];
}
for (var i0 = 0; i0 < 128; i0++) {
    dense_1.in[i0] <== dense_re_lu[i0].out;
}
for (var i0 = 0; i0 < 128; i0++) {
    for (var i1 = 0; i1 < 2; i1++) {
        dense_1.weights[i0][i1] <== dense_1_weights[i0][i1];
}}
for (var i0 = 0; i0 < 2; i0++) {
    dense_1.bias[i0] <== dense_1_bias[i0];
}
for (var i0 = 0; i0 < 2; i0++) {
    dense_1.out[i0] <== dense_1_out[i0];
}
for (var i0 = 0; i0 < 2; i0++) {
    dense_1.remainder[i0] <== dense_1_remainder[i0];
}
for (var i0 = 0; i0 < 2; i0++) {
    dense_1_re_lu[i0].in <== dense_1.out[i0];
}
for (var i0 = 0; i0 < 2; i0++) {
    dense_1_re_lu[i0].out <== dense_1_re_lu_out[i0];
}
for (var i0 = 0; i0 < 2; i0++) {
    out[i0] <== dense_1_re_lu[i0].out;
}

}

component main = Model();
