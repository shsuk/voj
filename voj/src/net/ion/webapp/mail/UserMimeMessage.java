package net.ion.webapp.mail;

import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.internet.MimeMessage;

/**
 * SendMail�� ������ ���� �� message-ID�� ������ �� �ְ� ����ϴ� message Ŭ����<br/>
 * �޴� ���� ������ message-ID�� ��� �޴� ����з� �� �� �����Ƿ�
 * �߼۽� ����� message-ID�� �������־���Ѵ�. (�ڹٸ��� api�� �⺻ �����δ� �Ϲ������� ����ó���ȴ�.)
 *
 * @author Kim, Sanghoon (wizest@i-on.net)
 * @version 1.0
 */

class UserMimeMessage
    extends MimeMessage
{
    private String msgId;

    public UserMimeMessage(Session session,String msgId) {
        super(session);
        this.msgId=msgId;
    }

    protected void updateHeaders() throws MessagingException {
        super.updateHeaders();
        setHeader("Message-ID",msgId);
    }
}
