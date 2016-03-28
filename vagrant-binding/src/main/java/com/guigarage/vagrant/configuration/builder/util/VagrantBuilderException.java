package com.guigarage.vagrant.configuration.builder.util;

/**
 * The default Exception for all builder classes.
 * @author hendrikebbers
 *
 */
public class VagrantBuilderException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public VagrantBuilderException() {
        super();
    }

    public VagrantBuilderException(String message) {
        super(message);
    }

    public VagrantBuilderException(String message, Throwable cause) {
        super(message, cause);
    }

    public VagrantBuilderException(Throwable cause) {
        super(cause);
    }
}
