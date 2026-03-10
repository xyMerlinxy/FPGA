onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /HMACSHA3224Tb/hmacSha3224/inClk
add wave -noupdate /HMACSHA3224Tb/hmacSha3224/inRst
add wave -noupdate /HMACSHA3224Tb/hmacSha3224/inDataData
add wave -noupdate /HMACSHA3224Tb/hmacSha3224/inDataWr
add wave -noupdate /HMACSHA3224Tb/hmacSha3224/inDataEnd
add wave -noupdate /HMACSHA3224Tb/hmacSha3224/inKeyData
add wave -noupdate /HMACSHA3224Tb/hmacSha3224/inKeyWr
add wave -noupdate /HMACSHA3224Tb/hmacSha3224/inKeyEnd
add wave -noupdate /HMACSHA3224Tb/outHashEnable
add wave -noupdate /HMACSHA3224Tb/hmacSha3224/outHash
add wave -noupdate /HMACSHA3224Tb/hmacSha3224/outBusy
add wave -noupdate -group Control -radix unsigned /HMACSHA3224Tb/hmacSha3224/hmacSha3Control/regState
add wave -noupdate -group regKey /HMACSHA3224Tb/hmacSha3224/hmacSha3224KeyReg/regKey
add wave -noupdate -group regKey /HMACSHA3224Tb/hmacSha3224/hmacSha3224KeyReg/inExtWr
add wave -noupdate -group regKey /HMACSHA3224Tb/hmacSha3224/hmacSha3224KeyReg/inExtKey
add wave -noupdate -group regKey /HMACSHA3224Tb/hmacSha3224/hmacSha3224KeyReg/inIntWr
add wave -noupdate -group regKey /HMACSHA3224Tb/hmacSha3224/hmacSha3224KeyReg/inIntKey
add wave -noupdate -group regKey /HMACSHA3224Tb/hmacSha3224/hmacSha3224KeyReg/outIpadKey
add wave -noupdate -group regKey /HMACSHA3224Tb/hmacSha3224/hmacSha3224KeyReg/outOpadKey
add wave -noupdate -group Hash /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3DataData
add wave -noupdate -group Hash /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3DataWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/inExtData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/inKeyWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/inKeyData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/inIpadWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/inIpadData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/inOpadWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/inOpadData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/inHashWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/inExtWr
add wave -noupdate -group SHA3 /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/inDataData
add wave -noupdate -group SHA3 /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/outDataData
add wave -noupdate -group SHA3 /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/outBusy
add wave -noupdate -group SHA3 -radix unsigned /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/regRoundCnt
add wave -noupdate -group SHA3 /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3224RegData/regData
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/inClk
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/inExtRst
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/inExtDataWr
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/inEnd
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/outRegDataInIntWr
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/outRegDataInExtWr
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/outRegOutDataWr
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/outRegDataRst
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/outBusy
add wave -noupdate -group SHA3 -group {SHA Control} -radix unsigned /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/regRoundCnt
add wave -noupdate -group SHA3 -group {SHA Control} /HMACSHA3224Tb/hmacSha3224/hmacSha3224Hash/sha3224/instSha3Control/regEnd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1019 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {933 ns} {1173 ns}
