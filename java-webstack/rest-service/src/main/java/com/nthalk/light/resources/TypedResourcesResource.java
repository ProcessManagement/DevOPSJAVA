package com.nthalk.light.resources;

import com.nthalk.light.models.TypedResources;
import org.glassfish.jersey.server.internal.JerseyResourceContext;
import org.glassfish.jersey.server.model.Invocable;
import org.glassfish.jersey.server.model.Parameter;
import org.glassfish.jersey.server.model.Resource;
import org.glassfish.jersey.server.model.ResourceMethod;
import org.springframework.beans.factory.annotation.Autowired;

import javax.ws.rs.BeanParam;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.MediaType;
import java.lang.annotation.Annotation;
import java.lang.reflect.Type;

public class TypedResourcesResource {

  @Autowired
  JerseyResourceContext jerseyResourceContext;

  //  Try to generate TS resources from jersey resources
  public TypedResources get() {
    StringBuilder out = new StringBuilder();
    for (Resource resource : jerseyResourceContext.getResourceModel().getResources()) {
      String name = resource.getName();
      // Build class

      /**
       *  module Remote{
       *    module Model{
       *      interface MyModelClass{}
       *    }
       *    module Resource{
       *      class MyResource{
       *        METHOD_NAME: (PARAM_NAME:PARAM_TYPE...)=>{
       *          return $http({
       *            method: 'METHOD',
       *            headers: {
       *              PARAM_HEADER_NAME: param
       *            },
       *            data: PAYLOAD_PARAM,
       *            params: {
       *              PARAM_NAME: PARAM_NAME
       *            }
       *          })
       *        }
       *      }
       *    }
       *  }
       */
      out.append("class ");
      out.append(name);
      out.append("{\n");


      for (ResourceMethod resourceMethod : resource.getResourceMethods()) {

        out.append("");
        Invocable invocable = resourceMethod.getInvocable();
        // Path of resource
        String path = resource.getPath();

        // Method of resource
        String httpMethod = resourceMethod.getHttpMethod();
        // Accepts
        for (Parameter parameter : invocable.getParameters()) {
          parameter.getType();
          parameter.getSourceName();
          Annotation sourceAnnotation = parameter.getSourceAnnotation();
          if (sourceAnnotation == null) {
            // This is the default payload
          } else if (sourceAnnotation instanceof PathParam) {
            // This is within the path
          } else if (sourceAnnotation instanceof BeanParam) {
            // This is provided via queryString
          } else if (sourceAnnotation instanceof HeaderParam) {
            // This is a header parameter
          }
        }

        // Accepts via
        for (MediaType mediaType : resourceMethod.getConsumedTypes()) {
        }

        // Returns
        Type responseType = invocable.getResponseType();
        // Returns via
        for (MediaType type : resourceMethod.getProducedTypes()) {

        }
      }
    }

    return new TypedResources();
  }
}
