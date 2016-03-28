package org.kafkaliu.test.vagrant.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Inherited
public @interface VagrantConfigure {
  // String vagrantfilePath();
  String vagrantfile();

  String vagrantLog() default "";

  boolean needDestroyVmAfterClassTest() default true;

  boolean needUpVmBeforeClassTest() default true;
}
