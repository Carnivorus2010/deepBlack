#ifndef DEEPBLACK_MAKO_DEFAULTS_H
#define DEEPBLACK_MAKO_DEFAULTS_H

#include "deepblack_tokens.h"

/*
 * deepBlack Mako defaults
 *
 * Mako represents HIERARCHY_03 — System Communication.
 * Notifications should be visible, structured, and calm.
 */

#define DB_MAKO_FONT             "JetBrainsMono Nerd Font Mono Bold 11"

#define DB_MAKO_BACKGROUND       DB_SURFACE_01
#define DB_MAKO_TEXT             DB_TEXT_PRIMARY
#define DB_MAKO_BORDER           DB_BORDER_ACTIVE
#define DB_MAKO_PROGRESS         DB_ACCENT_PRIMARY

#define DB_MAKO_WIDTH            420
#define DB_MAKO_HEIGHT           120
#define DB_MAKO_OUTER_MARGIN     16
#define DB_MAKO_MARGIN           8
#define DB_MAKO_PADDING          12

#define DB_MAKO_BORDER_SIZE      2
#define DB_MAKO_BORDER_RADIUS    0
#define DB_MAKO_ICON_SIZE        32
#define DB_MAKO_ICON_RADIUS      0

#define DB_MAKO_DEFAULT_TIMEOUT  5000
#define DB_MAKO_MAX_VISIBLE      4

/* Urgency defaults */
#define DB_MAKO_LOW_BORDER        DB_BORDER_INACTIVE
#define DB_MAKO_LOW_PROGRESS      DB_TEXT_MUTED
#define DB_MAKO_LOW_TIMEOUT       3000

#define DB_MAKO_NORMAL_BORDER     DB_BORDER_ACTIVE
#define DB_MAKO_NORMAL_PROGRESS   DB_ACCENT_PRIMARY
#define DB_MAKO_NORMAL_TIMEOUT    DB_MAKO_DEFAULT_TIMEOUT

#define DB_MAKO_CRITICAL_BORDER   DB_BORDER_CRITICAL
#define DB_MAKO_CRITICAL_PROGRESS DB_STATE_CRITICAL
#define DB_MAKO_CRITICAL_TIMEOUT  0

#endif /* DEEPBLACK_MAKO_DEFAULTS_H */
