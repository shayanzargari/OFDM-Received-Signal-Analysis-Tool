# **OFDM Received Signal Analysis Tool**

## **Overview**
This MATLAB project provides a toolkit to analyze single-antenna OFDM receiver systems under AWGN noise. Several OFDM parameters are estimated blindly from the received waveform.

---

## **Repository Structure**

### **Main Functions**
- **`main.m`**: Integrates all subfunctions for estimating the received OFDM signal.
- **`OFDMToolGUI.m`**: GUI tool for interactive parameter initialization.
- **`initializeParameters.m`**: Defines default system parameters.

---

### **Modulation Functions**
- **`mapToPSKSyms.m`**: Maps input bits to PSK symbols.
- **`mapToQAMSyms.m`**: Maps input bits to QAM symbols.
- **`symToBits.m`**: Converts symbols to binary data.
- **`qamToBits.m`**: Demaps QAM symbols to binary data.
- **`pskToBits.m`**: Demaps PSK symbols to binary data.

---

### **OFDM Processing Functions**
- **`calOFDMSymParams.m`**:
  - Estimates the number of OFDM symbols using autocorrelation peaks.
  - Calculates cyclic prefix length.

- **`removeCyclicPrefix.m`**:
  - Removes cyclic prefixes from OFDM symbols.

- **`processFFT.m`**:
  - Performs FFT processing and normalization.

- **`reorderData.m`**:
  - Reorders FFT bins and extracts active subcarriers.

---

### **Signal Analysis Functions**
- **`estSNRandModulation.m`**:
  - Estimates SNR and identifies modulation type/order.

- **`autoCorrAnalyze.m`**:
  - Performs normalized autocorrelation and peak detection.

- **`calSignalBW.m`**:
  - Estimates bandwidth using threshold, 3 dB, or occupied bandwidth methods.

- **`estSubSpc.m`**:
  - Estimates OFDM subcarrier spacing.

- **`freqAnalyzer.m`**:
  - Performs FFT-based spectrum analysis.

---

### **Detection Functions**
- **`optDetector.m`**:
  - Performs hard or soft symbol detection.

- **`softDemod.m`**:
  - Computes log-likelihood ratios (LLRs).

- **`findMinDis.m`**:
  - Finds the nearest constellation point.

---

## **Requirements**
- MATLAB R2022b or newer recommended
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox (required for k-means option)
- Communications Toolbox (required for some modulation utilities)

---

## **Running the Tool**
1. Clone the repository:

```bash
git clone https://github.com/shayanzargari/OFDM-Received-Signal-Analysis-Tool.git
```

2. Open MATLAB.
3. Navigate to the repository folder.
4. Run:

```matlab
OFDMToolGUI
```

5. Load a `.mat` file containing `RxSignal`.
6. Configure parameters and start the simulation.

---

## **Notes**
- The tool currently supports PSK and QAM workflows.
- Input signals should be synchronized reasonably well for reliable blind estimation.
- Incorrect OFDM parameter estimation can affect FFT extraction and demodulation performance.

---

## **Acknowledgments**
Developed by Shayan Zargari as part of a wireless communication research project.
