package com.skillnova.filter;

import com.skillnova.util.CookieUtil;
import com.skillnova.util.SessionUtil;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final Set<String> PUBLIC_PATHS = Set.of(
            "/",
            "/index.jsp",
            "/login",
            "/register",
            "/health/db",
            "/logout",
            "/about.jsp",
            "/contact.jsp"
    );

    private static final long SESSION_TIMEOUT_MILLIS = 20L * 60L * 1000L;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI();
        String path = uri.substring(contextPath.length());

        if (isAsset(path) || PUBLIC_PATHS.contains(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        String role = SessionUtil.getRole(session);

        if (session != null) {
            Long lastSeen = SessionUtil.getLastSeenAt(session);
            long now = System.currentTimeMillis();
            if (lastSeen != null && now - lastSeen > SESSION_TIMEOUT_MILLIS) {
                SessionUtil.invalidate(session);
                CookieUtil.delete(req, resp, CookieUtil.REMEMBER_ME);
                resp.sendRedirect(contextPath + "/login?timeout=1");
                return;
            }
            SessionUtil.touchSession(session);
        }

        if (role == null) {
            resp.sendRedirect(contextPath + "/login");
            return;
        }

        if (role != null && (path.startsWith("/client") || path.startsWith("/freelancer"))) {
            String status = (String) session.getAttribute("accountStatus");
            if (status != null && "SUSPENDED".equalsIgnoreCase(status)) {
                resp.sendRedirect(contextPath + "/error/403");
                return;
            }
        }

        if (path.startsWith("/admin") && !"ADMIN".equals(role)) {
            resp.sendRedirect(contextPath + "/error/403");
            return;
        }

        if (path.startsWith("/client") && !"CLIENT".equals(role)) {
            resp.sendRedirect(contextPath + "/error/403");
            return;
        }

        if (path.startsWith("/freelancer") && !"FREELANCER".equals(role)) {
            resp.sendRedirect(contextPath + "/error/403");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isAsset(String path) {
        return path.startsWith("/assets/") || path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png")
                || path.endsWith(".jpg") || path.endsWith(".svg") || path.endsWith(".ico");
    }
}
