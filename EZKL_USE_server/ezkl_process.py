import subprocess
import sys
import os
import json
import ezkl


def process_model(onnx_file, input_json):
    
    model_path = onnx_file
    compiled_model_path = 'network.ezkl'
    pk_path = 'test.pk'
    vk_path = 'test.vk'
    settings_path = 'settings.json'
    witness_path = 'witness.json'
    proof_path = 'proof.json'
    cal_data_path = 'cal_data.json'
    sol_code_path = 'Verifier.sol'
    abi_path = 'Verifier.abi'

 
    if not ezkl.gen_settings(model_path, settings_path):
        raise Exception("Failed to generate settings")


    with open(input_json, 'r') as f:
        data = json.load(f)
    if not ezkl.calibrate_settings(input_json, model_path, settings_path, "resources", max_logrows=12, scales=[2]):
        raise Exception("Failed to calibrate settings")


    if not ezkl.compile_circuit(model_path, compiled_model_path, settings_path):
        raise Exception("Failed to compile circuit")

  
    if not ezkl.get_srs(settings_path):
        raise Exception("Failed to get SRS")

    
    if not ezkl.setup(compiled_model_path, vk_path, pk_path):
        raise Exception("Failed to setup")

    # Generate the Witness for the proof
    if not ezkl.gen_witness(input_json, compiled_model_path, witness_path):
        raise Exception("Failed to generate witness")
    # Generate the proof
    proof = ezkl.prove(witness_path, compiled_model_path, pk_path, proof_path, "single")
    print("Proof generated:", proof)
    # verify our proof
    if not ezkl.verify(proof_path, settings_path, vk_path):
        raise Exception("Verification failed")
    print("Verification successful")

   
    
    if not ezkl.create_evm_verifier(vk_path, settings_path, sol_code_path, abi_path):
        raise Exception("Failed to create EVM verifier")
    print(f"EVM Verifier and ABI files generated: {sol_code_path}, {abi_path}")


    onchain_input_array = []
    
    formatted_output = "["
    for i, value in enumerate(proof["instances"]):
        for j, field_element in enumerate(value):
            onchain_input_array.append(ezkl.felt_to_big_endian(field_element))
            formatted_output += str(onchain_input_array[-1])
            if j != len(value) - 1:
                formatted_output += ", "
        if i < len(proof["instances"]) - 1:
            formatted_output += "], ["
        else:
            formatted_output += "]"
    print("pubInputs: ", formatted_output)
    print("proof: ", proof["proof"])


if __name__ == "__main__":
    
    onnx_file = sys.argv[1]
    input_json = sys.argv[2]

    process_model(onnx_file, input_json)


# if its not work, try install in terminal solc-select install 0.8.20 and solc-select use 0.8.20
