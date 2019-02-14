To use the dws Client, you need to configure/edit, and then deploy it to your environment. 
1. Click [here](https://raw.githubusercontent.com/calittle/documaker/master/dwsClient/index.html) to download the file.
1. Use [this](https://github.com/calittle/documaker/blob/master/dwsClient/index.html) to reference the original file for line numbers, etc.

Open the file in your favorite text editor, e.g. Notepad. PS you should be using Sublime Text, but whatever.
The basic configuration goes like this:
* Edit the HTML form to include the input elements you want the user to enter. Be sure to give each element a unique id attribute.
* Set the variable dwsUrl to the correct endpoint for your DWS Publishing Service.
* Set the variable diUrl to the correct endpoint for your Documaker Interactive application.
* Deploy to your J2EE container (e.g. WebLogic).

So, step by step:
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
1. Now the application has been deployed -- time to open up your browser and try it out. If you need to change the HTML, you can redo the steps above to edit and copy your file, but you don't have to redo the deployment. Just copy the new file out there and refresh your browser page.
1. If you run into issues you can put your browser into "developer mode" and view the console to see if there's any useful error messages.
