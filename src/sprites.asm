SECTION "Sprites DEF", ROM0

;;include "Tiles/Floor.inc"
;;include "Tiles/Floor.z80"


Mr_floor_sprite:
DB $00, $00, $0F, $0F, $10, $1F, $10, $1F, $10, $10, $10, $10, $14, $19, $14, $10
DB $10, $12, $08, $08, $0B, $0D, $11, $17, $19, $16, $08, $0F, $05, $07, $0F, $09
DB $00, $00, $00, $00, $F0, $F0, $08, $F8, $08, $78, $08, $78, $08, $38, $08, $08
DB $08, $38, $F0, $30, $88, $78, $08, $C8, $38, $C8, $10, $F0, $D0, $F0, $F0, $90

Rock_Sprite:
DB $63, $1F, $B7, $11, $FB, $11, $FF, $F1, $9F, $BF, $99, $FB, $F8, $3E, $6F, $22
DB $F7, $22, $FF, $E3, $7E, $FE, $5E, $C7, $ED, $44, $FE, $44, $FF, $7C, $F3, $F7
DB $63, $1F, $B7, $11, $FB, $11, $FF, $F1, $9F, $BF, $99, $FB, $F8, $3E, $6F, $22
DB $F7, $22, $FF, $E3, $7E, $FE, $5E, $C7, $ED, $44, $FE, $44, $FF, $7C, $F3, $F7

Enemy_Sprite:
DB $00, $00, $03, $03, $07, $04, $0F, $08, $0F, $0A, $0F, $0A, $0F, $08, $0F, $09
DB $1F, $11, $3F, $20, $7B, $44, $73, $4C, $38, $3F, $0E, $0F, $03, $03, $00, $00
DB $00, $00, $E0, $E0, $F0, $10, $F8, $08, $F8, $28, $F8, $28, $F8, $88, $FC, $CC
DB $FA, $C6, $FA, $06, $EA, $16, $E2, $1E, $CA, $3E, $0C, $FC, $E8, $F8, $30, $30


Floor_sprite:
DB $00,$FF,$5D,$FF,$77,$FF,$7F,$FF
DB $47,$FF,$5F,$E7,$57,$E7,$54,$E7
DB $55,$E6,$55,$E6,$55,$E6,$55,$E6
DB $55,$E6,$55,$E6,$5D,$E6,$44,$FF
DB $00,$FF,$57,$FF,$FF,$FF,$F7,$FF
DB $EF,$FF,$FF,$FF,$FF,$FF,$7F,$FF
DB $FF,$7F,$7F,$7F,$47,$7F,$5F,$67
DB $57,$67,$57,$67,$DF,$67,$47,$FF


SECTION "Data", ROM0

;;             		y  x  tile  Att         
sprite1_player:  DB 16, 16, $28, %00000000
sprite2_player:  DB 16, 24, $2A, %00000000
sprite1_enemy:  DB  40,  80,   $20,  %00000000   
sprite2_enemy:  DB  40,  88,   $22,  %00000000   
sprite1_floor: DB 100, 50, $30, %00000000
sprite2_floor: DB 100, 58, $32, %00000000
