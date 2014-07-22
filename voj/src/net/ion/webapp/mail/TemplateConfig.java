package net.ion.webapp.mail;

import java.util.HashMap;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2004</p>
 * <p>Company: I-ON Communications</p>
 * @author bleujin
 * @version 1.0
 */

public class TemplateConfig {

    private HashMap mapping = new HashMap();

    public TemplateConfig() {
    }

    public void addTemplate(Template map) {
        mapping.put(map.getTemplateKey(), map);
    }

    public Template getTemplate(String templateKey) {
        return (Template) mapping.get(templateKey);
    }

    public HashMap getTemplates() {
        return mapping;
    }

}