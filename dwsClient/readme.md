# What Is This?
It's a very simple demonstration of capability to use SOAP messaging with just about any modern browser that supports ``XmlHttpRequest``. The gist of it is to enable a demonstration of user data capture to augment system data, and then use that to request a document for subsequent visual editing by the user.

# How Do I Use It?
To use the dws Client, you need to configure/edit, and then deploy it to your environment. Open the file in your favorite text editor, e.g. Notepad. PS you should be using Sublime Text, but it's your choice.
The files:
* Click [here](https://raw.githubusercontent.com/calittle/documaker/master/dwsClient/index.html) to download the file.
* Use [this](https://github.com/calittle/documaker/blob/master/dwsClient/index.html) to reference the original file for line numbers, etc.

## Assumptions
* You have a working Documaker Enterprise environment on a Linux machine that uses WebLogic. You can adapt the instructions if you are running on Windows (really the only difference is the simply-scripted creation of the _web.xml_ file) and the file copying details. 
* If you aren't using Documaker Enterprise, and you're using iDocumaker/Docupresentment/EWPS, then this is not for you. However, you will note that the only _real_ difference is the SOAP messaging, and the endpoints, so you can probably figure that out. I will probably come back here some day and make another version for EWPS.
* This assumes an _*Interactive*_ workflow. What does that mean? It means you're going to be using *_Documaker Interactive_* to allow the user to go mess with the document before it's published. _Wait, do I have to do that?_ No, you don't. You could:
   * ...Present a PDF to the user as a result of their request. Around _line 44_ set `var returnType = 'Attachments'` and then go around _line 278_ to change what happens when the response is received (e.g. retrieve the PDF from the response, decode it, and present it to the user; or...
   * ...Make it a straight-through process with no user intervention. Around _line 287_ you could remove the redirection to Documaker Interactive and just add something like `alert('Your document was submitted')` and if the user doesn't need to do anything else; or...
   * ...Do both of the above, depending on data, or the response from Documaker e.g. if it generated a PDF, show it; if it was routed for user entry, redirect there. Or, do nothing!

## Basic Instructions for Technical Wizards
The basic configuration goes like this:
* Edit the HTML form to include the input elements you want the user to enter. Be sure to give each element a unique id attribute.
* Set the variable dwsUrl to the correct endpoint for your DWS Publishing Service.
* Set the variable diUrl to the correct endpoint for your Documaker Interactive application.
* Deploy to your J2EE container (e.g. WebLogic). Note: you could deploy this to another container or server, but you need to be aware of CORS. I'm not getting into that here, so just keep it simple and deploy to the same container, alright?

## Step-By-Step Configuration and Deployment for Those Who Like Words
1. Around _line 27_ in the file you will see the definition of HTML input tags. You can add as many or as few as you like. The only thing you need to keep in mind is that each one needs a unique ID attribute, like the examples. You’ll see there are two, `lastname` and `firstname`. Add however many you want, and give them each a unique ID.
1. Around _line 35_, you will have the settings you need to make. These are pretty easy, really you just need to change the IP address to the IP of your environment, on the lines that say `var dwsUrl` and `var diUrl`. You don’t need to change anything else about those lines.
1. Here’s where it gets interesting, and this is the glue between this sample client and your Documaker installation - the extract data! If you want to use a specific extract file, you can - just make sure it corresponds to what your MRL is expecting. I have presented the extract data here as one big string, so you can read it and replace/add anything you might need. The key is around _line 77_ - you will see my example comments - where you need to replace the data in the extract string with the user-entered data. Look at my example and follow it. You can copy and paste this as you need to. Notice that you’re referencing your user inputs by the unique ID attribute.
You can also add some fancy HTML or CSS or whatever you want between _lines 2-31_ if you want to pretty it up. This is by design a VERY light and bare-bones example, so changing this is optional but recommended.
1. Save the file somewhere - it’s time to deploy!
1. Open a terminal in your Documaker environment's server. Copy these commands, paste them into the terminal, then press `ENTER`.
```
cd /home/oracle
mkdir demohtml
mkdir demohtml/WEB-INF
cat > demohtml/WEB-INF/web.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE web-app PUBLIC
"-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/j2ee/dtds/web-app_2_3.dtd">
<web-app>
</web-app>
EOF
```
6. Now you can copy over your saved file to the environment and place it inside the `/home/oracle/demohtml` directory as `index.html`. There are a number of ways to accomplish this, depending on where your system is and how you normally put files there. If it's running as a VM, you might have a shared directory. You can use _scp_ if you're into the whole command-line thing. It's up to you - the key is to make sure the file is named *index.html* and that it is in `/home/oracle/demohtml`.
    * Just FYI: you can create multiple copies of this file in the `/home/oracle/demohtml` directory, in case you want to try different things. 
1. Time to create the deployment in WebLogic. This needs to happen only once, no matter how many copies of the HTML file you have. 
    1. Open your browser to the WebLogic console and log in.
    1. Navigate to Deployments
    1. Click Install
    1. Locate the `/home/oracle/demohtml` directory and tick the radio button next to it, click `Next`. 
      * If you can't see it, use the links in _Current Location_ to get to it, or...
      * Just enter `/home/oracle/demohtml` in the _Path_ and click `Next`.
    1. Accept the default _Install this deployment as an application_ and click `Next`.
    1. Select the server(s) on which to deploy the application, e.g. _AdminServer_  and click `Next`.
    1. Accept defaults and click `Finish`.
* Now the application has been deployed -- time to open up your browser and try it out. 
* If you need to change the HTML, you can redo the steps above to edit and copy your file, but you don't have to redo the deployment. Just copy the new file out there and refresh your browser page.
* If you run into issues you can put your browser into "developer mode" and view the console to see if there's any useful error messages. Wait, you aren't getting console messages? Have a look around _line 35_ and make sure `var debug = true;` so you can get some debugging information to your console.
* Lastly, if you need some assistance, you can comment here or over at the Oracle Documaker [community](https://community.oracle.com/community/groundbreakers/oracle-applications/documaker).
