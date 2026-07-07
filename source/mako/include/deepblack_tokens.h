#ifndef DEEPBLACK_TOKENS_H
#define DEEPBLACK_TOKENS_H

/*
 * deepBlack semantic tokens
 *
 * Tokens describe purpose, not decoration.
 * Implementation values may evolve, but semantic meaning should remain stable.
 */

/* Accent tokens */
#define DB_ACCENT_PRIMARY        0x39FF14FF

/* Surface tokens */
#define DB_SURFACE_00            0x000000FF
#define DB_SURFACE_01            0x050805F2
#define DB_SURFACE_02            0x071009F2
#define DB_SURFACE_03            0x0A120CF2

/* Text tokens */
#define DB_TEXT_PRIMARY          0xD7FFE0FF
#define DB_TEXT_SECONDARY        0x9ABAA2FF
#define DB_TEXT_MUTED            0x4D6654FF

/* State tokens */
#define DB_STATE_SUCCESS         DB_ACCENT_PRIMARY
#define DB_STATE_WARNING         0xFFB020FF
#define DB_STATE_CRITICAL        0xFF3040FF
#define DB_STATE_DISABLED        DB_TEXT_MUTED

/* Border tokens */
#define DB_BORDER_ACTIVE         DB_ACCENT_PRIMARY
#define DB_BORDER_INACTIVE       DB_TEXT_MUTED
#define DB_BORDER_CRITICAL       DB_STATE_CRITICAL

#endif /* DEEPBLACK_TOKENS_H */
