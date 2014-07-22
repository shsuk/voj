package net.ion.webapp.controller.tag;

import java.io.IOException;

import javax.el.ELContext;
import javax.el.ExpressionFactory;
import javax.el.ValueExpression;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspFactory;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyContent;

import org.apache.commons.lang.StringUtils;
import org.apache.taglibs.standard.functions.Functions;


public class TemplateUtils {
	public static void include(String src, PageContext pageContext) throws ServletException, IOException{
		JspWriter out = pageContext.getOut();
		String exp = null;
		while(StringUtils.isNotEmpty(exp = StringUtils.substringBetween(src, "${", "}"))){
			exp = "${" + exp + "}";
			String val = (String) TemplateUtils.proprietaryEvaluate(exp, String.class, (PageContext)pageContext, null, false);
			val = Functions.escapeXml(val);
			src = StringUtils.replace(StringUtils.replace(src, exp, val), "__::__", ";");
		}
		
		if(src.endsWith(".jsp")) TemplateUtils.include(pageContext.getRequest(), pageContext.getResponse(), src, out, false);
		else out.print(src);
		
	}
	private static String getContextRelativePath(ServletRequest request, String relativePath) {
		if (relativePath.startsWith("/"))
			return relativePath;
		if (!(request instanceof HttpServletRequest))
			return relativePath;
		HttpServletRequest hrequest = (HttpServletRequest) request;
		String uri = (String) request.getAttribute("javax.servlet.include.servlet_path");
		if (uri != null) {
			String pathInfo = (String) request.getAttribute("javax.servlet.include.path_info");
			if (pathInfo == null && uri.lastIndexOf('/') >= 0)
				uri = uri.substring(0, uri.lastIndexOf('/'));
		} else {
			uri = hrequest.getServletPath();
			if (uri.lastIndexOf('/') >= 0)
				uri = uri.substring(0, uri.lastIndexOf('/'));
		}
		return (new StringBuilder()).append(uri).append('/')
				.append(relativePath).toString();
	}
	
	private static void include(ServletRequest request, ServletResponse response, String relativePath, JspWriter out, boolean flush) throws IOException, ServletException {
		if (flush && !(out instanceof BodyContent)) out.flush();
		String resourcePath = getContextRelativePath(request, relativePath);
		RequestDispatcher rd = request.getRequestDispatcher(resourcePath);
		ServletResponseWrapperInclude srwi = new ServletResponseWrapperInclude(response, out);
		rd.include(request, srwi);
	}
// -----------------------------------------------------------------------------------------------------	
	
	
// -----------------------------------------------------------------------------------------------------	
// WebLogic에서는 tomcat/lib/jasper.jar를 사용할 수 없다.
// 그러므로 PageContextImpl.proprietaryEvaluate() 메소드 기능을 자체 기능구현 하여야 한다.	
// - (String) PageContextImpl.proprietaryEvaluate(exp, String.class, (PageContext)pageContext, null, false);	
// - weblogic.servlet.jsp.ELContextImpl	가 존재하므로 다른 클래스명으로 사용해야 한다.
// -----------------------------------------------------------------------------------------------------	
	private static final JspFactory jspf = JspFactory.getDefaultFactory();

	public static Object proprietaryEvaluate(String expression, Class expectedType, PageContext pageContext, javax.servlet.jsp.el.FunctionMapper functionMap, boolean escape) {
		ExpressionFactory exprFactory = jspf.getJspApplicationContext(pageContext.getServletContext()).getExpressionFactory();
		Object retValue;
//		ELContextImpl ctx = (ELContextImpl) pageContext.getELContext();
		ELContext ctx = pageContext.getELContext();
//		ctx.setFunctionMapper(new FunctionMapperImpl(functionMap));
		ValueExpression ve = exprFactory.createValueExpression(ctx, expression, expectedType);
		retValue = ve.getValue(ctx);
		return retValue;
	}
//	private static final boolean IS_SECURITY_ENABLED = System.getSecurityManager() != null;
//	private static final class ELContextImpl extends ELContext {
//		private static final class VariableMapperImpl extends VariableMapper {
//
//			private Map vars;
//
//			public ValueExpression resolveVariable(String variable) {
//				if (vars == null)
//					return null;
//				else
//					return (ValueExpression) vars.get(variable);
//			}
//
//			public ValueExpression setVariable(String variable,
//					ValueExpression expression) {
//				if (vars == null)
//					vars = new HashMap();
//				return (ValueExpression) vars.put(variable, expression);
//			}
//
//			private VariableMapperImpl() {
//			}
//
//		}
//
//		private static final FunctionMapper NullFunctionMapper = new FunctionMapper() {
//
//			public Method resolveFunction(String prefix, String localName) {
//				return null;
//			}
//
//		};
//		private static final ELResolver DefaultResolver;
//		private final ELResolver resolver;
//		private FunctionMapper functionMapper;
//		private VariableMapper variableMapper;
//
//		public ELContextImpl() {
//			this(getDefaultResolver());
//		}
//
//		public ELContextImpl(ELResolver resolver) {
//			functionMapper = NullFunctionMapper;
//			this.resolver = resolver;
//		}
//
//		public ELResolver getELResolver() {
//			return resolver;
//		}
//
//		public FunctionMapper getFunctionMapper() {
//			return functionMapper;
//		}
//
//		public VariableMapper getVariableMapper() {
//			if (variableMapper == null)
//				variableMapper = new VariableMapperImpl();
//			return variableMapper;
//		}
//
//		public void setFunctionMapper(FunctionMapper functionMapper) {
//			this.functionMapper = functionMapper;
//		}
//
//		public void setVariableMapper(VariableMapper variableMapper) {
//			this.variableMapper = variableMapper;
//		}
//
//		public static ELResolver getDefaultResolver() {
//			if (IS_SECURITY_ENABLED) {
//				CompositeELResolver defaultResolver = new CompositeELResolver();
//				defaultResolver.add(new MapELResolver());
//				defaultResolver.add(new ResourceBundleELResolver());
//				defaultResolver.add(new ListELResolver());
//				defaultResolver.add(new ArrayELResolver());
//				defaultResolver.add(new BeanELResolver());
//				return defaultResolver;
//			} else {
//				return DefaultResolver;
//			}
//		}
//
//		static {
//			if (IS_SECURITY_ENABLED) {
//				DefaultResolver = null;
//			} else {
//				DefaultResolver = new CompositeELResolver();
//				((CompositeELResolver) DefaultResolver).add(new MapELResolver());
//				((CompositeELResolver) DefaultResolver)
//						.add(new ResourceBundleELResolver());
//				((CompositeELResolver) DefaultResolver).add(new ListELResolver());
//				((CompositeELResolver) DefaultResolver).add(new ArrayELResolver());
//				((CompositeELResolver) DefaultResolver).add(new BeanELResolver());
//			}
//		}
//	}
	
//	private final class FunctionMapperImpl extends FunctionMapper {
//
//		private final javax.servlet.jsp.el.FunctionMapper fnMapper;
//
//		public FunctionMapperImpl(javax.servlet.jsp.el.FunctionMapper fnMapper) {
//			this.fnMapper = fnMapper;
//		}
//
//		public Method resolveFunction(String prefix, String localName) {
//			return fnMapper.resolveFunction(prefix, localName);
//		}
//	}
// -----------------------------------------------------------------------------------------------------	
}
