package com.nthalk.light.resources;

import org.springframework.stereotype.Component;

import javax.ws.rs.GET;
import javax.ws.rs.Path;

@Component
@Path("/ws")
public class WebSocketResource {

  @GET
  public void get() {

  }
}
