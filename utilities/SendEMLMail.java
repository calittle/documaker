import java.util.*;
import java.io.*;
import javax.mail.*;
import javax.mail.internet.*;

class SendEMLMail {
	
	public static void main(String[] args)
	{
		String to = "someone@oracle.com";
		String from = "someoneelse@oracle.com";
		
		Properties props = new Properties();
		props.put("mail.smtp.auth","true");
		props.put("mail.smtp.host","smtp.hostname.com");
		props.put("mail.smtp.port","587");
		props.put("mail.smtp.starttls.enable","true");

		Session session = Session.getInstance(props,
			new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication(){
					return new PasswordAuthentication("smtp@user.com","smtp**pass");
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
			message.setSubject("Hi! Email from Documaker!");
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