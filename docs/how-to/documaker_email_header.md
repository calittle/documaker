# Generating Content for Emails with Documaker
* Documaker Editions: Standard, Enterprise
* Documaker Versions: 12.0 or newer, perhaps 11.5

The purpose of this HOW-TO is to give you some information on how you can generate email content for Documaker. Not specifically how to _send_ email, as I expect you already have mechanisms in place to do this, perhaps using a tool such as Eloqua to track email bouncebacks. So let's assume that our interest is squarely situated around the email content itself.

A customer asked me about some specific elements of email:
1. **Sender Image** : this is a little graphic that some email clients place next to the sender's name to help identify the sender. This is not a feature of Documaker, it's a feature of an email provider, such as Google. Enabling this requires your company to subscribe to Google services and linking the sending email account (e.g. _yourcompany@yourdomain.com_ to a Google account). This is well outside the scope of Documaker. **OUT OF SCOPE**
2. **Sender Name** : emails often contain a name and address, and the format is typically something like _"My Name"<myname@domain.com>_. This type of email metadata is needed for the _sending_ of the email, not the composition of the message itself. Let's put this as outside the scope of Documaker. **OUT OF SCOPE**
3. **Subject** : Now we're starting to get in a little bit of a grey area, since the subject could contain transaction-specific information. Let's put this on our to-do list. Oh, and let's get into the current decade and add emojis 😄 to our subject too! **IN SCOPE**
4. **Email Preheader** : this is the bit of the message that some email clients display that may or may not actually be displayed in the email body (often it is not) so we need a way to dynamically generate this information. **IN SCOPE**
5. **_Extra Credit_**: let's include some code to send the email just for testing purposes. See [here](https://github.com/calittle/documaker/blob/master/utilities/SendEMLMail.java) 

## Subject
TBD. 
## Email Preheader
Whether or not this is displayed depends largely on the device or service used to view the inbox. The objective is to give the recipient some idea of what the message contains prior to opening it. Here’s an example in Gmail.

![text](/img/preheader-preview.png)

To create this resource in Documaker it's easy:
1. Put some text (e.g. a text label) near the top of your form set, e.g. in a section used for the header. You can even use variables here to populate the text from extract data. You could also dynamically add this header section using DAL if you want to. How the section and text label get into your form set is up to you. 
1. Choose to print **in color**, and the color matches the background of your email. For example, if you have a empty/white gutter around your content, then white text is fine. You should choose a font size font small enough so that none of it will overlap any other content that's not white. 

That's it. That's all the magic there is! In the example below, I just dropped a text label at the top of a form that was the first form in my form set. In practice, you might want to do create a tiny section with this text label, and then a PostTransDAL to place it on the very first form, no matter what it is. That way you don't have to be concerned with the order of the forms in the form list. 

![text](/img/preheader-studio.png)
