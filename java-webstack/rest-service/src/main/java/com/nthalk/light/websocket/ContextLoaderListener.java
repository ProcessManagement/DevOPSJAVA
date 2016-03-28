package com.nthalk.light.websocket;

import org.cometd.bayeux.Bayeux;
import org.cometd.bayeux.server.BayeuxServer;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class ContextLoaderListener implements ServletContextListener {

  public ContextLoaderListener() {
  }

  public void contextInitialized(ServletContextEvent sce) {
    ServletContext servletContext = sce.getServletContext();
    WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
    Bayeux bayeux = (Bayeux) webApplicationContext.getBean("bayeux");
    servletContext.setAttribute(BayeuxServer.ATTRIBUTE, bayeux);
  }

  public void contextDestroyed(ServletContextEvent sce) {

  }

}
