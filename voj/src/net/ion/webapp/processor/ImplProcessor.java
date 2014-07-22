package net.ion.webapp.processor;

public abstract class ImplProcessor implements ProcessorService {
	private String jobId;
	public String getJobId(){
		
		if(jobId!=null) return jobId;
		
		String name = this.getClass().getSimpleName();
		name = name.endsWith(ProcessorFactory.PROCESSOR_SUFFIX) ? name.substring(0, name.length()-ProcessorFactory.PROCESSOR_SUFFIX.length()) : name;
		jobId = name.toLowerCase();
		return jobId;
	}

}
