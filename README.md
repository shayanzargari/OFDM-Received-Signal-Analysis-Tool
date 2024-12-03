# **OFDM Received Signal Analysis Tool**

## **Overview**
This MATLAB project provides a toolkit to analyze single-antenna OFDM receiver systems under AWG noise. All the necessary parameters are estimated blindly. 

---

## **Repository Structure**

### **Main Functions**
- **`main.m`**: This main function includes all subfunctions for estimating the received OFDM signal.
- **`OFDMToolGUI.m`**: This GUI tool provides an interactive platform for parameter initialization.


---

### **Modulation Functions**
- **`mapToPSKSyms.m`**: Maps input bits to PSK symbols.
- **`mapToQAMSyms.m`**: Maps input bits to QAM symbols.
- **`symToBits.m`**: Converts symbols to binary data.
- **`qamToBits.m`**: Demaps QAM symbols to binary data.
- **`pskToBits.m`**: Demaps PSK symbols to binary data.

---

### **OFDM Core Functions**
### **OFDM Processing Functions**

- **`calOFDMSymParams.m`**  
  - Estimate the number of OFDM symbols using lags corresponding to the autocorrelation of the received OFDM signal.
  - Calculate cyclic prefix (CP) length based on the length of the received OFDM signal, number of OFDM symbols, and FFT size.

- **`removeCyclicPrefix.m`**  
  - Removes the cyclic prefix from the received OFDM signal for each OFDM.

- **`processFFT.m`**  
  - Transforms the OFDM signal from the time domain to the frequency domain using FFT.  

- **`freqAnalyzer.m`**  
  - Analyzes the frequency components of an OFDM signal for spectrum visualization.  
  - It uses FFT-based spectral analysis to calculate and visualize the power spectral density (PSD).

- **`calSignalBW.m`**  
  - Computes the bandwidth of a signal based on its Power Spectral Density (PSD) and user-defined criteria.  
  - **Bandwidth Calculation Types**:  
    - **`threshold`**: Identifies signal regions exceeding a threshold fraction of the maximum PSD.  
    - **`3dB`**: Computes bandwidth where the PSD is within -3 dB of its maximum value.  
    - **`OBW`**: Determines Occupied Bandwidth containing a specified percentage (e.g., 99%) of total signal power.  

---

### **Signal Analysis Functions**
14. **`estSNRandModulation.m`**  
    - Estimates the Signal-to-Noise Ratio (SNR) and determines the modulation scheme.  
    - **Output:** Estimated SNR and modulation type.

15. **`autoCorrAnalyze.m`**  
    - Performs autocorrelation analysis on the received signal to estimate synchronization and detect cyclic prefix boundaries.

16. **`reorderData.m`**  
    - Reorders the received data to correct subcarrier mapping.

17. **`softDemod.m`**  
    - Implements soft demodulation for advanced decoding techniques.  

18. **`optDetector.m`**  
    - Optimizes signal detection to reduce errors.  
    - **Output:** Detected symbols.

19. **`findMinDis.m`**  
    - Computes the minimum distance between received symbols and the ideal constellation points.  
    - **Output:** Decoded symbols with minimized errors.

20. **`RxSignalOFDM.mat`**  
    - A sample dataset for testing and validating the OFDM receiver.

---

### **Visualization and User Interface**
21. **`OFDMToolGUI.m`**  
    - A graphical user interface (GUI) for visualizing OFDM system parameters and results.

22. **`estSubSpc.m`**  
    - Estimates the subcarrier spacing of the OFDM system.

23. **`initializeParameters.m`**  
    - Initializes system parameters for simulation (e.g., FFT size, subcarrier allocation, cyclic prefix length, and modulation order).

---

## **Getting Started**

### **Requirements**
- MATLAB (R2021b or later is recommended)
- Signal Processing Toolbox (optional for advanced analysis)

### **Running the Simulation**
1. Clone the repository:
   ```bash
   git clone https://github.com/shayanzargari/OFDM-Received-Signal-Analysis-Tool.git
   Launch MATLAB.
   Runb the file OFDMToolGUI.m in the MATLAB editor.

### Acknowledgments
This tool was developed by Shayan Zargari as part of a wireless communication project. Contributions and feedback are welcome!
