import java.util.*;
import java.io.*;
import javax.mail.*;
import javax.mail.internet.*;

class SendEMLMail {
	
	public static void main(String[] args)
	{
		String to = "Jo Customer <customer@oracle.com>";
		String from = "Oracle <documaker@andylittle.org>";
		
		Properties props = new Properties();
		props.put("mail.smtp.auth","true");
		props.put("mail.smtp.host","smtp.oracle.com");
		props.put("mail.smtp.port","587");
		props.put("mail.smtp.starttls.enable","true");

		Session session = Session.getInstance(props,
			new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication(){
					return new PasswordAuthentication("smtpuser","smtppass");
				}
			}
		);
		try 
		{
			// If you want to send a file created by Docuamker, include it here.
			File emlFile = new File("./message.eml");

			InputStream source = new FileInputStream(emlFile);
			MimeMessage message = new MimeMessage(session, source);
		
			message.setFrom(new InternetAddress(from));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
			message.setSubject("=?utf-8?Q?=F0=9F=8F=A1_Your_tenant_insurance_quote_D-EN-ON?=");
			// Not using this since we're embedding the EML from Documaker.
			//message.setContent("<h1>This is actual message embedded in HTML tags</h1>","text/html");
			Transport.send(message);
			System.out.println("Sent.");
	    } 
		catch (Exception e) 
		{
			e.printStackTrace();			
		}

	}
}	
