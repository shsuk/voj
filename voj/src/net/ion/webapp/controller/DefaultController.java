package net.ion.webapp.controller;

import java.text.SimpleDateFormat;

import net.ion.webapp.service.ProcessService;
import net.ion.webapp.service.TestService;

import org.springframework.beans.factory.annotation.Autowired;

public class DefaultController {
	// @Autowired
	// MethodNameResolver methodNameResolver;
	@Autowired
	protected ProcessService processService;
	@Autowired
	protected TestService testService;
	SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
}
