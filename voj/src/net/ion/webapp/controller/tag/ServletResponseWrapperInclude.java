package net.ion.webapp.controller.tag;

import java.io.IOException;
import java.io.PrintWriter;


import javax.el.ELContext;
import javax.el.ExpressionFactory;
import javax.el.ValueExpression;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import javax.servlet.jsp.JspFactory;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyContent;

import org.apache.commons.lang.StringUtils;

public class ServletResponseWrapperInclude extends HttpServletResponseWrapper {

		private PrintWriter printWriter;
		private JspWriter jspWriter;

		public ServletResponseWrapperInclude(ServletResponse response, JspWriter jspWriter) {
			super((HttpServletResponse) response);
			printWriter = new PrintWriter(jspWriter);
			this.jspWriter = jspWriter;
		}

		public PrintWriter getWriter() throws IOException {
			return printWriter;
		}

//		public ServletOutputStream getOutputStream() throws IOException {
//			throw new IllegalStateException();
//		}

		public void resetBuffer() {
			try {
				jspWriter.clearBuffer();
			} catch (IOException ioe) {
			}
		}
}

