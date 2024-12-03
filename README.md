# **OFDM Received Signal Analysis Tool**

## **Overview**
This MATLAB project provides a toolkit to analyze single-antenna OFDM receiver systems under AWGN noise. All necessary parameters are estimated blindly. 

---

## **Repository Structure**

### **Main Functions**
- **`main.m`**: Integrates all subfunctions for estimating the received OFDM signal.
- **`OFDMToolGUI.m`**: A GUI tool for interactive parameter initialization.
- **`initializeParameters.m`**: Defines essential system parameters for simulation.

---

### **Modulation Functions**
- **`mapToPSKSyms.m`**: Maps input bits to PSK symbols.
- **`mapToQAMSyms.m`**: Maps input bits to QAM symbols.
- **`symToBits.m`**: Converts symbols to binary data.
- **`qamToBits.m`**: Demaps QAM symbols to binary data.
- **`pskToBits.m`**: Demaps PSK symbols to binary data.

---

### **OFDM Processing Functions**
- **`calOFDMSymParams.m`**  
  - Estimates the number of OFDM symbols using lags from the autocorrelation of the received OFDM signal.
  - Calculates the cyclic prefix (CP) length based on the received OFDM signal length, number of OFDM symbols, and FFT size.

- **`removeCyclicPrefix.m`**  
  - Removes the cyclic prefix from each OFDM symbol in the received signal.

- **`processFFT.m`**  
  - Converts the OFDM signal from the time domain to the frequency domain using FFT.

- **`reorderData.m`**  
  - Processes FFT output to retain only occupied subcarriers by removing virtual subcarriers and reordering the data.
  - Extracts active subcarriers from the lower and upper spectrum, combines them into one signal, and removes unused subcarriers for better organization.

---

### **Signal Analysis Functions**
- **`estSNRandModulation.m`**  
  - Estimates the signal-to-noise ratio (SNR) for soft decoding and identifies the modulation scheme and order.  
  - **Method**: Uses autocorrelation to calculate SNR by measuring the signal peak and noise floor. Determines modulation type (e.g., PSK, QAM) by clustering signal amplitudes and mapping cluster counts.

- **`autoCorrAnalyze.m`**  
  - Performs autocorrelation on the received signal to detect peaks for cyclic prefix boundary estimation.  
  - **Method**: Computes normalized autocorrelation, detects peaks exceeding a threshold, and extracts corresponding lags, which are used in `calOFDMSymParams.m`.

- **`calSignalBW.m`**  
  - Computes the bandwidth of a signal based on its power spectral density (PSD) and user-defined criteria.  
  - **Method**: Evaluates bandwidth using threshold levels, -3 dB range, or occupied bandwidth containing a specified fraction of total power.

- **`estSubSpc.m`**  
  - Estimates the subcarrier spacing in an OFDM system.  
  - **Method**: Detects frequency peaks in the PSD, calculates pairwise frequency differences, and estimates spacing using either the mean or k-means clustering approach.

- **`freqAnalyzer.m`**  
  - Analyzes the frequency components of an OFDM signal for spectrum visualization.  
  - **Method**: Uses FFT-based spectral analysis to calculate and visualize the PSD.

---

### **Detection Functions**
- **`optDetector.m`**  
  - Optimally detects received symbols using hard or soft demodulation.  
  - **Method**: Maps received signals to the nearest constellation points (hard demodulation) or calculates LLRs (soft demodulation) for decoding.

- **`softDemod.m`**  
  - Performs soft demodulation by calculating log-likelihood ratios (LLRs) for each bit in the received symbols.  
  - **Method**: Computes LLRs based on the Euclidean distance between received symbols and constellation points, using Gray or natural coding.

- **`findMinDis.m`**  
  - Finds the nearest symbol in the constellation set based on the minimum distance criterion.  
  - **Method**: Computes the Euclidean distance between the received signal and all constellation points to identify the closest match.

---

## **Getting Started**

### **Requirements**
- MATLAB (R2022b or later recommended)
- Signal Processing Toolbox (optional for advanced analysis)

### **Running the Simulation**
1. Clone the repository:
   ```bash
   git clone https://github.com/shayanzargari/OFDM-Received-Signal-Analysis-Tool.git
   Launch MATLAB.
   Run file OFDMToolGUI.m in the MATLAB editor.

### Acknowledgments
This tool was developed by Shayan Zargari as part of a wireless communication project. Contributions and feedback are welcome!
