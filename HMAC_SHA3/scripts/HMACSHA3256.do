onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /HMACSHA3256Tb/hmacSha3256/inClk
add wave -noupdate /HMACSHA3256Tb/hmacSha3256/inRst
add wave -noupdate /HMACSHA3256Tb/hmacSha3256/inDataData
add wave -noupdate /HMACSHA3256Tb/hmacSha3256/inDataWr
add wave -noupdate /HMACSHA3256Tb/hmacSha3256/inDataEnd
add wave -noupdate /HMACSHA3256Tb/hmacSha3256/inKeyData
add wave -noupdate /HMACSHA3256Tb/hmacSha3256/inKeyWr
add wave -noupdate /HMACSHA3256Tb/hmacSha3256/inKeyEnd
add wave -noupdate /HMACSHA3256Tb/hmacSha3256/outHash
add wave -noupdate /HMACSHA3256Tb/hmacSha3256/outBusy
add wave -noupdate -expand -group Control -radix unsigned /HMACSHA3256Tb/hmacSha3256/hmacSha3Control/regState
add wave -noupdate -group regKey /HMACSHA3256Tb/hmacSha3256/hmacSha3256KeyReg/regKey
add wave -noupdate -group regKey /HMACSHA3256Tb/hmacSha3256/hmacSha3256KeyReg/inExtWr
add wave -noupdate -group regKey /HMACSHA3256Tb/hmacSha3256/hmacSha3256KeyReg/inExtKey
add wave -noupdate -group regKey /HMACSHA3256Tb/hmacSha3256/hmacSha3256KeyReg/inIntWr
add wave -noupdate -group regKey /HMACSHA3256Tb/hmacSha3256/hmacSha3256KeyReg/inIntKey
add wave -noupdate -group regKey /HMACSHA3256Tb/hmacSha3256/hmacSha3256KeyReg/outIpadKey
add wave -noupdate -group regKey /HMACSHA3256Tb/hmacSha3256/hmacSha3256KeyReg/outOpadKey
add wave -noupdate -group Hash /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3DataData
add wave -noupdate -group Hash /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3DataWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/inExtData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/inKeyWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/inKeyData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/inIpadWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/inIpadData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/inOpadWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/inOpadData
add wave -noupdate -group Hash -group {In Data} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/inHashWr
add wave -noupdate -group Hash -group {In Data} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/inExtWr
add wave -noupdate -expand -group SHA3 /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/inDataData
add wave -noupdate -expand -group SHA3 /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/outDataData
add wave -noupdate -expand -group SHA3 /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/outBusy
add wave -noupdate -expand -group SHA3 -radix unsigned /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/regRoundCnt
add wave -noupdate -expand -group SHA3 /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3256RegData/regData
add wave -noupdate -expand -group SHA3 -group {SHA Control} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/inClk
add wave -noupdate -expand -group SHA3 -group {SHA Control} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/inExtRst
add wave -noupdate -expand -group SHA3 -group {SHA Control} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/inExtDataWr
add wave -noupdate -expand -group SHA3 -group {SHA Control} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/inEnd
add wave -noupdate -expand -group SHA3 -group {SHA Control} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/outRegDataInIntWr
add wave -noupdate -expand -group SHA3 -group {SHA Control} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/outRegDataInExtWr
add wave -noupdate -expand -group SHA3 -group {SHA Control} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/outRegOutDataWr
add wave -noupdate -expand -group SHA3 -group {SHA Control} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/outRegDataRst
add wave -noupdate -expand -group SHA3 -group {SHA Control} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/outBusy
add wave -noupdate -expand -group SHA3 -group {SHA Control} -radix unsigned /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/regRoundCnt
add wave -noupdate -expand -group SHA3 -group {SHA Control} /HMACSHA3256Tb/hmacSha3256/hmacSha3256Hash/sha3256/instSha3Control/regEnd
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
