package com.nthalk.light.resources;

import com.nthalk.light.presentations.PongPresentation;
import com.wordnik.swagger.annotations.Api;
import com.wordnik.swagger.annotations.ApiOperation;
import org.springframework.stereotype.Component;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

@Api("Ping")
@Component
@Path("/ping")
@Produces("application/json")
public class PingResource {

  @GET
  @ApiOperation("Ping")
  public PongPresentation get() {
    return new PongPresentation();
  }
}
