# Censored harmonic averaging CFAR (CHA-CFAR) detector 

The sliding window Constant False Alarm Rate (CFAR) detector compares the Cell Under Test (CUT), denoted as $x_{\textrm{CUT}}$, with an estimate of the background noise level, denoted as $g({x_{1}}, {x_{2}}, \ldots, {x_{N}})$, multiplied by a positive constant $\tau$. The aim is to make a decision on the presence or absence of a target in the CUT as below

<img src="https://github.com/reza-ghaderi/CHA-CFAR/blob/main/assets/eq1.png" style="display:block;margin:auto;width:60%" alt="drawing" />

where the secondary data { ${x_1,\ldots,x_N}$ } is assumed to be independent and identically distributed (i.i.d.) random variables containing the background noise. The function $g(\cdot)$ maps the vector  $[x_1, \ldots, x_N]$  to a non-negative real number. The hypothesis testing problem in target detection involves making a decision between $H_0$ (indicating that $x_{\textrm{CUT}}$ contains only noise measurements) and ${H_1}$ (indicating that $x_{\textrm{CUT}}$ includes a target component within the noise returns). The threshold multiplier $\tau > 0$ is used to control the required Probability of False Alarm ($P_{\textrm{fa}}$). By adjusting the value of $\tau$, the desired level of false alarms can be achieved. For brevity, we will use $g$ to represent $g({x_{1}}, {x_{2}}, \ldots, {x_{N}})$ throughout this text.

The CHA-CFAR detector was proposed as a new CFAR detector in [1], specifically designed for dense outlier situations. Unlike other methods that eliminate outliers through censoring (as seen in OS-CFAR and TM-CFAR), CHA-CFAR softens the effect of outliers by utilizing the harmonic mean and the Ordered Statistics (OS) principle to estimate the noise level, as shown in equation (2):

<img src="https://github.com/reza-ghaderi/CHA-CFAR/blob/main/assets/eq2.png" style="display:block;margin:auto;width:60%" alt="drawing" />

where ${x_{(k)}}$ represents the $k$ th sample of ordered statistics. In CHA-CFAR detector, $k$ represents the number of eliminated secondary data with the smallest amplitudes. It is suggested to choose small values for $k$. In the following, $k$ is set to 8. Indeed, the function $g$ reduces the impact of outliers instead of rejecting them. Consequently, unlike other existing methods, the CHA-CFAR detector does not require prior knowledge of the number of outliers [1].

As mentioned, OS-CFAR and TM-CFAR detectors are based on the Ordered Statistics principle. Also, many CFAR techniques such as the weighted amplitude iteration (WAI)-CFAR detector use iterative algorithms. Some CFAR detectors are summarized in Table 1 [1]. The superiority of CHA-CFAR is illustrated through simulations and real Synthetic Aperture Radar (SAR) images in the following figures.

<p align="center"> Table 1. Summary of Various CFAR detectors Unified in (1).</p>
<img align="center" src="https://github.com/reza-ghaderi/CHA-CFAR/blob/main/assets/table.png" style="display:block;margin:auto;width:95%" alt="drawing" />
       

In the following simulations, we use the results of the CA-CFAR detector in a homogeneous environment as an optimal bound, which called Ideal. As expected, all detectors have the same performance in a homogeneous environment in Fig. 1 ($P_{\textrm{fa}} = 10^{-3}$ and  $N = 32$).

<img src="https://github.com/reza-ghaderi/CHA-CFAR/blob/main/figure/pd1.png" style="width:49%" alt="drawing" /><img src="https://github.com/reza-ghaderi/CHA-CFAR/blob/main/figure/pfa1.png" style="width:49%" alt="drawing">

<p align="center">Fig 1. $P_{\textrm{d}}$ and $P_{\textrm{fa}}$ plot versus SCR in a homogeneous environment.</p>
 
In the presence of outliers, the CHA-CFAR detector outperforms other methods without knowing the number of high-amplitude outliers and rejecting them. To demonstrate the robustness of the CHA-CFAR detector to a high number of outliers, 15 interfering targets are located in the reference window. As can be seen, the CHA-CFAR detector significantly outperforms others in Fig. 2. Although the performance of the WAI-CFAR detector is better than that of TM- and OS-CFAR detectors, it has a higher processing load. From the computational complexity point of view, the CHA-CFAR detector only needs to censor a few samples with the lowest amplitude, and any additional or iterative processing is not necessary to handle the outliers.

<img  src="https://github.com/reza-ghaderi/CHA-CFAR/blob/main/figure/pd2.png" style="width:49%" alt="drawing" /><img src="https://github.com/reza-ghaderi/CHA-CFAR/blob/main/figure/pfa2.png" style="width:49%" alt="drawing" />

<p align="center">Fig 2. $P_{\textrm{d}}$ and $P_{\textrm{fa}}$ plot versus SCR for 15 interfering targets.</p>


We compare all detectors for a large vessel as an extended target using real SAR images in Fig. 3. As can be seen, the CHA-CFAR detector exhibits the best detection performance.


<img src="https://github.com/reza-ghaderi/CHA-CFAR/blob/main/figure/fig02.png" style="" alt="drawing" />

<p align="center"> Fig 3. Detection performance comparison on extended target. SLI VV polarization SAR image is applied with $P_{\textrm{fa}} = 10^{−3}$ on TerraSAR-X image for different detectors.</p>


## How to Adjust the CFAR Parameters of Detectors Using Monte Carlo

To set the thresholds for CFAR detectors using Monte Carlo, follow these steps:

1. Open the `main_interfering_target.m` script and set the number of secondary data contaminated with outliers to zero (`Number_Interfering_Target = 0`).

2. Set the values for the false alarm probability ($P_{\textrm{fa}}$) and the number of secondary data $N$. The default values are `pfa = 10^-3` and  `window_size = 32` (Note that `N = window_size`).

3. In the CFAR Parameters section of the script, adjust the variables to achieve the desired $P_{\textrm{fa}}$ for all detectors through trial and error.

After adjusting the CFAR parameters to achieve the desired $P_{\textrm{fa}}$, see all detectors have the same $P_{\textrm{fa}}$ when there are no outliers.

## To further explore the detectors' behavior:

- Use the `interfering_target.m` script to observe outliers by adjusting the `Number_Interfering_Target` variable and observe its effect on the false alarm probability ($P_{\textrm{fa}}$) and detection probability ($P_{\textrm{d}}$) of different detectors.

- Employ the `edge.m` script to observe the impact of a sudden change in the power of background noise on the $P_{\textrm{fa}}$ and $P_{\textrm{d}}$ of different detectors.

- Utilize the `real_SAR_data.m` script to examine the $P_{\textrm{d}}$ results of different detectors on real SAR data. Select the area and push submit button to execute the script (Fig. 4).

   <img style="display: block;margin-left: auto;margin-right: auto;width:60%" src="https://github.com/reza-ghaderi/CHA-CFAR/blob/main/figure/fig01.png" alt="drawing" />
<p align="center"> Fig 4. The TerraSAR-X images is contains single-look complex images that were acquired from July 2008 to November 2009 over Barcelona, Spain. </p>

## Reference
[1] R. G. Zefreh, M. R. Taban, M. M. Naghsh, and S. Gazor, “Robust CFAR detector based on censored harmonic averaging in heterogeneous clutter,” IEEE Transactions on Aerospace and Electronic Systems, vol. 57, no. 3, pp. 1956–1963, Jun. 2021.


