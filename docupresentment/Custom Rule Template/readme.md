# Docupresentment Custom Rule Template

A sample Docupresentment (IDS) custom rule.

## About IDS Rules
IDS Rules have 4 modes: Initialize(1), Run Forward(2), Run Reverse(3), and Terminate(4). When an IDS request is
executed, each rule in the request is executed 4 times and receives a flag indicating the mode:
-  Pass 1 is the Initialize Pass, and rules are executed in order from first to last.
-  Pass 2 is the Run Forward, and rules are executed in order from first to last.
-  Pass 3 is the Run Reverse, and rules are executed in order from last to first.
-  Pass 4 is the Terminate, and rules are executed in order from last to first.

This allows your rule to have an initialize routine and a terminate routine to setup and teardown anything needed to perform its work, e.g. a database connection, temporary file, etc. 
The run forward and run reverse modes allow your rule to execute with respect to other rules, e.g. your rule might be dependent on another rule's output which may not 
be generated until run reverse, so your code would need to run on the reverse mode.

## Configuration 
This template includes a sample code illustrating how you can pass parameters into the rule from IDS configuration (docserv.xml), or from properties files inside the JAR, or from
properties files somewhere on the fileystem using a JVM System Property. Note: if you use the properties files, be aware that by default password values are not encrypted in these
files so you will have to consider this risk.

## Testing
The template includes a robust test suite that tests different success and failure conditions (e.g. bad configurations, database not available, etc.) represented by several test cases. 
Each test case has 4 tests that simulate the init, run forward, run reverse, and terminate messages. Modify this template as needed, then compile and test. The tests simulate the 4 modes that a rule will receive, and
you may need to simulate the expected data inputs and outputs your rule receives and generates, or modify the test assertions.

## Deployment
To deploy a custom rule, simply drop the JAR file and any dependency JAR files in the _docserv/rules_ folder.
You will also need to add the rule into a request type in the `docserv.xml` configuration file, using this pattern:

`<entry name="function">java;RuleClassName;ScopeObject;Scope;Method;Arguments</entry>`

*Where*
`RuleClassName` is the class name of your rule, e.g. com.oracle.documaker.ids.customrules.MyCustomRule
`ScopeObject` is a unique name to maintain the state of your rule according to your designated scope; note that if multiple IDS request types use your rule and they have need to share data, then the ScopeObject can be the same. Use with caution!
`Scope` is one of the following which determines how your rule is created as a Java object:
	`global` – The object will remain until IDS is restarted.
    `transaction` The object will be created during the MSG_INIT message and will remain until the request has processed all the MSG_INIT, MSG_RUNF, MSG_RUNR and MSG_TERM messages.
    `local` – The object is created and destroyed for every message run during the request.
    `static` – No object is created; the method is a static method of the class and will be run as such
`Arguments` is a string that contains any arguments you want to pass to your rule. Format is up to you; the example herein uses comma-delimited name-value pairs which are parsed into a Properties object.

Example (lines are split for readability):
```
<entry name="function">java;com.oracle.documaker.ids.customrules.MyCustomRule;RuleObj;transaction;getEmployees;arguments</entry>
```