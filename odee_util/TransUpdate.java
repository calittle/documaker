import java.sql.*;
import org.apache.commons.cli.*;

import java.util.Hashtable;

import javax.jms.JMSException;
import javax.jms.Queue;
import javax.jms.QueueConnection;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueSession;
import javax.jms.Session;

import javax.jms.BytesMessage;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

class TransUpdate {
	
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
	public static void main(String[] args)
	{
		int trnid=0;
		int trnstatus=0;
		int updatedTrns=0;
		String[] trnids = null;
		String constring = "";
		String user = "";
		String pass = "";
		String url = "";
		boolean sweep = false;
		boolean test = false;
		boolean trnFound = false;
		String qcfname = "";
		String queuename = "";
		String clazz = "";
		Options options = new Options();
		Option opt;
		
		opt = new Option("c","constring",true,"Database Connection String (e.g. jdbc:oracle:thin:@localhost:1521:orcl)");
		opt.setRequired(true);
		options.addOption(opt);

		opt = new Option("u","user",true,"Assembly Line Database User (e.g. dmkr_asline)");
		opt.setRequired(true);
		options.addOption(opt);

		opt = new Option("p","password",true,"Assembly Line User Password");
		opt.setRequired(true);
		options.addOption(opt);

		opt = Option.builder("i")
			.required()
			.longOpt("id")
			.hasArgs()
			.desc("Transaction ID(s) to modify (comma-delimited)")
			.valueSeparator(new Character(','))
			.build();			
		opt.setArgs(Option.UNLIMITED_VALUES);
		options.addOption(opt);

		opt = new Option("s","status",true,"New Transaction Status (default:221)");
		opt.setRequired(false);
		options.addOption(opt);

		opt = new Option("f","qcf",true,"Queue Connection Factory (default: jms.al1.qcf)");
		opt.setRequired(false);
		options.addOption(opt);

		opt = new Option("q","queue",true,"Queue (default: jms.al1.assemberreq)");
		opt.setRequired(false);
		options.addOption(opt);

		opt = new Option("d","dbclass",true,"Database connection class name (default: oracle.jdbc.driver.OracleDriver)");
		opt.setRequired(false);
		options.addOption(opt);

		opt = new Option("w","wlsurl",true,"WebLogic JMS Server URL (default: t3://localhost:11001)");
		opt.setRequired(false);
		options.addOption(opt);

		opt = new Option("d","delete",false,"Delete any existing BCHS, RCPS, PUBS records.");
		opt.setRequired(false);
		options.addOption(opt);
		
		opt = new Option("t","test",false,"Test run; no updates will be performed or messages actually sent.");
		opt.setRequired(false);
		options.addOption(opt);
		

		CommandLineParser parser = new DefaultParser();
        HelpFormatter formatter = new HelpFormatter();
        CommandLine cmd;
		
		try
		{
			cmd = parser.parse(options, args);			
			
			trnids = cmd.getOptionValues("id");
			
			constring = cmd.getOptionValue("constring");
			user = cmd.getOptionValue("user");
			pass = cmd.getOptionValue("password");
			String temp = cmd.getOptionValue("status");
			
			if (temp != null)
			{
				trnstatus = Integer.parseInt(temp);
			}
			else
			{
				trnstatus = 221;
			}

			if (cmd.hasOption("delete"))
			{
				sweep = true;
			}
			if (cmd.hasOption("test"))
			{
				test = true;
			}

			temp = cmd.getOptionValue("qcf");
			if (temp != null)
			{
				qcfname = temp;
			}
			else
			{
				qcfname = "jms.al1.qcf";
			}		

			temp = cmd.getOptionValue("queue");
			if (temp != null)
			{
				queuename = temp;
			}
			else
			{
				queuename = "jms.al1.assemblerreq";
			}

			temp = cmd.getOptionValue("wlsurl");
			
			if (temp != null){
				url = temp;
			}
			else
			{
				url = "t3://localhost:7001";
			}		

			temp = cmd.getOptionValue("dbclass");
			if (temp != null)
			{
				clazz = temp;
			}
			else
			{
				clazz = "oracle.jdbc.driver.OracleDriver";
			}
			
		}
		catch (ParseException e)
		{
			System.err.println(e);
			formatter.printHelp("TransUpdate", options);
			System.exit(1);
		}
		catch (Exception e)
		{
			System.err.println(e);
			System.exit(1);
		}

		
		try 
		{
			
			Class.forName(clazz);			
			
			java.sql.Connection c = DriverManager.getConnection(constring, user, pass);
			
			System.out.println("Database connection opened.");			
			System.out.println("Transactions to process: " + trnids.length);

			for (int trncounter=0; trncounter < trnids.length; trncounter++) 
			{

				trnid = Integer.parseInt(trnids[trncounter]);
				System.out.println("============ " + (trncounter + 1) + ". TRNID "  + trnid + " ============");

				PreparedStatement ps = c.prepareStatement(SQL_VALIDATE_TRNS);
				ps.setInt(1,trnid);

				ResultSet rs = ps.executeQuery();
				
				while (rs.next())
				{

					if (rs.getInt(1) == 1)
					{
						System.out.println("TRANS " + trnid + " located.");
						if (sweep)
						{
							if (!test)
							{
								System.out.println("Performing sweep for TRNID " + trnid);
								// Clean up:
								// DELETE FROM BCHS WHERE BCH_ID IN (SELECT BCH_ID FROM BCHS_RCPS WHERE TRN_ID = ?)
								// DELETE FROM RCPS WHERE RCP_ID IN (SELECT RCP_ID FROM BCHS_RCPS WHERE TRN_ID = ?)
								PreparedStatement swps = c.prepareStatement("DELETE FROM PUBS WHERE PUB_ID IN (SELECT PUB_ID FROM BCHS_RCPS WHERE TRN_ID = ?)");
								swps.setInt(1,trnid);
								updatedTrns = swps.executeUpdate();
								if (updatedTrns >= 1)
								{
									System.out.println(updatedTrns + " PUBS releated to TRNID " + trnid + " deleted. ");
								}
								else 
								{
									System.out.println("No PUBS to remove for TRNID " + trnid);
								}

								swps = c.prepareStatement("DELETE FROM BCHS WHERE BCH_ID IN (SELECT BCH_ID FROM BCHS_RCPS WHERE TRN_ID = ?)");
								swps.setInt(1,trnid);
								updatedTrns = swps.executeUpdate();
								if (updatedTrns >= 1)
								{
									System.out.println(updatedTrns + " BCHS releated to TRNID " + trnid + " deleted. ");
								}
								else 
								{
									System.out.println("No BCHS to remove for TRNID " + trnid);
								}

								swps = c.prepareStatement("DELETE FROM RCPS WHERE RCP_ID IN (SELECT RCP_ID FROM BCHS_RCPS WHERE TRN_ID = ?)");
								swps.setInt(1,trnid);
								updatedTrns = swps.executeUpdate();
								if (updatedTrns >= 1)
								{
									System.out.println(updatedTrns + " RCPS releated to TRNID " + trnid + " deleted. ");
								}
								else 
								{
									System.out.println("No RCPS to remove for TRNID " + trnid);
								}

								swps = c.prepareStatement("DELETE FROM BCHS_RCPS WHERE TRN_ID = ?");
								swps.setInt(1,trnid);
								updatedTrns = swps.executeUpdate();
								if (updatedTrns >= 1)
								{
									System.out.println(updatedTrns + " BCHS_RCPS releated to TRNID " + trnid + " deleted. ");
								}
								else 
								{
									System.out.println("No BCHS_RCPS to remove for TRNID " + trnid);
								}							

								// TRNS.TRNNAPOLXML, TRNNAPOLBLOB, TRNNAPOLSIZE (set to null)
								swps = c.prepareStatement("UPDATE TRNS SET TRNNAPOLXML=null, TRNNAPOLBLOB=null, TRNNAPOLSIZE=0 WHERE TRN_ID = ?");
								swps.setInt(1,trnid);
								updatedTrns = swps.executeUpdate();
								if (updatedTrns == 1)
								{
									System.out.println("TRNS NAPOL data deleted. ");
								}
								else if (updatedTrns > 1)
								{
									System.out.println("Something bad happened trying to delete TRNS NAPOL data for TRNID " + trnid);
								}else 
								{
									System.err.println("Unable to remove TRNS NAPOL data for TRNID " + trnid);
								}




 							}
							else
							{
								System.out.println("Test enabled -- no sweep will be performed for TRNID " + trnid + ".");
							}					
						}
						if (!test) 
						{	
						
							ps = c.prepareStatement(SQL_UPDATE_TRNS);
							ps.setInt(1,trnstatus);
							ps.setInt(2,trnid);
							updatedTrns = ps.executeUpdate();
						
						}
						else
						{						
							System.out.println("Test enabled -- no update performed for TRNID " + trnid +", ignore following message.");
							updatedTrns=1;
						
						}

						if (updatedTrns>0)
						{						
							System.out.println("TRANS " + trnid + " updated to TRNSTATUS = " +trnstatus);
													
							try
							{
							    InitialContext namingContext = getInitialContext(url);
								QueueConnectionFactory queueConnectionFactory = (QueueConnectionFactory) namingContext.lookup(qcfname);
								Queue queue = (Queue) namingContext.lookup(queuename); 
								QueueConnection  conn = queueConnectionFactory.createQueueConnection();						
								QueueSession session = conn.createQueueSession(false, Session.AUTO_ACKNOWLEDGE);

								String messageText = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><TransactionTicket xmlns='oracle/documaker/schema/tables/trns'><TRN_ID>" + trnid + "</TRN_ID></TransactionTicket>";
								
								BytesMessage message = session.createBytesMessage();
								message.writeBytes(messageText.getBytes("UTF-8"));
								
								if (test)
								{
									System.out.println("Test enabled -- no message will be sent for TRNID " + trnid);

								}else
								{
									conn.start();						
									session.createSender(queue).send(message);
									conn.close();					
									System.out.println("Message posted to " + qcfname + "/" + queuename + " on " + url);
								}
							}
							catch(NamingException e){
								e.printStackTrace();
							}
							catch(JMSException e){
								e.printStackTrace();
							}	
						}
					}
					else 
					{
						System.out.println("TRANS " + trnid + " was not located.");					
					}

				} // end of while on RS of TRNID find
			} // end of for on TRNID array 
			
			c.close();
			System.out.println("Database connection closed.");
			System.exit(0);

		}// end of try
		catch (Exception e)
		{
			System.err.println(e);
		}		
	}
}