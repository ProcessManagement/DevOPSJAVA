package com.guigarage.vagrant.configuration.builder;

import com.guigarage.vagrant.configuration.PuppetProvisionerConfig;
import com.guigarage.vagrant.configuration.builder.util.VagrantBuilderException;

/**
 * Builder for {@link PuppetProvisionerConfig}
 * @author hendrikebbers
 *
 */
public class PuppetProvisionerConfigBuilder {

	private String manifestPath;
	
	private String manifestFile;
	
	private boolean debug;
	
	private String modulesPath;
	
	public PuppetProvisionerConfigBuilder() {
	}
	
	/**
	 * creates a new {@link PuppetProvisionerConfigBuilder}
	 * @return a new {@link PuppetProvisionerConfigBuilder}
	 */
	public static PuppetProvisionerConfigBuilder create() {
		return new PuppetProvisionerConfigBuilder();
	}
	
	public PuppetProvisionerConfigBuilder withManifestFile(String manifestFile) {
		this.manifestFile = manifestFile;
		return this;
	}
	
	public PuppetProvisionerConfigBuilder withManifestPath(String manifestPath) {
		this.manifestPath = manifestPath;
		return this;
	}
	
	public PuppetProvisionerConfigBuilder withModulesPath(String modulesPath) {
		this.modulesPath = modulesPath;
		return this;
	}
	
	public PuppetProvisionerConfigBuilder withDebug(boolean debug) {
		this.debug = debug;
		return this;
	}
	
	public PuppetProvisionerConfig build() {
		if(manifestPath == null) {
			throw new VagrantBuilderException("no manifestPath defined!");
		}
		if(manifestFile == null) {
			throw new VagrantBuilderException("no manifestFile defined!");
		}
		return new PuppetProvisionerConfig(debug, manifestPath, manifestFile, modulesPath);
	}
}
