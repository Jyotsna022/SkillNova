package com.skillnova.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public final class SessionUtil {

    public static final String USER_ID = "userId";
    public static final String FULL_NAME = "fullName";
    public static final String ROLE = "role";
    public static final String LAST_SEEN_AT = "lastSeenAt";

    private SessionUtil() {
    }

    public static void createUserSession(HttpServletRequest request, long userId, String fullName, String role) {
        HttpSession session = request.getSession(true);
        session.setAttribute(USER_ID, userId);
        session.setAttribute(FULL_NAME, fullName);
        session.setAttribute(ROLE, role);
        touchSession(session);
    }

    public static void touchSession(HttpSession session) {
        if (session != null) {
            session.setAttribute(LAST_SEEN_AT, System.currentTimeMillis());
        }
    }

    public static Long getUserId(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object userId = session.getAttribute(USER_ID);
        if (userId instanceof Long) {
            return (Long) userId;
        }
        if (userId instanceof Integer) {
            return ((Integer) userId).longValue();
        }
        if (userId != null) {
            try {
                return Long.parseLong(String.valueOf(userId));
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
        return null;
    }

    public static String getRole(HttpSession session) {
        return session == null ? null : (String) session.getAttribute(ROLE);
    }

    public static Long getLastSeenAt(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute(LAST_SEEN_AT);
        if (value instanceof Long) {
            return (Long) value;
        }
        return null;
    }

    public static void invalidate(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }
}
