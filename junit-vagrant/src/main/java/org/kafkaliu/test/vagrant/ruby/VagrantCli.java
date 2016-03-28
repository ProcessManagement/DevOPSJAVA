package org.kafkaliu.test.vagrant.ruby;

import org.jruby.*;
import org.jruby.runtime.Block;
import org.jruby.runtime.MethodBlock;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;

import java.util.HashMap;
import java.util.Map;

import static org.kafkaliu.test.vagrant.ruby.VagrantRubyHelper.argsAsString;
import static org.kafkaliu.test.vagrant.ruby.VagrantRubyHelper.newSymbol;

public class VagrantCli {

  private VagrantEnvironment env;

  private VagrantMachine vagrantMachine;

  public VagrantCli(VagrantEnvironment env) {
    this.env = env;
    this.vagrantMachine = new VagrantMachine(env);
  }

  public void up() {
    cli("up");
  }

  public void up(String vmName) {
    cli("up", vmName);
  }

  public void destroy() {
    cli("destroy", "-f");
  }

  public void halt() {
    cli("halt");
  }

  public void halt(String vmName) {
    cli("halt", vmName);
  }

  public String status(String vmName) {
    return ((RubyObject) vagrantMachine.getMachine(vmName).callMethod("state")).getInstanceVariable("@short_description").asJavaString();
  }

  public void suspend() {
    cli("suspend");
  }

  public void resume() {
    cli("resume");
  }

  private Map<String, Map<String, String>> ssh(String command) {
    Map<String, Map<String, String>> results = new HashMap<String, Map<String, String>>();
    for (RubySymbol vmName : vagrantMachine.getMachineNames()) {
      results.put(vmName.asJavaString(), sshOne(vmName.asJavaString(), command, false));
    }
    return results;
  }

  public Map<String, Map<String, String>> ssh(String vmName, String command) {
    if (vmName == null || vmName.isEmpty()) {
      return ssh(command);
    } else {
      Map<String, Map<String, String>> result = new HashMap<String, Map<String, String>>();
      result.put(vmName, sshOne(vmName, command, false));
      return result;
    }
  }

  public Map<String, Map<String, String>> trySsh(String vmName, String command) {
    Map<String, Map<String, String>> result = new HashMap<String, Map<String, String>>();
    result.put(vmName, sshOne(vmName, command, true));
    return result;
  }

  private Map<String, String> sshOne(String vmName, String command, boolean ignoreException) {
    if ("running".equals(status(vmName))) {
      return ssh(vagrantMachine.getMachine(vmName), command, ignoreException);
    }
    return new HashMap<String, String>();
  }

  // refer to ssh_run.rb
  private Map<String, String> ssh(RubyObject vm, String command, boolean ignoreException) {
    final Map<String, String> result = new HashMap<String, String>();
    RubyMethod method = (RubyMethod) (((RubyObject) vm.callMethod("communicate")).method(argsAsString(env, "execute")));

    Ruby runtime = env.getEnvironment().getRuntime();
    ThreadContext tc = runtime.getCurrentContext();
    Block methodBlock = MethodBlock.createMethodBlock(tc, method, tc.getCurrentScope(), new MethodBlock(method, tc.getCurrentStaticScope()) {

      @Override
      public IRubyObject callback(IRubyObject value, IRubyObject method, IRubyObject self, Block block) {
        RubyArray resultArray = (RubyArray) value;
        RubySymbol type = (RubySymbol) resultArray.get(0);
        String data = (String) resultArray.get(1);
        result.put(type.asJavaString(), data);
        return null;
      }
    });

    RubyHash opts = new RubyHash(runtime);
    opts.put(newSymbol(env, "error_check"), !ignoreException);
    method.call(tc, argsAsString(env, command), opts, methodBlock);

    return result;
  }

  private IRubyObject cli(String... commands) {
    return env.callCli("cli", commands);
  }

  public String plugin() {
    return cli("plugin", "list").toString();
  }
}
