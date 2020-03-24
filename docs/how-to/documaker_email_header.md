Applicability: ODSE, ODEE. Version: Any.
***
First of all, you're probably wondering what exactly is a "preheader"? It's the summary text that short summary text that follows the subject line when viewing an email from the inbox. Whether or not this is displayed depends largely on the device or service used to view the inbox. The objective is to give the recipient some idea of what the message contains prior to opening it. Here’s an example in Gmail.

![text](/img/preheader-preview.png)

To create this resource in Documaker it's easy:
1. Put some text (e.g. a text label) near the top of your form set, e.g. in a section used for the header. You can even use variables here to populate the text from extract data. You could also dynamically add this header section using DAL if you want to. How the section and text label get into your form set is up to you. 
1. Choose to print **in color**, and the color matches the background of your email. For example, if you have a empty/white gutter around your content, then white text is fine. You should choose a font size font small enough so that none of it will overlap any other content that's not white. 

That's it. That's all the magic there is! In the example below, I just dropped a text label at the top of a form that was the first form in my form set. In practice, you might want to do create a tiny section with this text label, and then a PostTransDAL to place it on the very first form, no matter what it is. That way you don't have to be concerned with the order of the forms in the form list. 

![text](/img/preheader-studio.png)
