onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /HMACSHA3384Tb/TEST
add wave -noupdate /HMACSHA3384Tb/hmacSha3384/inClk
add wave -noupdate /HMACSHA3384Tb/hmacSha3384/inRst
add wave -noupdate /HMACSHA3384Tb/hmacSha3384/inDataData
add wave -noupdate /HMACSHA3384Tb/hmacSha3384/inDataWr
add wave -noupdate /HMACSHA3384Tb/hmacSha3384/inDataEnd
add wave -noupdate /HMACSHA3384Tb/hmacSha3384/inKeyData
add wave -noupdate /HMACSHA3384Tb/hmacSha3384/inKeyWr
add wave -noupdate /HMACSHA3384Tb/hmacSha3384/inKeyEnd
add wave -noupdate /HMACSHA3384Tb/hmacSha3384/outHash
add wave -noupdate /HMACSHA3384Tb/outHashEnable
add wave -noupdate /HMACSHA3384Tb/hmacSha3384/outBusy
add wave -noupdate -expand -group Control -radix unsigned /HMACSHA3384Tb/hmacSha3384/hmacSha3Control/regState
add wave -noupdate -group regKey /HMACSHA3384Tb/hmacSha3384/hmacSha3384KeyReg/regKey
add wave -noupdate -group regKey /HMACSHA3384Tb/hmacSha3384/hmacSha3384KeyReg/inExtWr
add wave -noupdate -group regKey /HMACSHA3384Tb/hmacSha3384/hmacSha3384KeyReg/inExtKey
add wave -noupdate -group regKey /HMACSHA3384Tb/hmacSha3384/hmacSha3384KeyReg/inIntWr
add wave -noupdate -group regKey /HMACSHA3384Tb/hmacSha3384/hmacSha3384KeyReg/inIntKey
add wave -noupdate -group regKey /HMACSHA3384Tb/hmacSha3384/hmacSha3384KeyReg/outIpadKey
add wave -noupdate -group regKey /HMACSHA3384Tb/hmacSha3384/hmacSha3384KeyReg/outOpadKey
add wave -noupdate -group Hash /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3DataData
add wave -noupdate -group Hash /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3DataWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/inExtData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/inKeyWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/inKeyData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/inIpadWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/inIpadData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/inOpadWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/inOpadData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/inHashWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/inExtWr
add wave -noupdate -group SHA3 /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/inDataData
add wave -noupdate -group SHA3 /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/outDataData
add wave -noupdate -group SHA3 /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/outBusy
add wave -noupdate -group SHA3 -radix unsigned /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/regRoundCnt
add wave -noupdate -group SHA3 /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3384RegData/regData
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/inClk
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/inExtRst
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/inExtDataWr
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/inEnd
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/outRegDataInIntWr
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/outRegDataInExtWr
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/outRegOutDataWr
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/outRegDataRst
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/outBusy
add wave -noupdate -group SHA3 -group {SHA Control} -radix unsigned /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/regRoundCnt
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3384Tb/hmacSha3384/hmacSha3384Hash/sha3384/instSha3Control/regEnd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1019 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 140
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {921 ns} {1164 ns}
