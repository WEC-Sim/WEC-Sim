import os
import subprocess
from model_configs import MODEL_DIRS

def modify_freqs(file_path, num_freqs, min_freq, max_freq, version):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    for i, line in enumerate(lines):
        if '--- Load cases to be solved ---' in line:
            freq_line_index = i + 1
            new_line = (
                f'{num_freqs} {min_freq} {max_freq}    ! Number of wave frequencies, Min, and Max (rad/s)\n'
                if version == 'v2.3'
                else f'1 {num_freqs} {min_freq} {max_freq}    ! Freq type 1,2,3=[rad/s,Hz,s], Number of wave frequencies, Min, and Max (rad/s)\n'
            )
            lines[freq_line_index] = new_line
            break

    with open(file_path, 'w') as file:
        file.writelines(lines)
    print(f'Modified: {file_path} -> {num_freqs}, {min_freq}, {max_freq}')

def run_nemoh(project_dir, bin_dir, version):
    binaries = ['preProcessor.exe', 'Solver.exe', 'postProcessor.exe'] if version == 'v2.3' else ['preProc.exe', 'solver.exe', 'postProc.exe']

    original_dir = os.getcwd()
    for binary in binaries:
        binary_path = os.path.join(bin_dir, binary)
        binary_path = os.path.abspath(binary_path)
        if os.path.exists(binary_path):
            try:
                os.chdir(project_dir)
                result = subprocess.run([binary_path], capture_output=True, text=True, check=True)
                print(result.stdout)
                print(result.stderr)
            except (FileNotFoundError, subprocess.CalledProcessError) as e:
                print(f'Error with {binary_path}: {e}')
                break
            finally:
                os.chdir(original_dir)

def main(num_freqs='default', version='v3.0.2'):
    """
    Main function to run Nemoh binaries for different models.

    Parameters:
        num_freqs (int or str): Number of frequencies to use. If 'default', high_res_frequencies will be used.
        version (str): Version of Nemoh to use ('v2.3' or 'v3.0.2').

    Usage:
        main(num_freqs=6, version='v2.3')
        main(num_freqs='default', version='v3.0.2')
    """
    base_path = f'NEMOH_{version}'
    bin_dir = os.path.join(base_path, 'bin')

    for model_dir, (high_res_freqs, min_freq, max_freq, _) in MODEL_DIRS.items():
        project_dir = os.path.join(base_path, model_dir)
        cal_file_path = os.path.join(project_dir, 'Nemoh.cal')

        freqs = high_res_freqs if num_freqs == 'default' else num_freqs

        modify_freqs(cal_file_path, freqs, min_freq, max_freq, version)
        run_nemoh(project_dir, bin_dir, version)

if __name__ == "__main__":
    main(num_freqs=6, version='v3.0.2')  # Choose version ('v2.3' or 'v3.0.2') and number of frequencies (e.g. from 'default' to 6, to run faster)
