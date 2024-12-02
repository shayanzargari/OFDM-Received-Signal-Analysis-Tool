# **OFDM Received Signal Analysis Tool**

## **Overview**
This MATLAB project provides a complete toolkit for simulating and analyzing Orthogonal Frequency Division Multiplexing (OFDM) systems. It includes functions for transmitter/receiver design, parameter initialization, signal processing, and performance evaluation.

---

## **Repository Structure**

### **Main Functions**
1. **`main.m`**  
   - The primary script for running the OFDM simulation. It integrates all subfunctions to simulate signal generation, transmission, reception, and analysis.

---

### **Transmitter Functions**
2. **`mapToPSKSyms.m`**  
   - Maps input bits to Phase Shift Keying (PSK) symbols for modulation.  
   - **Input:** Binary data.  
   - **Output:** Complex PSK symbols.

3. **`mapToQAMSyms.m`**  
   - Maps input bits to Quadrature Amplitude Modulation (QAM) symbols.  
   - **Input:** Binary data.  
   - **Output:** Complex QAM symbols.

4. **`mapToPAMSyms.m`**  
   - Maps input bits to Pulse Amplitude Modulation (PAM) symbols.  
   - **Input:** Binary data.  
   - **Output:** PAM symbols.

5. **`symToBits.m`**  
   - Converts symbols back to binary data after demodulation.  
   - **Input:** Received symbols.  
   - **Output:** Binary data.

6. **`qamToBits.m`**  
   - Demaps QAM symbols to binary data.  
   - **Input:** QAM symbols.  
   - **Output:** Binary data.

7. **`pskToBits.m`**  
   - Demaps PSK symbols to binary data.  
   - **Input:** PSK symbols.  
   - **Output:** Binary data.

8. **`pamToBits.m`**  
   - Converts PAM symbols back to binary data.  
   - **Input:** PAM symbols.  
   - **Output:** Binary data.

---

### **OFDM Core Functions**
9. **`calOFDMSymParams.m`**  
   - Calculates key OFDM symbol parameters, such as FFT size, cyclic prefix length, and subcarrier allocation.

10. **`removeCyclicPrefix.m`**  
    - Removes the cyclic prefix from the received OFDM signal.  
    - **Input:** Time-domain signal with cyclic prefix.  
    - **Output:** Signal without cyclic prefix.

11. **`processFFT.m`**  
    - Applies the FFT to convert the received signal to the frequency domain.  
    - **Input:** Time-domain signal.  
    - **Output:** Frequency-domain signal.

12. **`freqAnalyzer.m`**  
    - Analyzes the frequency components of the OFDM signal for spectrum visualization.  

13. **`calSignalBW.m`**  
    - Calculates the bandwidth of the OFDM signal.

---

### **Channel and Signal Analysis Functions**
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
