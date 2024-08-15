import os
import numpy as np
import matplotlib.pyplot as plt
from model_configs import MODEL_DIRS

def read_ex_force_data(file_path, version=2, num_bodies=1):
    """
    Reads excitation force data from a specified file.

    Parameters:
        file_path (str): The path to the file to be read.
        version (int): Version of the data format (2 or 3).
        num_bodies (int): Number of bodies (1 or 2).

    Returns:
        tuple: A tuple containing:
            - freqs (np.array): Array of frequency values.
            - fx (np.array): Array of surge force values.
            - fy (np.array): Array of heave force values.
            - fz (np.array): Array of pitch force values.
    """
    with open(file_path, 'r') as file:
        lines = file.readlines()

    freqs = []
    f_surge, f_heave, m_pitch = [], [], []
    read_data = False

    word = "Diffraction" if version == 2 else "Excitation"
    zone_str = f'Zone t="{word} force - beta =   0.000 deg"'

    for line in lines:
        if zone_str in line:
            read_data = True
            continue
        if 'Zone' in line and read_data:
            break
        if read_data:
            parts = line.split()
            if len(parts) < 12 * num_bodies + 1:
                continue
            try:
                freqs.append(float(parts[0]))
                f_surge.append(float(parts[1]))
                f_heave.append(float(parts[5]))
                m_pitch.append(float(parts[9]))
            except ValueError:
                continue

    return np.array(freqs), np.array(f_surge), np.array(f_heave), np.array(m_pitch)

def plot_comparison_ex_force(freqs_v2, fx_v2, fy_v2, fz_v2, freqs_v3, fx_v3, fy_v3, fz_v3, model_name):
    fig, axs = plt.subplots(3, 1, figsize=(8, 8))
    fig.suptitle(f'Excitation Force Comparison for {model_name}', fontsize=16)
    
    axs[0].plot(freqs_v2, fx_v2, 'o--', color='darkblue', label='Surge (Fx) (v2.3)', markersize=8)
    axs[0].plot(freqs_v3, fx_v3, 'x:', color='red', label='Surge (Fx) (v3.0.2)', markersize=8)
    axs[0].set_xlabel('Frequency (rad/s)', fontsize=10)
    axs[0].set_ylabel('Excitation Force', fontsize=10)
    axs[0].set_title('Surge (Fx)', fontsize=12)
    axs[0].grid(True)
    axs[0].legend(fontsize=10)

    axs[1].plot(freqs_v2, fy_v2, 'o--', color='darkblue', label='Heave (Fy) (v2.3)', markersize=8)
    axs[1].plot(freqs_v3, fy_v3, 'x:', color='red', label='Heave (Fy) (v3.0.2)', markersize=8)
    axs[1].set_xlabel('Frequency (rad/s)', fontsize=10)
    axs[1].set_ylabel('Excitation Force', fontsize=10)
    axs[1].set_title('Heave (Fy)', fontsize=12)
    axs[1].grid(True)
    axs[1].legend(fontsize=10)

    axs[2].plot(freqs_v2, fz_v2, 'o--', color='darkblue', label='Pitch (Fz) (v2.3)', markersize=8)
    axs[2].plot(freqs_v3, fz_v3, 'x:', color='red', label='Pitch (Fz) (v3.0.2)', markersize=8)
    axs[2].set_xlabel('Frequency (rad/s)', fontsize=10)
    axs[2].set_ylabel('Excitation Force', fontsize=10)
    axs[2].set_title('Pitch (Fz)', fontsize=12)
    axs[2].grid(True)
    axs[2].legend(fontsize=10)

    plt.tight_layout(rect=[0, 0, 1, 0.96])
    
    img_dir = 'img'
    os.makedirs(img_dir, exist_ok=True)
    plt.savefig(os.path.join(img_dir, f'{model_name}_Excitation_Force_Comparison.png'))
    plt.show()

def main():
    base_path_v2 = 'NEMOH_v2.3'
    base_path_v3 = 'NEMOH_v3.0.2'

    for model_dir, (_, _, _, num_bodies) in MODEL_DIRS.items():
        project_dir_v2 = os.path.join(base_path_v2, model_dir, 'Results')
        project_dir_v3 = os.path.join(base_path_v3, model_dir, 'Results')

        ex_force_file_path_v2 = os.path.join(project_dir_v2, 'ExcitationForce.tec')
        ex_force_file_path_v3 = os.path.join(project_dir_v3, 'ExcitationForce.tec')
        if os.path.exists(ex_force_file_path_v2) and os.path.exists(ex_force_file_path_v3):
            freqs_v2, fx_v2, fy_v2, fz_v2 = read_ex_force_data(ex_force_file_path_v2, 2, num_bodies)
            freqs_v3, fx_v3, fy_v3, fz_v3 = read_ex_force_data(ex_force_file_path_v3, 3)
            plot_comparison_ex_force(freqs_v2, fx_v2, fy_v2, fz_v2, freqs_v3, fx_v3, fy_v3, fz_v3, model_dir)

if __name__ == '__main__':
    main()