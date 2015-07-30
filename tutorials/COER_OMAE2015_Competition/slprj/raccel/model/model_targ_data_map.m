  function targMap = targDataMap(),

  ;%***********************
  ;% Create Parameter Map *
  ;%***********************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 1;
    sectIdxOffset = 0;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc paramMap
    ;%
    paramMap.nSections           = nTotSects;
    paramMap.sectIdxOffset       = sectIdxOffset;
      paramMap.sections(nTotSects) = dumSection; %prealloc
    paramMap.nTotData            = -1;
    
    ;%
    ;% Auto data (rtP)
    ;%
      section.nData     = 39;
      section.data(39)  = dumData; %prealloc
      
	  ;% rtP.Constant1_Value
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% rtP.Constant3_Value
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 1;
	
	  ;% rtP.RampTime_Value
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 2;
	
	  ;% rtP.Constant2_Value
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 3;
	
	  ;% rtP.SineWaveFunction_Amp
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 4;
	
	  ;% rtP.SineWaveFunction_Bias
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 5;
	
	  ;% rtP.SineWaveFunction_Freq
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 6;
	
	  ;% rtP.SineWaveFunction_Phase
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 7;
	
	  ;% rtP.Constant_Value
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 8;
	
	  ;% rtP.R_Y0
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 9;
	
	  ;% rtP.Constant_Value_hb53syfdvp
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 10;
	
	  ;% rtP.InputWaveForceTimeHistory_Time0
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 11;
	
	  ;% rtP.InputWaveForceTimeHistory_Data0
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 25012;
	
	  ;% rtP.Constant_Value_nukvykjcqh
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 175018;
	
	  ;% rtP.RampFunctionTime1_Value
	  section.data(15).logicalSrcIdx = 14;
	  section.data(15).dtTransOffset = 175024;
	
	  ;% rtP.RadiationDampingMatrix_Value
	  section.data(16).logicalSrcIdx = 15;
	  section.data(16).dtTransOffset = 175025;
	
	  ;% rtP.WaveType1_Value
	  section.data(17).logicalSrcIdx = 16;
	  section.data(17).dtTransOffset = 175061;
	
	  ;% rtP.ImpulseResponseFunctionK1_Value
	  section.data(18).logicalSrcIdx = 17;
	  section.data(18).dtTransOffset = 175062;
	
	  ;% rtP.Timerelativetothecurrenttimestep1_Value
	  section.data(19).logicalSrcIdx = 18;
	  section.data(19).dtTransOffset = 193098;
	
	  ;% rtP.AddedMassMatrix_Value
	  section.data(20).logicalSrcIdx = 19;
	  section.data(20).dtTransOffset = 193599;
	
	  ;% rtP.TransportDelay_Delay
	  section.data(21).logicalSrcIdx = 20;
	  section.data(21).dtTransOffset = 193635;
	
	  ;% rtP.TransportDelay_InitOutput
	  section.data(22).logicalSrcIdx = 21;
	  section.data(22).dtTransOffset = 193636;
	
	  ;% rtP.Constant1_Value_agy3hr22i0
	  section.data(23).logicalSrcIdx = 22;
	  section.data(23).dtTransOffset = 193637;
	
	  ;% rtP.Gravity_Value
	  section.data(24).logicalSrcIdx = 23;
	  section.data(24).dtTransOffset = 193643;
	
	  ;% rtP.BodyMass_Value
	  section.data(25).logicalSrcIdx = 24;
	  section.data(25).dtTransOffset = 193644;
	
	  ;% rtP.WaterDensity_Value
	  section.data(26).logicalSrcIdx = 25;
	  section.data(26).dtTransOffset = 193645;
	
	  ;% rtP.Volume_Value
	  section.data(27).logicalSrcIdx = 26;
	  section.data(27).dtTransOffset = 193646;
	
	  ;% rtP.LinearRestioringCoefficientMatrix_Value
	  section.data(28).logicalSrcIdx = 27;
	  section.data(28).dtTransOffset = 193647;
	
	  ;% rtP.CenterofGravity_Value
	  section.data(29).logicalSrcIdx = 28;
	  section.data(29).dtTransOffset = 193683;
	
	  ;% rtP.Constant_Value_lkconmqjp1
	  section.data(30).logicalSrcIdx = 29;
	  section.data(30).dtTransOffset = 193686;
	
	  ;% rtP.ViscousDampingMatrixdiagonal_Value
	  section.data(31).logicalSrcIdx = 30;
	  section.data(31).dtTransOffset = 193689;
	
	  ;% rtP.MooringKMatrix_Value
	  section.data(32).logicalSrcIdx = 31;
	  section.data(32).dtTransOffset = 193725;
	
	  ;% rtP.CenterofGravity_Value_domqznncni
	  section.data(33).logicalSrcIdx = 32;
	  section.data(33).dtTransOffset = 193761;
	
	  ;% rtP.DispforRotation_Value
	  section.data(34).logicalSrcIdx = 33;
	  section.data(34).dtTransOffset = 193764;
	
	  ;% rtP.CenterofGravity2_Value
	  section.data(35).logicalSrcIdx = 34;
	  section.data(35).dtTransOffset = 193767;
	
	  ;% rtP.MooringPreTension_Value
	  section.data(36).logicalSrcIdx = 35;
	  section.data(36).dtTransOffset = 193803;
	
	  ;% rtP.AdditionalLinearDampingMatrixdiagonal_Value
	  section.data(37).logicalSrcIdx = 36;
	  section.data(37).dtTransOffset = 193809;
	
	  ;% rtP.Gain1_Gain
	  section.data(38).logicalSrcIdx = 37;
	  section.data(38).dtTransOffset = 193845;
	
	  ;% rtP.Gain_Gain
	  section.data(39).logicalSrcIdx = 38;
	  section.data(39).dtTransOffset = 193846;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(1) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (parameter)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    paramMap.nTotData = nTotData;
    


  ;%**************************
  ;% Create Block Output Map *
  ;%**************************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 1;
    sectIdxOffset = 0;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc sigMap
    ;%
    sigMap.nSections           = nTotSects;
    sigMap.sectIdxOffset       = sectIdxOffset;
      sigMap.sections(nTotSects) = dumSection; %prealloc
    sigMap.nTotData            = -1;
    
    ;%
    ;% Auto data (rtB)
    ;%
      section.nData     = 25;
      section.data(25)  = dumData; %prealloc
      
	  ;% rtB.gp4nev3uk2
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% rtB.d2xuepsjim
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 1;
	
	  ;% rtB.ct40rrgy2z
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 2;
	
	  ;% rtB.ihwes2dtfr
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 8;
	
	  ;% rtB.m1qvdx50x4
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 14;
	
	  ;% rtB.d3y2xaszec
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 27;
	
	  ;% rtB.lvvf0bqxfs
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 33;
	
	  ;% rtB.eolsxqeopi
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 39;
	
	  ;% rtB.lwja32nw0o
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 45;
	
	  ;% rtB.ahycaj0guq
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 51;
	
	  ;% rtB.ap3oljrrms
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 57;
	
	  ;% rtB.bsdgilczcq
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 63;
	
	  ;% rtB.ir15yujoqd
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 69;
	
	  ;% rtB.boiyl5gumk
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 75;
	
	  ;% rtB.fqjbfnavyj
	  section.data(15).logicalSrcIdx = 14;
	  section.data(15).dtTransOffset = 79;
	
	  ;% rtB.ihyzgszr0v
	  section.data(16).logicalSrcIdx = 15;
	  section.data(16).dtTransOffset = 83;
	
	  ;% rtB.nq2h4515ht
	  section.data(17).logicalSrcIdx = 16;
	  section.data(17).dtTransOffset = 87;
	
	  ;% rtB.goiaowndqp
	  section.data(18).logicalSrcIdx = 17;
	  section.data(18).dtTransOffset = 91;
	
	  ;% rtB.ndxl3efuzg
	  section.data(19).logicalSrcIdx = 18;
	  section.data(19).dtTransOffset = 95;
	
	  ;% rtB.jbr0g0opkk
	  section.data(20).logicalSrcIdx = 19;
	  section.data(20).dtTransOffset = 99;
	
	  ;% rtB.puftny0vbh
	  section.data(21).logicalSrcIdx = 20;
	  section.data(21).dtTransOffset = 111;
	
	  ;% rtB.agg0imdhkd
	  section.data(22).logicalSrcIdx = 21;
	  section.data(22).dtTransOffset = 114;
	
	  ;% rtB.blhr21o55v
	  section.data(23).logicalSrcIdx = 22;
	  section.data(23).dtTransOffset = 117;
	
	  ;% rtB.bakyzhadqy
	  section.data(24).logicalSrcIdx = 23;
	  section.data(24).dtTransOffset = 123;
	
	  ;% rtB.ior3oqabda
	  section.data(25).logicalSrcIdx = 25;
	  section.data(25).dtTransOffset = 189;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(1) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (signal)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    sigMap.nTotData = nTotData;
    


  ;%*******************
  ;% Create DWork Map *
  ;%*******************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 5;
    sectIdxOffset = 1;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc dworkMap
    ;%
    dworkMap.nSections           = nTotSects;
    dworkMap.sectIdxOffset       = sectIdxOffset;
      dworkMap.sections(nTotSects) = dumSection; %prealloc
    dworkMap.nTotData            = -1;
    
    ;%
    ;% Auto data (rtDW)
    ;%
      section.nData     = 9;
      section.data(9)  = dumData; %prealloc
      
	  ;% rtDW.cm0dc1ejgh
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% rtDW.hvk1i0gkkr
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 2;
	
	  ;% rtDW.nfneg5f1xq
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 4;
	
	  ;% rtDW.cnt3gp5zk0
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 6;
	
	  ;% rtDW.hkjbpa1hoy
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 8;
	
	  ;% rtDW.pyrzhckx4q
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 10;
	
	  ;% rtDW.pokqkec44n
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 12;
	
	  ;% rtDW.ofa1jalz0c
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 3018;
	
	  ;% rtDW.epe5e3kr3q.modelTStart
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 3019;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(1) = section;
      clear section
      
      section.nData     = 24;
      section.data(24)  = dumData; %prealloc
      
	  ;% rtDW.e2nsljhsxc.TimePtr
	  section.data(1).logicalSrcIdx = 9;
	  section.data(1).dtTransOffset = 0;
	
	  ;% rtDW.jfer4bapbu
	  section.data(2).logicalSrcIdx = 10;
	  section.data(2).dtTransOffset = 1;
	
	  ;% rtDW.fz2tfi3tcg
	  section.data(3).logicalSrcIdx = 11;
	  section.data(3).dtTransOffset = 2;
	
	  ;% rtDW.pqjjdgupqa
	  section.data(4).logicalSrcIdx = 12;
	  section.data(4).dtTransOffset = 3;
	
	  ;% rtDW.nx2pmzebeh
	  section.data(5).logicalSrcIdx = 13;
	  section.data(5).dtTransOffset = 4;
	
	  ;% rtDW.gu3lcgxapn
	  section.data(6).logicalSrcIdx = 14;
	  section.data(6).dtTransOffset = 5;
	
	  ;% rtDW.dxed3rmk0e
	  section.data(7).logicalSrcIdx = 15;
	  section.data(7).dtTransOffset = 6;
	
	  ;% rtDW.devp2jxxwr
	  section.data(8).logicalSrcIdx = 16;
	  section.data(8).dtTransOffset = 7;
	
	  ;% rtDW.m4ocv53w5j
	  section.data(9).logicalSrcIdx = 17;
	  section.data(9).dtTransOffset = 8;
	
	  ;% rtDW.jaqn44uwte
	  section.data(10).logicalSrcIdx = 18;
	  section.data(10).dtTransOffset = 9;
	
	  ;% rtDW.h3n5kza03q
	  section.data(11).logicalSrcIdx = 19;
	  section.data(11).dtTransOffset = 10;
	
	  ;% rtDW.fozqgpqyng.TUbufferPtrs
	  section.data(12).logicalSrcIdx = 20;
	  section.data(12).dtTransOffset = 11;
	
	  ;% rtDW.mqbg0o0lmq
	  section.data(13).logicalSrcIdx = 21;
	  section.data(13).dtTransOffset = 23;
	
	  ;% rtDW.aec5yt3v3h
	  section.data(14).logicalSrcIdx = 22;
	  section.data(14).dtTransOffset = 24;
	
	  ;% rtDW.bwkayrmypq
	  section.data(15).logicalSrcIdx = 23;
	  section.data(15).dtTransOffset = 25;
	
	  ;% rtDW.gxjky3bs13
	  section.data(16).logicalSrcIdx = 24;
	  section.data(16).dtTransOffset = 26;
	
	  ;% rtDW.pbnodt1qas
	  section.data(17).logicalSrcIdx = 25;
	  section.data(17).dtTransOffset = 27;
	
	  ;% rtDW.avzl3iplot.LoggedData
	  section.data(18).logicalSrcIdx = 26;
	  section.data(18).dtTransOffset = 28;
	
	  ;% rtDW.ch53c52p0v
	  section.data(19).logicalSrcIdx = 27;
	  section.data(19).dtTransOffset = 29;
	
	  ;% rtDW.dmricrwz2r
	  section.data(20).logicalSrcIdx = 28;
	  section.data(20).dtTransOffset = 30;
	
	  ;% rtDW.j3vkxhyoia
	  section.data(21).logicalSrcIdx = 29;
	  section.data(21).dtTransOffset = 31;
	
	  ;% rtDW.b2eyiur3lz
	  section.data(22).logicalSrcIdx = 30;
	  section.data(22).dtTransOffset = 32;
	
	  ;% rtDW.ptxcrgvmjq
	  section.data(23).logicalSrcIdx = 31;
	  section.data(23).dtTransOffset = 33;
	
	  ;% rtDW.njkjsgon2r.LoggedData
	  section.data(24).logicalSrcIdx = 32;
	  section.data(24).dtTransOffset = 34;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(2) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% rtDW.alodwyeszf.PrevIndex
	  section.data(1).logicalSrcIdx = 33;
	  section.data(1).dtTransOffset = 0;
	
	  ;% rtDW.g2ak3oh3dw.Tail
	  section.data(2).logicalSrcIdx = 34;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(3) = section;
      clear section
      
      section.nData     = 3;
      section.data(3)  = dumData; %prealloc
      
	  ;% rtDW.jpt0sqycta
	  section.data(1).logicalSrcIdx = 35;
	  section.data(1).dtTransOffset = 0;
	
	  ;% rtDW.e50d3egpdn
	  section.data(2).logicalSrcIdx = 36;
	  section.data(2).dtTransOffset = 1;
	
	  ;% rtDW.f3x2trazzv
	  section.data(3).logicalSrcIdx = 37;
	  section.data(3).dtTransOffset = 2;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(4) = section;
      clear section
      
      section.nData     = 5;
      section.data(5)  = dumData; %prealloc
      
	  ;% rtDW.pl3mmoxioc
	  section.data(1).logicalSrcIdx = 38;
	  section.data(1).dtTransOffset = 0;
	
	  ;% rtDW.ctuxjzycgp
	  section.data(2).logicalSrcIdx = 39;
	  section.data(2).dtTransOffset = 1;
	
	  ;% rtDW.or53wctqce
	  section.data(3).logicalSrcIdx = 40;
	  section.data(3).dtTransOffset = 2;
	
	  ;% rtDW.llyujcj5cn
	  section.data(4).logicalSrcIdx = 41;
	  section.data(4).dtTransOffset = 3;
	
	  ;% rtDW.ezftuaym53
	  section.data(5).logicalSrcIdx = 42;
	  section.data(5).dtTransOffset = 4;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(5) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (dwork)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    dworkMap.nTotData = nTotData;
    


  ;%
  ;% Add individual maps to base struct.
  ;%

  targMap.paramMap  = paramMap;    
  targMap.signalMap = sigMap;
  targMap.dworkMap  = dworkMap;
  
  ;%
  ;% Add checksums to base struct.
  ;%


  targMap.checksum0 = 3784954264;
  targMap.checksum1 = 1773877015;
  targMap.checksum2 = 2961190069;
  targMap.checksum3 = 531083146;

