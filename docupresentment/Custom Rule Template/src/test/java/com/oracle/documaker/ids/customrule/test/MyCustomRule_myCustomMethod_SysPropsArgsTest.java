package com.oracle.documaker.ids.customrule.test;

import com.docucorp.ids.data.IDSConstants;
import com.oracle.documaker.ids.customrule.MyCustomRule;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * In order to use these tests, you will need to modify the strings
 * to contain your database connection details, or source them
 * from some other component (e.g. a properties file)
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class MyCustomRule_myCustomMethod_SysPropsArgsTest {
    private static final String idsArgs = "";
    static MyCustomRule idsRule = new MyCustomRule();


    // ----------------
    // Test Cases for System Property properties file..
    // ----------------
    @Test
    @Order(1)
    @SystemProperty(key = "MyCustomRulePropFile",value = "system.config.properties")
    public void getEmployeesSysPropsInit() throws Exception
    {
        System.out.println("getEmployeesSysPropsInit");
        assertEquals(
                IDSConstants.RET_SUCCESS,
                idsRule.myCustomMethod(
                    null,
                    idsArgs,
                    IDSConstants.MSG_INIT
                )
        );
    }

    @Test
    @Order(2)
    @SystemProperty(key = "MyCustomRulePropFile",value = "system.config.properties")
    public void getEmployeesSysPropsForward()
    {
        System.out.println("getEmployeesSysPropsForward");
        assertEquals(
                IDSConstants.RET_SUCCESS,
                idsRule.myCustomMethod(
                        null,
                        idsArgs,
                        IDSConstants.MSG_RUNF
                )
        );
    }

    @Test
    @Order(3)
    @SystemProperty(key = "MyCustomRulePropFile",value = "system.config.properties")
    public void getEmployeesSysPropsReverse()
    {
        System.out.println("getEmployeesSysPropsReverse");
        assertEquals(
                IDSConstants.RET_SUCCESS,
                idsRule.myCustomMethod(
                        null,
                        idsArgs,
                        IDSConstants.MSG_RUNR
                )
        );
    }

    @Test
    @Order(4)
    @SystemProperty(key = "MyCustomRulePropFile",value = "system.config.properties")
    public void getEmployeesSysPropsTerm() throws Exception
    {
        System.out.println("getEmployeesSysPropsTerm");
        idsRule.myCustomMethod(
                null,
                idsArgs,
                IDSConstants.MSG_TERM
        );
    }
}
