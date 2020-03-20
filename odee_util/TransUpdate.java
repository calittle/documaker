import java.sql.*;
import org.apache.commons.cli.*;

import java.util.Hashtable;

import javax.jms.JMSException;
import javax.jms.Queue;
import javax.jms.QueueConnection;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueSession;
import javax.jms.Session;
//import javax.jms.TextMessage;
import javax.jms.BytesMessage;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

class TransUpdate {
	
	private static final String usage = "Usage: TransUpdate <constring> <dbuser> <dbpass> <trn_id> [trnstatus] [QCF] [Q]";
	
	private static final String SQL_VALIDATE_TRNS = "select count(*) from TRNS where TRN_ID = ?";
	private static final String SQL_UPDATE_TRNS = "update TRNS set TRNSTATUS = ? WHERE TRN_ID = ?";	
	private static final String JNDI_FACTORY = "weblogic.jndi.WLInitialContextFactory";

	private static InitialContext getInitialContext(String url) throws NamingException
	{
		Hashtable<String, String> env = new Hashtable<>();
		env.put(Context.INITIAL_CONTEXT_FACTORY, JNDI_FACTORY);
		env.put(Context.PROVIDER_URL, url);
		return new InitialContext(env);
	}
	public static void main(String[] args){
		int trnid=0;
		int trnstatus=0;
		String constring = "";
		String user = "";
		String pass = "";
		String url = "";
		boolean trnFound = false;
		String qcfname = "";
		String queuename = "";

		Options options = new Options();

		//required command line options		
		Option opt;
		
		opt = new Option("c","constring",true,"Connection String (e.g. jdbc:oracle:thin:@localhost:1521:orcl)");
		opt.setRequired(true);
		options.addOption(opt);

		opt = new Option("u","user",true,"Database User (e.g. dmkr_asline)");
		opt.setRequired(true);
		options.addOption(opt);

		opt = new Option("p","password",true,"Database Password");
		opt.setRequired(true);
		options.addOption(opt);

		opt = new Option("i","id",true,"Transaction ID");
		opt.setRequired(true);
		options.addOption(opt);

		//optional options
		opt = new Option("s","status",true,"Transaction Status (default:221)");
		opt.setRequired(false);
		options.addOption(opt);

		opt = new Option("f","qcf",true,"Queue Connection Factory (default: jms.al1.qcf)");
		opt.setRequired(false);
		options.addOption(opt);

		opt = new Option("q","queue",true,"Queue (default: jms.al1.assemberreq)");
		opt.setRequired(false);
		options.addOption(opt);

		opt = new Option("w","wlsurl",true,"WebLogic URL (default: t3://localhost:7001)");
		opt.setRequired(false);
		options.addOption(opt);

		
		CommandLineParser parser = new DefaultParser();
        HelpFormatter formatter = new HelpFormatter();
        CommandLine cmd;
		
		try{
			cmd = parser.parse(options, args);			
			trnid = Integer.parseInt(cmd.getOptionValue("id"));
			constring = cmd.getOptionValue("constring");
			user = cmd.getOptionValue("user");
			pass = cmd.getOptionValue("password");
			String temp = cmd.getOptionValue("status");
			if (temp != null){
				trnstatus = Integer.parseInt(temp);
			}else{
				trnstatus = 221;
			}

			temp = cmd.getOptionValue("qcf");
			if (temp != null){
				qcfname = temp;
			}else{
				qcfname = "jms.al1.qcf";
			}		

			temp = cmd.getOptionValue("queue");
			if (temp != null){
				queuename = temp;
			}else{
				queuename = "jms.al1.assemblerreq";
			}

			temp = cmd.getOptionValue("wlsurl");
			if (temp != null){
				url = temp;
			}else{
				url = "t3://localhost:7001";
			}		

		}
		catch (ParseException e){
			System.err.println(e);
			formatter.printHelp("TransUpdate", options);
			System.exit(1);
		}
		catch (Exception e){
			System.err.println(e);
			System.exit(1);
		}

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			java.sql.Connection c = DriverManager.getConnection(constring, user, pass);
			PreparedStatement ps = c.prepareStatement(SQL_VALIDATE_TRNS);
			ps.setInt(1,trnid);

			ResultSet rs = ps.executeQuery();
			
			while (rs.next()){
				if (rs.getInt(1) == 1){
					System.out.println("TRANS " + trnid + " located.");
					trnFound = true;
				}else {
					System.err.println("TRANS " + trnid + " was not located.");
					trnFound = false;
				}
			}

			if (trnFound){
				
				ps = c.prepareStatement(SQL_UPDATE_TRNS);
				ps.setInt(1,trnstatus);
				ps.setInt(2,trnid);
				int i = ps.executeUpdate();

				if (i>0){
				
					System.out.println("TRANS " + trnid + " updated to TRNSTATUS = " +trnstatus);
											
					try{
					    InitialContext namingContext = getInitialContext(url);
						QueueConnectionFactory queueConnectionFactory = (QueueConnectionFactory) namingContext.lookup(qcfname);
						Queue queue = (Queue) namingContext.lookup(queuename); 
						QueueConnection  conn = queueConnectionFactory.createQueueConnection();						
						QueueSession session = conn.createQueueSession(false, Session.AUTO_ACKNOWLEDGE);

						String messageText = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><TransactionTicket xmlns='oracle/documaker/schema/tables/trns'><TRN_ID>" + trnid + "</TRN_ID></TransactionTicket>";
						
						BytesMessage message = session.createBytesMessage();
						message.writeBytes(messageText.getBytes("UTF-8"));
						//TextMessage message =  session.createTextMessage(messageText);
						
						conn.start();						
						session.createSender(queue).send(message);
						conn.close();					
					
						System.out.println("Message posted to " + qcfname + "/" + queuename + " on " + url);

					}
					catch(NamingException e){
						e.printStackTrace();
					}
					catch(JMSException e){
						e.printStackTrace();
					}
					
				}
			}

			c.close();
		}
		catch (Exception e){
			System.err.println(e);
		}
	}
}