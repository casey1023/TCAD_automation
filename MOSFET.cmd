File {
  * input files:
  Grid=   "MOSFET_msh.tdr"
  * output files:
  Plot=   "MOSFET_Vds0p5V_des.tdr"
  Current="MOSFET_Vds0p5V_des.plt"
  Output= "MOSFET_Vds0p5V_des.log"
}

Electrode {
  { Name="Source"    Voltage=0.0 }
  { Name="Drain"     Voltage=0.5 }
  { Name="Gate"      Voltage=0.0 }
  { Name="Body"      Voltage=0.0 }
}

Physics {
  Mobility( DopingDep HighFieldsat Enormal )
  EffectiveIntrinsicDensity( OldSlotboom )
}

Plot {
  eDensity  hDensity  eCurrent  hCurrent
  Potential  SpaceCharge  ElectricField
  eMobility  hMobility  eVelocity  hVelocity
  Doping  DonorConcentration   AcceptorConcentration
  ConductionBandEnergy ValenceBandEnergy
}

Math {
  Extrapolate
  RelErrControl
}

Solve {
  #-initial solution:
  Poisson
  Coupled { Poisson Electron Hole }
  #-ramp gate:
  Quasistationary ( InitialStep = 0.010 MaxStep = 0.010 MinStep=0.005
                    Goal { Name="Gate" Voltage=-0.5 } )
                  { Coupled { Poisson Electron Hole} }
  Quasistationary ( InitialStep = 0.010 MaxStep = 0.010 MinStep=0.005
                    Goal { Name="Gate" Voltage=3 } )
                  { Coupled { Poisson Electron Hole} }
}
