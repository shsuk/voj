package net.ion.webapp;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class UserCharsetFilter implements Filter {
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		String charset = "UTF-8";
		request.setCharacterEncoding(charset);
		response.setCharacterEncoding(charset);
		
		// ((HttpServletResponse)response).addHeader("Content-Type", "text/html; charset=utf-8");
		
		chain.doFilter(request, response);
	}

	public void destroy() {
	}
}
