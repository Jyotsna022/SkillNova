package com.skillnova.filter;

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
            "/logout"
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
        String role = session == null ? null : (String) session.getAttribute("role");

        if (session != null) {
            Long lastSeen = (Long) session.getAttribute("lastSeenAt");
            long now = System.currentTimeMillis();
            if (lastSeen != null && now - lastSeen > SESSION_TIMEOUT_MILLIS) {
                session.invalidate();
                resp.sendRedirect(contextPath + "/login?timeout=1");
                return;
            }
            session.setAttribute("lastSeenAt", now);
        }

        if (role == null) {
            resp.sendRedirect(contextPath + "/login");
            return;
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
