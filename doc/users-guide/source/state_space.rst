Time Domain Hydrodynamic Coefficients
========================================

The instantaneous wave radiation force \cite{Cummins}, know as the Cummins Equation, can be written as:

.. math::

	& \mathbf{f_{r}}(t) = - \mathbf{\mu_{\infty}} \mathbf{\ddot{\zeta}} \left( t \right) - \mathbf{\lambda_{\infty}} \mathbf{\dot{\zeta}} \left( t \right) - \int_{-\infty}^{t} \mathbf{K_{r}} \left( t - \tau \right) \mathbf{\dot{\zeta}} \left( \tau \right) d\tau~~,&

	.. where $\mathbf{\mu_{\infty}}$ is the infinite frequency added mass matrix, $\mathbf{\lambda_{\infty}}$ is the infinite frequency wave damping matrix, $\mathbf{K_{r}}$ is a causal function known as the radiation impulse response function, and $\mathbf{\zeta}$ is the six degree of freedom vector of body motion.  This representation can be inserted into the time domain equation of motion for a generic floating body:
	.. & \left[ \mathbf{M} + \mathbf{\mu_{\infty}} \right] \mathbf{\ddot{\zeta}} \left( t \right) + \lambda_{\infty} \dot{\zeta} \left( t \right)+ \int_{-\infty}^{t} \mathbf{K_{r}}  \left(t - \tau \right) \dot{\zeta} \left( \tau \right) d\tau + \mathbf{C}\zeta \left( t \right)= \mathbf{f_{e}}(t)~~,&

.. where $\mathbf{M}$ is the mass matrix of the floating body, $\mathbf{C}$ is the linear restoring matrix, and $\mathbf{f_{e}}$ is the wave exciting force vector.  The convolution term in Eqn.~(\ref{eqn:Krconv}) captures the effect that the changes in momentum of the fluid at a particular time affects the motion at future instances, which can be considered as a fluid memory effect.

.. The relations between the time and frequency domain coefficients were derived in \cite{OT} as follows:

.. \begin{eqnarray}
.. \label{eqn:dampingKr}
.. \mathbf{\lambda} \left( \sigma \right) & = & \mathbf{\lambda}_{\infty} + \int_{0}^{\infty} \mathbf{K_{r}} \left( t \right) \cos \sigma t dt~~,\\ 
.. \label{eqn:addedKr}
.. \mathbf{\mu} \left( \sigma \right) & = & \mathbf{\mu}_{\infty} -  \frac{1}{\sigma} \int_{0}^{\infty} \mathbf{K_{r}} \left( t \right) \sin \sigma t dt~~,
.. \end{eqnarray}

.. where $\mu\left( \sigma \right)$ and $\lambda\left( \sigma \right)$ are the frequency dependent hydrodynamic
.. radiation coefficients commonly known as the added mass and wave damping.

.. \section{Calculation of $K_{r}$}

.. The radiation impulse response function can be calculated by taking the inverse Fourier transform of the hydrodynamic radiation coefficients as found by:

.. \begin{eqnarray}
.. \label{eqn:Kradd}
.. & \mathbf{K_{r}} \left( t \right) = -\frac{2}{\pi} \int_{0}^{\infty} \sigma \left[ \mathbf{\mu} \left( \sigma \right) - \mathbf{\mu_{\infty}} \right] \sin \sigma t d\sigma~~,&\\
.. \label{eqn:Krdamp}
.. & \mathbf{K_{r}} \left( t \right) = \frac{2}{\pi} \int_{0}^{\infty} \left[ \mathbf{\lambda} \left( \sigma \right) - \mathbf{\lambda}_{\infty} \right] \cos \sigma t d\sigma~~, &
.. \end{eqnarray}

.. where the frequency response of the convolution will be given by:

.. \begin{eqnarray}
.. \mathbf{K_{r}} \left( j\sigma \right) &=& \int_{0}^{\infty} \mathbf{K_{r}} e^{-j\sigma \tau} d\tau~~\nonumber \\
.. &=& \left[ \lambda \left( \sigma \right) - \lambda_{\infty} \right] + j \sigma \left[\mu \left( \sigma \right) - \mu_{\infty} \right]~~.
.. \end{eqnarray}

.. For most single floating bodies $\lambda_{\infty} = 0$ and Eqn. (\ref{eqn:Krdamp}) converges significantly faster than Eqn. (\ref{eqn:Kradd}).  The hydrodynamic coefficients are solely a function of geometry and the frequency-dependent added mass, wave damping, and wave-exciting force values can be obtained from boundary element methods such as WAMIT.

.. \subsection{Frequency-domain properties of $K_{r}$}
.. The wave damping tends to zero as $\sigma \rightarrow 0$, and the difference in $\mathbf{\mu} \left( 0 \right) - \mathbf{\mu_{\infty}}$ is finite thus:

.. \begin{eqnarray}
.. \lim_{\sigma \to 0} \mathbf{K_{r}} \left( j \sigma \right) = 0.
.. \end{eqnarray}

.. Furthermore, wave damping tends to zero as $\sigma \rightarrow \infty$, providing:

.. \begin{eqnarray}
.. \lim_{\sigma \to \infty} \sigma \left[ \mathbf{\mu} \left( \sigma \right) - \mathbf{\mu_{\infty}} \right] = \int_{0}^{\infty} \mathbf{K_{r}} \left( t \right) \sin \sigma \tau d\tau = 0
.. \end{eqnarray}
.. which as a consequence of the Riemman-Lebesgue Lemma and Eqn.~(\ref{eqn:addedKr}) leads to:
.. \begin{eqnarray}
.. \lim_{\sigma \to \infty} \mathbf{K_{r}} \left( j \sigma \right) = 0.
.. \end{eqnarray}

.. \subsection{Time-domain properties of $K_{r}$}

.. The following relations are satisfied by the convolution terms.  It follows from Eqn.~(\ref{eqn:Krdamp}):

.. \begin{eqnarray}
.. \label{eqn:InitTime}
.. \mathbf{K_{r}} \left( 0 \right) = \frac{2}{\pi} \int_{0}^{\infty} \left[ \mathbf{\lambda} \left( \sigma \right) - \mathbf{\lambda}_{\infty} \right] d\sigma \neq 0 < \infty~~.
.. \end{eqnarray}

.. The input-output stability of the convolution term can be verified by taking the limit as $t \rightarrow \infty$:

.. \begin{eqnarray}
.. \lim_{t\rightarrow \infty} \mathbf{K_{r}} \left( t \right) = \lim_{t \rightarrow \infty} \frac{2}{\pi} \int_{0}^{\infty} \left[ \mathbf{\lambda} \left( \sigma \right) - \mathbf{\lambda}_{\infty} \right] d\sigma = 0~~,
.. \end{eqnarray}

.. which follows from the Riemann-Lebesgue Lemma.

.. \section{State Space Representation of $K_{r}$}

.. In is highly desirable to represent the convolution integral shown in Eqn. (\ref{eqn:Krconv}) in state space (SS) form \cite{YF}.  This has been shown to dramatically increase computational speeds \cite{TPT} and allow for conventional control methods, that rely on linear state space models, to be used.  An approximation will need to be made as $K_{r}$ is solved from a set of partial differential equations where as a linear state space is constructed from a set of ordinary differential equations.  In general it is desired to make the following approximation:

.. \begin{eqnarray}
.. \mathbf{\dot{X}_{r}} \left( t \right) = \mathbf{A_{r}} \mathbf{X_{r}} \left( t \right) + \mathbf{B_{r}} \mathbf{\dot{\zeta}} (t);~~\mathbf{X_{r} }\left( 0 \right) = 0~~, \nonumber \\
.. \label{eqn:Conv2ss}
.. \int_{-\infty}^{t} \mathbf{K_{r}} \left( t- \tau \right) d\tau \approx \mathbf{C_{r}} \mathbf{X_{r}} \left( t \right) + \mathbf{D_{r}} \mathbf{\dot{\zeta}} \left( t \right)~~,
.. \end{eqnarray}

.. with $\mathbf{A_{r}},~\mathbf{B_{r}},~\mathbf{C_{r}},~\mathbf{C_{r}},~\mathbf{D_{r}}$ being the time-invariant state, input, output, and feed through matrices, while $\dot{\zeta}$ is the input to the system.

.. \subsection{Calculation of $K_{r}$ from State Space Matrices}

.. The impulse response of a single-input state-space model represented by:

.. \begin{eqnarray}
.. \dot{x} &=&  \mathbf{A_{r}}x + \mathbf{B_{r}} u~~,\\
.. y &=& C_{r} \mathbf{x}~~,
.. \end{eqnarray}

.. is the same as the unforced response, ($u=0$), with the initial states set to $\mathbf{B_{r}}$:

.. \begin{eqnarray}
.. \dot{x} &=& \mathbf{A_{r}} x~~,~~x(0)= \mathbf{B_{r}}~~,\\
.. y &=& \mathbf{C_{r}} x~~,
.. \end{eqnarray}

.. The impulse response of a continuous system with a nonzero $D$ matrix is infinite at $t=0$, therefore the lower continuity value $\mathbf{C_{r}}\mathbf{B_{r}}$ is reported at $t=0$.  \\
.. \indent The general solution to a linear time invariant (LTI) system is given by:

.. \begin{eqnarray}
.. x(t) = e^{\mathbf{A_{r}}t} x(0) + \int_{0}^{t} e^{\mathbf{A_{r}}(t-\tau)} \mathbf{B_{r}} u (\tau) d\tau~~,
.. \end{eqnarray}

.. where $e^{\mathbf{A_{r}}}$ is called the matrix exponential and the calculation of $K_{r}$ follows:

.. \begin{eqnarray}
.. K_{r}(t) = \mathbf{C_{r}}e^{\mathbf{A_{r}}t}\mathbf{B_{r}}~~.
.. \end{eqnarray}

.. \section{Laplace Transform and Transfer Function}

.. The Laplace transform is a common integral transform in mathematics.  It is a linear operator of a function that transforms $f(t)$ to a function $F \left( s \right)$ with complex argument $s$, which is calculated from the integral

.. \begin{eqnarray}
.. F \left( s \right) = \int_{0}^{\infty} f \left( t \right) e^{-st} dt~~,
.. \end{eqnarray}

.. where the derivative of $f \left( t \right)$ has the following laplace transform

.. \begin{eqnarray}
.. sF \left( s \right) = \int_{0}^{\infty} \frac{df \left( t \right)}{dt} e^{-st} dt~~,
.. \end{eqnarray}

.. The Laplace transform has some useful relationships, the first relation used later in this document is the initial value theorem:
.. \begin{eqnarray}
.. f \left( 0^{+} \right) = \lim_{s \rightarrow \infty} s F \left( s \right)~~,
.. \end{eqnarray}

.. and the final value theorem:
.. \begin{eqnarray}
.. f \left( \infty \right) = \lim_{s \rightarrow 0} s F \left( s \right)~~.
.. \end{eqnarray}

.. Consider a linear input/output system described by the following differential equation

.. \begin{eqnarray}
.. \label{eqn:ODE}
.. \frac{d^{m}y}{dt^{m}}+a_{1}\frac{d^{m-1}y}{dt^{m-1}}+\ldots + a_{m}y = b_{0}\frac{d^{n}u}{dt^{n}} + b_{1}\frac{d^{n}u}{dt^{n}} + \ldots + b_{n} u~~,
.. \end{eqnarray}

.. where $y$ is the output and $u$ the input.  After taking the Laplace Transform of Eqn.~(\ref{eqn:ODE}), the differential equation is now completely described by two polynomials

.. \begin{eqnarray}
.. & A \left( s \right) = s^{m} + a_{1} s^{m-1} + \ldots + a_{m-1}s + a_{m}~~,& \\
.. & B \left( s \right) = b_{0}s^{n} + b_{1}s^{n-1} + \ldots + b_{n-1}s + b_{n}~~,&
.. \end{eqnarray}

.. where $A \left( s \right)$ is characteristic polynomial of the system.  The polynomials can be inserted into Eqn.~(\ref{eqn:ODE}) leading to:

.. \begin{eqnarray}
.. \label{eqn:FDODE}
.. G \left( s \right)=\frac{Y\left( s \right)}{U \left( s \right)} = \frac{s^{m} + a_{1} s^{m-1} + \ldots + a_{m-1}s + a_{m} }{b_{0}s^{n} + b_{1}s^{n-1} + \ldots + b_{n-1}s + b_{n}}~~,
.. \end{eqnarray}

.. where $G\left( s \right)$ is the transfer function.  If the state, input, output, and feedthrough matrices are known the transfer function of the system can be calculated from:

.. \begin{eqnarray}
.. G \left( s \right) = C \left( sI - A \right)^{-1}B + D~~.
.. \end{eqnarray}

.. The frequency response of the system can be obtained by substituting $j\sigma$ for $s$, for the frequency range of interest, where the magnitude and phase of $G \left( j\sigma \right)$ can be calculated with the results commonly presented in a Bode plot.

.. \section{Realization Theory}
.. The state space realization of the hydrodynamic radiation coefficients can be pursued in the frequency domain (FD) or the time domain (TD).  

.. \subsection{Frequency Domain}

.. The transfer function created by the state space approximation can be estimated using regression in the frequency domain.  In this analysis the frequency response $\mathbf{K_{r}} \left(j \sigma\right)$ of the impulse response function is used to fit a rational transfer function $G\left(s\right)$, which can then be converted to a state-space model.  The general form of a single input single output (SISO) transfer function of order $n$, and relative degree $n-m$ is given by:

.. \begin{eqnarray}
.. &G \left( s, \gamma \right) = \frac{A \left( s, \gamma \right)}{B \left( s, \gamma \right)} = \frac{s^{m} + a_{1}s^{m-1} + \ldots + a_{m}}{b_{0}s^{n} + b_{1}s^{n-1} + \ldots + b_{n}}~~,& \\
.. &\gamma = [a_{1},~\ldots,~a_{m},~b_{0},~\ldots~,b_{n}]^{T}~~.&
.. \end{eqnarray}

.. One method for estimating the parameters of $\gamma$ is to use a nonlinear least squares solver.  The estimation can only be made after the order and relative degree of $G\left(s\right)$ is decided at which point the following least squares minimization can be performed:

.. \begin{eqnarray}
.. \label{eqn:NLLS}
.. \gamma^{*} = \text{arg}~\underset{\gamma}{\text{min}} \sum_{i} w_{i} \left| \mathbf{K_{r}} \left( j\sigma \right) - \frac{ A \left( j \sigma, \gamma \right)}{B \left( j \sigma, \gamma \right)}   \right|^{2}~~,
.. \end{eqnarray}

.. where $w_{i}$ is an individual weighting value for each frequency.  An alternative that linearizes Eqn.~(\ref{eqn:NLLS}) can be formed by choosing the weights as:

.. \begin{eqnarray}
.. w_{i} = \left|B \left( j\sigma , \gamma \right) \right|^{2}~~,
.. \end{eqnarray}

.. which reduces the problem to 

.. \begin{eqnarray}
.. \label{eqn:NLLS}
.. \gamma^{*} = \text{arg}~\underset{\gamma}{\text{min}} \sum_{i} \left|  B  \left( j\sigma , \gamma \right) \mathbf{K_{r}} \left( j\sigma \right) - A \left( j \sigma, \gamma \right)   \right|^{2}~~,
.. \end{eqnarray}

.. which is affine in the parameter $\gamma$; and satisfies the normal equations of a linear least squares problem.  However, depending on the data to be fitted the transfer function may be unstable as stability is not a constraint used in the minimization.  If this occurs the unstable poles are reflected about the imaginary axis.

.. The relative order of the transfer function can be determined from the initial value theorem described in Eqn.~(\ref{eqn:InitTime}):

.. \begin{eqnarray}
.. \lim_{t\rightarrow0} \mathbf{K_{r}} \left( t \right) = \lim_{s\rightarrow \infty} s\mathbf{K_{r}} \left( s \right) = \lim_{s\rightarrow \infty} s\frac{A \left( s \right)}{B \left( s \right) }   = \frac{s^{m+1}}{b_{0}s^{n}}~~,
.. \end{eqnarray}

.. therefore in order for the above limit to be finite and nonzero the relative order of the transfer function  must be one $\left( n = m + 1\right)$.  If the user has access to the MATLAB Signal Processing Toolbox \cite{MATLAB}, the function \textit{\textbf{invfreqs}} will perform the frequency-domain realization as described in this section.

.. \subsection{Time Domain}

.. This consists of finding the minimal order of the system and the discrete time state matrices ($\mathbf{A_{d}},~\mathbf{B_{d}},~\mathbf{C_{d}},~\mathbf{D_{d}}$) from a matrix assembly from the samples of the impulse response function.  This problem is easier to handle for a discrete-time system than for continuous-time, the reason being that impulse response function of a discrete-time system is given by the Markov parameters of the system:

.. \begin{eqnarray}
.. \mathbf{\tilde{K}_{r}} \left( t_{k} \right) = \mathbf{C_{d}}\mathbf{A_{d}}^{k}\mathbf{B_{d}}~~,
.. \end{eqnarray}

.. where $t_{k}=k\Delta t$ for $k=0,~1,~2,~\ldots$ with $\Delta t$ being the sampling period.  The above equation does not include the feedthrough matrix as it results in an infinite value at $t=0$ and in order to keep the causality of the system.\\
.. \indent The most common algorithm to obtain the realization is to perform a Singular Value Decomposition (SVD) on the Hankel matrix of the impulse response function as proposed by Kung \cite{Kung}.  The order of the system and state-space parameters are determined from the number of significant values and the factors of the SVD.  Performing an SVD produces:

.. \begin{eqnarray}
.. & H = \begin{bmatrix}
..        \mathbf{K_{r}}(2) & \mathbf{K_{r}}(3) & \ldots & \mathbf{K_{r}}(n) \\
..        \mathbf{K_{r}}(3) & \mathbf{K_{r}}(4) & \ldots & 0 \\
..        \vdots & \vdots & \ddots & \vdots \\
..        \mathbf{K_{r}}(n) & 0 & \cdots & 0
..       \end{bmatrix} &\\ 
.. & H = \mathbf{U} \Sigma \mathbf{V^{*}} &
.. \end{eqnarray}

.. where $H$ is the Hankel matrix and $\Sigma$ is a diagonal matrix containing the Hankel singular vales in descending order.  Examination of the Hankel singular values reveals there are only a small number of significant states and model reduction can be performed without a significant loss in accuracy \cite{KHE, TPT}.  Further detail into the SVD method and calculation of the state space parameters will not be discussed and the reader is referred to \cite{Kung, KHE, TPT}.  If the user has access to the MATLAB Robust Control Toolbox \cite{MATLAB}, the function \textit{\textbf{imp2ss}} will perform the time-domain realization as described in this section.

.. \section{Quality of the Regression}
.. Assessing the quality of the model can be done in several ways. As described before, the frequency-domain model is evaluated using the frequency-response, while the time-domain models are evaluated by their impulse-response. In order to evaluate these responses, the $R^{2}$ value is computed using:

.. \begin{eqnarray}
.. R^{2} = 1 - \frac{ \sum \left( \mathbf{K_{r}} - \mathbf{\tilde{K}_{r}} \right)^{2} }{ \left( \mathbf{K_{r}}  - \mathbf{\overline{K}_{r}} \right)^{2}}
.. \end{eqnarray}

.. were $\mathbf{\tilde{K}_{r}}$ represents the state space model estimates and $\mathbf{\bar{K}_{r}}$ is the mean value of the reference (true) values. The summations are performed across all frequencies providing a measure of the variability of the function that is captured by the model. The closer to one, the better is the quality of the fit.

.. \section{Example Application}

.. A truncated cylindrical floater has been chosen as a sample geometry to compare the frequency- and time-domain realizations.  The floater geometric parameters and tank dimensions are found in Table~\ref{tab:1} and the hydrodynamic radiation coefficients were calculated from \cite{Yeung}.  The hydrodynamic coefficients were calculated between 0.05 - 11 rad/s at 0.05 rads and are plotted in Fig.~\ref{fig:lambdamu}.  In this example, an $R^{2}$ threshold of 0.99 was set for the frequency dependent wave damping or added mass fit, though modifications can be made to the code to compare the impulse response function in the time domain.  The results from the realizations can be found in Fig.~\ref{fig:Kr_TDvsFD} for the impulse response function and the frequency dependent hydrodynamic coefficients.  It is clear for this example that the time-domain characterization outperforms the frequency-domain regression, with the major difference appearing in the estimation of the wave damping.  It was found that the time-domain characterization had better stability than the frequency-domain as it does not require reflection of the unstable poles about the imaginary axis.  It is suggested that users check the quality of their hydrodynamic data with the custom MATLAB functions that perform the realizations without running the full WEC-Sim code.  These codes allow users to set various fitting parameters and has an iterative interface that shows how the fit changes with increasing state space order.  The user can fine tune the input parameters into WEC-Sim so the desired performance is achieved.

.. \begin{table}
.. \begin{center}
.. \caption{Floater geometric parameters and tank dimensions.\label{tab:1}}
.. \begin{tabular}{|c||c|}
.. \hline
.. $D$ (dia) = 2 r = 0.273 m              & $d$ (draft) = 0.6126 \\
.. \hline
.. (Tank width, $w_{T}$ )/D = 8.94 &  (Tank depth, h)/$w_{T}$ = 0.60\\
.. \hline
.. \end{tabular}
.. \end{center}
.. \end{table}

.. \begin{figure}[htc]
..     \centering
..     \includegraphics[width =0.75\textwidth]{../Conv2ss_HydroCoupling/epsFigures/ADM_WD_JOE.eps}
..     \caption{Frequency Domain Hydrodynamic Coefficients.}
..     \label{fig:lambdamu}
.. \end{figure}

.. \begin{figure}[htc]
..     \centering
..     \includegraphics[width =0.75\textwidth]{../Conv2ss_HydroCoupling/epsFigures/Kr_TDvsFD.eps}
..     \includegraphics[width = \textwidth]{../Conv2ss_HydroCoupling/epsFigures/Kw_TDvsFD.eps}
..     \caption{Comparison of Results from Time- and Frequency Domain Realizations.}
..     \label{fig:Kr_TDvsFD}
.. \end{figure}

.. \clearpage

.. \section{WEC-Sim Implementation - State Space Realization}

.. \subsection{Simulation Class Update}

.. \begin{itemize}
..   \item simu.convCalc
.. \begin{itemize}
..   \item Set at 0 to perform convolution integration for wave radiation force calculation
..   \item Set at 1 to perform state space integration for wave radiation force calculation
..   \item Set at 2 to perform state space integration for wave radiation force calculation use an imported state space representation of the convolution integral
.. \end{itemize}
..   \item simu.ssReal
.. \begin{itemize}
..   \item Set to 'TD' to perform time domain realization
..   \item Set to 'FD' to perform frequency domain realization, requires MATLAB Signal Processing Toolbox
.. \end{itemize}
..   \item simu.ssMax
.. \begin{itemize}
..   \item The upper limit on the state space order constructed from realization program
.. \end{itemize}
..   \item simu.R2Thresh
.. \begin{itemize}
..   \item The threshold set on $R^{2}$ to stop the realization program
.. \end{itemize}
.. \item simu.ssImport
.. \begin{itemize}
..   \item Label of the .mat file used to import the predefined state space representation of the convolution integral
..   \item The .mat file must include a structure variable called "radSS."  The structure will be of size "n" with matrices for $\mathbf{Af}$, $\mathbf{Bf}$, $\mathbf{Cf}$, $\mathbf{Cf}$
..   \item radSS(body number).A, radSS(body number).B, radSS(body number).C, radSS(body number).D
..   \item The StateSpacePreprocess script can be used to construct the radSS.mat file needed for import.  It also outputs a radSSest.mat file that can be used to plot the results from the state space realization using the PlotStateSpacePreprocess script to check if the desired accuracy is achieved.
..   \item The StateSpacePreprocess script reads the wecSimInputFile in the working directory of the model.  It requires the user to chose the type of realization (frequency or time domain), the maximum state space size, $R^{2}$ threshold, and wither hydrodynamic coupling terms will be included.  Note that the CITime should be chosen sufficiently long so the impulse response function is fully defined, i.e. asymptotes to 0.
..   \item The PlotStateSpacePreprocess script will plot the results from StateSpacePreprocess from the ``ssImport\_est.mat'' file that created by StateSpacePreprocess.  This allows the user to evaluate if the realization process completed properly and if the tolerance on the $R^{2}$ must be increased.
.. \end{itemize}
.. \end{itemize}

.. \subsection{Body Class Update}

.. \begin{itemize}
..   \item body.hydroForce.ssRad [ 6 x 6 \textbf{struct}]
.. \begin{itemize}
..   \item  $A_{ij}$, State Matrix for motion \textbf{[ i, j ]} of size \textbf{[ $\text{n}_{ij}$, $\text{n}_{ij}$ ]}
..   \item  $B_{ij}$, Input Matrix  for motion \textbf{[ i, j ]} of size \textbf{[ $\text{n}_{ij}$, 1 ]}
..   \item  $C_{ij}$, Output Matrix  for motion \textbf{[ i, j ]} of size \textbf{[ 1, $\text{n}_{ij}$ ]}
..   \item  $D_{ij}$, Feedthrough Matrix  for motion \textbf{[ i, j ]} of size \textbf{[ 1, 1 ]}
.. \end{itemize}
..   \item body.hydroForce.ssRadconv [ 6 x 6 \textbf{double}]
.. \begin{itemize}
..   \item  Denotes the convergence of the time domain realization
..   \item  $0$, imported hydrodynamic coefficients are zero
..   \item  $1$, a state space representation that reaches the $R^{2}$ threshold has been reached
..   \item  $2$, the state space representation did not reach the $R^{2}$ threshold and code uses the highest order state, $ssMax$, for computation.  User is suggested to check hydrodynamic radiation coefficients and then increase $ssMax$.
.. \end{itemize}
..   \item body.hydroForce.ssRadf [ 1 x 1 \textbf{struct}]
.. \begin{itemize}
..   \item $\mathbf{Af}$, Assembled State Matrix which consists of all $A_{ij}$ state matrices
..   \item $\mathbf{Bf}$, Assembled Input Matrix which consists of all $B_{ij}$ state matrices
..   \item $\mathbf{Cf}$, Assembled Output Matrix which consists of all $C_{ij}$ state matrices
..   \item $\mathbf{Df}$, Assembled Feedthrough Matrix which consists of all $D_{ij}$ state matrices
.. \end{itemize}
..   \item body.hydroForce.irkbss [ (simu.CITime/simu.dt + 1) x 6 x 6 \textbf{double}]
.. \begin{itemize}
..   \item Impulse response function as calculated from state space representation
.. \end{itemize}
..   \item body.hydro.data.fDampingest [ 6 x 6 x (\# of WAMIT Frequencies) \textbf{double}]
.. \begin{itemize}
..   \item The real component of the frequency response of the state space realization corresponding to the frequency dependent wave damping
.. \end{itemize}
..   \item body.hydro.data.fAddedMassest [ 6 x 6 x (\# of WAMIT Frequencies) \textbf{double}]
.. \begin{itemize}
..   \item The imaginary component of the frequency response of the state space realization corresponding to the frequency dependent added mass
.. \end{itemize}
.. \end{itemize}

.. \subsection{Final Matrix Assembly}

.. The hydrodynamic radiation coefficients are used to calculate the impulse response function $\mathbf{K}$, which is then used to calculate the state space representation as follows: 

.. \begin{eqnarray}
.. F_{rad-damp} & = & -\int_{0}^{t} \mathbf{K} \left( t - \tau \right) \dot{\mathbf{X}} \left( \tau \right) d\tau~~\\
.. & \approx & - \mathbf{Cf} \mathbf{X_{r}} - \mathbf{Df}\dot{\mathbf{X}} \\
.. & & \mathbf{\dot{X}_{r}} = \mathbf{Af} \mathbf{X_{r}} + \mathbf{Bf} \dot{\mathbf{X}}~~. \nonumber
.. \end{eqnarray}

.. The built in Simulink state space block is used to calculate the instantaneous wave radiation force as shown in Fig.~\ref{fig:statespace}.  The easiest use of the state space block requires the construction of a combined state, input, and output matrix as shown in Eqn.~(\ref{eqn:Af})-(\ref{eqn:Cf}), note that $\mathbf{Df}$ has been artificially been set to 0 as it provided better matching with the frequency domain hydrodynamic coefficients.

.. \begin{figure}[htc]
..     \centering
..     \includegraphics[width = 0.50\textwidth ]{../Conv2ss_HydroCoupling/epsFigures/statespace.eps}
..     \caption{State Space Action Block.}
..     \label{fig:statespace}
.. \end{figure}

.. \begin{eqnarray}
.. \label{eqn:Af}
.. & \mathbf{Af} = \begin{bmatrix}
.. 	A_{1,1} 	& 0		& \cdots	& 0		& 0		& \cdots 	& 0		& 0     		\\
.. 	0 		& A_{1,2}	& \cdots 	& 0		& 0		& \cdots 	& 0		& 0		\\
.. 	\vdots		& \vdots 	& \ddots	& \vdots	& \vdots	& \cdots 	& 0		& 0		\\
.. 	0		& 0		& \cdots 	& A_{1,2\times \text{n}}	& 0		& \dots 	& 0		& 0		\\
.. 	0		& 0		& \cdots 	& 0		& A_{2,1}	& \cdots 	& 0		& 0		\\
.. 	\vdots		& \vdots	& \cdots 	& \vdots	& \vdots	& \ddots 	& \vdots	& \vdots	\\
.. 	0		& 0		& \cdots 	& 0		& 0		& \cdots 	& A_{2\times \text{n}, 2\times \text{n} -1} 	& 0		\\
.. 	0		& 0		& \cdots 	& 0		& 0		& \cdots   	& 0 		& A_{2\times \text{n}, 2\times \text{n}}	
..      \end{bmatrix} ~~,~~ &
.. \end{eqnarray}
.. \begin{eqnarray}
.. \label{eqn:XrBf}
.. & \mathbf{X_{r}} = \begin{bmatrix}
.. 	X_{11} 	\\
.. 	\vdots 	\\
.. 	X_{1,2\times \text{n}}	\\
.. 	X_{21}	\\
.. 	\vdots		\\
.. 	X_{2,2\times \text{n}}	\\
.. 	\vdots		\\
.. 	X_{2\times \text{n},1}	\\
.. 	\vdots 	\\
.. 	X_{2\times \text{n}, 2 \times \text{n}}				
..      \end{bmatrix}~~,~~
..  \mathbf{Bf} = \begin{bmatrix}
.. 	B_{11} 	& 0		& \cdots		& 0		\\
.. 	0		& B_{12}	& \cdots 		& 0		\\
.. 	\vdots		& \vdots	& \ddots		& 0		\\
.. 	0		& 0		& \cdots		& B_{1, 2 \times \text{n}}		\\
.. 	B_{2,1}	& 0		& \cdots		& 0		\\
.. 	\vdots		& \vdots	& \ddots		& 0		\\
.. 	0		& 0 		& \cdots		& B_{2, 2\times \text{n}}		\\
.. 	\vdots		& \vdots	& \ddots		& \vdots	\\
.. 	0		& \cdots	& B_{2 \times  \text{n}, 2 \times  \text{n} - 1}		& 0	\\
.. 	0		& 0		& \cdots		& B_{2 \times  \text{n},2 \times  \text{n}}		
..      \end{bmatrix}~~,~~ &
.. \end{eqnarray}
.. \begin{eqnarray}
.. \label{eqn:Cf}
.. & \mathbf{Cf} = \begin{bmatrix}
.. 	C_{1,1} 	& \cdots	& C_{1,2\times \text{n}}		& 0		& \cdots	& 0		& \cdots 		& 0	& \cdots 	& 0	\\
.. 	0		& \ddots	& 0					& C_{2,1}	& \cdots 	& C_{2, 2 \times \text{n}}		& \cdots 		& 0	& \ddots 	& 0	\\
.. 	\vdots		& \cdots 	& \vdots				& \vdots	& \cdots	& \vdots	& \cdots 		& \vdots 		& \cdots 	& \vdots  \\
.. 	0		& \cdots 	& 0					& 0		& \cdots	& 0		& \cdots 		& C_{2 \times \text{n},1} 		& \cdots 	& C_{2 \times \text{n},2 \times \text{n}}		
..      \end{bmatrix} ~~,~~& \\
.. \label{eqn:Df}
.. & \mathbf{Df} = \begin{bmatrix}
.. 	0 		& \cdots	& 0		\\
.. 	\vdots		& \ddots	& \vdots	\\
.. 	0		& \cdots 	& 0
..      \end{bmatrix}~~.~~ &
.. \end{eqnarray}

.. Alterations to the body block were made in the \textit{Wave-Radiation-Forces-Calculation} subsystem where an \textit{If} function was inserted to determine if WEC-Sim should calculate the wave radiation force from the convolution integral or the state space integration, see Fig.~\ref{fig:Wave-Radiation}.  This prevents double calculating the wave radiation force reducing computational time.

.. %\begin{figure}[htc]
.. %    \centering
.. %    \includegraphics[width = \textheight, angle =90]{../Conv2ss_HydroCoupling/epsFigures/Float.eps}
.. %    \caption{Body block for Float in RM3-2Body-3DOF-0PT0.slx Simulink Model.}
.. %    \label{fig:Float}
.. %\end{figure}


.. \begin{figure}[htc]
..     \centering
..     \includegraphics[width = \textheight, angle =90 ]{../Conv2ss_HydroCoupling/epsFigures/simmodel.eps}
..     \caption{Updated Wave-Radiation-Force-Calculation subsystem.}
..     \label{fig:Wave-Radiation}
.. \end{figure}

.. \clearpage

.. \section{Hydrodynamic Cross Coupling Coefficients}

.. It is important to review  the hydrodynamic radiation coefficients obtained from WAMIT to ensure results have converged and agree with known physical properties.  The quality of the impulse response function is highly dependent on the quality and density of points over the range of wave frequencies.  At the moment, this example only includes hydrodynamic coefficients at 50 wave periods spaced at a 1 s interval and interpolation is used to calculate the impulse response function.  This is satisfactory for the primary diagonal directions of motion; however, the off diagonal matrices have higher oscillations that are likely due to rather coarse distribution of hydrodynamic coefficients in the high frequency regime.  It is also possible to perform a symmetry check about the main diagonal due to the reciprocity relationship \cite{Newman}, which states that cross diagonal hydrodynamic coefficients are equal,

.. \begin{eqnarray}
.. \mu_{ij} + \frac{\lambda_{ij}}{-i\sigma} = \mu_{ji} + \frac{\lambda_{ji}}{-i\sigma}~~.
.. \end{eqnarray}

.. For a single floating body, the time domain equation of motion given by Eqn.~(\ref{eqn:EOM1Body}) may be used, but if a wave energy converter consists of multiple bodies, especially in close proximity, additional interaction forces arise.  These forces are generated because motion of nearby floating bodies alter the local wave field.   Unique to floating body hydrodynamics are the forces felt by one body due to the motion of `n' additional bodies.  This is reflected in the off diagonal terms of the added mass and wave damping matrices which generate a force on body 1 due to the acceleration and velocity of bodies 2 through n. 

..  The hydrodynamic radiation coefficients, including the coupling coefficients, for Reference Model 3 as  calculated by WAMIT are found in Fig.~\ref{fig:lambdamu}.

.. \begin{figure}[htc]
..     \centering
..     \subfloat[Wave Damping]{\includegraphics[trim = 4mm 3mm 0mm 7mm, clip, width = 0.875\textwidth]{../Conv2ss_HydroCoupling/epsFigures/Lambda.eps}}\\
..     \subfloat[Added Mass]{\includegraphics[trim = 4mm 3mm 0mm 7mm, clip, width = 0.875\textwidth]{../Conv2ss_HydroCoupling/epsFigures/Mu.eps}}
..     \caption{Frequency Domain Hydrodynamic Coefficients.}
..     \label{fig:lambdamu}
.. \end{figure}

.. \clearpage

.. \section{Frequency Domain - Response Amplitude Operator}

.. It is common practice to construct the response amplitude operator to access the performance of a wave energy converter.  For an incident wave of amplitude $A$, and frequency $\sigma$, the response of the floating body is given by $\zeta_{j}$:

.. \begin{eqnarray}
.. \zeta_{0} \left( x, t \right) = \Re \left\lbrace A e^{i ( kx - \sigma t ) } \right\rbrace~~, \\
.. \zeta_{j} \left( t \right) = \Re \left\lbrace \mathcal{A}_{j} e^{- i \sigma t  } \right\rbrace~~,
.. \end{eqnarray}

.. where $k$ is the wave number and $\mathcal{A}_{j}$ is the complex amplitude of motion for the $j$-th direction.  The resulting harmonic motion, when allowing six degree of freedom motion for all floating bodies, can be described by the following coupled system of differential equations:

.. \begin{eqnarray}
.. \label{eqn:MultiBodyEOM}
.. \sum_{j = 1}^{6\times \text{n}}\left[  C_{ij}  -\sigma^{2} \left( M_{ij} + \mu_{ij} \right) + i \sigma \lambda_{ij} \right] \mathcal{A}_{j} = F_{i}~~,\text{for}~i=1,~2,~3,~\ldots~6 \times \text{n}
.. \end{eqnarray}

.. where $M_{ij}$ is the generalized mass matrix for all floating bodies, $\lambda_{ij}$ is the generalized wave damping matrix, $\mu_{ij}$ is the generalized added mass matrix, $C_{ij}$ is the restoring force matrix, and $F_{i}$ is the complex amplitude of the wave exciting force for all floating bodies.  The various matrices shown in Eqn.~(\ref{eqn:MultiBodyEOM}) are given by:  \\

.. \begin{eqnarray}
..  \lambda_{ij} = \begin{bmatrix}
.. \lambda_{11} & \lambda_{12} & \cdots & \lambda_{1, 6\times \text{n}} \\
.. \lambda_{21} & \lambda_{22} & \cdots & \vdots \\
.. \vdots            & \vdots             & \ddots & \vdots \\
.. \lambda_{6\times n, 1} & \lambda_{6\times n,2} & \cdots & \lambda_{6\times n, 6\times n} \\
.. \end{bmatrix}~,~\mu_{ij} = \begin{bmatrix}
.. \mu_{11} & \mu_{12} & \cdots & \mu_{1, 6\times \text{n}} \\
.. \mu_{21} & \mu_{22} & \cdots & \vdots \\
.. \vdots            & \vdots             & \ddots & \vdots \\
.. \mu_{6\times n, 1} & \mu_{6\times n,2} & \cdots & \mu_{6\times n, 6\times n} \\
.. \end{bmatrix}~,~
.. \end{eqnarray}
.. \begin{eqnarray}
.. b_{j} = \begin{bmatrix}
.. m_{j} 	& 0 		& 0 		& 0		& 0 		& 0 \\
.. 0 		& m_{j} 	& 0	 	& 0		& 0 		& 0 \\
.. 0 		& 0 		& m_{j} 	& 0 		& 0 		& 0 \\
.. 0		& 0 		& 0 		& I_{j-xx}	& -I_{j-xy}	& -I_{j-xz} \\
.. 0		& 0 		& 0 		& -I_{j-yz} 	& I_{j-yy}	& -I_{j-yz} \\
.. 0		& 0 		& 0 		& -I_{j-zx} 	& -I_{j-zy}	& I_{j-zz} \\
.. \end{bmatrix}~~,~~M_{ij} = \begin{bmatrix} b_{1} & 0 		& \cdots & 0 \\
.. 							0         & b_{2}	& \cdots & 0 \\
.. 							\vdots & \vdots 	& \ddots & \vdots \\
.. 							0         & 0		& \cdots & b_{\text{n}} 
.. 				      \end{bmatrix}~~,
.. \end{eqnarray}
.. \begin{eqnarray}
.. c_{j} = \rho g \begin{bmatrix}
.. 0 		& 0 		& 0 			& 0						& 0 						& 0 \\
.. 0 		& 0	 	& 0	 		& 0						& 0 						& 0 \\
.. 0 		& 0 		& A_{wp}	 	&  -A_{wp}y_{f}  				& A_{wp}x_{f}				& 0 \\
.. 0		& 0 		& -A_{wp}y_{f} 	& \bigtriangledown GM_{x}		& -J_{yx} 					& 0  \\
.. 0		& 0 		& A_{wp}x_{f}	& -J_{xy} 					& \bigtriangledown GM_{y} 		& 0 \\
.. 0		& 0 		& 0 			& 0 						& 0						& 0 \\
.. \end{bmatrix}~~,~~C_{ij} = \begin{bmatrix} c_{1} & 0 		& \cdots & 0 \\
.. 							0         & c_{2}	& \cdots & 0 \\
.. 							\vdots & \vdots 	& \ddots & \vdots \\
.. 							0         & 0		& \cdots & c_{\text{n}} 
.. 				      \end{bmatrix}~~,
.. \end{eqnarray}
.. \begin{eqnarray}
.. F_{i} = A \begin{bmatrix} X_{1} \\
.. 						         X_{2} \\
.. 						         \vdots \\
.. 						         X_{6 \times \text{n}-1}\\
.. 						         X_{6 \times \text{n}}
.. 				    \end{bmatrix}~~,~~ \zeta^{T} = \begin{bmatrix}
.. 				    						x_{1}, y_{1}, z_{1}, \alpha_{1}, \beta_{1}, \gamma_{1}, \cdots, x_{n}, y_{n}, z_{n}, \alpha_{n}, \beta_{n}, \gamma_{n}
.. 				    						 \end{bmatrix} ~~,
.. \end{eqnarray}

.. where $A_{wp}$ is the water plane area, $x_{f},y_{f}$ denote the center of flotation, $J$ is the second area moment of inertia of the water plane area, $\bigtriangledown$ is the displaced volume of the floater, $GM_{x},GM_{y}$ correspond to the distance between the center of gravity and the metacentric height in roll and pitch, $\rho$ density of the working fluid, and $g$ the gravitational acceleration.


.. \section{Reference Model 3 - Validation}

.. \subsection{Frequency Domain}

.. The Reference Model 3 (RM3) two body point absorber was chosen for initial validation of WEC-Sim's ability to handle multibody interactions.  For demonstration purposes the RM3 model will be constrained to heave, though extending the equation of motion to consider multiple degrees of freedom is easily achieved.  This assumption allows us to simplify Eqn.~(\ref{eqn:MultiBodyEOM}) to the following:

.. \begin{eqnarray}
.. \underbrace{\left[ C_{33}  -\sigma^{2} \left( m_{1} + \mu_{33} \right) + i \sigma \lambda_{33} \right]}_{A^{*}}\mathcal{A}_{3} + \underbrace{\left[ -\sigma^{2} \left( \mu_{39} \right) + i \sigma \lambda_{39}  \right]}_{B^{*}} \mathcal{A}_{9} = A X_{3}~~, \\
.. \underbrace{\left[ -\sigma^{2} \left( \mu_{93} \right) + i \sigma \lambda_{93}  \right]}_{C^{*}}\mathcal{A}_{3} + \underbrace{\left[  C_{99} -\sigma^{2} \left( m_{2} + \mu_{99} \right) + i \sigma \lambda_{99}  \right]}_{D^{*}} \mathcal{A}_{9} = A X_{9}~~.
.. \end{eqnarray}

.. The above is a system of equations that can be solved for the complex amplitudes of motion $\zeta_{3}$ and $\zeta_{9}$.  It is most easily seen after construction of the following matrices:

.. \begin{eqnarray}
.. \begin{bmatrix}
.. A^{*} &  B^{*}  \\
..  C^{*} & D^{*} 
.. \end{bmatrix}
.. \begin{bmatrix}
.. \mathcal{A}_{3}/A \\
.. \mathcal{A}_{9}/A
.. \end{bmatrix} = 
.. \begin{bmatrix}
.. X_{3} \\
.. X_{9}
.. \end{bmatrix} \rightarrow 
.. \begin{bmatrix}
.. \mathcal{A}_{3}/A \\
.. \mathcal{A}_{9}/A
.. \end{bmatrix} = \begin{bmatrix}
.. A^{*} &  B^{*}  \\
..  C^{*} & D^{*} 
.. \end{bmatrix}^{-1}
.. \begin{bmatrix}
.. X_{3} \\
.. X_{9}
.. \end{bmatrix}
.. \end{eqnarray}

.. with results plotted in Fig.~\ref{fig:RAOPhase}.  As seen from Fig.~\ref{fig:RAOPhase}, the hydrodynamic coupling reduces float and increases spar plate motion in the range of 0.3 - 0.8 rad/s.  This will lead to lower relative heave motion and result in a decrease in power production compared to when the coupling hydrodynamics are neglected.  \\

.. \begin{figure}[htc]
..     \centering
..     \subfloat[Response Amplitude Operator $\left| \mathcal{A}_{j}/A\right|$]{\includegraphics[trim = 4mm 3mm 0mm 7mm, clip, width = 0.875\textwidth]{../Conv2ss_HydroCoupling/epsFigures/RAO.eps}}\\
..     \subfloat[Motion Phase Shift $arg\left(\mathcal{A}_{j}/A\right)$]{\includegraphics[trim = 4mm 3mm 0mm 7mm, clip, width = 0.875\textwidth]{../Conv2ss_HydroCoupling/epsFigures/Phase_Plus.eps}}\\
..     \caption{Frequency Domain Response with and without Coupled Hydrodynamics.}
..     \label{fig:RAOPhase}
.. \end{figure}
.. %
.. \subsection{Velocity Response Amplitude Operator}

.. The amplitude excursion is useful for analysis of traditional platform motions, but as a wave energy converter developer there is greater emphasis on the velocity of the device as it is directly related to power extraction.  The velocity response amplitude operator can be calculated in a similar manner except the quantity $-i \sigma \mathcal{A}_{j}$ will be solved for instead:

.. \begin{eqnarray}
.. \underbrace{\left[ \frac{C_{33}}{-i \sigma} - i \sigma \left( m_{1} + \mu_{33} \right) - \lambda_{33} \right]}_{A_{v}^{*}}\left[-i\sigma\mathcal{A}_{3}\right] + \underbrace{\left[ -i \sigma \left( \mu_{39} \right) - \lambda_{39}  \right]}_{B_{v}^{*}} \left[-i\sigma\mathcal{A}_{9}\right] = A X_{3}~~,~~
.. \end{eqnarray}
.. \begin{eqnarray}
.. \underbrace{\left[ -i \sigma \left( \mu_{93} \right) - \lambda_{93}  \right]}_{C_{v}^{*}}\left[-i\sigma\mathcal{A}_{3}\right] + \underbrace{\left[ \frac{C_{99}}{-i\sigma}  -i \sigma \left( m_{2} + \mu_{99} \right) - \lambda_{99}  \right]}_{D_{v}^{*}} \left[ -i\sigma \mathcal{A}_{9}\right] = A X_{9}~~.
.. \end{eqnarray}

.. \begin{eqnarray}
.. \begin{bmatrix}
.. -i\sigma\mathcal{A}_{3} \\
.. -i\sigma\mathcal{A}_{9}
.. \end{bmatrix} /A= \begin{bmatrix}
.. A_{v}^{*} &  B_{v}^{*}  \\
..  C_{v}^{*} & D_{v}^{*} 
.. \end{bmatrix}^{-1}
.. \begin{bmatrix}
.. X_{3} \\
.. X_{9}
.. \end{bmatrix}
.. \end{eqnarray}

.. \subsection{Time Domain}

.. The time domain corollary of Eqn.~(\ref{eqn:MultiBodyEOM}) for RM3 is given by the following coupled equations:

.. \begin{eqnarray}
.. &\left(m_{1} + \mu_{33}\left(\infty\right) \right) \ddot{\zeta}_{3} (t) + \mu_{39} \left( \infty \right)  \ddot{\zeta}_{9}(t) +  \int_{-\infty}^{t} K_{33} \left( t - \tau \right) \dot{\zeta}_{3} \left( \tau \right) d\tau +  \int_{-\infty}^{t} K_{39} \left( t - \tau \right) \dot{\zeta}_{9} \left( \tau \right) d\tau & \nonumber \\
.. & + C_{33} \zeta_{3} (t) = f_{e1} (t)~~,& \\
.. &\mu_{93}\left(\infty\right) \ddot{\zeta}_{3} (t) + \left( m_{2} + \mu_{99} \left( \infty \right) \right)  \ddot{\zeta}_{9}(t) + \int_{-\infty}^{t} K_{93} \left( t - \tau \right) \dot{\zeta}_{3} \left( \tau \right) d\tau +  \int_{-\infty}^{t} K_{99} \left( t - \tau \right) \dot{\zeta}_{9} \left( \tau \right) d\tau & \nonumber \\
.. & + C_{99} \zeta_{9} (t) = f_{e2} (t)~~,&
.. \end{eqnarray}

.. which is implemented in WEC-Sim.  The comparison of WEC-Sim to the frequency domain solution is provided in Fig.~\ref{fig:FDvTDRAOPhase} and shows very good agreement between the magnitude and phase of both float and spar plate.  The largest differences occur as WEC-Sim slightly underpredicts the float motion and over predicts the phase of the spar plate motion in the high frequency range.  Despite these minor differences, it has been shown that WEC-Sim is properly modeling the dynamics of the multibody system.

.. \begin{figure}[h!]
..     \centering
..     \subfloat[Heave RAO]{\includegraphics[trim = 4mm 3mm 0mm 7mm, clip, width = 0.875\textwidth]{../Conv2ss_HydroCoupling/epsFigures/FloatSparHeave_FDvsTD_CICvsSS_nopto.eps}}\\
..     \subfloat[Motion Phase Shift]{\includegraphics[trim = 3mm 3mm 0mm 4mm, clip, width = 0.875\textwidth]{../Conv2ss_HydroCoupling/epsFigures/FloatSparHeave_FDvsTD_CICvsSS_Phase_nopto.eps}}
..     \caption{Comparison of the Float and Spar Heave Motion Response Frequency vs Time Domain. CIC represents solution obtained from the convolution integral calculation and SS represents solution obtained from the state space realization.}
..     \label{fig:FDvTDRAOPhase}
.. \end{figure}

.. \clearpage
.. %
.. \section{Relative Heave Motion}

.. For a two body point absorber, power is extracted from the relative motion between bodies.  In the RM3 design the spar plate was designed to have minimum motion in operational sea states while maximizing float motion.  The relative heave motion is given by:

.. \begin{eqnarray}
.. \zeta_{rel} (t) = \zeta_{3} (t) - \zeta_{9} (t) = \left| \mathcal{A}_{3} \right| \cos \left( \sigma t  - \theta_{3} \right) - \left| \mathcal{A}_{9} \right| \cos \left( \sigma t  - \theta_{9} \right)~~.
.. \end{eqnarray}

.. Using trigonometric identities the two sinusoids can be combined as follows:

.. \begin{eqnarray}
.. \label{eqn:rel}
.. & \zeta_{rel}(t) = \zeta_{ r} \cos \left( \sigma t - \Theta \right) ~~,~~&\\
.. \label{eqn:relmag}
.. & \zeta_{r} = \sqrt{\left| \mathcal{A}_{3} \right|^{2} + (-\left| \mathcal{A}_{9} \right|)^{2} -2\left| \mathcal{A}_{3} \right|\left| \mathcal{A}_{9} \right|\cos \left( \theta_{3} - \theta_{9}\right)}~~,~~& \\
.. \label{eqn:relphase}
.. & \Theta = arg \left( \frac{\left| \mathcal{A}_{3} \right|\sin \theta_{3}-\left| \mathcal{A}_{9} \right|\sin \theta_{9}}{\left| \mathcal{A}_{3} \right|\cos \theta_{3}-\left| \mathcal{A}_{9} \right|\cos \theta_{9}} \right)~~,&
.. \end{eqnarray}

.. with the frequency domain results plotted in Fig.~\ref{fig:RelRAOPhaseFD} for the coupled and uncoupled systems.  The same procedure can be applied to the values of $-i\sigma \mathcal{A}_{j}$ to calculate the relative velocity; however, upon inspection it can be deduced that the velocity magnitude will be $\dot{\zeta}_{r} = \sigma \zeta_{r}$ and the velocity phase will be $\Theta_{\sigma} = \Theta - \pi/2$.  The comparison between the frequency and time domain solutions are presented in Fig.~\ref{fig:RelRAOPhase}, providing further validation on the performance of WEC-Sim.

.. \begin{figure}[h!]
..     \centering
..    \includegraphics[trim = 3mm 3mm 0mm 7mm, clip, width = 0.8\textwidth]{../Conv2ss_HydroCoupling/epsFigures/RelativeRAO.eps}
..     \caption{Relative Heave Motion Frequency Domain Response with and without Hydrodynamic Coupling.}
..     \label{fig:RelRAOPhaseFD}
.. \end{figure}

.. \begin{figure}[h!]
..     \centering
..     \subfloat[Relative Heave Position RAO and Phase]{\includegraphics[trim = 3mm 3mm 0mm 7mm, clip, width = 0.8\textwidth]{../Conv2ss_HydroCoupling/epsFigures/RelHeave_FDvsTD_CICvsSS_nopto.eps}}\\
..      \subfloat[Relative Heave Velocity RAO and Phase]{\includegraphics[trim = 3mm 3mm 0mm 4mm, clip, width = 0.8\textwidth]{../Conv2ss_HydroCoupling/epsFigures/RelVel_FDvsTD_CICvsSS_nopto.eps}}
..     \caption{Relative Heave Motion Response Frequency vs Time Domain.CIC represents solution obtained from the convolution integral calculation and SS represents solution obtained from the state space realization.}
..     \label{fig:RelRAOPhase}
.. \end{figure}

.. \clearpage

.. \section{Inclusion of the Power-Take-Off System}

.. In order to extract any power from the incident waves a power-take-off (PTO) system is required, predominantly either a hydraulic or electrical generator.  The most generic form for the reaction force from the PTO is given by:

.. \begin{eqnarray}
.. F_{PTO} = - C_{g} \zeta_{rel} - B_{g} \dot{\zeta}_{rel} - \mu_{g} \ddot{\zeta}_{rel}~~,
.. \end{eqnarray}
.. where $C_{g}$, $B_{g}$, and $\mu_{g}$ are the generator spring, damping, and inertia coefficients.  The force applied to each body by the PTO will have the same magnitude, but act in opposite directions.  Adding the PTO contribution to Eqn.~(\ref{eqn:MultiBodyEOM}), while ignoring $\mu_{g}$, provides:

.. \begin{eqnarray}
.. \left[ C_{33} - \sigma^{2} \left( m_{1} + \mu_{33} \right) + i \sigma \lambda_{33} \right]\mathcal{A}_{3} + \left[ -\sigma^{2} \left( \mu_{39} \right) + i \sigma \lambda_{39}  \right] \mathcal{A}_{9} + \left( C_{g} + i\sigma B_{g} \right) \left( \mathcal{A}_{3} - \mathcal{A}_{9} \right)= A X_{3}~~, \\
.. \left[ -\sigma^{2} \left( \mu_{93} \right) + i \sigma \lambda_{93}  \right]\mathcal{A}_{3} + \left[ C_{99} -\sigma^{2} \left( m_{2} + \mu_{99} \right) + i \sigma \lambda_{99}  \right] \mathcal{A}_{9} - \left(C_{g} + i\sigma B_{g} \right) \left( \mathcal{A}_{3} - \mathcal{A}_{9} \right)= A X_{9}~~.
.. \end{eqnarray}

.. After combing like terms, the following 2x2 system of equations is obtained:

.. \begin{eqnarray}
.. \label{eqn:PTOEOM1}
.. \left\lbrace [ C_{g} + C_{33} - \sigma^{2} \left( m_{1} + \mu_{33} \right)] + i \sigma [\lambda_{33} + B_{g} ]  \right\rbrace\mathcal{A}_{3} + \left\lbrace [-C_{g} -\sigma^{2} \left( \mu_{39} \right)] + i \sigma [ \lambda_{39} - B_{g} ]\right\rbrace \mathcal{A}_{9} = A X_{3}~~, \\
.. \label{eqn:PTOEOM2}
.. \left\lbrace [- C_{g} -\sigma^{2} \left( \mu_{93} \right)] + i \sigma [ \lambda_{93} -B_{g}]  \right\rbrace\mathcal{A}_{3} + \left\lbrace [ C_{g} + C_{99} -\sigma^{2} \left( m_{2} + \mu_{99} \right)] + i \sigma [ \lambda_{99} + B_{g}]   \right\rbrace \mathcal{A}_{9} = A X_{9}~~,
.. \end{eqnarray}

.. and as described previously can be solved to obtain the response amplitude operator and phase of the coupled system.  A sample set of results are presented in Fig.~\ref{fig:FloatSparPTO} that compares the uncoupled and coupled hydrodynamic results.  Again, as stated in the free motion section the coupling terms slight reduce the float motion and increase spar motion in the range of 0.3 - 0.9 rad/s.  As a result the relative motion, Fig.~ \ref{fig:RelPTO}, is reduced in the low frequency regime specifically below 0.7 rad/s and will result in decreased power production.

.. \begin{figure}[h!]
..     \centering
..     \subfloat[Float and Spar RAO]{\includegraphics[trim = 4mm 3mm 0mm 7mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/FloatSpar_Amp_CoupledUnCoupled.eps}}\\
..      \subfloat[Float and Spar Phase]{\includegraphics[trim = 3mm 3mm 0mm 4mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/FloatSpar_Phase_CoupledUnCoupled.eps}}
..     \caption{Float and Spar Motion Amplitude and Phase Including PTO.  Only the damping contribution of the PTO was included in motion calculations with a value of $10^6$ N/(m/s).}
..     \label{fig:FloatSparPTO}
.. \end{figure}


.. \begin{figure}[h!]
..     \centering
..     \subfloat[Relative Heave]{\includegraphics[trim = 3mm 3mm 0mm 7mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/RelativeHeave_AmpPhase_CoupledUnCoupled.eps}}\\
..      \subfloat[Relative Velocity]{\includegraphics[trim = 4mm 3mm 0mm 4mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/RelativeVelocity_AmpPhase_CoupledUnCoupled.eps}}
..     \caption{Relative Heave and Velocity Motion and Phase Including PTO.  Only the damping contribution of the PTO was included in motion calculations with a value of $10^6$ N/(m/s).}
..     \label{fig:RelPTO}
.. \end{figure}

.. \clearpage

.. \subsection{PTO Power Consumption}

.. The power consumed by the PTO is given by:
.. \begin{equation}
.. P = -F_{PTO}\dot{\zeta}_{rel}=C_{g}\zeta_{rel}\dot{\zeta}_{rel}+B_{g}\dot{\zeta}^{2}_{rel} + \mu_{g} \dot{\zeta}_{rel}\ddot{\zeta}_{rel}~~,
.. \end{equation}
.. However, both relative motion and acceleration are out of phase by $\pi/2$ with relative velocity that result in a time-averaged product of 0. This reduces the absorbed power to:
.. \begin{equation}
.. P =B_{g}\dot{\zeta}^{2}_{rel}~~.
.. \end{equation}

.. Since the analysis is being completed in the frequency domain, it is possible to calculate the time averaged power, $\overline{P}$, over one period of the incident wave:

.. \begin{eqnarray}
.. \label{eqn:TAP}
.. P_{T} & = & \frac{1}{T} \int_{0}^{T} B_{g} \dot{\zeta}_{r} \left( \tau \right) ^{2} d\tau = \frac{B_{g}}{T} \int_{0}^{T}  \left( -\sigma \zeta_{ r} \sin \left( \sigma t - \Theta \right)  \right) ^{2} d\tau \nonumber \\
..                     & = & \frac{B_{g}\sigma^{2} \zeta_{r}^{2}}{T} \int_{0}^{T}  \sin \left( \sigma t - \Theta \right) ^{2} d\tau = \frac{B_{g}\sigma^{2} \zeta_{r}^{2}}{2}~~.
.. \end{eqnarray}

.. In a one degree single body in heave, the optimum generator damping that maximizes power is well known.  The PTO damping is required to extract energy, but it also acts to control the amplitude of motion as seen from Eqn.~(\ref{eqn:PTOEOM1}) and (\ref{eqn:PTOEOM2}).  A comparison between the power output for the coupled and uncoupled solutions can be found in Fig.~\ref{fig:RelPTO_Bg_FDvsTD}  Too little generator damping and too much energy is radiated while too much damping will reduce all motion.  For each frequency the optimum generator damping can be calculated using a Newton-Raphson iterative formula or the user can simply perform a loop calculating the absorbed power per frequency and per allowable $B_{g}$. \\

.. \begin{figure}[h!]
..     \centering
..     \includegraphics[trim = 4mm 3mm 0mm 4mm, clip, width = \textwidth]{../Conv2ss_HydroCoupling/epsFigures/PTO_TAP_CoupledUnCoupled.eps}
..     \caption{Comparison of the Time Averaged Absorbed Power for the Coupled and Uncoupled Solutions with a PTO damping value of $10^6$ N/(m/s)).}
..     \label{fig:RelPTO_Bg_FDvsTD}
.. \end{figure}

.. \indent The results from performing such a loop can be found in Fig.~\ref{fig:RelPTO_Bg} where the PTO damping has been scaled by the default value used in Figs.~\ref{fig:FloatSparPTO} \& \ref{fig:RelPTO}.  As seen from Fig.~\ref{fig:RelPTO_Bg}a, the greatest relative heave appears at the lowest damping values near 1 rad/s; however, the response quickly drops off as the PTO value is increased.   At roughly 0.5 rad/s (12.5 s), the relative heave motion is greatest over the range of tested damping values resulting in the greatest time averaged power,  Fig.~\ref{fig:RelPTO_Bg}b.  The greatest absorbed power appears at damping ratio of approximately 45, which is a result of the significant increase in PTO damping that overcomes the relatively slow decrease in relative motion.


.. \begin{figure}[h!]
..     \centering
..     \subfloat[Relative Heave]{\includegraphics[trim = 3mm 3mm 0mm 7mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/RelativeHeave_BgvsAngFreq.eps}}\\
..      \subfloat[Time Averaged Power]{\includegraphics[trim = 4mm 3mm 0mm 4mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/TAP_BgvsAngFreq.eps}}
..     \caption{Relative Heave and Time Averaged Power for a parameter sweep of angular frequency and PTO damping ($B_{g}^{*}$ has a value of $10^6$ N/(m/s)).}
..     \label{fig:RelPTO_Bg}
.. \end{figure}

.. \clearpage

.. \subsection{Time Domain with PTO Included}

.. The time domain corollary of Eqn.~(\ref{eqn:PTOEOM1}) \& (\ref{eqn:PTOEOM2}) for RM3 is given by the following coupled equations:

.. \begin{eqnarray}
.. &\left(m_{1} + \mu_{33}\left(\infty\right) \right) \ddot{\zeta}_{3} (t) + \mu_{39} \left( \infty \right)  \ddot{\zeta}_{9}(t) +  \int_{-\infty}^{t} K_{33} \left( t - \tau \right) \dot{\zeta}_{3} \left( \tau \right) d\tau +  \int_{-\infty}^{t} K_{39} \left( t - \tau \right) \dot{\zeta}_{9} \left( \tau \right) d\tau & \nonumber \\
.. & + B_{g} \dot{\zeta}_{3} \left( t \right) -  B_{g} \dot{\zeta}_{9}\left( t \right) + \left( C_{33} +C_{g} \right) \zeta_{3} (t) - C_{g} \zeta_{9}\left( t \right)= f_{e1} (t)~~,& \\
.. &\mu_{93}\left(\infty\right) \ddot{\zeta}_{3} (t) + \left( m_{2} + \mu_{99} \left( \infty \right) \right)  \ddot{\zeta}_{9}(t) + \int_{-\infty}^{t} K_{93} \left( t - \tau \right) \dot{\zeta}_{3} \left( \tau \right) d\tau +  \int_{-\infty}^{t} K_{99} \left( t - \tau \right) \dot{\zeta}_{9} \left( \tau \right) d\tau & \nonumber \\
.. &- B_{g} \dot{\zeta}_{3} \left( t \right) +  B_{g} \dot{\zeta}_{9} \left( t \right)- C_{g} \zeta_{3}\left( t \right) + \left( C_{99} + C_{g} \right) \zeta_{9} (t) = f_{e2} (t)~~,&
.. \end{eqnarray}

.. which is implemented in WEC-Sim.  The comparison of WEC-Sim to the frequency domain solution is provided in Figs.~\ref{fig:RelPTO_Bg_FDvsTD}-\ref{fig:RelHeaveVel_PTO_FDvsTD} and shows very good agreement between float/spar motion and power production.  The largest difference occurs as WEC-Sim slightly underpredicts the float motion which leads to reduced power near the peak response frequency.  These results show that WEC-Sim is able to properly incorporate the influence of a linear PTO mode in the system dynamics.

.. \begin{figure}[h!]
..     \centering
..     \includegraphics[trim = 0mm 3mm 0mm 4mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/TAP_FDvsTD_CICvsSS.eps}
..     \caption{Comparison of the Time Averaged Absorbed Power for the Frequency and Time Domain Solutions with a PTO damping value of $10^6$ N/(m/s)).}
..     \label{fig:RelPTO_Bg_FDvsTD}
.. \end{figure}

.. \begin{figure}[h!]
..     \centering
..     \subfloat[Float and Spar Amplitude]{\includegraphics[trim = 3mm 3mm 0mm 7mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/FloatSparHeave_FDvsTD_CICvsSS.eps}}\\
..      \subfloat[Float and Spar Phase]{\includegraphics[trim = 3mm 3mm 0mm 7mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/FloatSparHeave_FDvsTD_CICvsSS_Phase.eps}}
..     \caption{Frequency vs Time domain comparison of amplitude and phase of float and spar plate with a PTO damping value of $10^6$ N/(m/s).}
..     \label{fig:SparPlate_PTO_FDvsTD}
.. \end{figure}

.. \begin{figure}[h!]
..     \centering
..     \subfloat[Relative Heave Amplitude and Phase]{\includegraphics[trim = 3mm 3mm 0mm 7mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/RelHeave_FDvsTD_CICvsSS.eps}}\\
..      \subfloat[Relative Velocity Amplitude and Phase]{\includegraphics[trim = 3mm 3mm 0mm 7mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/RelVel_FDvsTD_CICvsSS.eps}}
..     \caption{Frequency vs Time domain comparison of amplitude and phase of relative heave and velocity with a PTO damping value of $10^6$ N/(m/s).}
..     \label{fig:RelHeaveVel_PTO_FDvsTD}
.. \end{figure}

.. \clearpage

.. \section{WEC-Sim Implementation}

.. \subsection{Simulation Class Update}

.. \begin{itemize}
..   \item simu.hydrocoupling
.. \begin{itemize}
..   \item Set at 0 when it is not desired to include hydrodynamic coupling forces
..   \item Set at 1  when it is desired to include hydrodynamic coupling forces
.. \end{itemize}
.. \end{itemize}

.. \subsection{WEC-Sim Library Update}

.. \begin{itemize}
..   \item Cross Coupling Block shown in Fig.~\ref{fig:SimulinkModel} \& \ref{fig:CrossCoupleBlock}
.. \begin{itemize}
..   \item Included in Simulink model only if the hydrodynamic coupling forces are included
..   \item Doubling clicking the block opens up a graphical user interface that allows the total number of bodies to be selected
.. \end{itemize}
..  \item Rigid Body Block shown in Fig.~\ref{fig:RigidBodyBlock}
..  \begin{itemize}
..   \item The graphical user interface has been updated with a drop down option that allows the hydrodynamic coupling to be included in the simulation.  When hydrodynamic coupling is set to ``Yes'' an additional input and output port is included in the block.
.. \end{itemize}
.. \end{itemize}

.. The cross coupling block takes the velocity and acceleration vectors from each body and concatenates them into a signal vector, for each, and is outputted to be wired back to each rigid body block.  Each rigid body block will need to be connected to the cross coupling block by two wires, one for output and one for input, thus the maximum number of additional connections will be $2 \times \text{n}$, where n is the number of bodies.  The input ports on the cross coupling block are not arbitrary and must be in ascending order, i.e. body(1) is connected to port Body 1, body(2) is connected to port Body 2, and so on.  The choice to add physical wires was to emphasize the drag and drop capability of Simulink, this provides a visualization of the hydrodynamic coupling effects and the interaction between bodies.  If the hydrodynamic coupling is set to ``No'' the additional input and output ports are removed and the bodies only interact through the constraint and pto blocks.

.. \begin{figure}[h!]
..     \centering
..     \includegraphics[width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/SimulinkModel.eps}
..     \caption{Simulink Model Showing the Cross Coupling Block.}
..     \label{fig:SimulinkModel}
.. \end{figure}

.. \begin{figure}[h!]
..     \centering
..     \includegraphics[width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/CrossCoupleBlock.eps}
..     \caption{Under the Mask of the Cross Coupling Block.}
..     \label{fig:CrossCoupleBlock}
.. \end{figure}

.. \begin{figure}[h!]
..     \centering
..     \includegraphics[angle =90, width = 0.65\textwidth]{../Conv2ss_HydroCoupling/epsFigures/RigidBody.eps}
..     \caption{Under the Mask of the Rigid Body Block when Hydrodynamic Coupling Option is Selected.}
..     \label{fig:RigidBodyBlock}
.. \end{figure}

.. \clearpage

.. \section{Convolution Integral Calculation vs State Space Realization}

.. As seen from the figures, comparing the frequency and time domain solution, WEC-Sim is properly simulating the multibody hydrodynamics of the RM3 model to a high level of accuracy.  The implementation of the state space realization has seen a dramatic increase in computational speed.  A 400 s regular wave simulation with a 50 ms time step takes approximately 875 s to complete, while using the same run parameters with the state space realization is only 17 s, which corresponds to nearly a factor of 20 reduction.  It should be noted that the computational time estimates for the state space realization were made using imported matrices.  The computational time would increase if WEC-Sim was forced to generate the realization.  However, the run time would not increase, but rather the preprocessing time which unfortunately causes the computational speed using the CIC method to increase as the time step is reduced and the number of bodies increases.

.. \clearpage

.. \section{Additional Validation}

.. \subsection{1 DOF Surge}

.. As an additional check the float and spar bodies of the RM3 Model were fixed to one another and allowed to surge as one body.  This can be expressed mathematically by including a PTO and calculating the surge response as  $B_{g}\rightarrow \infty$.

.. \begin{eqnarray}
.. \left[ \left( - i \sigma \right)^{2} \left( m_{1} + \mu_{1,1}  \right) + i \sigma \left( \lambda_{1,1} + B_{g} \right) \right] \mathcal{A}_{1}  + \left[ \left( - i \sigma \right)^{2} \mu_{1,7} + i \sigma \left( \lambda_{1,7} - B_{g} \right) \right] \mathcal{A}_{7}= A  X_{1}~~,~ \\
.. \left[ \left( - i \sigma \right)^{2} \left( \mu_{7,1}  \right) + i \sigma \left( \lambda_{7,1} - B_{g} \right) \right] \mathcal{A}_{1}  + \left[ \left( - i \sigma \right)^{2} \left( m_{2} + \mu_{7,7}\right) + i \sigma \left( \lambda_{7,7} + B_{g} \right) \right] \mathcal{A}_{7}= A  X_{7}~~,~
.. \end{eqnarray}

.. As the PTO damping increases, the relative motion is reduced until the two bodies are rigidly linked at which point the above equations can be simplified to:

.. \begin{eqnarray}
.. \left[ \left( - i \sigma \right)^{2} \left( m_{1} + \mu_{1,1} + \mu_{1,7} + m_{2} + \mu_{7,1} + \mu_{7,7} \right) + i \sigma \left( \lambda_{1,1} + \lambda_{1,7} + \lambda_{7,1} + \lambda_{7,7} \right) \right] \mathcal{A}_{1} = A \left[ X_{1} + X_{7} \right]~~. \nonumber \\
.. \end{eqnarray}

.. \begin{figure}[h!]
..     \centering
..     \subfloat[Relative Heave Amplitude and Phase]{\includegraphics[trim = 3mm 3mm 0mm 7mm, clip, width = 0.85\textwidth]{../Conv2ss_HydroCoupling/epsFigures/Surge_Fixed_RAOandPhase.eps}}\\
..     \caption{Frequency vs Time domain comparison of the surge amplitude and phase for fixed RM3 model.}
..     \label{fig:1DOF_Fixed_Surge_FDvsTD}
.. \end{figure}

.. \clearpage
.. \begin{thebibliography}{9}

.. \bibitem{Cummins}  Cummins, W. E., 1962, ``The Impulse Response Function and Ship Motions, Schiffstechnik, \textbf{9}, 101.
.. %Technical Report 1661, David Taylor Model Basin–DTNSRDC

.. \bibitem{OT} Ogilvie, T., 1964. ``Recent Progress Towards the Understanding and Prediction of Ship Motions." \textit{Proceedings of the 5th Symposium on Naval Hydrodynamics,}  Washington, D.C., Office of Naval Research-Department of the Navy, pp. 3-128.

.. \bibitem{YF} Yu, Z., Falnes, J., 1996, `` State-space Modelling of a Vertical Cylinder in Heave," Appl. Ocean Res., \textbf{17} (5), pp. 265-275.

.. \bibitem{Kung} Kung, S. Y. , 1978, ``A New Identification and Model Reduction Algorithm via Singular Value Decompositions," \textit{ Proceedings of the 12th IEEE
.. Asilomar Conference on Circuits, Systems and Computers}, Pacific Grove, CA, USA, November 6-8, pp. 705-714.

.. \bibitem{KHE} Kristiansen, E., Hijulstad, A., Egeland, O., 2005, ``State-space Representation of Radiation Forces in Time-domain Vessel Models," Ocean Eng., \textbf{32} (17-18), pp. 2195-2216.

.. \bibitem{TPT} Taghipour, R., Perez, T., Moan, T., 2008, ``Hybrid Frequency-time Domain Models for Dynamic Response Analysis of Marine Structures," Ocean Eng., \textbf{35} (7), pp. 685-705.

.. \bibitem{MATLAB} ``MATLAB - The Language of Technical Computing." [Online] \url{http://www.mathworks.com/products/matlab/}.

.. \bibitem{Yeung} Yeung, R. W., 1981, ``Added Mass and Damping of a Vertical Cylinder in Finite-depth Waters," App. Ocean Res., \textbf{3} (3), pp. 119-133.

.. \bibitem{Newman} Newman, J. H., 1977, \textit{Marine Hydrodynamics}, MIT: Press, Cambridge, Massachusetts.

.. \end{thebibliography}
.. \end{document}
