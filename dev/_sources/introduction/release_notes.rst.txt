.. _intro-release-notes:

Release Notes
=============

.. _intro-citation:

Citing WEC-Sim
------------------------

To cite WEC-Sim, please use the citation for WEC-Sim software release and/or cite the following WEC-Sim publication.


`WEC-Sim v6.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v6.1>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. NOTE: citation needs to be revised for each release, author order should reflect the Zenodo DOI.

[1] Kelley Ruehl, Adam Keester, Dominic Forbush, Jeff Grasberger, Salman Husain, Jorge Leon, David Ogden, and Mohamed Shabara, "WEC-Sim v6.1". Zenodo, September 16, 2024. https://doi.org/10.5281/zenodo.13770349.

.. NOTE: citation needs to be revised for each release, author order should reflect the Zenodo DOI.

.. code-block:: none

	@software{wecsim,
	  author       = {Kelley Ruehl,
                          Adam Keester, 
                          Dominic Forbush, 
                          Jeff Grasberger, 
                          Salman Husain,
                          Jorge Leon,
                          David Ogden,
                          Mohamed A. Shabara},
	  title        = {WEC-Sim v6.1.2},
	  month        = December,
	  year         = 2024,
	  publisher    = {Zenodo},
	  version      = {v6.1.2},
	  doi          = {10.5281/zenodo.14549050},
	  url          = {https://doi.org/10.5281/zenodo.14549050}
	}
    

.. NOTE: badge does NOT need to be updated, doi badge is always for the lastest release

.. image:: https://zenodo.org/badge/20451353.svg
   :target: https://zenodo.org/badge/latestdoi/20451353


Publication
^^^^^^^^^^^^^^^^^^^^^^^^^^^
[1] D. Ogden, K. Ruehl, Y.H. Yu, A. Keester, D. Forbush, J. Leon, N. Tom, "Review of WEC-Sim Development and Applications" in Proceedings of the 14th European Wave and Tidal Energy Conference, EWTEC 2021, Plymouth, UK, 2021. 


`WEC-Sim v6.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v6.1>`_
--------------------------------------------------------------------------------

**New Features**

* Update docs on main by @salhus in `#1031 <https://github.com/WEC-Sim/WEC-Sim/pull/1031>`_

* Save mooring library to R2020b by @akeeste in `#1040 <https://github.com/WEC-Sim/WEC-Sim/pull/1040>`_

* Update readAQWA.m by @salhus in `#1096 <https://github.com/WEC-Sim/WEC-Sim/pull/1096>`_

* Update plotRadiationIRF.m by @AlufaSam in `#1102 <https://github.com/WEC-Sim/WEC-Sim/pull/1102>`_

* Update readNEMOH.m for compatibility with NEMOH v3.0 by @nathanmtom in `#1105 <https://github.com/WEC-Sim/WEC-Sim/pull/1105>`_

* Remove direct github installations from docs environment by @H0R5E in `#1149 <https://github.com/WEC-Sim/WEC-Sim/pull/1149>`_

* Exclude R2020b and R2021a from Windows test runners by @H0R5E in `#1166 <https://github.com/WEC-Sim/WEC-Sim/pull/1166>`_

* Add BEMIO cleanup function by @dforbush2 in `#1076 <https://github.com/WEC-Sim/WEC-Sim/pull/1076>`_

* Remove dead code from wecSim.m by @akeeste in `#1170 <https://github.com/WEC-Sim/WEC-Sim/pull/1170>`_

* Update wecSim.m to new MoorDyn dll by @jtgrasb in `#1177 <https://github.com/WEC-Sim/WEC-Sim/pull/1177>`_

* Merge main commits to dev by @jtgrasb in `#1183 <https://github.com/WEC-Sim/WEC-Sim/pull/1183>`_

* Port testing PR #1186 to main by @H0R5E in `#1187 <https://github.com/WEC-Sim/WEC-Sim/pull/1187>`_

* Add R2023b to Windows tests by @H0R5E in `#1186 <https://github.com/WEC-Sim/WEC-Sim/pull/1186>`_

* Nemoh v3.0.2 Examples by @MShabara in `#1204 <https://github.com/WEC-Sim/WEC-Sim/pull/1204>`_

* Update paraview docs by @jtgrasb in `#1227 <https://github.com/WEC-Sim/WEC-Sim/pull/1227>`_

* Update default branch to main by @akeeste in `#1235 <https://github.com/WEC-Sim/WEC-Sim/pull/1235>`_

* Apply #1235 and #1241 to dev branch by @H0R5E in `#1240 <https://github.com/WEC-Sim/WEC-Sim/pull/1240>`_

* PTO Extension Feature by @Allison-File in `#1198 <https://github.com/WEC-Sim/WEC-Sim/pull/1198>`_

* Updating tests on main and dev by @kmruehl in `#1250 <https://github.com/WEC-Sim/WEC-Sim/pull/1250>`_

* Updating WEC-Sim Issue Templates by @kmruehl in `#1247 <https://github.com/WEC-Sim/WEC-Sim/pull/1247>`_

* Enable WEC-Sim to use MoorDyn v2 capabilities by @jtgrasb in `#1212 <https://github.com/WEC-Sim/WEC-Sim/pull/1212>`_

* Add missing mask initialization line in spherical constraint by @akeeste in `#1264 <https://github.com/WEC-Sim/WEC-Sim/pull/1264>`_

* Update readCAPYTAINE.m to read Khs from .nc by @salhus in `#1263 <https://github.com/WEC-Sim/WEC-Sim/pull/1263>`_

* Update readCapytaine - fix reading multiple bodies with <6 dofs by @akeeste in `#1274 <https://github.com/WEC-Sim/WEC-Sim/pull/1274>`_

* Reposition % for readability by @Gusmano-2-OSU in `#1272 <https://github.com/WEC-Sim/WEC-Sim/pull/1272>`_

* Update waveSpread calculation in irregular waves by @dforbush2 in `#1290 <https://github.com/WEC-Sim/WEC-Sim/pull/1290>`_

* Add new examples for updated version of NEMOH (NEMOHv3.0.2) by @ashleynchong in `#1226 <https://github.com/WEC-Sim/WEC-Sim/pull/1226>`_

* Pull main into dev by @kmruehl in `#1297 <https://github.com/WEC-Sim/WEC-Sim/pull/1297>`_

* Expand regression tests by @akeeste in `#1273 <https://github.com/WEC-Sim/WEC-Sim/pull/1273>`_

* BEMIO Unit Updates by @jniffene in `#1296 <https://github.com/WEC-Sim/WEC-Sim/pull/1296>`_

* Speed up writeBEMIOH5 by @akeeste in `#1301 <https://github.com/WEC-Sim/WEC-Sim/pull/1301>`_

* Update readAQWA.m by @jtgrasb in `#1253 <https://github.com/WEC-Sim/WEC-Sim/pull/1253>`_

* Variable hydrodynamics by @akeeste in `#1248 <https://github.com/WEC-Sim/WEC-Sim/pull/1248>`_

* Update readCapytaine - get Khs from .nc files when bodies have less than 6 DOFs by @akeeste in `#1275 <https://github.com/WEC-Sim/WEC-Sim/pull/1275>`_

* Adds the QTFs to WEC-Sim by @MShabara in `#1242 <https://github.com/WEC-Sim/WEC-Sim/pull/1242>`_

* QTF - Variable Hydro compatibility by @akeeste in `#1312 <https://github.com/WEC-Sim/WEC-Sim/pull/1312>`_

* Resolve conflicts between variable hydro and GBM by @akeeste in <https://github.com/WEC-Sim/WEC-Sim/pull/1317>`_

**Bug Fixes**

* Update to MoorDyn to fix MoorDyn crashing MATLAB session. by @AlixHaider in `#1012 <https://github.com/WEC-Sim/WEC-Sim/pull/1012>`_

* Fix Direct Drive PTO Output order by @jtgrasb in `#1095 <https://github.com/WEC-Sim/WEC-Sim/pull/1095>`_

* Fix accelerator modes issue by @jtgrasb in `#1100 <https://github.com/WEC-Sim/WEC-Sim/pull/1100>`_

* Bugfix for plotBEMIO bodies by @akeeste in `#1207 <https://github.com/WEC-Sim/WEC-Sim/pull/1207>`_

* Fix to #1217, nonlinFK and body block changed by @dforbush2 in `#1220 <https://github.com/WEC-Sim/WEC-Sim/pull/1220>`_

* Fix on pDis function call by @dforbush2 in `#1229 <https://github.com/WEC-Sim/WEC-Sim/pull/1229>`_

* Bug fixes for WEC-Sim GUI and Run From Simulink features by @akeeste in `#1195 <https://github.com/WEC-Sim/WEC-Sim/pull/1195>`_

* Fix sign bug in the Generator Equivalent Circuit Block in PTO-Sim - Rebase PR to main by @jleonqu in `#1236 <https://github.com/WEC-Sim/WEC-Sim/pull/1236>`_

* Fix direct drive bugs by @jtgrasb in `#1256 <https://github.com/WEC-Sim/WEC-Sim/pull/1256>`_

* Minor fix for formatting in Developer manual by @akeeste in `#1280 <https://github.com/WEC-Sim/WEC-Sim/pull/1280>`_

* Bad BEMIO fcn fix by @dforbush2 in `#1289 <https://github.com/WEC-Sim/WEC-Sim/pull/1289>`_

**New Contributors**

* @AlixHaider made their first contribution in `#1012 <https://github.com/WEC-Sim/WEC-Sim/pull/1012>`_

* @AlufaSam made their first contribution in `#1102 <https://github.com/WEC-Sim/WEC-Sim/pull/1102>`_

* @Allison-File made their first contribution in `#1198 <https://github.com/WEC-Sim/WEC-Sim/pull/1198>`_

* @Gusmano-2-OSU made their first contribution in `#1272 <https://github.com/WEC-Sim/WEC-Sim/pull/1272>`_

* @ashleynchong made their first contribution in `#1226 <https://github.com/WEC-Sim/WEC-Sim/pull/1226>`_

**Issues and Pull Requests**

* `v6.1 Changelog <https://github.com/WEC-Sim/WEC-Sim/compare/v6.0...v6.1>`_

* \> 104 issues closed since v6.0

* \> 48 PRs merged since v6.0

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.13770349.svg
  :target: https://doi.org/10.5281/zenodo.13770349



`WEC-Sim v6.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v6.0>`_
--------------------------------------------------------------------------------

**New Features**

* initial commit largeXYDispOption by @dforbush2 in `#877 <https://github.com/WEC-Sim/WEC-Sim/pull/877>`_

* Update coordinate system figure by @JiaMiGit in `#931 <https://github.com/WEC-Sim/WEC-Sim/pull/931>`_

* Property validation for WEC-Sim objects by @jtgrasb in `#904 <https://github.com/WEC-Sim/WEC-Sim/pull/904>`_

* Dev: adding ampSpectraForWS function by @dforbush2 in `#907 <https://github.com/WEC-Sim/WEC-Sim/pull/907>`_

* Customizable DOFs for plotBEMIO by @akeeste in `#944 <https://github.com/WEC-Sim/WEC-Sim/pull/944>`_

* Calculation_of_Ainf_using_radiationIRF.m by @salhus in `#946 <https://github.com/WEC-Sim/WEC-Sim/pull/946>`_

* Update citation names by @akeeste in `#954 <https://github.com/WEC-Sim/WEC-Sim/pull/954>`_

* Update getDofNames() by @akeeste in `#957 <https://github.com/WEC-Sim/WEC-Sim/pull/957>`_

* included readCAPYTAINE() argument to explicitly define KH.dat & Hydro by @dav-og in `#962 <https://github.com/WEC-Sim/WEC-Sim/pull/962>`_

* Extract mask variable by @salhus in `#958 <https://github.com/WEC-Sim/WEC-Sim/pull/958>`_

* Add tests to check that SLX file versions do not exceed R2020b by @H0R5E in `#919 <https://github.com/WEC-Sim/WEC-Sim/pull/919>`_

* Products of Inertia in WEC-Sim by @akeeste in `#981 <https://github.com/WEC-Sim/WEC-Sim/pull/981>`_

* Pull bug fixes #954, #999, #1002 from master into dev by @akeeste in `#1011 <https://github.com/WEC-Sim/WEC-Sim/pull/1011>`_

* updating readNEMOH based on #983 by @kmruehl in `#990 <https://github.com/WEC-Sim/WEC-Sim/pull/990>`_

* Remove 'fixed' mass option from OSWEC input file by @jtgrasb in `#1024 <https://github.com/WEC-Sim/WEC-Sim/pull/1022 and https://github.com/WEC-Sim/WEC-Sim/pull/1024>`_

* Save the applied added mass time series by @akeeste in `#1023 <https://github.com/WEC-Sim/WEC-Sim/pull/1023>`_

* Update tutorials by @kmruehl in `#1030 <https://github.com/WEC-Sim/WEC-Sim/pull/1030>`_

* Control applications docs by @jtgrasb in `#1018 <https://github.com/WEC-Sim/WEC-Sim/pull/1018>`_

* Update read- and writeBEMIOH5 to allow for pressure integration for mean drift  by @nathanmtom in `#1046 <https://github.com/WEC-Sim/WEC-Sim/pull/1046>`_

* Add function to read h5 file to hydro data structure by @jtgrasb in `#1048 <https://github.com/WEC-Sim/WEC-Sim/pull/1048>`_

* Update radiationIRF.m by @nathanmtom in `#1045 <https://github.com/WEC-Sim/WEC-Sim/pull/1045>`_

* Normalize quaternion to increase simulation robustness by @akeeste in `#1049 <https://github.com/WEC-Sim/WEC-Sim/pull/1049>`_

* Plot bemio features by @jtgrasb in `#1034 <https://github.com/WEC-Sim/WEC-Sim/pull/1034>`_

* Updates to Morison Element Implementation by @nathanmtom in `#1052 <https://github.com/WEC-Sim/WEC-Sim/pull/1052>`_

* Moving PTO-Sim to main WEC-Sim library  by @jleonqu in `#1057 <https://github.com/WEC-Sim/WEC-Sim/pull/1057>`_

* Add windows runner to dev branch unit test workflow by @H0R5E in `#1061 <https://github.com/WEC-Sim/WEC-Sim/pull/1061>`_

* Update docs dependencies by @H0R5E in `#1080 <https://github.com/WEC-Sim/WEC-Sim/pull/1080>`_

* Type property pto sim by @jleonqu in `#1064 <https://github.com/WEC-Sim/WEC-Sim/pull/1064>`_

* Added mass updates by @akeeste in `#1058 <https://github.com/WEC-Sim/WEC-Sim/pull/1058>`_

* Feature paraview by @agmoore4 in `#1081 <https://github.com/WEC-Sim/WEC-Sim/pull/1081>`_

* Paraview documentation hyperlink fix by @agmoore4 in `#1093 <https://github.com/WEC-Sim/WEC-Sim/pull/1093>`_

* use capytaine v2 to compute hydrostatics by @dav-og in `#1092 <https://github.com/WEC-Sim/WEC-Sim/pull/1092>`_

* Update paraview doc images by @jtgrasb in `#1098 <https://github.com/WEC-Sim/WEC-Sim/pull/1098>`_

* readNEMOH update to be compatible with v3.0.0 release (but not QTF) by @nathanmtom in `#1087 <https://github.com/WEC-Sim/WEC-Sim/pull/1087>`_

* Add simple direct drive PTO model by @jtgrasb in `#1106 <https://github.com/WEC-Sim/WEC-Sim/pull/1106>`_

* Control+pto docs by @jtgrasb in `#1108 <https://github.com/WEC-Sim/WEC-Sim/pull/1108>`_

* MOST Capabilities - Continuation by @jtgrasb in `#1127 <https://github.com/WEC-Sim/WEC-Sim/pull/1127>`_

* Implement an FIR filter to calculate radiation forces by @salhus in `#1071 <https://github.com/WEC-Sim/WEC-Sim/pull/1071>`_

* Updating documentation to include links for the Advanced Features Web by @jleonqu in `#1126 <https://github.com/WEC-Sim/WEC-Sim/pull/1126>`_

* Multiple Wave Spectra by @salhus in `#1130 <https://github.com/WEC-Sim/WEC-Sim/pull/1130>`_

* Update WECSim_Lib_Body_Elements.slx for N Waves Applications by @salhus in `#1133 <https://github.com/WEC-Sim/WEC-Sim/pull/1133>`_

* Update to MoorDyn v2 by @RyanDavies19 in `#1134 <https://github.com/WEC-Sim/WEC-Sim/pull/1134>`_

* Updating WEC-Sim tests for dev branch by @kmruehl in `#1142 <https://github.com/WEC-Sim/WEC-Sim/pull/1142>`_

**Bug Fixes**

* Remove fixed mass option by @akeeste in `#856 <https://github.com/WEC-Sim/WEC-Sim/pull/856>`_

* Move run('stopWecSim') to wecSim.m by @jtgrasb in `#885 <https://github.com/WEC-Sim/WEC-Sim/pull/885>`_

* Pull bug fixes into dev by @akeeste in `#900 <https://github.com/WEC-Sim/WEC-Sim/pull/900>`_

* Save slx files in 2020b fixes #920 by @jtgrasb in `#923 <https://github.com/WEC-Sim/WEC-Sim/pull/923>`_

* Fix readCAPYTAINE by @jtgrasb in `#884 <https://github.com/WEC-Sim/WEC-Sim/pull/884>`_

* Fixes saveViz feature for elevation import by @jtgrasb in `#929 <https://github.com/WEC-Sim/WEC-Sim/pull/929>`_

* Fix wave elevation import with rampTime = 0 by @jtgrasb in `#917 <https://github.com/WEC-Sim/WEC-Sim/pull/917>`_

* readCapytaine_fixes_for_reading_dataformats_correctly by @salhus in `#947 <https://github.com/WEC-Sim/WEC-Sim/pull/947>`_

* Pull #954 into dev by @akeeste in `#955 <https://github.com/WEC-Sim/WEC-Sim/pull/955>`_

* Bug fix for direction in readCapytaine by @akeeste in `#999 <https://github.com/WEC-Sim/WEC-Sim/pull/999>`_

* Fix sign bug reported on issue #993 by @jleonqu in `#102 <https://github.com/WEC-Sim/WEC-Sim/pull/1002>`_

* Dev: reverts PR 910, fixing error in nonLinearBuoyancy by @dforbush2 in `#1017 <https://github.com/WEC-Sim/WEC-Sim/pull/1017>`_

* Fix the transpose of linear restoring matrix to make roll mode rows to be 0 by @salhus in `#1032 <https://github.com/WEC-Sim/WEC-Sim/pull/1032>`_

* Bugfix resolving documentation build error by @kmruehl in `#1059 <https://github.com/WEC-Sim/WEC-Sim/pull/1059>`_

* fix_readWAMIT_and_writeBEMIOh5 by @salhus in `#1065 <https://github.com/WEC-Sim/WEC-Sim/pull/1065>`_

* Pulling master bugfixes into dev by @kmruehl in `#1101 <https://github.com/WEC-Sim/WEC-Sim/pull/1101>`_

* Bug fixes for v6.0 by @akeeste in `#1136 <https://github.com/WEC-Sim/WEC-Sim/pull/1136>`_

* Path fix for BEMIO example by @akeeste in `#1144 <https://github.com/WEC-Sim/WEC-Sim/pull/1144>`_

**New Contributors**

* @JiaMiGit made their first contribution in `#931 <https://github.com/WEC-Sim/WEC-Sim/pull/931>`_

* @agmoore4 made their first contribution in `#1081 <https://github.com/WEC-Sim/WEC-Sim/pull/1081>`_

* @RyanDavies19 made their first contribution in `#1134 <https://github.com/WEC-Sim/WEC-Sim/pull/1134>`_


**Issues and Pull Requests**

* \>130 issues closed since v5.0.1

* \>74 PRs merged since v5.0.1

* `v6.0 Changelog <https://github.com/WEC-Sim/WEC-Sim/compare/v5.0.1...v6.0>`_

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.10023797.svg
  :target: https://doi.org/10.5281/zenodo.10023797


`WEC-Sim v5.0.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v5.0.1>`_
--------------------------------------------------------------------------------

**New Features**

This is a bug fix release. New features since the previous release are not included.

**Bug Fixes**

* Fix saveViz by @jtgrasb in `#866 <https://github.com/WEC-Sim/WEC-Sim/pull/866>`_

* Fix typo in docs. by @mancellin in `#898 <https://github.com/WEC-Sim/WEC-Sim/pull/898>`_

* Update documentation tutorials to fix OSWEC inertia by @jtgrasb in `#894 <https://github.com/WEC-Sim/WEC-Sim/pull/894>`_

* CI: Split docs jobs | Add color to docs logs | Cancel runs on new push | Add 2021b to MATLAB versions by @H0R5E in `#862 <https://github.com/WEC-Sim/WEC-Sim/pull/862>`_

* Mac path fixes and make outputDir public by @ahmedmetin in `#874 <https://github.com/WEC-Sim/WEC-Sim/pull/874>`_

* wecSimPCT Fix (Master) by @yuyihsiang in `#870 <https://github.com/WEC-Sim/WEC-Sim/pull/870>`_

* Fix image bug in PTO-Sim in Library Browser by @jleonqu in `#896 <https://github.com/WEC-Sim/WEC-Sim/pull/896>`_

* update to v5.0 citation by @akeeste in `#911 <https://github.com/WEC-Sim/WEC-Sim/pull/911>`_

* fix non-linear hydro by @dforbush2 in `#910 <https://github.com/WEC-Sim/WEC-Sim/pull/910>`_

* Pull dev bugfixes into master by @akeeste @jtgrasb in `#950 <https://github.com/WEC-Sim/WEC-Sim/pull/950>`_ (includes `#929 <https://github.com/WEC-Sim/WEC-Sim/pull/929>`_ `#917 <https://github.com/WEC-Sim/WEC-Sim/pull/917>`_ `#884 <https://github.com/WEC-Sim/WEC-Sim/pull/884>`_ by @jtgrasb)

**New Contributors**

* @mancellin made their first contribution in `#898 <https://github.com/WEC-Sim/WEC-Sim/pull/898>`_

* @ahmedmetin made their first contribution in `#874 <https://github.com/WEC-Sim/WEC-Sim/pull/874>`_

**Issues and Pull Requests**

* \>52 issues closed since v5.0

* \>23 PRs merged since v5.0

* `v5.0.1 Changelog <https://github.com/WEC-Sim/WEC-Sim/compare/v5.0...v5.0.1>`_

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.7121186.svg
   :target: https://doi.org/10.5281/zenodo.7121186


`WEC-Sim v5.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v5.0>`_
--------------------------------------------------------------------------------
  
**New Features**

* Refactoring classes and properties @kmruehl in `#803 <https://github.com/WEC-Sim/WEC-Sim/pull/803>`_, `#822 <https://github.com/WEC-Sim/WEC-Sim/pull/822>`_, `#828 <https://github.com/WEC-Sim/WEC-Sim/pull/828>`_, `#832 <https://github.com/WEC-Sim/WEC-Sim/pull/832>`_, @akeeste in `#838 <https://github.com/WEC-Sim/WEC-Sim/pull/838>`_

* Refactoring docs by @kmruehl in `#840 <https://github.com/WEC-Sim/WEC-Sim/pull/840>`_

* Refactor BEMIO functions, tests, and documentation @akeeste in `#790 <https://github.com/WEC-Sim/WEC-Sim/pull/790>`_, `#812 <https://github.com/WEC-Sim/WEC-Sim/pull/812>`_, @H0R5E in `#839 <https://github.com/WEC-Sim/WEC-Sim/pull/839>`_, @dav-og in `#806 <https://github.com/WEC-Sim/WEC-Sim/pull/806>`_

* Run from sim updates by @akeeste in `#737 <https://github.com/WEC-Sim/WEC-Sim/pull/737>`_

* Allow binary STL files by @akeeste in `#760 <https://github.com/WEC-Sim/WEC-Sim/pull/760>`_

* Update Read_AQWA and AQWA examples by @jtgrasb in `#761 <https://github.com/WEC-Sim/WEC-Sim/pull/761>`_, `#779 <https://github.com/WEC-Sim/WEC-Sim/pull/779>`_, `#797 <https://github.com/WEC-Sim/WEC-Sim/pull/797>`_, `#831 <https://github.com/WEC-Sim/WEC-Sim/pull/831>`_

* Rename plotWaves by @jtgrasb in `#765 <https://github.com/WEC-Sim/WEC-Sim/pull/765>`_

* Update to normalize to handle sorting mean drift forces by @nathanmtom in #808 #809

* Remove passiveYawTest.m by @jtgrasb in `#807 <https://github.com/WEC-Sim/WEC-Sim/pull/807>`_

* Wave class wave gauge update by @nathanmtom in `#801 <https://github.com/WEC-Sim/WEC-Sim/pull/801>`_

* New pto sim lib by @jleonqu in `#821 <https://github.com/WEC-Sim/WEC-Sim/pull/821>`_

* Warning/Error flags by @jtgrasb in `#826 <https://github.com/WEC-Sim/WEC-Sim/pull/826>`_

* Add Google Analytics 4 by @akeeste in `#864 <https://github.com/WEC-Sim/WEC-Sim/pull/854>`_

**Documentation**

* Update WEC-Sim's Developer Documentation for the Morison Element Implementation by @nathanmtom in `#796 <https://github.com/WEC-Sim/WEC-Sim/pull/796>`_

* Update response class API by @akeeste in `#802 <hhttps://github.com/WEC-Sim/WEC-Sim/pull/802>`_

* Doc_auto_gen_masks by @salhus in `#842 <hhttps://github.com/WEC-Sim/WEC-Sim/pull/842>`_

* Move documentation compilation to GitHub Actions by @H0R5E in `#817 <hhttps://github.com/WEC-Sim/WEC-Sim/pull/817>`_

* Add branch build in docs workflow for testing PRs by @H0R5E in `#834 <hhttps://github.com/WEC-Sim/WEC-Sim/pull/834>`_

* Update the WEC-Sim Theory Documentation to Clarify Wave Power Calculation by @nathanmtom in `#847 <hhttps://github.com/WEC-Sim/WEC-Sim/pull/847>`_

* Update documentation on mean drift and current by @akeeste in `#800 <hhttps://github.com/WEC-Sim/WEC-Sim/pull/800>`_

**Bug Fixes**

* Fix cable library links. Resolves #770 by @akeeste in #774 #775

* Fix rate transition error by @akeeste in `#799 <https://github.com/WEC-Sim/WEC-Sim/pull/799>`_

* Fix cable implementation by @dforbush2 in `#827 <https://github.com/WEC-Sim/WEC-Sim/pull/827>`_

* PTO-Sim bug fix by @jleonqu in `#833 <https://github.com/WEC-Sim/WEC-Sim/pull/833>`_

* Bug fix for the regular wave power full expression by @nathanmtom in `#841 <https://github.com/WEC-Sim/WEC-Sim/pull/841>`_

* Fix documentation on dev branch by @H0R5E in `#816 <https://github.com/WEC-Sim/WEC-Sim/pull/816>`_

* Bug fix: responseClass reading the MoorDyn Lines.out file too early, resolves `#811 <https://github.com/WEC-Sim/WEC-Sim/pull/811>`_ by @akeeste in `#814 <https://github.com/WEC-Sim/WEC-Sim/pull/814>`_

**Issues and Pull Requests**

   * \>52 issues closed since v4.4

   * \>44 PRs merged since v4.4


.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.6555137.svg
   :target: https://doi.org/10.5281/zenodo.6555137
   


`WEC-Sim v4.4 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v4.4>`_
--------------------------------------------------------------------------------
  
**New Features**

  * Added WEC-Sim Library blocks for cable, spherical constraint, and spherical pto `#712 <https://github.com/WEC-Sim/WEC-Sim/pull/712>`_ `#675 <https://github.com/WEC-Sim/WEC-Sim/pull/675>`_   

  * Added feature to add/remove WEC-Sim path and create temp directory for each run `#685 <https://github.com/WEC-Sim/WEC-Sim/pull/685>`_ `#686 <https://github.com/WEC-Sim/WEC-Sim/pull/686>`_       

  * Updated WEC-Sim Library to 2020b and saved Simulink Library Functions to (`*.m`) files `#686 <https://github.com/WEC-Sim/WEC-Sim/pull/686>`_    `#654 <https://github.com/WEC-Sim/WEC-Sim/pull/654>`_       

  * Split WEC-Sim Library into sublibraries for each class `#720 <https://github.com/WEC-Sim/WEC-Sim/pull/720>`_   

  * Restructured WEC-Sim Continuous Integration tests into class-based tests `#620 <https://github.com/WEC-Sim/WEC-Sim/pull/620>`_    

  * Added wave visualization with wave markers and post-processing `#736 <https://github.com/WEC-Sim/WEC-Sim/pull/736>`_  `#678 <https://github.com/WEC-Sim/WEC-Sim/pull/678>`_      

  * Moved nonlinear hydrodynamics and morison elements to properties of the Body Class `#692 <https://github.com/WEC-Sim/WEC-Sim/pull/692>`_    
   
**Documentation**

  * Added developer manual content for WEC-Sim Library, Run from Simulink, Simulink Functions, Added Mass, Software Tests `#728 <https://github.com/WEC-Sim/WEC-Sim/pull/728>`_   

  * Added user manual content for troubleshooting WEC-Sim `#641 <https://github.com/WEC-Sim/WEC-Sim/pull/641>`_ 

  * Updated content for PTO-Sim, ParaView, WEC-Sim Applications and Tutorials `#668 <https://github.com/WEC-Sim/WEC-Sim/pull/668>`_ `#642 <https://github.com/WEC-Sim/WEC-Sim/pull/642>`_ `#649 <https://github.com/WEC-Sim/WEC-Sim/pull/649>`_ `#643 <https://github.com/WEC-Sim/WEC-Sim/pull/643>`_   

  * Added multi-version documentation for ``master`` and ``dev`` branches `#630 <https://github.com/WEC-Sim/WEC-Sim/pull/630>`_ 
      
   
**Bug Fixes**

  * Resolved bug with macro for ParaView 5.9 `#459 <https://github.com/WEC-Sim/WEC-Sim/pull/459>`_   

  * Resolved bugs in BEMIO with Read_Capytaine, READ_AQWA, and Write_H5 functions `#727 <https://github.com/WEC-Sim/WEC-Sim/pull/727>`_  `#694 <https://github.com/WEC-Sim/WEC-Sim/pull/694>`_  `#636 <https://github.com/WEC-Sim/WEC-Sim/pull/636>`_   

  * Resolved bug with variable time-step solver `#656 <https://github.com/WEC-Sim/WEC-Sim/pull/656>`_ 

Issues and Pull Requests**

  * \> 57 issues closed since v4.3

  * \> 54 PRs merged since v4.3

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.5608563.svg
   :target: https://doi.org/10.5281/zenodo.5608563



`WEC-Sim v4.3 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v4.3>`_
--------------------------------------------------------------------------------

**New Features**

  * Added the ability for WEC-Sim to be run directly from Simulink `#503 <https://github.com/WEC-Sim/WEC-Sim/pull/503>`_ `#512 <https://github.com/WEC-Sim/WEC-Sim/pull/512>`_ `#548 <https://github.com/WEC-Sim/WEC-Sim/pull/548>`_   

  * Added capability to read Capytaine (.nc) output. Includes examples of running Capytaine with hydrostatics `#464 <https://github.com/WEC-Sim/WEC-Sim/pull/464>`_   

  * Created a more accurate infinite frequency added mass calculation `#517 <https://github.com/WEC-Sim/WEC-Sim/pull/517>`_   

  * Added ability for setInitDisp to intake multiple initial rotations `#516 <https://github.com/WEC-Sim/WEC-Sim/pull/516>`_ `#586 <https://github.com/WEC-Sim/WEC-Sim/pull/586>`_
   
**Documentation** 

  * Restructured into four manuals: introduction, theory, user and development `#455 <https://github.com/WEC-Sim/WEC-Sim/pull/455>`_ `#557 <https://github.com/WEC-Sim/WEC-Sim/pull/557>`_   

  * Update of code structure section `#455 <https://github.com/WEC-Sim/WEC-Sim/pull/455>`_, links `#649 <https://github.com/WEC-Sim/WEC-Sim/pull/649>`_ , diagrams `#643 <https://github.com/WEC-Sim/WEC-Sim/pull/643>`_, paraview `#642 <https://github.com/WEC-Sim/WEC-Sim/pull/642>`_,    

  * Added section on suggested troubleshooting `#641 <https://github.com/WEC-Sim/WEC-Sim/pull/641>`_ 
   
**Continuous integration tests** 

  * Overhaul and speed up of tests `#508 <https://github.com/WEC-Sim/WEC-Sim/pull/508>`_ `#620 <https://github.com/WEC-Sim/WEC-Sim/pull/620>`_   

  * Extension of tests to the applications cases `#7 <https://github.com/WEC-Sim/WEC-Sim_Applications/pull/7>`_
   
**Clean up**

  * Created issue templates on GitHub `#575 <https://github.com/WEC-Sim/WEC-Sim/pull/575>`_ `#634 <https://github.com/WEC-Sim/WEC-Sim/pull/634>`_    

  * Updated Morison Element warning flags `#408 <https://github.com/WEC-Sim/WEC-Sim/pull/408>`_   

  * Clean up response class methods `#491 <https://github.com/WEC-Sim/WEC-Sim/pull/491>`_ `#514 <https://github.com/WEC-Sim/WEC-Sim/pull/514>`_    
 
 * Clean up paraview output functions `#490 <https://github.com/WEC-Sim/WEC-Sim/pull/490>`_
   
**Bug Fixes**

  * Paraview macros and .pvsm files `#459 <https://github.com/WEC-Sim/WEC-Sim/pull/459>`_  

  * BEMIO read mean drift force in R2021a `#636 <https://github.com/WEC-Sim/WEC-Sim/pull/636>`_  

  * PTO-Sim calling workspace `#632 <https://github.com/WEC-Sim/WEC-Sim/pull/632>`_ 

  * Combine_BEM Ainf initialization `#611 <https://github.com/WEC-Sim/WEC-Sim/pull/611>`_

**Issues and Pull Requests**  

  * \> 100 issues closed since v4.2

  * \> 45 PRs merged since v4.2

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.5122959.svg
   :target: https://doi.org/10.5281/zenodo.5122959



`WEC-Sim v4.2 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v4.2>`_
--------------------------------------------------------------------------------

**New Features**

  * Added normal/tangential option for Morison Force (``simu.morisonElement = 2``) `#408 <https://github.com/WEC-Sim/WEC-Sim/pull/408>`_

  * Added Drag Body (``body(i).nhBody=2``) `#423 <https://github.com/WEC-Sim/WEC-Sim/pull/423>`_ `#384 <https://github.com/WEC-Sim/WEC-Sim/issues/384>`_

  * WEC-Sim output saved to structure `#426 <https://github.com/WEC-Sim/WEC-Sim/pull/426>`_

  * Added WEC-Sim parallel execution for batch runs (``wecSimPCT``) using MATLAB parallel computing toolbox `#438 <https://github.com/WEC-Sim/WEC-Sim/pull/438>`_

  * Added end stops to PTOs `#445 <https://github.com/WEC-Sim/WEC-Sim/pull/445>`_

**Documentation** 

  * Automatically compile docs with TravisCI `#439 <https://github.com/WEC-Sim/WEC-Sim/pull/439>`_

  * Generate docs for master and dev branches of WEC-Sim
  
**Bug Fixes**

  * Resolved convolution integral bug for body-to-body interactions  `#444 <https://github.com/WEC-Sim/WEC-Sim/pull/444>`_

  * Resolved PTO-Sim bug for linear to rotary conversion blocks  `#247 <https://github.com/WEC-Sim/WEC-Sim/issues/247)>`_ `#485 <https://github.com/WEC-Sim/WEC-Sim/pull/485>`_

  * Resolved variant subsystem labeling bug  `#486 <https://github.com/WEC-Sim/WEC-Sim/pull/486)>`_ `#479 <https://github.com/WEC-Sim/WEC-Sim/issues/479>`_

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.4391330.svg
   :target: https://doi.org/10.5281/zenodo.4391330



`WEC-Sim v4.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v4.1>`_
--------------------------------------------------------------------------------

* Added passive yaw
* Revised spectral formulations per IEC TC114 TS 62600-2 Annex C
* Updated examples on the `WEC-Sim_Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository
* Added unit tests with Jenkins
* Added API documentation for WEC-Sim classes

* Merged Pull Requests

  * Updated BEMIO for AQWA version comparability `#373 <https://github.com/WEC-Sim/WEC-Sim/pull/373)>`_ 

  * Extended capabilities for ParaView visualization `#355 <https://github.com/WEC-Sim/WEC-Sim/pull/355>`_

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.3924765.svg
   :target: https://doi.org/10.5281/zenodo.3924765
   
   
`WEC-Sim v4.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v4.0>`_
--------------------------------------------------------------------------------

* Added mean drift force calculation
* Added generalized body modes for simulating flexible WEC devices and for structure loading analysis
* Updated BEMIO for mean drift force and generalized body modes

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.3827897.svg
   :target: https://doi.org/10.5281/zenodo.3827897
   


`WEC-Sim v3.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v3.1>`_
--------------------------------------------------------------------------------

* Added wave gauges for three locations
* Added command line documentation for objects
* Added error and warning flags
* Converted Morison Elements to script instead of block
* Converted WEC-Sim and PTO-Sim library files back to slx format
* Fixed plot error in MATLAB 2018b


`WEC-Sim v3.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v3.0>`_
--------------------------------------------------------------------------------

* Added option of :ref:`equal energy spacing <user-advanced-features-irregular-wave-binning>` for irregular waves (default)
* Added option to calculate the wave elevation at a location different from the origin
* Added option to define :ref:`gamma for JONSWAP spectrum <user-code-structure-irregular>`
* Improved the WEC-Sim simulation speed when using rapid-acceleration mode
* Fixed path bug in BEMIO for LINUX/OSX users

* Changed/Added following WEC-Sim parameters

  *  waves.randPreDefined -> :ref:`waves.phaseSeed <user-advanced-features-seeded-phase>`	

  *  waves.phaseRand -> waves.phase           	

  *  simu.dtFeNonlin -> :ref:`simu.dtNL <user-advanced-features-nonlinear>`	

  * simu.rampT -> :ref:`simu.rampTime <user-code-structure-simulation-class>`	

  * Added simu.dtME  to allow specification of :ref:`Morison force time-step <user-advanced-features-time-step>`


`WEC-Sim v2.2 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v2.2>`_
--------------------------------------------------------------------------------

* Added option to save pressure data for nonlinear hydro (`simu.pressureDis`)
* Update to moorDyn parser (doesn't require line#.out)  

* Repository cleanup

  * Implemented `Git LFS <https://git-lfs.github.com/>`_ for tracking ``*.h5`` files	

  *  Added `WEC-Sim Application  repository <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ as a `submodule <https://git-scm.com/book/en/v2/Git-Tools-Submodules>`_	

  *  Moved `moorDyn <https://github.com/WEC-Sim/moorDyn>`_ to its own repository	

  *  Removed publications from repository, :ref:`available on website <intro-publications>`



`WEC-Sim v2.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v2.1>`_
--------------------------------------------------------------------------------

* Added MATLAB version of BEMIO (to replace python version)
* Added variable time-step option with 'ode45' by @ratanakso 
* Update to MCR, option to not re-load ``*.h5`` file by @bradling 
* Update to waveClass to allow for definition of min/max wave frequency by @bradling 


`WEC-Sim v2.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v2.0>`_
--------------------------------------------------------------------------------

* Updated WEC-Sim Library (generalized joints/constraints/PTOs)
* Body-to-body interactions for radiation forces
* Morison forces
* Batch run mode (MCR)
* Mooring sub-library implemented in mooringClass (no longer in body or joint)
* More realistic PTO and mooring modeling through PTO-Sim and integration with MoorDyn
* Non-hydrodynamic body option
* Visualization using ParaView


`WEC-Sim v1.3 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.3>`_
--------------------------------------------------------------------------------
* Added Morison Elements
* Body2Body Interactions
* Multiple Case Runs (wecSimMCR)
* Moordyn
* Added Non-hydro Bodies
* Morison Forces
* Joint Updates
* Visualization with Paraview
	
`WEC-Sim v1.2 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.2>`_
--------------------------------------------------------------------------------
* Nonlinear Froude-Krylov hydrodynamics and hydrostatics
* State space radiation
* Wave directionality
* User-defined wave elevation time-series
* Imports nondimensionalized BEMIO hydrodynamic data (instead of fully dimensional coefficients)
* Variant Subsystems implemented to improve code stability (instead of if statements)
* Bug fixes


`WEC-Sim v1.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.1>`_
--------------------------------------------------------------------------------
* WEC-Sim v1.1, `available on GitHub <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.1>`_ 
* Improvements in code stability through modifications to the added mass, radiation damping calculations, and impulse response function calculations
* Implementation of state space representation of radiation damping convolution integral calculation
* New hydrodynamic data format based on :ref:`BEMIO <user-advanced-features-bemio>` output, a python code that reads data from WAMIT, NEMOH, and AQWA and writes to the `Hierarchical Data Format 5 <http://www.hdfgroup.org/>`_ (HDF5) format used by WEC-Sim.
* Documentation available on WEC-Sim Website

`WEC-Sim v1.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.0>`_
--------------------------------------------------------------------------------
* Initial release of WEC-Sim (originally on OpenEI, now on GitHub)
* Available as a static download 
* Documentation available in PDF 


