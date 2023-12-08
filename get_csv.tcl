set mydata2D [load_file MOSFET_Vds0p5V_des.plt]
export_variables -dataset $mydata2D -filename "set_your_csv_name.csv" -overwrite
